#!/bin/bash

# IIR Filter Test Runner - Runs each test case in isolation
# This ensures static state is reset between test cases

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to create a test case file
create_test_case() {
    local test_num=$1
    local description=$2
    local N=$3
    local b_array=$4
    local a_array=$5
    local x_array=$6
    local x_size=$7
    
    cat > "test_case_${test_num}.c" << EOF
#include "stdio.h"

#define N_MAX 10
#define X_SIZE 12

extern int iir(int N, int* b, int* a, int x_n);
void initialise_monitor_handles(void) { /* No-op */ }

int iir_c(int N, int* b, int* a, int x_n) {
    static int x_store[N_MAX] = {0};
    static int y_store[N_MAX] = {0};
    int j, y_n;
    
    y_n = x_n*b[0]/a[0];
    for (j=0; j<=N; j++) {
        y_n+=(b[j+1]*x_store[j]-a[j+1]*y_store[j])/a[0];
    }
    for (j=N-1; j>0; j--) {
        x_store[j] = x_store[j-1];
        y_store[j] = y_store[j-1];
    }
    x_store[0] = x_n;
    y_store[0] = y_n;
    y_n /= 100;
    return y_n;
}

int main(void) {
    initialise_monitor_handles();
    
    int N = $N;
    int b[] = {$b_array};
    int a[] = {$a_array};
    int x[] = {$x_array};
    int x_size = $x_size;
    
    printf("=== Test Case $test_num: $description ===\\n");
    
    int all_passed = 1;
    for (int i = 0; i < x_size; i++) {
        int asm_result = iir(N, b, a, x[i]);
        int c_result = iir_c(N, b, a, x[i]);
        
        printf("i=%2d: x=%4d, asm=%4d, c=%4d", i, x[i], asm_result, c_result);
        
        if (asm_result != c_result) {
            printf(" ❌\\n");
            all_passed = 0;
        } else {
            printf(" ✅\\n");
        }
    }
    
    if (all_passed) {
        printf("✅ Test Case $test_num PASSED\\n");
        return 0;
    } else {
        printf("❌ Test Case $test_num FAILED\\n");
        return 1;
    }
}
EOF
}

echo "🧪 IIR Filter Test Runner"
echo "========================"
echo "Running each test case in isolation to ensure clean state..."
echo ""

# Clean and translate
print_status "Preparing assembly translation..."
make clean > /dev/null 2>&1
make translate > /dev/null 2>&1

# Test case definitions
declare -a test_cases=(
    "1|Original test case - full array|4|100, 250, 360, 450, 580|100, 120, 180, 230, 250|100, 230, 280, 410, 540, 600, 480, 390, 250, 160, 100, 340|12"
    "2|Single input test case|4|100, 250, 360, 450, 580|100, 120, 180, 230, 250|100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0|1"
    "3|High order filter with negative values|9|100, 90, 80, 70, 60, 50, 40, 30, 20, 10|100, 95, 85, 75, 65, 55, 45, 35, 25, 15|50, 100, 150, 200, 250, 300, -300, -200, -100, 0, 100, 200|12"
    "4|Constant input test case|4|100, 250, 360, 450, 580|100, 120, 180, 230, 250|100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100|12"
    "5|Alternating positive/negative input test case|4|100, 250, 360, 450, 580|100, 120, 180, 230, 250|100, -100, 200, -200, 300, -300, 400, -400, 0, 0, 100, -100|12"
)

passed_tests=0
total_tests=${#test_cases[@]}

# Run each test case
for test_case in "${test_cases[@]}"; do
    IFS='|' read -r test_num description N b_array a_array x_array x_size <<< "$test_case"
    
    print_status "Creating test case $test_num..."
    create_test_case "$test_num" "$description" "$N" "$b_array" "$a_array" "$x_array" "$x_size"
    
    print_status "Compiling test case $test_num..."
    if gcc -Wall -Wextra "test_case_${test_num}.c" build/iir_translated.s -o "test_case_${test_num}" 2>/dev/null; then
        print_status "Running test case $test_num..."
        if "./test_case_${test_num}"; then
            ((passed_tests++))
        fi
        echo ""
    else
        print_error "Failed to compile test case $test_num"
    fi
    
    # Clean up
    rm -f "test_case_${test_num}.c" "test_case_${test_num}"
done

# Summary
echo "📊 TEST SUMMARY"
echo "==============="
echo "Test Cases Passed: $passed_tests/$total_tests"

if [ $passed_tests -eq $total_tests ]; then
    print_success "🎉 ALL TESTS PASSED! Assembly implementation is correct."
    exit 0
else
    print_error "⚠️  Some tests failed. Check implementation."
    exit 1
fi

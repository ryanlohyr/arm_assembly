#!/bin/bash

# IIR Filter Automated Test Script
# This script compiles and runs automated tests for the IIR filter implementation

set -e  # Exit on any error

echo "🧪 IIR Filter Automated Test Suite"
echo "=================================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Clean previous builds
print_status "Cleaning previous builds..."
make clean > /dev/null 2>&1 || true

# Check if iir.s exists and has content
if [ ! -f "iir.s" ]; then
    print_error "iir.s not found!"
    exit 1
fi

if [ ! -s "iir.s" ]; then
    print_error "iir.s is empty!"
    exit 1
fi

# Translate ARM assembly
print_status "Translating ARM assembly from Cortex-M4 to ARM64..."
if ! python3 arm_translator.py iir.s build/iir_translated.s; then
    print_error "ARM translation failed!"
    exit 1
fi

print_success "ARM translation completed successfully"

# Compile test suite
print_status "Compiling test suite..."
mkdir -p build
if ! gcc -Wall -Wextra -g test_iir.c build/iir_translated.s -o build/test_iir; then
    print_error "Compilation failed!"
    exit 1
fi

print_success "Test suite compiled successfully"

# Run tests
print_status "Running automated tests..."
echo ""

if ./build/test_iir; then
    echo ""
    print_success "🎉 All tests passed! Your IIR filter implementation is working correctly."
    
    # Optional: Run original main.c for comparison
    if [ -f "main.c" ]; then
        echo ""
        print_status "Running original main.c for reference..."
        if gcc -Wall -Wextra main.c build/iir_translated.s -o build/iir_filter; then
            echo ""
            echo "=== Original main.c output (first test case) ==="
            ./build/iir_filter | head -24  # Show first 12 pairs of lines
        fi
    fi
    
    exit 0
else
    echo ""
    print_error "❌ Some tests failed. Please check your implementation."
    exit 1
fi

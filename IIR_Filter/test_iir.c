/******************************************************************************
 * @project        : CG2028 Assignment 1 Test Script
 * @file           : test_iir.c
 * @brief          : Automated test script for IIR filter implementation
 *
 * @description    : This script runs multiple test cases to verify that the
 *                   assembly implementation matches the C reference implementation.
 ******************************************************************************
 */

#include "stdio.h"
#include "string.h"

#define N_MAX 10
#define X_SIZE 12

// Function prototypes
extern int iir(int N, int* b, int* a, int x_n); // asm implementation
int iir_c(int N, int* b, int* a, int x_n); // reference C implementation
void reset_iir_state(void); // reset static arrays

// Stub function for non-embedded environment
void initialise_monitor_handles(void) { /* No-op for regular compilation */ }

// Test case structure
typedef struct {
    int test_num;
    int N;
    int b[N_MAX+1];
    int a[N_MAX+1];
    int x[X_SIZE];
    int x_size;  // Actual size of x array for this test
    const char* description;
} test_case_t;

// Global test results
int total_tests = 0;
int passed_tests = 0;
int failed_tests = 0;

// Test cases
test_case_t test_cases[] = {
    {
        .test_num = 1,
        .N = 4,
        .b = {100, 250, 360, 450, 580},
        .a = {100, 120, 180, 230, 250},
        .x = {100, 230, 280, 410, 540, 600, 480, 390, 250, 160, 100, 340},
        .x_size = 12,
        .description = "Original test case - full array"
    },
    {
        .test_num = 2,
        .N = 4,
        .b = {100, 250, 360, 450, 580},
        .a = {100, 120, 180, 230, 250},
        .x = {100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
        .x_size = 1,
        .description = "Single input test case"
    },
    {
        .test_num = 3,
        .N = 9,
        .b = {100, 90, 80, 70, 60, 50, 40, 30, 20, 10},
        .a = {100, 95, 85, 75, 65, 55, 45, 35, 25, 15},
        .x = {50, 100, 150, 200, 250, 300, -300, -200, -100, 0, 100, 200},
        .x_size = 12,
        .description = "High order filter with negative values"
    },
    {
        .test_num = 4,
        .N = 4,
        .b = {100, 250, 360, 450, 580},
        .a = {100, 120, 180, 230, 250},
        .x = {100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100},
        .x_size = 12,
        .description = "Constant input test case"
    },
    {
        .test_num = 5,
        .N = 4,
        .b = {100, 250, 360, 450, 580},
        .a = {100, 120, 180, 230, 250},
        .x = {100, -100, 200, -200, 300, -300, 400, -400, 0, 0, 100, -100},
        .x_size = 12,
        .description = "Alternating positive/negative input test case"
    }
};

#define NUM_TEST_CASES (sizeof(test_cases) / sizeof(test_cases[0]))

// Function to run a single test case
void run_test_case(test_case_t* tc) {
    printf("\n=== Test Case %d: %s ===\n", tc->test_num, tc->description);
    printf("N = %d, x_size = %d\n", tc->N, tc->x_size);
    
    // Reset state before each test
    reset_iir_state();
    
    int test_passed = 1;
    int asm_results[X_SIZE];
    int c_results[X_SIZE];
    
    // Run the test
    for (int i = 0; i < tc->x_size; i++) {
        asm_results[i] = iir(tc->N, tc->b, tc->a, tc->x[i]);
        c_results[i] = iir_c(tc->N, tc->b, tc->a, tc->x[i]);
        
        printf("i=%2d: x=%4d, asm=%4d, c=%4d", i, tc->x[i], asm_results[i], c_results[i]);
        
        if (asm_results[i] != c_results[i]) {
            printf(" ❌ MISMATCH!");
            test_passed = 0;
        } else {
            printf(" ✅");
        }
        printf("\n");
        
        total_tests++;
    }
    
    if (test_passed) {
        printf("✅ Test Case %d PASSED\n", tc->test_num);
        passed_tests++;
    } else {
        printf("❌ Test Case %d FAILED\n", tc->test_num);
        failed_tests++;
    }
}

int main(void) {
    initialise_monitor_handles();
    
    printf("🧪 IIR Filter Automated Test Suite\n");
    printf("===================================\n");
    printf("Testing assembly implementation against C reference...\n");
    
    // Run all test cases
    for (int i = 0; i < NUM_TEST_CASES; i++) {
        run_test_case(&test_cases[i]);
    }
    
    // Print summary
    printf("\n📊 TEST SUMMARY\n");
    printf("===============\n");
    printf("Total individual tests: %d\n", total_tests);
    printf("Passed: %d\n", total_tests - (failed_tests > 0 ? failed_tests : 0));
    printf("Failed: %d\n", (failed_tests > 0 ? failed_tests : 0));
    printf("Test Cases Passed: %d/%d\n", passed_tests, (int)NUM_TEST_CASES);
    
    if (failed_tests == 0) {
        printf("🎉 ALL TESTS PASSED! Assembly implementation is correct.\n");
        return 0;
    } else {
        printf("⚠️  Some tests failed. Check implementation.\n");
        return 1;
    }
}

// Reference C implementation (same as original but with reset function)
static int x_store[N_MAX] = {0}; // to store the previous N values of x_n.
static int y_store[N_MAX] = {0}; // to store the previous values of y_n.

void reset_iir_state(void) {
    // Reset static arrays between test cases
    memset(x_store, 0, sizeof(x_store));
    memset(y_store, 0, sizeof(y_store));
}

int iir_c(int N, int* b, int* a, int x_n) {
    // The implementation below is inefficient and meant only for verifying your results.
    int j;
    int y_n;

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

    y_n /= 100; // scaling down

    return y_n;
}

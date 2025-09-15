// Auto-translated from Cortex-M4 to ARM64
.align 2

/*
 * iir.s
 *
 *  Created on: 29/7/2025
 *      Author: Ni Qingqing
 */

.global _iir

// Start of executable code
.text

// CG2028 Assignment 1, Sem 1, AY 2025/26
// (c) ECE NUS, 2025

// Write Student 1’s Name here:
// Write Student 2’s Name here:

// You could create a look-up table of registers here:

// w0 ...
// w1 ...

// write your program from here:

// Static storage for previous values (equivalent to C static arrays)
.data
.align 4
x_store: .space 40    // N_MAX * 4 bytes (10 integers)
y_store: .space 40    // N_MAX * 4 bytes (10 integers)

.text

// Function: iir
// Parameters:
//   w0 = N (filter order)
//   w1 = pointer to b[] (feedforward coefficients)
//   w2 = pointer to a[] (feedback coefficients)
//   w3 = x_n (current input sample)
// Returns:
//   w0 = y_n (output sample)

_iir:
    stp x29, x30, [sp, #-16]!
    mov x29, sp
    stp x19, x20, [sp, #-16]!
    
// Load a[0] for division operations
    ldr w4, [x2]         // R4 = a[0]
    
// Calculate initial y_n = x_n * b[0] / a[0]
    ldr w5, [x1]         // R5 = b[0]
    mul w6, w3, w5       // R6 = x_n * b[0]
    sdiv w6, w6, w4      // R6 = (x_n * b[0]) / a[0], this is our y_n
    
// Load addresses of static storage
    adrp x7, x_store@PAGE
    add x7, x7, x_store@PAGEOFF     // R7 = address of x_store
    adrp x8, y_store@PAGE
    add x8, x8, y_store@PAGEOFF     // R8 = address of y_store
    
// Loop through j from 0 to N
    mov w9, #0           // R9 = j (loop counter)
    
loop_start:
    cmp w9, w0           // Compare j with N
    b.gt loop_end         // If j > N, exit loop
    
// Calculate array indices: j*4 (since each int is 4 bytes)
    lsl w10, w9, #2      // R10 = j * 4
    
// Load x_store[j] and y_store[j]
    ldr w11, [x7, w10, uxtw]   // R11 = x_store[j]
    ldr w12, [x8, w10, uxtw]   // R12 = y_store[j]
    
// Calculate b[j+1] address and load value
    add w10, w9, #1      // R10 = j + 1
    lsl w10, w10, #2     // R10 = (j+1) * 4
    ldr w5, [x1, w10, uxtw]    // R5 = b[j+1]
    
// Calculate a[j+1] address and load value
    ldr w10, [x2, w10, uxtw]   // R10 = a[j+1]
    
// Calculate b[j+1] * x_store[j]
    mul w5, w5, w11      // R5 = b[j+1] * x_store[j]
    
// Calculate a[j+1] * y_store[j]
    mul w10, w10, w12    // R10 = a[j+1] * y_store[j]
    
// Calculate (b[j+1]*x_store[j] - a[j+1]*y_store[j])
    sub w5, w5, w10      // R5 = b[j+1]*x_store[j] - a[j+1]*y_store[j]
    
// Divide by a[0]
    sdiv w5, w5, w4      // R5 = (b[j+1]*x_store[j] - a[j+1]*y_store[j]) / a[0]
    
// Add to y_n
    add w6, w6, w5       // y_n += result
    
// Increment loop counter
    add w9, w9, #1
    B loop_start
    
loop_end:
// Now shift the arrays (from N-1 down to 1)
    sub w9, w0, #1       // R9 = N-1 (start from N-1)
    
shift_loop:
    cmp w9, #0           // Compare with 0
    b.le shift_done       // If j <= 0, done shifting
    
// Calculate current and previous indices
    lsl w10, w9, #2      // R10 = j * 4 (current index)
    sub w11, w9, #1      // R11 = j - 1
    lsl w11, w11, #2     // R11 = (j-1) * 4 (previous index)
    
// Shift x_store: x_store[j] = x_store[j-1]
    ldr w12, [x7, w11, uxtw]   // Load x_store[j-1]
    str w12, [x7, w10, uxtw]   // Store to x_store[j]
    
// Shift y_store: y_store[j] = y_store[j-1]
    ldr w12, [x8, w11, uxtw]   // Load y_store[j-1]
    str w12, [x8, w10, uxtw]   // Store to y_store[j]
    
// Decrement counter
    sub w9, w9, #1
    B shift_loop
    
shift_done:
// Store current values at index 0
    str w3, [x7]         // x_store[0] = x_n
    str w6, [x8]         // y_store[0] = y_n
    
// Scale down by 100
    mov w5, #100
    sdiv w6, w6, w5      // y_n /= 100
    
// Return result
    mov w0, w6           // Return y_n
    
    ldp x19, x20, [sp], #16
    ldp x29, x30, [sp], #16
    ret

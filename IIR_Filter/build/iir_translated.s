// Auto-translated from Cortex-M4 to ARM64
.align 2

; /*
;  * iir.s
;  *
;  *  Created on: 29/7/2025
;  *      Author: Ni Qingqing
;  */
;    .syntax unified
; 	.cpu cortex-m4
; 	.fpu softvfp
; 	.thumb

.global _iir

; // Start of executable code
.text

; // CG20d 8 Assignment 1, Sem 1, AY 2025/26
; // (c) ECE NUS, 2025

; // Write Student 1’s Name here:
; // Write Student 2’s Name here:

; // You could create a look-up table of registers here:

; // w0 ...
; // w1 ...

; // write your program from here:

; // Function: iir
; // Parameters:
; //   w0 = N (filter order)
; //   w1 = pointer to b[] (feedforward coefficients)
; //   w2 = pointer to a[] (feedback coefficients)
; //   w3 = x_n (current input sample)
; // Returns:
; //   w0 = y_n (output sample)

.global _iir
; iir:
    stp x29, x30, [sp, #-16]!
    mov x29, sp
    stp x19, x20, [sp, #-16]!

; 	// For now, return a simple placeholder value
; 	// This is a basic implementation that just returns x_n * b[0] / a[0] / 100
; 	// The full IIR implementation would require static storage for previous values
	
; 	LDR w4, [w1]         // Load b[0]
; 	LDR w5, [w2]         // Load a[0]
	
; 	MUL w0, w3, w4       // x_n * b[0]
	
; 	// Divide by a[0]
; 	CMP w5, #0           // Check for division by zero
; 	cbz w5, div_zero
; 	SDIV w0, w0, w5      // (x_n * b[0]) / a[0]
	
; 	// Scale down by 100
; 	MOV w4, #100
; 	SDIV w0, w0, w4      // y_n / 100
	
; 	B end_iir

; div_zero:
; 	MOV w0, #0           // Return 0 if division by zero

; end_iir:
    ldp x19, x20, [sp], #16
    ldp x29, x30, [sp], #16
    ret


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

_iir:
    str x30, [sp, #-16]!

    bl SUBROUTINE

    ldr x30, [sp], #16

    ret

SUBROUTINE:

    ret

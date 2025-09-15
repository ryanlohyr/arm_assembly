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

; 		.global iir

; @ Start of executable code
; .section .text

; @ CG20d 8 Assignment 1, Sem 1, AY 2025/26
; @ (c) ECE NUS, 2025

; @ Write Student 1’s Name here:
; @ Write Student 2’s Name here:

; @ You could create a look-up table of registers here:

; @ R0 ...
; @ R1 ...

; @ write your program from here:

; @ Function: iir
; @ Parameters:
; @   R0 = N (filter order)
; @   R1 = pointer to b[] (feedforward coefficients)
; @   R2 = pointer to a[] (feedback coefficients)
; @   R3 = x_n (current input sample)
; @ Returns:
; @   R0 = y_n (output sample)

; .global iir
; iir:
; 	PUSH {R4-R11, LR}    @ Save registers

; 	@ For now, return a simple placeholder value
; 	@ This is a basic implementation that just returns x_n * b[0] / a[0] / 100
; 	@ The full IIR implementation would require static storage for previous values
	
; 	LDR R4, [R1]         @ Load b[0]
; 	LDR R5, [R2]         @ Load a[0]
	
; 	MUL R0, R3, R4       @ x_n * b[0]
	
; 	@ Divide by a[0]
; 	CMP R5, #0           @ Check for division by zero
; 	BEQ div_zero
; 	SDIV R0, R0, R5      @ (x_n * b[0]) / a[0]
	
; 	@ Scale down by 100
; 	MOV R4, #100
; 	SDIV R0, R0, R4      @ y_n / 100
	
; 	B end_iir

; div_zero:
; 	MOV R0, #0           @ Return 0 if division by zero

; end_iir:
; 	POP {R4-R11, PC}     @ Restore registers and return


/*
 * iir.s
 *
 *  Created on: 29/7/2025
 *      Author: Ni Qingqing
 */
   .syntax unified
	.cpu cortex-m4
	.fpu softvfp
	.thumb

		.global iir

@ Start of executable code
.section .text

@ CG2028 Assignment 1, Sem 1, AY 2025/26
@ (c) ECE NUS, 2025

@ Write Student 1’s Name here:
@ Write Student 2’s Name here:

@ You could create a look-up table of registers here:

@ R0 ...
@ R1 ...

@ write your program from here:

iir:
 	PUSH {R14}

	BL SUBROUTINE

 	POP {R14}

	BX LR

SUBROUTINE:

	BX LR

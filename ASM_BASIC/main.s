/*
 * asm_basic : main.s
 * Gu Jing, ECE, NUS
 * July 2020
 *
 * Simple ARM assembly file to demonstrate basic asm instructions.
 */

	.syntax unified
	.global main

@ Equates, equivalent to #define in C program
	.equ C,	20
	.equ D,	400

main:
@ Code starts here
@ Calculate ANSWER = A*B + C*D

	LDR R0, A // this loads Register 0 as A (100)
	LDR R1, B // this loads register 1 as B (50)
	MUL R0, R0, R1 // this is equivalent to R0 = R0 * R1
	LDR R1, =C // this loads R1 as 20
	LDR R2, =D // this loads R2 as 400
	MLA R0, R1, R2, R0 // this is equivalent to R0 = (R1 X R2) + R0
	MOV R4, R0 // this is equivalent to R4 = R0 (assign R0 to R4)
	LDR R3, =ANSWER // R3 = address of ANSWER
	STR R4, [R3] // This stores R4 into memry at ANSWER

HALT:
	B HALT

@ Define constant values
A:	.word	100
B:	.word	50

@ Store result in SRAM (4 bytes)
.lcomm	ANSWER	4
.end



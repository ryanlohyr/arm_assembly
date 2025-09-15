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

@ Static storage for previous values (equivalent to C static arrays)
.section .bss
.align 4
x_store: .space 40    @ N_MAX * 4 bytes (10 integers)
y_store: .space 40    @ N_MAX * 4 bytes (10 integers)

.section .text

@ Function: iir
@ Parameters:
@   R0 = N (filter order)
@   R1 = pointer to b[] (feedforward coefficients)
@   R2 = pointer to a[] (feedback coefficients)
@   R3 = x_n (current input sample)
@ Returns:
@   R0 = y_n (output sample)

iir:
    PUSH {R4-R11, LR}    @ Save registers
    
    @ Load a[0] for division operations
    LDR R4, [R2]         @ R4 = a[0]
    
    @ Calculate initial y_n = x_n * b[0] / a[0]
    LDR R5, [R1]         @ R5 = b[0]
    MUL R6, R3, R5       @ R6 = x_n * b[0]
    SDIV R6, R6, R4      @ R6 = (x_n * b[0]) / a[0], this is our y_n
    
    @ Load addresses of static storage
    LDR R7, =x_store     @ R7 = address of x_store
    LDR R8, =y_store     @ R8 = address of y_store
    
    @ Loop through j from 0 to N
    MOV R9, #0           @ R9 = j (loop counter)
    
loop_start:
    CMP R9, R0           @ Compare j with N
    BGT loop_end         @ If j > N, exit loop
    
    @ Calculate array indices: j*4 (since each int is 4 bytes)
    LSL R10, R9, #2      @ R10 = j * 4
    
    @ Load x_store[j] and y_store[j]
    LDR R11, [R7, R10]   @ R11 = x_store[j]
    LDR R12, [R8, R10]   @ R12 = y_store[j]
    
    @ Calculate b[j+1] address and load value
    ADD R10, R9, #1      @ R10 = j + 1
    LSL R10, R10, #2     @ R10 = (j+1) * 4
    LDR R5, [R1, R10]    @ R5 = b[j+1]
    
    @ Calculate a[j+1] address and load value
    LDR R10, [R2, R10]   @ R10 = a[j+1]
    
    @ Calculate b[j+1] * x_store[j]
    MUL R5, R5, R11      @ R5 = b[j+1] * x_store[j]
    
    @ Calculate a[j+1] * y_store[j]
    MUL R10, R10, R12    @ R10 = a[j+1] * y_store[j]
    
    @ Calculate (b[j+1]*x_store[j] - a[j+1]*y_store[j])
    SUB R5, R5, R10      @ R5 = b[j+1]*x_store[j] - a[j+1]*y_store[j]
    
    @ Divide by a[0]
    SDIV R5, R5, R4      @ R5 = (b[j+1]*x_store[j] - a[j+1]*y_store[j]) / a[0]
    
    @ Add to y_n
    ADD R6, R6, R5       @ y_n += result
    
    @ Increment loop counter
    ADD R9, R9, #1
    B loop_start
    
loop_end:
    @ Now shift the arrays (from N-1 down to 1)
    SUB R9, R0, #1       @ R9 = N-1 (start from N-1)
    
shift_loop:
    CMP R9, #0           @ Compare with 0
    BLE shift_done       @ If j <= 0, done shifting
    
    @ Calculate current and previous indices
    LSL R10, R9, #2      @ R10 = j * 4 (current index)
    SUB R11, R9, #1      @ R11 = j - 1
    LSL R11, R11, #2     @ R11 = (j-1) * 4 (previous index)
    
    @ Shift x_store: x_store[j] = x_store[j-1]
    LDR R12, [R7, R11]   @ Load x_store[j-1]
    STR R12, [R7, R10]   @ Store to x_store[j]
    
    @ Shift y_store: y_store[j] = y_store[j-1]
    LDR R12, [R8, R11]   @ Load y_store[j-1]
    STR R12, [R8, R10]   @ Store to y_store[j]
    
    @ Decrement counter
    SUB R9, R9, #1
    B shift_loop
    
shift_done:
    @ Store current values at index 0
    STR R3, [R7]         @ x_store[0] = x_n
    STR R6, [R8]         @ y_store[0] = y_n
    
    @ Scale down by 100
    MOV R5, #100
    SDIV R6, R6, R5      @ y_n /= 100
    
    @ Return result
    MOV R0, R6           @ Return y_n
    
    POP {R4-R11, PC}     @ Restore registers and return

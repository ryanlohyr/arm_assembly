.section .text
    .global _start

@ Function to calculate factorial of a number
@ Input: r0 = number
@ Output: r0 = factorial
factorial:
    push {r1, r2, lr}   @ Save registers and link register
    
    @ Base case: if n <= 1, return 1
    cmp r0, #1
    ble factorial_base
    
    @ Recursive case: n * factorial(n-1)
    mov r1, r0          @ Save n in r1
    sub r0, r0, #1      @ r0 = n - 1
    bl factorial        @ Call factorial(n-1)
    mul r0, r1, r0      @ r0 = n * factorial(n-1)
    
    pop {r1, r2, lr}    @ Restore registers
    bx lr               @ Return
    
factorial_base:
    mov r0, #1          @ Return 1
    pop {r1, r2, lr}    @ Restore registers
    bx lr               @ Return

@ Function to add two numbers
@ Input: r0 = first number, r1 = second number
@ Output: r0 = sum
add_numbers:
    push {lr}           @ Save link register
    add r0, r0, r1      @ r0 = r0 + r1
    pop {lr}            @ Restore link register
    bx lr               @ Return

_start:
    @ Test add_numbers function
    mov r0, #10         @ First number
    mov r1, #20         @ Second number
    bl add_numbers      @ Call function, result in r0 (30)
    
    @ Save result for later
    mov r4, r0          @ Save sum result
    
    @ Test factorial function
    mov r0, #5          @ Calculate factorial of 5
    bl factorial        @ Call function, result in r0 (120)
    
    @ Use factorial result as exit code (mod 256)
    and r0, r0, #0xFF   @ Keep only lower 8 bits for exit code
    
    @ Exit
    mov r7, #1          @ sys_exit system call number
    svc #0              @ invoke system call
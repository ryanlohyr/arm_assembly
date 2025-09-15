.section .text
    .global _start

_start:
    @ Basic arithmetic operations practice
    
    @ Addition: 15 + 25 = 40
    mov r0, #15         @ Load 15 into r0
    mov r1, #25         @ Load 25 into r1
    add r2, r0, r1      @ r2 = r0 + r1 (40)
    
    @ Subtraction: 100 - 35 = 65
    mov r3, #100        @ Load 100 into r3
    mov r4, #35         @ Load 35 into r4
    sub r5, r3, r4      @ r5 = r3 - r4 (65)
    
    @ Multiplication: 8 * 7 = 56
    mov r6, #8          @ Load 8 into r6
    mov r7, #7          @ Load 7 into r7
    mul r8, r6, r7      @ r8 = r6 * r7 (56)
    
    @ Logical operations
    mov r9, #0xFF       @ Load 255 into r9
    mov r10, #0x0F      @ Load 15 into r10
    and r11, r9, r10    @ r11 = r9 & r10 (15)
    orr r12, r9, r10    @ r12 = r9 | r10 (255)
    eor r0, r9, r10     @ r0 = r9 ^ r10 (240)
    
    @ Shift operations
    mov r1, #8          @ Load 8 into r1
    lsl r2, r1, #2      @ r2 = r1 << 2 (32)
    lsr r3, r1, #1      @ r3 = r1 >> 1 (4)
    
    @ Exit with the result of addition (40)
    add r0, r2, #0      @ Move final result to r0 for exit status
    mov r7, #1          @ sys_exit system call number
    svc #0              @ invoke system call
.section .data
    msg: .ascii "Hello, ARM Assembly World!\n"
    msg_len = . - msg

.section .text
    .global _start

_start:
    @ Write system call
    mov r0, #1          @ stdout file descriptor
    ldr r1, =msg        @ message to write
    mov r2, #msg_len    @ message length
    mov r7, #4          @ sys_write system call number
    svc #0              @ invoke system call

    @ Exit system call
    mov r0, #0          @ exit status
    mov r7, #1          @ sys_exit system call number
    svc #0              @ invoke system call
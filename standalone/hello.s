# Simple assembly program for ARM64 (Apple Silicon macOS)
.section __TEXT,__text,regular,pure_instructions
.globl _main
.align 2

_main:
    # Set up stack frame
    stp     x29, x30, [sp, #-16]!
    mov     x29, sp
    
    # Call printf
    adrp    x0, hello_string@PAGE
    add     x0, x0, hello_string@PAGEOFF
    bl      _printf
    
    # Return 0
    mov     w0, #0
    
    # Clean up and return
    ldp     x29, x30, [sp], #16
    ret

.section __TEXT,__cstring,cstring_literals
hello_string:
    .asciz "Hello from ARM Assembly!\n"

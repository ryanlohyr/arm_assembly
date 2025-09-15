# ARM64 Assembly functions that can be called from C
.section __TEXT,__text,regular,pure_instructions
.globl _add_numbers
.globl _multiply_numbers
.align 2

# Funcroution: int add_numbers(int a, int b)
# Parameters: a in w0, b in w1
# Returns: sum in w0
_add_numbers:
    stp     x29, x30, [sp, #-16]!
    mov     x29, sp
    
    add     w0, w0, w1
    
    ldp     x29, x30, [sp], #16
    ret

# Function: int multiply_numbers(int a, int b)
# Parameters: a in w0, b in w1  
# Returns: product in w0
_multiply_numbers:
    stp     x29, x30, [sp, #-16]!
    mov     x29, sp
    
    mul     w0, w0, w1
    
    ldp     x29, x30, [sp], #16
    ret

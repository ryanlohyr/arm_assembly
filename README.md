# ARM Assembly Practice

This repository contains ARM assembly language practice examples for learning low-level programming concepts.

## Prerequisites

To build and run these examples, you need:
- ARM cross-compilation tools: `gcc-arm-linux-gnueabihf`, `binutils-arm-linux-gnueabihf`
- QEMU user emulation: `qemu-user`

### Installing Prerequisites on Ubuntu/Debian
```bash
sudo apt update
sudo apt install -y gcc-arm-linux-gnueabihf binutils-arm-linux-gnueabihf qemu-user
```

## Examples

### 1. Hello World (`hello_world.s`)
A basic ARM assembly program that prints "Hello, ARM Assembly World!" to the console.

**Concepts covered:**
- Basic ARM assembly structure
- System calls (write, exit)
- Data section and string constants
- ARM registers and instructions

### 2. Arithmetic Operations (`arithmetic.s`)
Demonstrates various arithmetic and logical operations in ARM assembly.

**Concepts covered:**
- Basic arithmetic: addition, subtraction, multiplication
- Logical operations: AND, OR, XOR
- Shift operations: logical left shift, logical right shift
- Register usage and data movement

### 3. Functions and Stack (`functions.s`)
Shows function calls, stack usage, and recursion in ARM assembly.

**Concepts covered:**
- Function definition and calling conventions
- Stack operations (push/pop)
- Link register usage
- Recursion (factorial calculation)
- Function parameters and return values

## Building and Running

### Build all examples
```bash
make all
```

### Build individual examples
```bash
make hello_world
make arithmetic
make functions
```

### Run examples
```bash
make test-hello       # Run hello world
make test-arithmetic  # Run arithmetic operations
make test-functions   # Run functions example
make test-all         # Run all examples
```

### Clean build artifacts
```bash
make clean
```

## Understanding the Output

- **Hello World**: Prints a message and exits with code 0
- **Arithmetic**: Exits with code 32 (result of 8 << 2)
- **Functions**: Exits with code 120 (factorial of 5)

## ARM Assembly Basics

### Registers
- `r0-r12`: General purpose registers
- `r13 (sp)`: Stack pointer
- `r14 (lr)`: Link register (return address)
- `r15 (pc)`: Program counter

### Common Instructions
- `mov`: Move data between registers
- `add`/`sub`: Addition and subtraction
- `mul`: Multiplication
- `ldr`/`str`: Load/store memory
- `push`/`pop`: Stack operations
- `bl`: Branch with link (function call)
- `bx lr`: Return from function
- `svc`: System call

### System Calls
- `r7`: System call number
- `r0-r2`: System call arguments
- Common system calls:
  - `1`: exit
  - `4`: write

## Learning Path

1. Start with `hello_world.s` to understand basic structure
2. Study `arithmetic.s` for register operations and math
3. Examine `functions.s` for advanced concepts like function calls and recursion

## Resources

- [ARM Assembly Language Programming](https://www.arm.com/resources/education/books)
- [ARM Developer Documentation](https://developer.arm.com/documentation/)
- [Linux System Calls](https://syscalls.kernelgrok.com/)

## Contributing

Feel free to add more assembly examples or improve existing ones. Make sure to:
1. Add appropriate comments explaining the code
2. Update the Makefile if needed
3. Test with `make test-all`
4. Update this README
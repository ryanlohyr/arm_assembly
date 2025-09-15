# Makefile for Standalone C and ARM Assembly Programs

# Compiler and flags
CC = gcc
CFLAGS = -Wall -Wextra
C_TARGET = hello_c
ASM_TARGET = hello_arm
C_SOURCE = hello.c
ASM_SOURCE = hello.s

# Default target - build both programs
all: $(C_TARGET) $(ASM_TARGET)

# Build C program
$(C_TARGET): $(C_SOURCE)
	$(CC) $(CFLAGS) $(C_SOURCE) -o $(C_TARGET)

# Build ARM assembly program
$(ASM_TARGET): $(ASM_SOURCE)
	$(CC) $(ASM_SOURCE) -o $(ASM_TARGET)

# Run C program
run-c: $(C_TARGET)
	./$(C_TARGET)

# Run ARM assembly program
run-asm: $(ASM_TARGET)
	./$(ASM_TARGET)

# Run both programs
run: run-c run-asm

# Clean build artifacts
clean:
	rm -f $(C_TARGET) $(ASM_TARGET) *.o

# Debug builds
debug-c: CFLAGS += -g -O0
debug-c: $(C_TARGET)

debug-asm: $(ASM_TARGET)

# Show help
help:
	@echo "Available targets:"
	@echo "  all       - Build both programs (default)"
	@echo "  hello_c   - Build C program only"
	@echo "  hello_arm - Build ARM assembly program only"
	@echo "  run-c     - Build and run C program"
	@echo "  run-asm   - Build and run ARM assembly program"
	@echo "  run       - Build and run both programs"
	@echo "  clean     - Remove build artifacts"
	@echo "  debug-c   - Build C program with debug symbols"
	@echo "  debug-asm - Build assembly program (same as hello_arm)"
	@echo "  help      - Show this help message"

.PHONY: all run-c run-asm run clean debug-c debug-asm help

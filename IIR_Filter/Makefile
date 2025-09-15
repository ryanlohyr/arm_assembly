# Auto-translating Makefile for ARM Cortex-M4 to ARM64
# Automatically translates iir.s from Cortex-M4 to ARM64 before compiling

CC = gcc
CFLAGS = -Wall -Wextra
PYTHON = python3
TRANSLATOR = arm_translator.py

TARGET = build/iir_filter
CORTEXM4_SRC = iir.s
ARM64_SRC = build/iir_translated.s
C_SRC = main.c

# Default target
all: translate $(TARGET)

# Translate Cortex-M4 assembly to ARM64
translate: $(CORTEXM4_SRC)
	@mkdir -p build
	@echo "Translating $(CORTEXM4_SRC) from Cortex-M4 to ARM64..."
	$(PYTHON) $(TRANSLATOR) $(CORTEXM4_SRC) $(ARM64_SRC)

# Build the program with translated assembly
$(TARGET): $(C_SRC) $(ARM64_SRC)
	@echo "Compiling with auto-translated ARM64 assembly..."
	$(CC) $(CFLAGS) $(C_SRC) $(ARM64_SRC) -o $(TARGET)

# Run the program
run: $(TARGET)
	./$(TARGET)

# Clean build artifacts
clean:
	rm -rf build/ *.o

# Show the translated assembly
show-translated: translate
	@echo "=== Translated ARM64 Assembly ==="
	@cat $(ARM64_SRC)

# Debug - show side by side comparison
compare: translate
	@echo "=== Original Cortex-M4 (first 40 lines) ==="
	@head -n 40 $(CORTEXM4_SRC)
	@echo ""
	@echo "=== Translated ARM64 (first 40 lines) ==="
	@head -n 40 $(ARM64_SRC)

# Help
help:
	@echo "Auto-translating Makefile"
	@echo "========================="
	@echo "This Makefile automatically translates Cortex-M4 assembly to ARM64"
	@echo ""
	@echo "Targets:"
	@echo "  all             - Translate and build (default)"
	@echo "  translate       - Just translate iir.s to ARM64"
	@echo "  run             - Build and run the program"
	@echo "  show-translated - Display the translated assembly"
	@echo "  compare         - Show original vs translated"
	@echo "  clean           - Remove build artifacts"
	@echo "  help            - Show this help"
	@echo ""
	@echo "How it works:"
	@echo "  1. Reads iir.s (Cortex-M4 assembly)"
	@echo "  2. Translates to iir_translated.s (ARM64)"
	@echo "  3. Compiles with main.c for your Mac"

.PHONY: all translate run clean show-translated compare help

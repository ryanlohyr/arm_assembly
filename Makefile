# ARM Assembly Practice Makefile

# Cross-compilation tools
AS = arm-linux-gnueabihf-as
LD = arm-linux-gnueabihf-ld
GCC = arm-linux-gnueabihf-gcc

# Emulator for testing
QEMU = qemu-arm

# Assembly source files
SOURCES = hello_world.s arithmetic.s functions.s

# Object files
OBJECTS = $(SOURCES:.s=.o)

# Executable files
EXECUTABLES = $(SOURCES:.s=)

# Default target
all: $(EXECUTABLES)

# Pattern rule for creating object files from assembly source
%.o: %.s
	$(AS) -o $@ $<

# Pattern rule for creating executables from object files
%: %.o
	$(LD) -o $@ $<

# Build individual targets
hello_world: hello_world.o
	$(LD) -o $@ $<

arithmetic: arithmetic.o
	$(LD) -o $@ $<

functions: functions.o
	$(LD) -o $@ $<

# Test targets (run with QEMU emulator)
test-hello: hello_world
	$(QEMU) ./hello_world

test-arithmetic: arithmetic
	$(QEMU) ./arithmetic; echo "Exit code: $$?"

test-functions: functions
	$(QEMU) ./functions; echo "Exit code: $$?"

test-all: test-hello test-arithmetic test-functions

# Clean up generated files
clean:
	rm -f $(OBJECTS) $(EXECUTABLES)

# Help target
help:
	@echo "Available targets:"
	@echo "  all          - Build all assembly programs"
	@echo "  hello_world  - Build hello world program"
	@echo "  arithmetic   - Build arithmetic operations program"
	@echo "  functions    - Build functions and stack program"
	@echo "  test-hello   - Run hello world program"
	@echo "  test-arithmetic - Run arithmetic program"
	@echo "  test-functions  - Run functions program"
	@echo "  test-all     - Run all programs"
	@echo "  clean        - Remove all generated files"
	@echo "  help         - Show this help message"

.PHONY: all clean help test-hello test-arithmetic test-functions test-all
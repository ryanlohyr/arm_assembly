# Makefile for Mixed C and ARM Assembly Project

# Compiler and flags
CC = gcc
CFLAGS = -Wall -Wextra
TARGET = mixed_program
SOURCES = main.c math_functions.s

# Default target
all: $(TARGET)

# Build the mixed program
$(TARGET): $(SOURCES)
	$(CC) $(CFLAGS) $(SOURCES) -o $(TARGET)

# Run the program
run: $(TARGET)
	./$(TARGET)

# Clean build artifacts
clean:k
	rm -f $(TARGET) *.o

# Debug build with symbols
debug: CFLAGS += -g -O0
debug: $(TARGET)

# Show help
help:
	@echo "Available targets:"
	@echo "  all     - Build the program (default)"
	@echo "  run     - Build and run the program"
	@echo "  clean   - Remove build artifacts"
	@echo "  debug   - Build with debug symbols"
	@echo "  help    - Show this help message"

.PHONY: all run clean debug help

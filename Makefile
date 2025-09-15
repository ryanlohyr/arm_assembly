# Root Makefile for CG2028 Test Code Projects

# Default target - build all projects
all: mixed standalone

# Build mixed program project
mixed:
	@echo "Building mixed C+Assembly program..."
	$(MAKE) -C mixed_program

# Build standalone programs
standalone:
	@echo "Building standalone programs..."
	$(MAKE) -C standalone

# Run mixed program
run-mixed:
	@echo "Running mixed C+Assembly program:"
	$(MAKE) -C mixed_program run

# Run standalone programs
run-standalone:
	@echo "Running standalone programs:"
	$(MAKE) -C standalone run

# Run all programs
run: run-mixed run-standalone

# Clean all projects
clean:
	@echo "Cleaning all projects..."
	$(MAKE) -C mixed_program clean
	$(MAKE) -C standalone clean

# Show project structure
show:
	@echo "Project Structure:"
	@echo "├── mixed_program/     (C calling ARM assembly functions)"
	@echo "│   ├── main.c"
	@echo "│   ├── math_functions.s"
	@echo "│   └── Makefile"
	@echo "└── standalone/        (Individual C and assembly programs)"
	@echo "    ├── hello.c"
	@echo "    ├── hello.s"
	@echo "    └── Makefile"

# Show help
help:
	@echo "Available targets:"
	@echo "  all            - Build all projects (default)"
	@echo "  mixed          - Build mixed C+Assembly program"
	@echo "  standalone     - Build standalone programs"
	@echo "  run-mixed      - Build and run mixed program"
	@echo "  run-standalone - Build and run standalone programs"
	@echo "  run            - Build and run all programs"
	@echo "  clean          - Clean all build artifacts"
	@echo "  show           - Show project structure"
	@echo "  help           - Show this help message"
	@echo ""
	@echo "Individual project commands:"
	@echo "  cd mixed_program && make help"
	@echo "  cd standalone && make help"

.PHONY: all mixed standalone run-mixed run-standalone run clean show help

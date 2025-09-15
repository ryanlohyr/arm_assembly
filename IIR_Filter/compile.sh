#!/bin/bash
# Simple compilation script for IIR Filter with auto-translation

echo "===========================================" 
echo "IIR Filter Compiler with ARM Translation"
echo "==========================================="
echo ""

# Check if running on ARM Mac
if [[ $(uname -m) == "arm64" ]]; then
    echo "✓ Detected ARM64 Mac - using auto-translator"
    echo ""
    echo "Translating Cortex-M4 assembly to ARM64..."
    make clean > /dev/null 2>&1
    make
    
    if [ $? -eq 0 ]; then
        echo ""
        echo "✓ Compilation successful!"
        echo ""
        echo "Running the program:"
        echo "-------------------"
        ./build/iir_filter
    else
        echo "✗ Compilation failed"
        exit 1
    fi
else
    echo "⚠ Not running on ARM Mac - using regular compilation"
    make
fi

#!/usr/bin/env python3
"""
ARM Cortex-M4 to ARM64 Assembly Translator
Translates Thumb2/Cortex-M4 assembly to ARM64 for testing on Apple Silicon Macs
"""

import sys
import re

def translate_line(line):
    """Translate a single line from Cortex-M4 to ARM64 assembly"""
    
    # Skip/remove Cortex-M4 specific directives
    if line.strip().startswith('.syntax') or \
       line.strip().startswith('.cpu') or \
       line.strip().startswith('.fpu') or \
       line.strip().startswith('.thumb'):
        return ''
    
    # Fix .section directive for macOS
    if '.section .text' in line:
        return '.text\n'
    
    # Handle comments - ARM uses @ but AArch64 uses // or /* */
    if '@' in line and not line.strip().startswith('@'):
        # Replace inline comments
        line = line.replace('@', '//')
    elif line.strip().startswith('@'):
        # Convert full-line comments
        line = '//' + line[line.index('@')+1:]
    
    # Function declaration - add underscore prefix for macOS
    if '.global iir' in line:
        return '.global _iir\n'
    
    # Function label
    if line.strip() == 'iir:':
        return '_iir:\n'
    
    # Register mapping for common operations
    # Map R0-R11 to w0-w11 (32-bit operations) or x0-x11 (for addresses)
    original_line = line
    
    # PUSH/POP conversions
    if 'PUSH' in line:
        # PUSH {R4-R11, LR} -> stp instructions
        if '{R4-R11, LR}' in line or '{R4-R11, R14}' in line:
            return '    stp x29, x30, [sp, #-16]!\n    mov x29, sp\n    stp x19, x20, [sp, #-16]!\n'
        elif '{R14}' in line or '{LR}' in line:
            return '    str x30, [sp, #-16]!\n'
    
    if 'POP' in line:
        # POP {R4-R11, PC} -> ldp instructions
        if '{R4-R11, PC}' in line:
            return '    ldp x19, x20, [sp], #16\n    ldp x29, x30, [sp], #16\n    ret\n'
        elif '{R14}' in line or '{LR}' in line:
            return '    ldr x30, [sp], #16\n'
    
    # BX LR -> ret
    if 'BX' in line and 'LR' in line:
        return '    ret\n'
    
    # LDR with register addressing
    if re.match(r'\s*LDR\s+R(\d+),\s*\[R(\d+)\]', line):
        match = re.match(r'\s*LDR\s+R(\d+),\s*\[R(\d+)\](.*)', line)
        if match:
            rd = match.group(1)
            rn = match.group(2)
            comment = match.group(3)
            return f'    ldr w{rd}, [x{rn}]{comment}\n'
    
    # MUL instruction
    if re.match(r'\s*MUL\s+R(\d+),\s*R(\d+),\s*R(\d+)', line):
        match = re.match(r'\s*MUL\s+R(\d+),\s*R(\d+),\s*R(\d+)(.*)', line)
        if match:
            rd = match.group(1)
            rn = match.group(2)
            rm = match.group(3)
            comment = match.group(4)
            return f'    mul w{rd}, w{rn}, w{rm}{comment}\n'
    
    # SDIV instruction
    if re.match(r'\s*SDIV\s+R(\d+),\s*R(\d+),\s*R(\d+)', line):
        match = re.match(r'\s*SDIV\s+R(\d+),\s*R(\d+),\s*R(\d+)(.*)', line)
        if match:
            rd = match.group(1)
            rn = match.group(2)
            rm = match.group(3)
            comment = match.group(4)
            return f'    sdiv w{rd}, w{rn}, w{rm}{comment}\n'
    
    # CMP and conditional branch
    if re.match(r'\s*CMP\s+R(\d+),\s*#(\d+)', line):
        match = re.match(r'\s*CMP\s+R(\d+),\s*#(\d+)(.*)', line)
        if match:
            rn = match.group(1)
            imm = match.group(2)
            comment = match.group(3)
            if imm == '0':
                # For zero comparison, we'll use cbz in the next BEQ
                return f'    // cmp w{rn}, #{imm} - will use cbz{comment}\n'
            else:
                return f'    cmp w{rn}, #{imm}{comment}\n'
    
    # BEQ after CMP #0 -> cbz
    if 'BEQ' in line:
        return line.replace('BEQ', 'cbz w5,')  # Assuming R5 from previous CMP
    
    # MOV immediate
    if re.match(r'\s*MOV\s+R(\d+),\s*#(\d+)', line):
        match = re.match(r'\s*MOV\s+R(\d+),\s*#(\d+)(.*)', line)
        if match:
            rd = match.group(1)
            imm = match.group(2)
            comment = match.group(3)
            return f'    mov w{rd}, #{imm}{comment}\n'
    
    # Branch instructions
    if re.match(r'\s*B\s+(\w+)', line) and not 'BX' in line and not 'BL' in line:
        return line  # B instruction is the same
    
    # BL (Branch with Link)
    if re.match(r'\s*BL\s+(\w+)', line):
        match = re.match(r'\s*BL\s+(\w+)(.*)', line)
        if match:
            label = match.group(1)
            comment = match.group(2)
            # Check if it's a known system function
            if label == 'SUBROUTINE':
                return f'    bl {label}{comment}\n'
    
    # Labels (keep as is)
    if line.strip().endswith(':'):
        return line
    
    # Default R register replacements for remaining instructions
    # This is a fallback for instructions we haven't specifically handled
    for i in range(12):
        line = re.sub(f'\\bR{i}\\b', f'w{i}', line)
    
    # R14 -> x30 (LR)
    line = line.replace('R14', 'x30')
    
    return line

def translate_file(input_file, output_file):
    """Translate entire assembly file from Cortex-M4 to ARM64"""
    
    with open(input_file, 'r') as f:
        lines = f.readlines()
    
    translated_lines = []
    
    # Add ARM64 header
    translated_lines.append('// Auto-translated from Cortex-M4 to ARM64\n')
    translated_lines.append('.align 2\n')
    translated_lines.append('\n')
    
    # Process each line
    skip_next_beq = False
    for i, line in enumerate(lines):
        translated = translate_line(line)
        
        # Special handling for CMP R5, #0 followed by BEQ
        if 'cmp w5, #0' in translated and i + 1 < len(lines):
            next_line = lines[i + 1]
            if 'BEQ' in next_line:
                # Replace CMP + BEQ with CBZ
                label = next_line.split()[-1]
                translated_lines.append(f'    cbz w5, {label}\n')
                skip_next_beq = True
                continue
        
        if skip_next_beq and 'BEQ' in line:
            skip_next_beq = False
            continue
            
        if translated:
            translated_lines.append(translated)
    
    # Write output file
    with open(output_file, 'w') as f:
        f.writelines(translated_lines)
    
    print(f"Translated {input_file} -> {output_file}")
    return True

if __name__ == "__main__":
    if len(sys.argv) != 3:
        print("Usage: python3 arm_translator.py <input.s> <output.s>")
        sys.exit(1)
    
    input_file = sys.argv[1]
    output_file = sys.argv[2]
    
    try:
        if translate_file(input_file, output_file):
            print("Translation successful!")
    except Exception as e:
        print(f"Translation failed: {e}")
        sys.exit(1)
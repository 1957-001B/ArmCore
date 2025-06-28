'''
This file generates instructions.vh which will be used to program the BRAM
'''
import os
import subprocess
import shutil

SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))
DEBUG_DIR = os.path.join(SCRIPT_DIR, 'debug')
TARGET_FILE = os.path.join(DEBUG_DIR, 'cpu_test.s')
OUTPUT_FILE = os.path.join(DEBUG_DIR, 'generated.bin')
INSTRUCTION_SIZE = 4

instructions = [bytes]

FILE_HEADER_TEMPLATE = '''`ifndef INSTRUCTIONS_VH\n`define INSTRUCTIONS_VH\n
'''

def test():
    
    target_abs = os.path.abspath(TARGET_FILE)
    assembler_bin = '../ArmAsm/target/release/minimal-assembler'

    print(f'Starting Assembly of target: {target_abs}')
    result = subprocess.run([assembler_bin, target_abs], capture_output=True, text=True)
    
    if result.returncode != 0:
        print(f'Assembler failed with error:\n{result.stderr}')
        return

    if not os.path.exists(OUTPUT_FILE):
        print(f'Error: {OUTPUT_FILE} not found after assembly.')
        return
    
    dest_path = os.path.join(DEBUG_DIR, OUTPUT_FILE)
    shutil.move(OUTPUT_FILE, dest_path)
    print(f'Moved {OUTPUT_FILE} to {dest_path}')
    
    try:
        with open(dest_path, 'rb') as f:
            content = f.read()
            instruction_n = len(content) // INSTRUCTION_SIZE
            instructions = [content[i:i+INSTRUCTION_SIZE] for i in range(0, len(content), INSTRUCTION_SIZE)]
            instructions = [i for i in instructions if i != b'\x00\x00\x00\x00']

        with open(os.path.join(SCRIPT_DIR, 'instructions.vh'), 'w', encoding='utf-8') as f:
            f.write(FILE_HEADER_TEMPLATE)
            f.write(f'`define INSTRUCTION_N = {instruction_n};\n')
            for i, instr in enumerate(instructions):
                value = int.from_bytes(instr, 'little')
                f.write(f'instruction[{i}] = 32\'h{value:08x};\n')
            f.write('`endif\n')
            
    except IOError as e:
        print(f'File operation failed: {e}')
        

test()
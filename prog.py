import os
import subprocess
import shutil

SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))
DEBUG_DIR = os.path.join(SCRIPT_DIR, "debug")
TARGET_FILE = os.path.join(DEBUG_DIR, "cpu_test.s")
OUTPUT_FILE = os.path.join(DEBUG_DIR, "generated.bin")

Contents = bytes
instructions = [bytes]

FILE_HEADER_TEMPLATE= '''`ifndef INSTRUCTIONS_VH\n`define INSTRUCTIONS_VH\n
'''

def r(arg):
    os.system(arg)

def test():
    
    target_abs = os.path.abspath(TARGET_FILE)
    assembler_bin = "../ArmAsm/target/release/minimal-assembler"

    print(f"Starting Assembly of target: {target_abs}")
    result = subprocess.run([assembler_bin, target_abs], capture_output=True, text=True)
    
    if result.returncode != 0:
        print(f"Assembler failed with error:\n{result.stderr}")
        return

    generated_file = "generated.bin"
    if not os.path.exists(generated_file):
        print(f"Error: {generated_file} not found after assembly.")
        return
    
    os.makedirs(DEBUG_DIR, exist_ok=True)  
    dest_path = os.path.join(DEBUG_DIR, generated_file)
    shutil.move(generated_file, dest_path)
    print(f"Moved {generated_file} to {dest_path}")

    with open('/Users/camus/armcpuasm/armcore/debug/generated.bin', 'rb') as g:
        content = g.read()
        instruction_n = len(content) // 4  # Number of 32-bit instructions
        instructions = [content[i:i+4] for i in range(0, len(content), 4)]
        instructions = [i for i in instructions if i != b'\x00\x00\x00\x00']

    with open('instructions.vh', 'w', encoding='utf8') as inst:
        inst.write(FILE_HEADER_TEMPLATE)
        inst.write(f"`define INSTRUCTION_N = {instruction_n};\n")

        for i, instr in enumerate(instructions):
            value = int.from_bytes(instr, 'little')
            print(i)
            inst.write(f"instruction [{i}] = 32'h{value:08x};\n")

        inst.write("endif\n")

test()
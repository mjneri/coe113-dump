import subprocess
import argparse
import logging
import os

logging.basicConfig(level=logging.DEBUG,
                    format='(%(asctime)s) [%(levelname)s] (%(threadName)-10s) %(message)s',)

parser = argparse.ArgumentParser()
parser.add_argument("asm_file", help="name of asm file", type=str, default="test.asm")
args = parser.parse_args()

try:
    os.stat("asm/{}".format(args.asm_file))
except Exception as e:
    logging.debug("asm file doesn't exist")
    exit(e)

asm_file = 'asm/{}'.format(args.asm_file)

s = subprocess.run(['java', '-jar', 'mars.jar', 'nc', 'a', 'mc', 'CompactDataAtZero', 
    'dump', '.text', 'HexText', 'instmem.txt', asm_file])

if s.returncode:
    print("error in executing mars: dumping text region")
    exit(s.returncode)

s = subprocess.run(['java', '-jar', 'mars.jar', 'nc', 'a', 'mc', 'CompactDataAtZero', 
    'dump', '.data', 'HexText', 'datamem.txt', asm_file])

if s.returncode:
    print("error in executing mars: dumping data region")
    exit(s.returncode)

s = subprocess.run(['java', '-jar', 'mars.jar', 'nc', 'mc', 'CompactDataAtZero', 
    'dump', '.data', 'HexText', 'datamem_ans.txt', asm_file])

if s.returncode:
    print("error in executing mars: dumping data_ans region")
    exit(s.returncode)


INST_JUMP_OPCODE    = 0x02
INST_JAL_OPCODE     = 0x03

# check for J type instructions
with open("instmem.txt") as f:
    with open("instmem_temp.txt", "w") as fp:
        for line in f:
            line = line.strip()

            opcode = ( int(line,16) & 0xFC000000 ) >> 26

            if (opcode == INST_JUMP_OPCODE) or (opcode == INST_JAL_OPCODE):
                j_imm = ( int(line,16) & 0x03FFFFFF )
                j_imm -= (0x3000 >> 2)
                new_inst = (opcode << 26) | j_imm
                fp.write("{:08x}\n".format(new_inst))
            else:
                fp.write(line + "\n")

os.remove("instmem.txt")
os.rename("instmem_temp.txt", "instmem.txt")

fp = open("instmem_parse.txt", "w")

with open("instmem.txt") as f:
    for line in f:
        line = line.strip()
        
        for i in range(0, len(line), 2):
            fp.write("{}\n".format(line[i:i+2]))

fp.close()

fp = open("datamem_parse.txt", "w")

with open("datamem.txt") as f:
    for j, line in enumerate(f):
        if (j * 4 == 1024):
            break

        line = line.strip()

        for i in range(0, len(line), 2):
            fp.write("{}\n".format(line[i:i+2]))

fp.close()

fp = open("datamem_ans_parse.txt", "w")

with open("datamem_ans.txt") as f:
    for j, line in enumerate(f):
        if (j * 4 == 1024):
            break

        line = line.strip()

        for i in range(0, len(line), 2):
            fp.write("{}\n".format(line[i:i+2]))

fp.close()
import sys
import os

INST_JUMP_OPCODE    = 0x02
INST_JAL_OPCODE     = 0x03


filename = input("Filename: ")
fp = open(filename, "r+")

# check for J type instructions
with open(filename) as f:
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

fp = open("instmem_parse.mem", "w")

with open("instmem.txt") as f:
    for line in f:
        line = line.strip()
        
        for i in range(0, len(line), 2):
            fp.write("{}\n".format(line[i:i+2]))

fp.close()

fp = open("datamem_parse.mem", "w")

with open("datamem.txt") as f:
    for j, line in enumerate(f):
        if (j * 4 == 1024):
            break

        line = line.strip()

        for i in range(0, len(line), 2):
            fp.write("{}\n".format(line[i:i+2]))

fp.close()

fp = open("datamem_ans_parse.mem", "w")

with open("datamem_ans.txt") as f:
    for j, line in enumerate(f):
        if (j * 4 == 1024):
            break

        line = line.strip()

        for i in range(0, len(line), 2):
            fp.write("{}\n".format(line[i:i+2]))

fp.close()


# print("contents of " + fp.name + ": ")
# s = fp.read()
# print(s)

# # Check end position (total bytes)
# fpos = fp.tell()
# print("Final file position : ", fpos)

# # Go back to start of file
# pos = fp.seek(0,0)

# # Remove \n
# stemp = []
# for c in s:
#     if c != "\n":
#         stemp.append(c)
# s = ''.join(stemp)

# # Separate to 1byte segments
# i = 0
# stemp = []
# for c in s:
#     if i%2==0 and i!=0:
#         stemp.append("\n")
#         stemp.append(c)
#     else:
#         stemp.append(c)
#     i = i + 1

# parsed = ''.join(stemp)			# convert char list to string
# print("Parsed:",parsed)	# print parsed data

# fp.close()

# filename = input("Save to: ")
# fp = open(filename, "w+")
# fp.write(parsed)
# fp.close()
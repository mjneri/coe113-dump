import sys
import os
import time

INST_JUMP_OPCODE    = 0x02
INST_JAL_OPCODE     = 0x03


filename = 'text.dmp'
fp = open(filename, "r+")
print("contents of " + fp.name + ": ")
s = fp.read()
print(s)

# Check end position (total bytes)
fpos = fp.tell()
print("Final file position : ", fpos)

# Go back to start of file
pos = fp.seek(0,0)

# Remove \n
s = s.replace('\n', '')
i = 0
stemp = ''
for c in s:
	if i%8==0:
		line = s[i:i+8]
		opcode = ( int(line, 16) & 0xFC000000 ) >> 26
		if(opcode == INST_JUMP_OPCODE) or (opcode == INST_JAL_OPCODE):
			j_imm = ( int(line, 16) & 0x03FFFFFF ) << 2
			j_imm -= (0x3000)
			stemp += '0' + format( ((opcode << 26) | j_imm >> 2), 'x' )
		else:
			stemp += line
	i = i + 1
s = stemp
print(s)

# Separate to 1byte segments
i = 0
stemp = []
for c in s:
    if i%2==0 and i!=0:
        stemp.append("\n")
        stemp.append(c)
    else:
        stemp.append(c)
    i = i + 1

parsed = ''.join(stemp)			# convert char list to string
print("Parsed:\n" + parsed)	# print parsed data

fp.close()

filename = 'instmem_parse.txt'
fp = open(filename, "w+")
fp.write(parsed)
fp.close()
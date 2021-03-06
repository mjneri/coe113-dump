import sys
import os
import time

filename = 'data.dmp'
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

filename = 'datamem_parse.txt'
fp = open(filename, "w+")
fp.write(parsed)
fp.close()

#
filename = 'data_ans.dmp'
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

filename = 'datamem_ans_parse.txt'
fp = open(filename, "w+")
fp.write(parsed)
fp.close()
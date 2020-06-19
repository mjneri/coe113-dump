# Test program for MIPS Verilog
.data 0x000001c0
	# Constants -> test the following cases for each input: both positive, both negative, one positive one negative
	# for add, sub, slt, addi, and slti
	# these should be able to test whether negative values are used correctly
	# Notes: should also test the following:
	# Add/i: x + 0, 0 + x, -x + 0, 0 + (-x), 0 + 0, 7fff ffff + 1(overflow), 8000 0000 + (-1) (underflow) ( +7 cases)
	# Sub: x - 0, 0 - x, -x - 0, 0 - (-x), 0 - 0, 8000 0000 - 1 (underflow), 7fff ffff - (-1) (overflow) ( +7 cases)
	# Slt/i: x < 0, 0 < x, -x < 0, 0 < -x ( +4 cases)
	c1: .word 113
	c2: .word 105
	c3: .word 197
	c4: .word -113
	c5: .word -105
	c6: .word -197
	c7: .word 0x7fffffff
	c8: .word 0x80000000
	c9: .word 1
	c10: .word -1
	
.text
main:
	#lw & sw test (6 cases)
	lw $t1, 0x000001c0($0)
	lw $t2, 0x000001c4($0)
	lw $t3, 0x000001c8($0)
	lw $t4, 0x000001cc($0)
	lw $t5, 0x000001d0($0)
	lw $t6, 0x000001d4($0)
	
	sw $t6, 0($0)
	sw $t5, 4($0)
	sw $t4, 8($0)
	sw $t3, 12($0)
	sw $t2, 16($0)
	sw $t1, 20($0)
	
	# test beq (12 cases)
	# if the values are equal, the 2nd sw call should be skipped.
	sw $t1, 264($0)
	beq $t1, $t2, beq1
	sw $t2, 264($0)
beq1:
	sw $t2, 268($0)
	beq $t1, $t3, beq2
	sw $t3, 268($0)	
	
	# test bne (12 cases)
	# same with the beq test. if the values are NOT equal, the 2nd sw should be skipped
bne1:
	sw $t1, 312($0)
	bne $t1, $t2, bne2
	sw $t2, 312($0)
	
	#test jump
	sw $t3, 468($0)
	j j_test
	sw $t4, 468($0)
	
	# test jal
j_test:
	jal jal_test
	sw $t6, 476($0)
	j end
	
	# test jr
jal_test:
	sw $t5, 472($0)
	jr $ra
	
end:
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
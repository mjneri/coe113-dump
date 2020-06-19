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
	
	#test addition (12 cases) (++, --, +-, -+)
	add $s0, $t1, $t2
	sw $s0, 24($0)
	add $s0, $t1, $t3
	sw $s0, 28($0)
	add $s0, $t1, $t1
	sw $s0, 32($0)
	add $s0, $t4, $t6
	sw $s0, 36($0)
	add $s0, $t4, $t5
	sw $s0, 40($0)
	add $s0, $t4, $t4
	sw $s0, 44($0)
	add $s0, $t1, $t4
	sw $s0, 48($0)
	add $s0, $t1, $t6
	sw $s0, 52($0)
	add $s0, $t1, $t5
	sw $s0, 56($0)
	add $s0, $t4, $t3
	sw $s0, 60($0)
	add $s0, $t4, $t2
	sw $s0, 64($0)
	add $s0, $t4, $t1
	sw $s0, 68($0)
	
	#test subtraction (12 cases) (++, --, +-, -+)
	sub $s0, $t1, $t2
	sw $s0, 72($0)
	sub $s0, $t1, $t3
	sw $s0, 76($0)
	sub $s0, $t1, $t1
	sw $s0, 80($0)
	sub $s0, $t4, $t6
	sw $s0, 84($0)
	sub $s0, $t4, $t5
	sw $s0, 88($0)
	sub $s0, $t4, $t4
	sw $s0, 92($0)
	sub $s0, $t1, $t4
	sw $s0, 96($0)
	sub $s0, $t1, $t6
	sw $s0, 100($0)
	sub $s0, $t1, $t5
	sw $s0, 104($0)
	sub $s0, $t4, $t3
	sw $s0, 108($0)
	sub $s0, $t4, $t2
	sw $s0, 112($0)
	sub $s0, $t4, $t1
	sw $s0, 116($0)
	
	#test slt (12 cases) (++, --, +-, -+)
	slt $s0, $t1, $t2
	sw $s0, 120($0)
	slt $s0, $t1, $t3
	sw $s0, 124($0)
	slt $s0, $t1, $t1
	sw $s0, 128($0)
	slt $s0, $t4, $t6
	sw $s0, 132($0)
	slt $s0, $t4, $t5
	sw $s0, 136($0)
	slt $s0, $t4, $t4
	sw $s0, 140($0)
	slt $s0, $t1, $t4
	sw $s0, 144($0)
	slt $s0, $t1, $t6
	sw $s0, 148($0)
	slt $s0, $t1, $t5
	sw $s0, 152($0)
	slt $s0, $t4, $t3
	sw $s0, 156($0)
	slt $s0, $t4, $t2
	sw $s0, 160($0)
	slt $s0, $t4, $t1
	sw $s0, 164($0)
	
	#test addi (12 cases) (++, --, +-, -+)
	addi $s0, $t1, 105
	sw $s0, 168($0)
	addi $s0, $t1, 197
	sw $s0, 172($0)
	addi $s0, $t1, 113
	sw $s0, 176($0)
	addi $s0, $t4, -197
	sw $s0, 180($0)
	addi $s0, $t4, -105
	sw $s0, 184($0)
	addi $s0, $t4, -113
	sw $s0, 188($0)
	addi $s0, $t1, -113
	sw $s0, 192($0)
	addi $s0, $t1, -197
	sw $s0, 196($0)
	addi $s0, $t1, -105
	sw $s0, 200($0)
	addi $s0, $t4, 197
	sw $s0, 204($0)
	addi $s0, $t4, 105
	sw $s0, 208($0)
	addi $s0, $t4, 113
	sw $s0, 212($0)
	
	#test slti (15 cases) (++, --, +-, -+)
	slti $s0, $t1, 105
	sw $s0, 216($0)
	slti $s0, $t1, 197
	sw $s0, 220($0)
	slti $s0, $t1, 113
	sw $s0, 224($0)
	slti $s0, $t4, -197
	sw $s0, 228($0)
	slti $s0, $t4, -105
	sw $s0, 232($0)
	slti $s0, $t4, -113
	sw $s0, 236($0)
	slti $s0, $t1, -113
	sw $s0, 240($0)
	slti $s0, $t1, -197
	sw $s0, 244($0)
	slti $s0, $t1, -105
	sw $s0, 248($0)
	slti $s0, $t4, 197
	sw $s0, 252($0)
	slti $s0, $t4, 105
	sw $s0, 256($0)
	slti $s0, $t4, 113
	sw $s0, 260($0)
	
	# test beq (12 cases)
	# if the values are equal, the 2nd sw call should be skipped.
	sw $t1, 264($0)
	beq $t1, $t2, beq1
	sw $t2, 264($0)
beq1:
	sw $t2, 268($0)
	beq $t1, $t3, beq2
	sw $t3, 268($0)	
beq2:
	sw $t3, 272($0)
	beq $t1, $t1, beq3
	sw $t4, 272($0)	
	
beq3:
	sw $t4, 276($0)
	beq $t4, $t6, beq4
	sw $t5, 276($0)		
beq4:
	sw $t5, 280($0)
	beq $t4, $t5, beq5
	sw $t6, 280($0)
beq5:
	sw $t6, 284($0)
	beq $t4, $t4, beq6
	sw $t1, 284($0)
	
beq6:
	sw $t1, 288($0)
	beq $t1, $t4, beq7
	sw $t2, 288($0)
beq7:
	sw $t2, 292($0)
	beq $t1, $t6, beq8
	sw $t3, 292($0)
beq8:
	sw $t3, 296($0)
	beq $t1, $t5, beq9
	sw $t4, 296($0)
	
beq9:
	sw $t4, 300($0)
	beq $t4, $t3, beq10
	sw $t5, 300($0)
beq10:
	sw $t5, 304($0)
	beq $t4, $t2, beq11
	sw $t6, 304($0)
beq11:
	sw $t6, 308($0)
	beq $t4, $t1, bne1
	sw $t1, 308($0)
	
	# test bne (12 cases)
	# same with the beq test. if the values are NOT equal, the 2nd sw should be skipped
bne1:
	sw $t1, 312($0)
	bne $t1, $t2, bne2
	sw $t2, 312($0)
bne2:
	sw $t2, 316($0)
	bne $t1, $t3, bne3
	sw $t3, 316($0)	
bne3:
	sw $t3, 320($0)
	bne $t1, $t1, bne4
	sw $t4, 320($0)	
	
bne4:
	sw $t4, 324($0)
	bne $t4, $t6, bne5
	sw $t5, 324($0)		
bne5:
	sw $t5, 328($0)
	bne $t4, $t5, bne6
	sw $t6, 328($0)
bne6:
	sw $t6, 332($0)
	bne $t4, $t4, bne7
	sw $t1, 332($0)
	
bne7:
	sw $t1, 336($0)
	bne $t1, $t4, bne8
	sw $t2, 336($0)
bne8:
	sw $t2, 340($0)
	bne $t1, $t6, bne9
	sw $t3, 340($0)
bne9:
	sw $t3, 344($0)
	bne $t1, $t5, bne10
	sw $t4, 344($0)
	
bne10:
	sw $t4, 348($0)
	bne $t4, $t3, bne11
	sw $t5, 348($0)
bne11:
	sw $t5, 352($0)
	bne $t4, $t2, bne12
	sw $t6, 352($0)
bne12:
	sw $t6, 356($0)
	bne $t4, $t1, addendum
	sw $t1, 356($0)

	# test additional add cases
addendum:	
	add $s0, $t1, $0	# x + 0
	sw $s0, 360($0)
	add $s0, $0, $t1	# 0 + x
	sw $s0, 364($0)
	add $s0, $t4, $0	# -x + 0
	sw $s0, 368($0)
	add $s0, $0, $t4	# 0 + -x
	sw $s0, 372($0)
	add $s0, $0, $0	# 0 + 0
	sw $s0, 376($0)
	
	# test addi cases
	addi $s0, $t1, 0	# x + 0
	sw $s0, 380($0)
	addi $s0, $0, 113 # 0 + x
	sw $s0, 384($0)
	addi $s0, $t4, 0	# -x + 0
	sw $s0, 388($0)
	addi $s0, $0, -113	# 0 + -x
	sw $s0, 392($0)
	addi $s0, $0, 0	# 0 + 0
	sw $s0, 396($0)
	
	# test sub cases
	sub $s0, $t1, $0	# x - 0
	sw $s0, 400($0)
	sub $s0, $0, $t1	# 0 -x
	sw $s0, 404($0)
	sub $s0, $t4, $0	# -x - 0
	sw $s0, 408($0)
	sub $s0, $0, $t4	# 0 - -x
	sw $s0, 412($0)
	sub $s0, $0, $0	# 0 - 0
	sw $s0, 416($0)
	
	# test slt cases
	slt $s0, $t1, $0	# x < 0
	sw $s0, 420($0)
	slt $s0, $0, $t1	# 0 < x
	sw $s0, 424($0)
	slt $s0, $t4, $0	# -x < 0
	sw $s0, 428($0)
	slt $s0, $0, $t4	# 0 < -x
	sw $s0, 432($0)
	
	# test slti cases
	slti $s0, $t1, 0	# x < 0
	sw $s0, 436($0)
	slti $s0, $0, 113	# 0 < x
	sw $s0, 440($0)
	slti $s0, $t4, 0	# -x < 0
	sw $s0, 444($0)
	slti $s0, $0, -113	# 0 < -x
	sw $s0, 448($0)
	
	# test sll
	sll $s0, $t1, 1
	sw $s0, 452($0)
	sll $s0, $t2, 31
	sw $s0, 456($0)
	
	# test srl
	srl $s0, $t3, 1
	sw $s0, 460($0)
	srl $s0, $t4, 31
	sw $s0, 464($0)
	
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

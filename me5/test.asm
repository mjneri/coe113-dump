# Test program for MIPS Verilog
.data 0x000001c0
	c1: .word 113
	c2: .word 105
	c3: .word 197
	c4: .word -113
	c5: .word -105
	c6: .word -197
	
.text
main:
	#lw & sw test (6 cases)
	lw $t1, 0x000001c0($0)
	lw $t2, 0x000001c4($0)
	lw $t3, 0x000001c8($0)
	lw $t4, 0x000001cc($0)
	lw $t5, 0x000001d0($0)
	lw $t6, 0x000001d4($0)
	
	sw $t1, 0($0)
	sw $t2, 4($0)
	sw $t3, 8($0)
	sw $t4, 12($0)
	sw $t5, 16($0)
	sw $t6, 20($0)
	
	# test jal
j_test:
	jal jal_test
	sw $t1, 28($0)
	add $0, $0, $0
	add $0, $0, $0
	add $0, $0, $0
	beq $0, $0, end
	j main
	
	# test jr
jal_test:
	sw $t2, 24($0)
	addi $s0, $0, 42
	addi $s1, $0, 43
	addi $s2, $0, 44
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

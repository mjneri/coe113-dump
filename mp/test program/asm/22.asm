# Test program for MIPS Verilog
.data 0x000001c0
	c1: .word 113
	
.text
main:
	#lw & sw test (6 cases)
	lw $t1, 0x000001c1($0)
	add $t2, $t1, $t1
	add $t3, $t1, $t1
	add $t4, $t2, $t2
	
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

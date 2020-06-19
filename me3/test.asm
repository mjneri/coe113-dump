.data 
	i: .word 2
	j: .word 4

.text
main:
	lw $t0, i
	sw $t1, i
	sw $t1, j
.data
    lw_sw_test0: .space 4
    add_res0:  .space 4
    sub_res0:  .space 4
    slt_res0:  .space 4
    addi_res0:  .space 4
    slti_res0:  .space 4
    sll_test0: .space 4
    srl_test0: .space 4

    .space 8
    var1: .word 0x12341234
    var2: .word 0xADE1B055

    var3:   .word   -1
    var4:   .word   0x0000FFFF
    var5:   .word   0x7FFFFFFF
    var6:   .word   -123456789
    var7:   .word   50

    var8:   .word -1
    var9:   .word 1

.text
main:
    lw $t0, var3
    lw $t1, var4
    lw $t2, var5
    lw $t3, var6
    lw $t5, var7

    sw $t0, lw_sw_test0

    add $t4, $t0, $t1   # (-) + (+)
    sw $t4, add_res0

    sub $t4, $t0, $t1   # (-) - (+)
    sw $t4, sub_res0

    slt $t4, $t0, $t1   # (-) < (+)
    sw $t4, slt_res0

    slti $t4, $t0, 100   # (-) < (+)
    sw $t4, slti_res0

    addi $t4, $t0, 100    # (-) + (+)
    sw $t4, addi_res0

    sll $t2, $t0, 14
    sw $t2, sll_test0

    srl $t2, $t0, 16
    sw $t2, srl_test0

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

addi t2, x0, -4
addi t1, x0, 0
nop
nop
nop
tag:
    addi t1, t1, 3
    nop
    nop
    nop
    nop
    addi t2, t2, 4
    nop
    nop
    nop
    nop
    sw t1, 0(t2)
    jal tag

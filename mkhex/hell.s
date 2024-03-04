test:
    li a1, 2 
    li a2, 2
    add a3, a1,a2
    add a3, a3, a3
    sw a3, 0(zero)
    jal jump
    li a1, 3 
    li a2, 3
    li a1, 4 
    li a2, 4

jump:
    add a4, ra, zero
    ret

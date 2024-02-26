test:
    li x1, 5
    sw x1,0(x0)
    li x2, 6 
    sw x2,4(x0)
    add x3, x1, x2
    beq x1, x2, 10
    add x10, x0, x2

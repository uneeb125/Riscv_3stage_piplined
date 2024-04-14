    li x1, 5
    lui x4, 0x80000

    sw x1, 0(x0)
    sw x1, 0(x4)
    li x2, 1
    sw x2, 4(x4)
    li x3, 1
    sw x3, 8(x4)

 

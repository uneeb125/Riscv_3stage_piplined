    li x4, 0
    auipc x1, 0
    add x1, x1, 0x44
    csrrw x1, mtvec, x1
    addi x4, x4, 0xff
    addi x4, x4, 0xff
    csrrw x1,mie,x4
    csrrw x1,mip,x4
    csrrw x1,mstatus,x4
    sw x1, 0(x0)
    li x1, 5
    sw x1, 0(x4)
    li x2, 1
    sw x2, 4(x4)
    li x3, 1
    sw x3, 8(x4)
    lw x6, 0(x4)
    lw x7, 4(x4)

interrupt_handler:
    csrrw x0,mie,x0
    csrrw x0,mie,x11
    li x1, 8
    mret


 

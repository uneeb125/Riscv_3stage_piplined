j main

interrupt_handler:
    lui x4, 0x80000
    lw x1, 12(x4)
    sw x1, 4(x0)
    mret
main:
    lw x1, 0(x0)
    lui x4, 0x80000
    sw x1, 0(x4)
    li x2, 2
    sw x2, 4(x4)
    li x3, 3 
    sw x3, 20(x4)
    li x3, 1
    sw x3, 8(x4)
    lw x6, 0(x4)
    lw x7, 4(x4)
    add x4,x0,x8 
    li x1, 0x4
    csrrw x1,mtvec, x1
    csrrw x1,mie,x8
    csrrw x1,mstatus,x4
loop:
    j loop



 

test:
    li x1, 2 
    li x2, 2
    li x3, 5
    beq x1,x2, branch
    sw x1, 0(x0)

branch:
    sw x3, 0(x0)
    
    

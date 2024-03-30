    li x8, 11
    li x9, 110
    
gcd:   beq x8, x9, stop 
       blt x8, x9, less 
       sub x8, x8, x9 

less: 
       sub x9, x9, x8 
       j gcd        

stop:  sw x8,0(x0) 

end:   lw x10,0(x0) 
       j end      


module forward_unit #(parameter Width = 32) 
    (
        input logic reg_wrMW, br_taken,
        input logic [Width-1:0] ir_FD,ir_EM,
        output logic stall,stall_MW,flush,fora,forb
    );
    
    logic [4:0] EM_rs1_addr, EM_rs2_addr,FD_rd_addr;
    assign EM_rs1_addr = ir_EM[19:15];
    assign EM_rs2_addr = ir_EM[24:20];
    assign FD_rd_addr = ir_FD[11:7];

    assign fora = (FD_rd_addr == EM_rs1_addr);
    assign forb = (FD_rd_addr == EM_rs2_addr);
    
    assign flush = br_taken;
    endmodule
    
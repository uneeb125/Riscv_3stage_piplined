module forward_unit #(parameter Width = 32) 
    (
        input logic reg_wrMW, br_taken,
        input logic [Width-1:0] ir_FD,ir_EM,
        output logic stall,stall_MW,flush,fora,forb
    );
    
    logic [4:0] FD_rs1_addr, FD_rs2_addr,EM_rd_addr;
    assign FD_rs1_addr = ir_FD[19:15];
    assign FD_rs2_addr = ir_FD[24:20];
    assign EM_rd_addr = ir_EM[11:7];

    assign fora = (EM_rd_addr == FD_rs1_addr)&&FD_rs1_addr;
    assign forb = (EM_rd_addr == FD_rs2_addr)&&FD_rs2_addr; 
    assign flush = br_taken;
    endmodule
    
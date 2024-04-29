`include "../DEFS/DEFS.svh"
module forward_unit #(parameter Width = 32) 
    (
        input logic is_mret,
        input logic dmem_en,
        input logic reg_wrMW, br_taken,
        input logic [Width-1:0] ir_FD,ir_EM,
        output logic stall,stall_MW,flush,fora,forb
    );
    struc_inst FD;
    struc_inst EM;
    
    assign FD.rs1 = ir_FD[19:15];
    assign FD.rs2 = ir_FD[24:20];
    assign EM.rd = ir_EM[11:7];

    assign fora = (EM.rd == FD.rs1)&&FD.rs1&&dmem_en;
    assign forb = (EM.rd == FD.rs2)&&FD.rs2&&dmem_en; 

    assign flush = br_taken | (is_mret);
    endmodule
    

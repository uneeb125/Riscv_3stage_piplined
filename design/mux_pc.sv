module mux_pc (
    input logic  br_taken,              //signal from controller
    input logic  [31:0] pc_next,alu_result,
    output logic [31:0] pc
);
 always_comb 
 begin 
    case (br_taken)
        1'b0 :   pc = pc_next;
        1'b1 :   pc = alu_result; 
        default: pc = pc_next;
    endcase
 end 
endmodule
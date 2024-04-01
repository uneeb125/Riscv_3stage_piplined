`ifndef DEFS
`define DEFS

typedef enum logic[6:0] { 
    op_r = 7'b0110011,
    op_i = 7'b0010011,
    op_l = 7'b0000011,
    op_s = 7'b0100011,
    op_b = 7'b1100011,
    op_a = 7'b0010111,
    op_ui = 7'b0110111,
    op_j = 7'b1101111,
    op_jr = 7'b1100111
} type_opcode;



typedef enum logic[3:0] { 
    alu_add    =   4'b0000,
    alu_sub    =   4'b0001,
    alu_sll    =   4'b0010,
    alu_slt    =   4'b0011,
    alu_sltu   =   4'b0100,
    alu_xor    =   4'b0101,
    alu_srl    =   4'b0110,
    alu_sra    =   4'b0111,
    alu_or     =   4'b1000, 
    alu_and    =   4'b1001
} type_alu_op;


typedef struct packed { 
    logic [6:0] opcode;
    logic [4:0] rd;
    logic [4:0] rs1;
    logic [4:0] rs2;
} struc_inst;
`endif

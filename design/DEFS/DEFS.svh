`ifndef DEFS
`define DEFS

typedef enum logic [6:0] {
  OP_R  = 7'b0110011,
  OP_I  = 7'b0010011,
  OP_L  = 7'b0000011,
  OP_S  = 7'b0100011,
  OP_B  = 7'b1100011,
  OP_A  = 7'b0010111,
  OP_UI = 7'b0110111,
  OP_J  = 7'b1101111,
  OP_JR = 7'b1100111,
  OP_CSR= 7'b1110011
} type_opcode;

typedef enum logic [3:0] {
  DMEM_ADDR = 4'h0,
  UART_ADDR = 4'h8
} type_mem_map;



typedef enum logic [3:0] {
  ALU_ADD  = 4'b0000,
  ALU_SUB  = 4'b0001,
  ALU_SLL  = 4'b0010,
  ALU_SLT  = 4'b0011,
  ALU_SLTU = 4'b0100,
  ALU_XOR  = 4'b0101,
  ALU_SRL  = 4'b0110,
  ALU_SRA  = 4'b0111,
  ALU_OR   = 4'b1000,
  ALU_AND  = 4'b1001
} type_alu_op;


typedef struct packed {
  logic [6:0] opcode;
  logic [4:0] rd;
  logic [4:0] rs1;
  logic [4:0] rs2;
} struc_inst;

typedef enum logic [11:0] {
  MSTATUS_ADDR = 12'h300,
  MIE_ADDR     = 12'h304,
  MTVEC_ADDR   = 12'h305,
  MEPC_ADDR    = 12'h341,
  MCAUSE_ADDR  = 12'h342,
  MIP_ADDR     = 12'h344
} type_csr_addr;


`endif

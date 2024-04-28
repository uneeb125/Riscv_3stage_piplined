`include "../DEFS/DEFS.svh"
module controller (
    input logic [6:0] opcode_in,     
    input [2:0] funct3,     
    input [6:0] funct7,     
    output reg [3:0] alu_op,
    output reg reg_write,  
    output reg PCen,        
    output reg read_en,
    output reg [1:0] wb_sel,
    output reg write_en,
    output reg [1:0] br_type,
    output reg sel_A,
    output reg sel_B,
    output reg csr_reg_rdpin,
    output reg csr_reg_wrpin,
    output reg is_mret
    );
type_opcode opcode;

assign opcode = type_opcode'(opcode_in);

always_comb begin

    case (opcode)
        OP_R: begin //R-Type
            reg_write = 1'b1;
            write_en=1'b0;
            read_en=1'b0;
            wb_sel=2'b01;
            br_type=2'b00;
            sel_A=1'b1;
            sel_B=1'b1;
            PCen = 1'b1;
            csr_reg_rdpin = 1'b0;
            csr_reg_wrpin = 1'b0;
            case ({funct7, funct3})
                10'b0000000000: alu_op = ALU_ADD  ; // ADD (0)
                10'b0100000000: alu_op = ALU_SUB  ; // SUB (1)
                10'b0000000001: alu_op = ALU_SLL  ; // SLL (2)
                10'b0000000010: alu_op = ALU_SLT  ; // SLT (3)
                10'b0000000011: alu_op = ALU_SLTU ; // SLTU (4)
                10'b0000000100: alu_op = ALU_XOR  ; // XOR (5)
                10'b0000000101: alu_op = ALU_SRL  ; // SRL (6)
                10'b0100000101: alu_op = ALU_SRA  ; // SRA (7)
                10'b0000000110: alu_op = ALU_OR   ; // OR (8)
                10'b0000000111: alu_op = ALU_AND  ; // AND (9)
                default: alu_op = ALU_ADD; // Undefined operation (31)
            endcase
        end

        // I-type opcode (for example, 0010011)
        OP_I: begin
            reg_write = 1'b1; // I-type instructions write to register
            read_en=1'b0;
            write_en=1'b0;
            wb_sel=2'b01;
            br_type=2'b00;
            sel_A=1'b1;
            sel_B=1'b0;
            PCen = 1'b1;
            csr_reg_wrpin = 1'b0;
            csr_reg_rdpin = 1'b0;
            // Determine ALU operation based on funct3
            case (funct3)
                3'b000: alu_op = ALU_ADD ; // ADDI (0)
                3'b010: alu_op = ALU_SLT  ; // SLTI (3)
                3'b011: alu_op = ALU_SLTU; // SLTIU (4)
                3'b100: alu_op = ALU_XOR ; // XORI (5)
                3'b110: alu_op = ALU_OR  ; // ORI (8)
                3'b111: alu_op = ALU_AND ; // ANDI (9)
                3'b001: alu_op = ALU_SLL ; // SLLI (2)
                3'b101: alu_op = (funct7[5] == 1'b0) ? ALU_SRL : ALU_SRA; // SRLI (17) if funct7[5] is 0, SRAI (18) if 1
                default: alu_op = ALU_ADD; // Undefined operation (31)
            endcase
        end


        // L-type opcode (for example, 0000011)
        OP_L: begin
            reg_write = 1'b1; // Load-type instructions write to register
            read_en=1'b1;
            wb_sel =2'b00;
            write_en=1'b0;
            br_type=2'b00;
            sel_A=1'b1;
            sel_B=1'b0;
            PCen = 1'b1;
            csr_reg_wrpin = 1'b0;
            csr_reg_rdpin = 1'b0;
            // Determine ALU operation based on funct3
            case (funct3)
                3'b000: alu_op = ALU_ADD; // LB (0)
                3'b001: alu_op = ALU_ADD; // LH (0)
                3'b010: alu_op = ALU_ADD; // LW (0)
                3'b100: alu_op = ALU_ADD; // LBU (0)
                3'b101: alu_op = ALU_ADD; // LHU (0)
                default: alu_op = ALU_ADD; // Undefined operation (0)
            endcase
        end
        
        OP_S: begin//Sw Opcode
            reg_write=1'b0;
            write_en=1'b1;
            wb_sel=2'b00;
            read_en=1'b0;
            br_type=2'b00;
            sel_A=1'b1;
            sel_B=1'b0;
            PCen = 1'b1;
            csr_reg_wrpin = 1'b0;
            csr_reg_rdpin = 1'b0;
            case(funct3)
                3'b010:alu_op=ALU_ADD; //sw(0)
               default: alu_op = ALU_ADD; // Undefined operation (0)
            endcase
            end

        OP_B: begin //Branch Opcode
            reg_write=1'b0;
            write_en=1'b0;
            wb_sel=2'b01;
            read_en=1'b0;
            br_type=2'b01;
            sel_A=1'b0;
            sel_B=1'b0;
            PCen = 1'b1;
            alu_op = ALU_ADD;
            csr_reg_wrpin = 1'b0;
            csr_reg_rdpin = 1'b0;
            end
        // AUIPC
        OP_A: begin
            reg_write = 1'b1; // I-type instructions write to register
            read_en=1'b0;
            write_en=1'b0;
            wb_sel=2'b01;
            br_type=2'b00;
            sel_A=1'b0;
            sel_B=1'b0;
            PCen = 1'b1;
            csr_reg_wrpin = 1'b0;
            csr_reg_rdpin = 1'b0;
            
        end
        // LUI
        OP_UI: begin
            reg_write = 1'b1; // I-type instructions write to register
            read_en=1'b0;
            write_en=1'b0;
            wb_sel=2'b01;
            br_type=2'b00;
            sel_A=1'b1;
            sel_B=1'b0;
            PCen = 1'b1;
            csr_reg_wrpin = 1'b0;
            csr_reg_rdpin = 1'b0;
            
        end

        //Jal opcode
        OP_J: begin
            reg_write = 1'b1; 
            read_en=1'b0;
            write_en=1'b0;
            wb_sel=2'b10;
            br_type=2'b10;
            sel_A=1'b0;
            sel_B=1'b0;
            PCen = 1'b1;
            alu_op = ALU_ADD;
            csr_reg_wrpin = 1'b0;
            csr_reg_rdpin = 1'b0;
            
        end

        //JalR opcode
        OP_JR: begin
            reg_write = 1'b1; 
            read_en=1'b0;
            write_en=1'b0;
            wb_sel=2'b10;
            br_type=2'b10;
            sel_A=1'b1;
            sel_B=1'b0;
            PCen = 1'b1;
            alu_op = ALU_ADD;
            csr_reg_wrpin = 1'b0;
            csr_reg_rdpin = 1'b0;
            
        end

        OP_CSR: begin
            csr_reg_wrpin = 1'b1;
            csr_reg_rdpin = 1'b1;
            wb_sel     = 2'b11;
            reg_write  = 1'b1;
            br_type    = 2'b00;


        end

        default: begin
            alu_op = ALU_ADD; // Undefined operation (31)
            PCen = 1'b1;
            csr_reg_wrpin = 1'b0;
            csr_reg_rdpin = 1'b0;
            reg_write = 1'b0;
            write_en=1'b0;
            read_en=1'b0;
            wb_sel=2'b00;
            br_type=2'b00;
            sel_A=1'b1;
        end
    endcase
end

always_comb begin
    is_mret = 1'b0;
    case ( opcode )
    32'h30200073: is_mret = 1'b1; // Here 30200073 is hex value of mret instruction
    endcase
end

endmodule

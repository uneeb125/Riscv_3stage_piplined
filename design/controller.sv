`include "DEFS.svh"
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
    output reg sel_B
    );
type_opcode opcode;

assign opcode = type_opcode'(opcode_in);

always_comb begin

    case (opcode)
        op_r: begin //R-Type
            reg_write = 1'b1;
            write_en=1'b0;
            read_en=1'b0;
            wb_sel=2'b01;
            br_type=2'b00;
            sel_A=1'b1;
            sel_B=1'b1;
            PCen = 1'b1;
            case ({funct7, funct3})
                10'b0000000000: alu_op = alu_add  ; // ADD (0)
                10'b0100000000: alu_op = alu_sub  ; // SUB (1)
                10'b0000000001: alu_op = alu_sll  ; // SLL (2)
                10'b0000000010: alu_op = alu_slt  ; // SLT (3)
                10'b0000000011: alu_op = alu_sltu ; // SLTU (4)
                10'b0000000100: alu_op = alu_xor  ; // XOR (5)
                10'b0000000101: alu_op = alu_srl  ; // SRL (6)
                10'b0100000101: alu_op = alu_sra  ; // SRA (7)
                10'b0000000110: alu_op = alu_or   ; // OR (8)
                10'b0000000111: alu_op = alu_and  ; // AND (9)
                default: alu_op = alu_add; // Undefined operation (31)
            endcase
        end

        // I-type opcode (for example, 0010011)
        op_i: begin
            reg_write = 1'b1; // I-type instructions write to register
            read_en=1'b0;
            write_en=1'b0;
            wb_sel=2'b01;
            br_type=2'b00;
            sel_A=1'b1;
            sel_B=1'b0;
            PCen = 1'b1;
            // Determine ALU operation based on funct3
            case (funct3)
                3'b000: alu_op = alu_add ; // ADDI (0)
                3'b010: alu_op = alu_slt  ; // SLTI (3)
                3'b011: alu_op = alu_sltu; // SLTIU (4)
                3'b100: alu_op = alu_xor ; // XORI (5)
                3'b110: alu_op = alu_or  ; // ORI (8)
                3'b111: alu_op = alu_and ; // ANDI (9)
                3'b001: alu_op = alu_sll ; // SLLI (2)
                3'b101: alu_op = (funct7[5] == 1'b0) ? alu_srl : alu_sra; // SRLI (17) if funct7[5] is 0, SRAI (18) if 1
                default: alu_op = alu_add; // Undefined operation (31)
            endcase
        end


        // L-type opcode (for example, 0000011)
        op_l: begin
            reg_write = 1'b1; // Load-type instructions write to register
            read_en=1'b1;
            wb_sel =2'b00;
            write_en=1'b0;
            br_type=2'b00;
            sel_A=1'b1;
            sel_B=1'b0;
            PCen = 1'b1;
            // Determine ALU operation based on funct3
            case (funct3)
                3'b000: alu_op = alu_add; // LB (0)
                3'b001: alu_op = alu_add; // LH (0)
                3'b010: alu_op = alu_add; // LW (0)
                3'b100: alu_op = alu_add; // LBU (0)
                3'b101: alu_op = alu_add; // LHU (0)
                default: alu_op = alu_add; // Undefined operation (0)
            endcase
        end
        
        op_s: begin//Sw Opcode
            reg_write=1'b0;
            write_en=1'b1;
            wb_sel=2'b00;
            read_en=1'b0;
            br_type=2'b00;
            sel_A=1'b1;
            sel_B=1'b0;
            PCen = 1'b1;
            case(funct3)
                3'b010:alu_op=alu_add; //sw(0)
               default: alu_op = alu_add; // Undefined operation (0)
            endcase
            end

        op_b: begin //Branch Opcode
            reg_write=1'b0;
            write_en=1'b0;
            wb_sel=2'b01;
            read_en=1'b0;
            br_type=2'b01;
            sel_A=1'b0;
            sel_B=1'b0;
            PCen = 1'b1;
            alu_op = alu_add;
            end
        // AUIPC
        op_a: begin
            reg_write = 1'b1; // I-type instructions write to register
            read_en=1'b0;
            write_en=1'b0;
            wb_sel=2'b01;
            br_type=2'b00;
            sel_A=1'b0;
            sel_B=1'b0;
            PCen = 1'b1;
            
        end
        // LUI
        op_ui: begin
            reg_write = 1'b1; // I-type instructions write to register
            read_en=1'b0;
            write_en=1'b0;
            wb_sel=2'b01;
            br_type=2'b00;
            sel_A=1'b1;
            sel_B=1'b0;
            PCen = 1'b1;
            
        end

        //Jal opcode
        op_j: begin
            reg_write = 1'b1; 
            read_en=1'b0;
            write_en=1'b0;
            wb_sel=2'b10;
            br_type=2'b10;
            sel_A=1'b0;
            sel_B=1'b0;
            PCen = 1'b1;
            alu_op = alu_add;
            
        end

        //JalR opcode
        op_jr: begin
            reg_write = 1'b1; 
            read_en=1'b0;
            write_en=1'b0;
            wb_sel=2'b10;
            br_type=2'b10;
            sel_A=1'b1;
            sel_B=1'b0;
            PCen = 1'b1;
            alu_op = alu_add;
            
        end

        default: begin
            alu_op = alu_add; // Undefined operation (31)
            PCen = 1'b1;
            reg_write = 1'b0;
            write_en=1'b0;
            read_en=1'b0;
            wb_sel=2'b00;
            br_type=2'b00;
            sel_A=1'b1;
        end
    endcase
end

endmodule

module controller (
    input [6:0] opcode,     
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

always_comb begin

    case (opcode)
        7'b0110011: begin //R-Type
            reg_write = 1'b1;
            write_en=1'b0;
            read_en=1'b0;
            wb_sel=2'b01;
            br_type=2'b00;
            sel_A=1'b1;
            sel_B=1'b1;
            PCen = 1'b1;
            case ({funct7, funct3})
                10'b0000000000: alu_op = 4'b0000; // ADD (0)
                10'b0100000000: alu_op = 4'b0001; // SUB (1)
                10'b0000000001: alu_op = 4'b0010; // SLL (2)
                10'b0000000010: alu_op = 4'b0011; // SLT (3)
                10'b0000000011: alu_op = 4'b0100; // SLTU (4)
                10'b0000000100: alu_op = 4'b0101; // XOR (5)
                10'b0000000101: alu_op = 4'b0110; // SRL (6)
                10'b0100000101: alu_op = 4'b0111; // SRA (7)
                10'b0000000110: alu_op = 4'b1000; // OR (8)
                10'b0000000111: alu_op = 4'b1001; // AND (9)
                default: alu_op = 5'b1111; // Undefined operation (31)
            endcase
        end

        // I-type opcode (for example, 0010011)
        7'b0010011: begin
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
                3'b000: alu_op = 4'b0000; // ADDI (0)
                3'b010: alu_op = 4'b0011; // SLTI (3)
                3'b011: alu_op = 4'b0100; // SLTIU (4)
                3'b100: alu_op = 4'b0101; // XORI (5)
                3'b110: alu_op = 4'b1000; // ORI (8)
                3'b111: alu_op = 4'b1001; // ANDI (9)
                3'b001: alu_op =4'b0010; // SLLI (2)
                3'b101: alu_op = (funct7[5] == 1'b0) ? 4'b0110 : 4'b0111; // SRLI (17) if funct7[5] is 0, SRAI (18) if 1
                default: alu_op = 5'b1111; // Undefined operation (31)
            endcase
        end


        // L-type opcode (for example, 0000011)
        7'b0000011: begin
            reg_write = 1'b1; // Load-type instructions write to register
            read_en=1'b1;
            wb_sel =2'b00;
            write_en=1'b0;
            br_type=2'b00;
            sel_A=1'b0;
            sel_B=1'b0;
            PCen = 1'b1;
            // Determine ALU operation based on funct3
            case (funct3)
                3'b000: alu_op = 4'b0000; // LB (0)
                3'b001: alu_op = 4'b0000; // LH (0)
                3'b010: alu_op = 4'b0000; // LW (0)
                3'b100: alu_op = 4'b0000; // LBU (0)
                3'b101: alu_op = 4'b0000; // LHU (0)
                default: alu_op = 4'b1111; // Undefined operation (0)
            endcase
        end
        
        7'b0100011: begin//Sw Opcode
            reg_write=1'b0;
            write_en=1'b1;
            wb_sel=2'b00;
            read_en=1'b0;
            br_type=2'b00;
            sel_A=1'b1;
            sel_B=1'b0;
            PCen = 1'b1;
            case(funct3)
                3'b010:alu_op=4'b0000; //sw(0)
               default: alu_op = 4'b1111; // Undefined operation (0)
            endcase
            end

        7'b1100011: begin //Branch Opcode
            reg_write=1'b0;
            write_en=1'b0;
            wb_sel=2'b01;
            read_en=1'b0;
            br_type=2'b01;
            sel_A=1'b0;
            sel_B=1'b0;
            PCen = 1'b1;
            //case(funct3)
              //  3'b010:alu_op=4'b0000; //sw(0)
            //alu_op = 4'b1111; // Undefined operation (0)
            //endcase
            end
        // AUIPC
        7'b0010111: begin
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
        7'b0110111: begin
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
        7'b1101111: begin
            reg_write = 1'b1; 
            read_en=1'b0;
            write_en=1'b0;
            wb_sel=2'b10;
            br_type=2'b10;
            sel_A=1'b0;
            sel_B=1'b0;
            PCen = 1'b1;
            
        end

        //JalR opcode
        7'b1100111: begin
            reg_write = 1'b1; 
            read_en=1'b0;
            write_en=1'b0;
            wb_sel=2'b10;
            br_type=2'b10;
            sel_A=1'b1;
            sel_B=1'b0;
            PCen = 1'b1;
            
        end

        default: begin
            alu_op = 4'b1111; // Undefined operation (31)
            PCen = 1'b1;
            reg_write = 1'b1;
            write_en=1'b0;
            read_en=1'b0;
            wb_sel=2'b00;
            br_type=2'b00;
            sel_A=1'b1;
        end
    endcase
end

endmodule

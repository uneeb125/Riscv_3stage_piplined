module branch_cond (
    input logic [1:0] br_type,             // Control signal to indicate branch type instruction
    input logic [2:0] funct3,        // The funct3 field from the instruction
    input logic [31:0] rs1_data,     // Data from source register 1
    input logic [31:0] rs2_data,     // Data from source register 2
    output logic take_branch         // Output signal to indicate if branch is taken
);

    always_comb begin
        if (br_type == 2'b01) begin
            // Only evaluate branch condition if it is a branch type instruction
            case (funct3)
                3'b000: take_branch = (rs1_data == rs2_data);    // BEQ
                3'b001: take_branch = (rs1_data != rs2_data);    // BNE
                3'b100: take_branch = ($signed(rs1_data) < $signed(rs2_data)); // BLT
                3'b101: take_branch = ($signed(rs1_data) >= $signed(rs2_data)); // BGE
                3'b110: take_branch = (rs1_data < rs2_data);    // BLTU
                3'b111: take_branch = (rs1_data >= rs2_data);    // BGEU
                default: take_branch = 0; // Invalid branch condition
            endcase
        end 
        else if (br_type == 2'b10) begin
            take_branch = 1;
        end

        else begin
            // If not a branch type instruction, do not take branch
            take_branch = 0;
        end
    end
endmodule

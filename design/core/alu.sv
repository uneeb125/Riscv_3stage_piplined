module alu #(
    parameter Data_Width = 32,
    parameter Op_Width = 4 // Increase opsel_i width to accommodate more operations
)
(
    input logic  [Data_Width-1:0] operand_a_i,
    input logic  [Data_Width-1:0] operand_b_i,
    input logic  [Op_Width-1:0] alu_op, // Increase the size to 4 bits
    output logic [Data_Width-1:0] result_o
);

// Define operation codes
   localparam[Op_Width-1:0] signed_add   = 4'b0000;
   localparam[Op_Width-1:0] signed_sub   = 4'b0001;
   localparam[Op_Width-1:0] bitwise_sll  = 4'b0010;
   localparam[Op_Width-1:0] set_less_than= 4'b0011;
   localparam[Op_Width-1:0] set_less_than_unsigned= 4'b0100;
   localparam[Op_Width-1:0] bitwise_xor  = 4'b0101;
   localparam[Op_Width-1:0] bitwise_srl  = 4'b0110;
   localparam[Op_Width-1:0] bitwise_sra  = 4'b0111;
   localparam[Op_Width-1:0] bitwise_or   = 4'b1000;
   localparam[Op_Width-1:0] bitwise_and  = 4'b1001;
always @(*)
begin
    case (alu_op) 
        signed_add               : result_o = $signed(operand_a_i) + $signed(operand_b_i);
        signed_sub               : result_o = $signed(operand_a_i) - $signed(operand_b_i);
        bitwise_sll              : result_o = operand_a_i << operand_b_i[4:0]; // Shift left logical
        set_less_than            : result_o = $signed(operand_a_i) < $signed(operand_b_i) ? 1 : 0;
        set_less_than_unsigned   : result_o = operand_a_i < operand_b_i ? 1 : 0;
        bitwise_xor              : result_o = operand_a_i ^ operand_b_i;
        bitwise_srl              : result_o = operand_a_i >> operand_b_i[4:0]; // Shift right logical
        bitwise_sra              : result_o = operand_a_i >>> operand_b_i[4:0]; // Shift right arithmetic
        bitwise_or               : result_o = operand_a_i | operand_b_i;
        bitwise_and              : result_o = operand_a_i & operand_b_i;
    endcase
end

endmodule


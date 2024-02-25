`timescale 1ns / 1ps

module alu_tb;

// Parameters
localparam Data_Width = 32;
localparam Op_Width = 4;

// Testbench Signals
reg [Data_Width-1:0] operand_a_i;
reg [Data_Width-1:0] operand_b_i;
reg [Op_Width-1:0] opsel_i;
wire [Data_Width-1:0] result_o;

// Instantiate the ALU
alu #(
    .Data_Width(Data_Width),
    .Op_Width(Op_Width)
) uut (
    .operand_a_i(operand_a_i),
    .operand_b_i(operand_b_i),
    .opsel_i(opsel_i),
    .result_o(result_o)
);

// Test Vector Procedure
initial begin
    // Initialize Inputs
    operand_a_i = 0;
    operand_b_i = 0;
    opsel_i = 0;

    // Apply Test Vectors
    #10;
    operand_a_i = 1; operand_b_i = 1; opsel_i = 4'b0000; // unsigned_add
    #10;
    operand_a_i = 3; operand_b_i = 1; opsel_i = 4'b0001; // unsigned_sub
    #10;
    operand_a_i = 32'h80000000; operand_b_i = 32'h80000000; opsel_i = 4'b0010; // signed_add (large negative numbers)
    #10;
    operand_a_i = 32'h80000000; operand_b_i = 1; opsel_i = 4'b0011; // signed_sub (large negative number and small positive number)
    #10;
    operand_a_i = 268435455; operand_b_i = -1; opsel_i = 4'b0100; // bitwise_and
    #10;
    operand_a_i = 268435455; operand_b_i = -1; opsel_i = 4'b0101; // bitwise_or
    #10;
    operand_a_i = 252645135; operand_b_i = -252645136; opsel_i = 4'b0110; // bitwise_xor
    #10;
    operand_a_i = 1; operand_b_i = 16; opsel_i = 4'b0111; // bitwise_sll
    #10;
    operand_a_i = 32'h80000000; operand_b_i = 16; opsel_i = 4'b1000; // bitwise_srl (large negative number shifted right)
    #10;
    operand_a_i = 32'h80000000; operand_b_i = 16; opsel_i = 4'b1001; // bitwise_sra (large negative number arithmetically shifted right)
    #10;
    operand_a_i = 2147483647; operand_b_i = -1; opsel_i = 4'b1010; // set_less_than (largest positive number and -1)
    #10;
    // ... Continue for other operations
    $finish; // End the simulation
end
initial
          begin
              $dumpfile("waveform.vcd");
              $dumpvars(1,alu_tb);
          end
endmodule

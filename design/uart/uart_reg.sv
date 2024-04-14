module uart_reg (
    input logic clk,
    input logic write_enable,
    input logic [4:0] address,
    input logic [31:0] data_in,

    output logic [10:0] dvsr,
    output logic [7:0] data_out,
    output logic tx_start
);

  logic [31:0] registers[0:2];

  always @(negedge clk) begin
    if (write_enable) begin
      registers[address>>2] <= data_in;
    end
  end

  assign data_out = registers[0][7:0];
  assign dvsr = registers[1][10:0];
  assign tx_start = registers[2][1:0];

endmodule

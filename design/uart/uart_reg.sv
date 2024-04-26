module uart_reg (
    input logic        clk,
    input logic        write_enable,
    input logic [ 4:0] address,
    input logic [30:0] data_in,
    input logic        tx_done,

    output logic [10:0] dvsr,
    output logic [7:0] data_out,
    output logic tx_start,
    output logic full,
    output logic [31:0] cout
);

  logic [31:0] registers[0:2];
  

  always @(negedge clk) begin
    if (write_enable) begin
      if((address>>2)==0)
      registers[address>>2] <= {1'b1,data_in};
      else
      registers[address>>2] <= data_in;
    end
    else if (tx_done) begin
      registers[0] <= registers[0] & !(32'h80000000);
    end
  end

  assign data_out = registers[0][7:0];
  assign dvsr = registers[1][10:0];
  assign tx_start = registers[2][1:0];
  assign full = registers[0][31];

  always_comb begin
    if (address==5'b0) begin
      cout = 32'h80000000 & registers[address>>2];
    end
    else begin
      cout = registers[address>>2];
    end

  end


endmodule

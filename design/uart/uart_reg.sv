module uart_reg (
    input logic        clk,
    input logic        write_enable,
    input logic [ 4:0] address,
    input logic [30:0] data_in,
    input logic        tx_done,
    input logic        snum,
    input logic        rx_done,
    input logic        d_rx,
    input logic        rxing,

    output logic [10:0] dvsr,
    output logic [7:0] data_out,
    output logic tx_start,
    output logic full,
    output logic [31:0] cout,
    output logic tx_int,
    output logic rx_int
);

  logic [31:0] registers[0:5];
  

  always @(negedge clk) begin
    if (write_enable) begin
      if((address>>2)==0)
      registers[address>>2] <= {1'b1,data_in};
      else
      registers[address>>2] <= data_in;
    end
    else if (tx_done) begin
      registers[0] <= registers[0] & !(32'h80000000);
      registers[4][0] <= 1'b1;
    end
    else if (rxing) begin
      registers[3] <= registers[3] & !(32'h80000000);
    end
    else if (rx_done) begin
      registers[3] <= d_rx;
      registers[4][1] <= 1'b1;
    end
    
  end

  assign data_out = registers[0][7:0];
  assign dvsr = registers[1][10:0];
  assign tx_start = registers[2][0];
  assign full = registers[0][31];
  assign snum = registers[2][1];
  assign tx_int = registers[5][0] & registers[4][0];
  assign rx_int = registers[5][1] & registers[4][1];

  always_comb begin
    if (address==5'b0 | address==5'hC) begin
      cout = 32'h80000000 & registers[address>>2];
    end
    else begin
      cout = registers[address>>2];
    end

  end


endmodule

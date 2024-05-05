module uart_reg (
  input logic        clk,
  input logic        write_enable,
  input logic [4:0]  address,
  input logic [30:0] data_in,  // Input from CPU
  input logic        tx_done,
  input logic        rx_done,

  output logic [10:0] dvsr,
  output logic [7:0] data_out,
  output logic [7:0] data_in_rx,  // Received data output
  output logic       tx_start,
  output logic       rx_enable,
  output logic       full,
  output logic [31:0] cout
);

logic [31:0] registers[0:2];

always @(negedge clk) begin
  if (write_enable) begin
    if ((address>>2) == 0) begin
      registers[address>>2] <= {1'b1, data_in[7:0]};  // Assume data_in is only using lower 8 bits for consistency
    end else if ((address>>2) == 1 && tx_done) begin
      registers[address>>2] <= data_in;
    end else if ((address>>2) == 2 && tx_done) begin
      registers[address>>2] <= data_in;
    end
  end else if (tx_done) begin
    registers[0] <= registers[0] & ~32'h80000000;  // Clear full bit after tx done
  end
end

assign data_out = registers[0][7:0];       // Data to transmit
assign dvsr = registers[1][10:0];          // Baud rate divisor
assign tx_start = registers[2][0];         // Start transmission
assign full = registers[0][31];            // Full bit
assign data_in_rx = registers[0][15:8];    // Assuming received data is stored here

always_comb begin
  if (address == 5'b0) begin
    cout = {23'b0, full, 8'h00};  // Read full status and tx-byte
  end else begin
    cout = registers[address>>2];
  end
end

endmodule

module uart_top (
    input  logic        clk,
    input  logic        reset,
    input  logic [31:0] cpu_address,
    input  logic [31:0] cpu_data,
    input  logic        write_enable,
    input  logic        rx,
    output logic [31:0] cout,
    output logic        tx
);

  logic        tx_done, rx_done;
  logic [10:0] dvsr;
  logic [7:0] data_out, data_in_rx;  // Changed name to data_in_rx for received data
  logic tx_start, rx_enable;

  logic tick;

  logic full;

  // Generate baud tick based on even divisor, and sample in the middle
  baud_gen uart_baud_gen (
      .full (full),
      .clk  (clk),
      .reset(reset),
      .dvsr (dvsr),
      .tick (tick)
  );

  uart_reg uart_reg_block (
      .clk(clk),
      .write_enable(write_enable),
      .address(cpu_address[4:0]),
      .data_in(cpu_data[30:0]),  // Input data from CPU
      .tx_done(tx_done),
      .rx_done(rx_done),
      .dvsr(dvsr),
      .data_out(data_out),
      .data_in_rx(data_in_rx),  // Connection for received data
      .tx_start(tx_start),
      .rx_enable(rx_enable),
      .full(full),
      .cout(cout)
  );

  uart_rx uart_receiver (
      .clk(clk),
      .reset(reset),
      .rx(rx),
      .s_tick(tick),
      .rx_done_tick(rx_done),
      .dout(data_in_rx)  // Correct connection for output data from receiver
  );

  uart_tx uart_transmitter (
      .clk         (tick),
      .reset       (reset),
      .tx_start    (tx_start),
      .d_tx        (data_out),
      .tx_done(tx_done),
      .tx          (tx)
  );

endmodule

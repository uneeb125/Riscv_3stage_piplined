module uart_top (
    input  logic        clk,
    input  logic        reset,
    input  logic [31:0] cpu_address,
    input  logic [31:0] cpu_data,
    input  logic        write_enable,
    output logic [31:0] cout
    // output logic [ 7:0] dout
);
  logic        tx_done;
  logic [10:0] dvsr;
  logic [ 7:0] data_out;
  logic tx_start;


  logic tick;

  logic full;


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
      .data_in(cpu_data[30:0]),
      .tx_done(tx_done),
      .cout(cout),

      .dvsr(dvsr),
      .data_out(data_out),
      .tx_start(tx_start),
      .full(full)
  );

  //   uart_rx #(
  //       .DBIT(8),
  //       .SB_TICK(16)
  //   ) uart_receiver (
  //       .clk(clk),
  //       .reset(reset),
  //       .rx(rx),
  //       .s_tick(tick),
  //       .rx_done_tick(rx_done_tick),
  //       .dout(rx_data)
  //   );

  uart_tx #(
      .DBIT(8),
      .SB_TICK(16)
  ) uart_transmitter (
      .clk         (tick),
      .reset       (reset),
      .tx_start    (tx_start),
      .d_tx        (data_out),
      .tx_done(tx_done),
      .tx          (tx)
  );

endmodule

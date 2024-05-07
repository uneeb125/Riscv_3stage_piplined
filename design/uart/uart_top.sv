module uart_top (
    input  logic        clk,
    input  logic        reset,
    input  logic [31:0] cpu_address,
    input  logic [31:0] cpu_data,
    input  logic        write_enable,
    output logic [31:0] cout,
    output logic tx_int,
    output logic rx_int
    // output logic [ 7:0] dout
);
  logic        tx_done;
  logic [10:0] dvsr;
  logic [ 7:0] data_out;
  logic tx_start;
  logic snum;
  logic [7:0] d_rx;
  logic rx_done;
  logic rxing;


  logic tx_tick;

  logic full;


  baud_gen uart_baud_gen (
      .clk  (clk),
      .reset(reset),
      .dvsr (dvsr),
      .tx_tick (tx_tick),
      .rx_tick (rx_tick)
  );

  uart_reg uart_reg_block (
      .clk(clk),
      .write_enable(write_enable),
      .address(cpu_address[4:0]),
      .data_in(cpu_data[30:0]),
      .tx_done(tx_done),
      .rx_done(rx_done),
      .rxing(rxing),
      .d_rx(d_rx),
      .cout(cout),
      .snum(snum),
      .rx_int(rx_int),
      .tx_int(tx_int),

      .dvsr(dvsr),
      .data_out(data_out),
      .tx_start(tx_start),
      .full(full)
  );

    uart_rx #(
        .DBIT(8),
        .SB_TICK(16)
    ) uart_receiver (
        .clk(rx_tick),
        .reset(reset),
        .snum(snum),
        .d_rx(d_rx),
        .rxing(rxing),
        .rx_done(rx_done),
        .rx(rx)
    );

  uart_tx #(
      .DBIT(8),
      .SB_TICK(16)
  ) uart_transmitter (
      .clk         (tx_tick),
      .reset       (reset),
      .tx_start    (tx_start),
      .snum        (snum),
      .d_tx        (data_out),
      .tx_done     (tx_done),
      .tx          (tx)
  );

endmodule

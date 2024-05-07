`timescale 1ns / 1ps

module tb_uart_top;

  // Inputs to the UART top module
  logic clk;
  logic reset;
  logic snum;
  logic [7:0] d_rx;
  logic rx_done;
  logic rx;



  // Instantiate the uart_top module
  uart_rx UUT (
      .clk(clk),
      .reset(reset),
      .snum(snum),
      .d_rx(d_rx),
      .rx_done(rx_done),
      .rx(rx)

  );

  // Clock generation
  always #10 clk = ~clk;  // 50 MHz clock

  // Test scenarios
  initial begin
    // Initialize Inputs
    clk = 0;
    reset = 1;
    rx = 1;
    snum = 0;

    // Reset the system
    #25;  // Wait a bit
    reset = 1;
    #20;
    reset = 0;
    #20;

    repeat(2) @(posedge clk);
    rx = 0;

    repeat(2) @(posedge clk);
    rx = 0;

    
    repeat(2) @(posedge clk);
    rx = 0;

    repeat(2) @(posedge clk);
    rx = 0;

    repeat(2) @(posedge clk);
    rx = 1;

    repeat(2) @(posedge clk);
    rx = 1;

    repeat(2) @(posedge clk);
    rx = 1;

    repeat(2) @(posedge clk);
    rx = 1;
  
    repeat(2) @(posedge clk);
    rx = 1;

    repeat(2) @(posedge clk);
    rx = 1;


    #500;

    $finish;
  end

  // Monitor changes
  initial begin
    $dumpfile("uart.vcd");
    $dumpvars(0, tb_uart_top);
  end

endmodule

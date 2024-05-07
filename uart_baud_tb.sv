`timescale 1ns / 1ps

module uart_baud_tb;

  // Inputs to the UART top module
  logic clk;
  logic reset;
  logic [10:0] dvsr;
  logic tx_tick;
  logic rx_tick;
  



  // Instantiate the uart_top module
  baud_gen UUT (
        .clk(clk),
        .reset(reset),
        .dvsr(dvsr),
        .tx_tick(tx_tick),
        .rx_tick(rx_tick)

  );

  // Clock generation
  always #10 clk = ~clk;  // 50 MHz clock

  // Test scenarios
  initial begin
    // Initialize Inputs
    clk = 0;
    reset = 1;
    dvsr = 2;

    // Reset the system
    #20;  // Wait a bit
    reset = 1;
    #20;
    reset = 0;
    #20;


    #500;

    $finish;
  end

  // Monitor changes
  initial begin
    $dumpfile("uart.vcd");
    $dumpvars(0, uart_baud_tb);
  end

endmodule

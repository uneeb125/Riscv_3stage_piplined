`timescale 1ns / 1ps

module tb_uart_top;

  // Inputs to the UART top module
  logic clk;
  logic reset;
  logic [31:0] cpu_address;
  logic [31:0] cpu_data;
  logic write_enable;
  logic cpu_tx_start;

  // Outputs from the UART top module
  logic [7:0] dout;

  // Instantiate the uart_top module
  uart_top UUT (
      .clk(clk),
      .reset(reset),
      .cpu_address(cpu_address),
      .cpu_data(cpu_data),
      .write_enable(write_enable)
  );

  // Clock generation
  always #10 clk = ~clk;  // 50 MHz clock

  // Test scenarios
  initial begin
    // Initialize Inputs
    clk = 0;
    reset = 1;
    cpu_address = 0;
    cpu_data = 0;
    cpu_tx_start = 0;

    // Reset the system
    #25;  // Wait a bit
    reset = 1;
    #20;
    reset = 0;
    #20;

// Set the Data to be transferred
    write_enable = 1'b1;
    cpu_address = 32'h80000000;
    cpu_data    = 32'b01101001;
    #20;

// Set the Baudivisor according to (sys_clk/baudrate)-1  
    write_enable = 1'b1;
    cpu_address = 32'h80000004;
    cpu_data    = 8'h1; 
    #20;

// Inititate the transmission
    write_enable = 1'b1;
    cpu_address = 32'h80000008;
    cpu_data    = 8'h1; 
    #20;

    #500;

    $finish;
  end

  // Monitor changes
  initial begin
    $dumpfile("uart.vcd");
    $dumpvars(0, tb_uart_top);
  end

endmodule

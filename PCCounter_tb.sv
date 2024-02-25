`timescale 1ns / 1ps

module PCCounter_tb;

// Testbench Parameters
parameter Width = 32;

// Testbench Signals
logic clk_tb;
logic reset_tb;
logic PCen_tb;
logic [Width-1:0] PC1_tb;
logic [Width-1:0] PC_tb;

// Instantiate the Unit Under Test (UUT)
PCCounter #(.Width(Width)) uut (
    .clk(clk_tb), 
    .reset(reset_tb),
    .PCen(PCen_tb), 
    .PC1(PC1_tb), 
    .PC(PC_tb)
);

// Clock Generation
initial begin
    clk_tb = 0;
    forever #5 clk_tb = ~clk_tb; // Generate a 100MHz clock
end

// Test Cases
initial begin
    // Initialize Inputs
    reset_tb = 1; // Apply reset
    PCen_tb = 0;
    PC1_tb = 0;

    #10; // Wait for some time to simulate reset duration
    reset_tb = 0; // Release reset

    // Case 1: Enable PC update, PC should change to PC1
    PCen_tb = 1;
    PC1_tb = 32'hAAAA_AAAA; // Set a test value
    #10; // Wait for a clock cycle

    // Case 2: Change PC1 while PCen is high, PC should update
    PC1_tb = 32'h5555_5555; // Change the input value
    #10; // Wait for a clock cycle

    // Case 3: Disable PC update, PC should not change
    PCen_tb = 0;
    #10; // Wait for a clock cycle

    // Case 4: Re-enable PC update with a different value
    PC1_tb = 32'hFFFF_0000; // Set another test value
    PCen_tb = 1;
    #10; // Wait for a clock cycle

    // Finish the simu
end

// Optional: Dump waveforms
initial begin
    $dumpfile("PCCounter_tb.vcd");
    $dumpvars(0, PCCounter_tb);
end

endmodule

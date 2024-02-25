`timescale 1ns/1ps

module InstructionMemory_tb;

    parameter AddrWidth = 32;

    // Testbench signals
    logic [AddrWidth-1:0] tb_address;
    logic [31:0] tb_instruction;

    // Instantiate the InstructionMemory module
    InstructionMemory #(
        .AddrWidth(AddrWidth)
    ) uut (
        .address(tb_address),
        .instruction(tb_instruction)
    );

    initial begin
        // Initialize the testbench variables
        tb_address = 0;

        // Apply test cases
        #10; // Wait for 10 time units
        tb_address = 0; // Read the first instruction
        #10; // Wait for 10 time units
        tb_address = 4; // Read the second instruction (assuming word-aligned addresses)
        #10; // Wait for 10 time units
        tb_address = 8; // Read the third instruction
        #10; // Continue with more test cases as needed

        // Finish the simulation
        #10;
        $finish;
    end

    // Monitor the output on change
    initial begin
        $monitor("Time = %t, Address = %h, Instruction = %h", $time, tb_address, tb_instruction);
    end

    initial
          begin
              $dumpfile("waveform.vcd");
              $dumpvars(1,InstructionMemory_tb);
          end

endmodule

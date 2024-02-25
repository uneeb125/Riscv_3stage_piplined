`timescale 1ns / 1ps

module main_tb;

    logic clk, reset;

    main dut (
        .clk(clk),
        .reset(reset)
    );

    always #5 clk = ~clk; 

    initial begin
        clk = 0;
        reset = 1;

        #20 reset = 0;

        #100;
        $finish;
    end

    initial begin
        $monitor("PC: %h, Instruction: %h,Read_Address: %h,Data_in: %h ,  write_data: %h, write_address: %h ...", dut.pc_current, dut.instruction, dut.data_mem.write_address , dut.data_mem.data_in, dut.reg_file.write_data, dut.reg_file.write_address);
    end

    initial
        begin
            $dumpfile("waveform.vcd");
            $dumpvars(0,main_tb);
        end

endmodule

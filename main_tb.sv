`timescale 1ns / 1ps

module main_tb;

    logic clk, reset, interrupt;

    main dut (
        .clk(clk),
        .reset(reset),
        .interrupt(interrupt)
    );

    always #5 clk = ~clk; 

    initial begin
        clk = 0;
        reset = 1;

        @(posedge clk) reset = 0;

        repeat(6)@(posedge clk);
        interrupt = 1;

        @(posedge clk);
        interrupt = 0;


        #1500;
        $finish;
    end

    initial
        begin
            $dumpfile("waveform.vcd");
            $dumpvars(0,main_tb);
        end

endmodule

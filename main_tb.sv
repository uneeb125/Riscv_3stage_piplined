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

        @(posedge clk) reset = 0;

        #200;
        $finish;
    end

    initial
        begin
            $dumpfile("waveform.vcd");
            $dumpvars(0,main_tb);
        end

endmodule

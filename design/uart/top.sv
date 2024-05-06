module top(
    input  logic        clk,
    input  logic        reset,
    input  logic [31:0] cpu_address,
    input  logic [31:0] cpu_data,
    input  logic        write_enable,
    input  logic        rx,
    output logic [31:0] cout,
    output logic        tx
);

logic tx_start;
logic [7:0] data_in;
logic tx_done;
logic [31:0] dvsr;
logic [ 7:0] data_out;


logic [7:0] data_out_r;
logic recive_flag;

logic tick;
logic full;


baud_gen uart_baud_gen (
    .full (full),
    .clk  (clk),
    .reset(reset),
    .dvsr (dvsr),
    .tick (tick)
);


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

uart_reg uart_reg_block (
    .clk(clk),
    .write_enable(write_enable),
    .address(cpu_address[4:0]),
    .data_in(cpu_data[30:0]),
    .tx_done(tx_done), //output of the receiver 
    .cout(cout),
    .dvsr(dvsr),
    .data_out(data_out),
    .tx_start(tx_start),
    .full(full),
    .data_out_r(data_out_r)
);

UART_receiver rx(
    .clk(clk),
    .rst(reset),
    .rx(rx),
    .baud_divisor(dvsr),
    .data_out(data_out_r),
    .recive_flag(recive_flag)
);


endmodule
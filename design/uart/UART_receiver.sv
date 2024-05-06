`include "UART_datapathR.sv"
`include "UART_controllerR.sv"

module UART_receiver(
    input logic clk,
    input logic rx,
    input logic rst,
    input logic [31:0] baud_divisor,
    output logic [7:0] data_out,
    output logic recive_flag
);

    logic en_reg;
    logic baud_rate;
    logic rx_data;
    UART_datapathR datapath(.clk(clk),.rst(rst),.en_reg(en_reg),.tx_data(rx_data),.baud_divisor(baud_divisor),.data_out(data_out),.baud_rate(baud_rate));

    UART_controllerR control(.tx(rx),.clk(baud_rate),.rst(rst),.en_reg(en_reg),.recive_flag(recive_flag),.rx_data(rx_data));

endmodule
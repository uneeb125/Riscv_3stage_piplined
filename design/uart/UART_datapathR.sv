module baud_rate_generatorR(
    input logic clk,
    input logic rst,
    input logic [31:0] baud_divisor,
    output logic baud_gen
);
    logic [19:0] count;
    always_ff @ (posedge clk) begin
        if (rst) begin
            count <= 0;
            baud_gen <= 0;
        end else if (count >= (baud_divisor >> 1)) begin
            count <= 0;
            baud_gen <= ~baud_gen;
        end else begin
            count <= count + 1;
        end
    end
endmodule



module SIPO_register(
    input logic baud_rate,
    // input logic load,
    input logic rst,
    input logic en_reg,
    input logic sr_in,
    output logic [7:0] data_out
);
logic temp;
always_ff @(posedge baud_rate, posedge rst) begin
    if (rst) begin 
        data_out <= 0;
        temp <= 0;
    end else if (en_reg) begin 
        temp <= sr_in;
        data_out <= {temp, data_out[6:0]} >> 1;
    end
end

endmodule


module UART_datapathR(
    input logic clk,
    input logic rst,
    input logic en_reg,
    input logic tx_data,
    input logic [31:0] baud_divisor,
    output logic [7:0] data_out,
    output logic baud_rate

);

    baud_rate_generatorR brg1(.clk(clk),.rst(rst),.baud_divisor(baud_divisor),.baud_gen(baud_rate));

    SIPO_register sipo1(.baud_rate(baud_rate),.rst(rst),.en_reg(en_reg),.sr_in(tx_data),.data_out(data_out));
    
endmodule
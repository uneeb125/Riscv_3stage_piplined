module uartmux(
    input logic  uart_en,dmem_en, //from controller
    input logic  [31:0] dmemout,uartout,
    output logic [31:0] dmem_out
);
always_comb begin 
    if(dmem_en) 
        dmem_out = dmemout;
    else if(uart_en)
        dmem_out = uartout;
end
endmodule
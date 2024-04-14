module mux3x1(
    input logic  [1:0] sel, //from controller
    input logic  [31:0] sel0,sel1,sel2,
    output logic [31:0] out
);
always_comb begin 
    case (sel)
        2'b00 : out = sel0;
        2'b01 : out = sel1;
        2'b10 : out = sel2;
        default : out = sel0;
    endcase  
end
endmodule
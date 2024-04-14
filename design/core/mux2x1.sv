module mux2x1(
    input logic  sel, //from controller
    input logic  [31:0] sel0,sel1,
    output logic [31:0] out
);
always_comb begin 
    case (sel)
        1'b0 : out = sel0;
        1'b1 : out = sel1;
        default : out = sel0;
    endcase  
end
endmodule
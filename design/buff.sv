module buff #(
    Width = 32
) (
    input logic clk,en,rst,
    input logic[Width-1:0] din,
    output logic[Width-1:0] dout    
);
    always_ff @( posedge clk or posedge rst ) begin 
        if (rst)
            dout <= 0;
        else if (en) begin
            dout <= din;
        end
        else begin
            dout<= dout;
        end
    end
    
endmodule
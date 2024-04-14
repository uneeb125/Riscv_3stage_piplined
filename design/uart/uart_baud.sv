module baud_gen (
    input logic clk,
    reset,
    input logic [10:0] dvsr,
    output logic tick
);

  logic [11:0] r_reg;
  logic [11:0] dvsr2;

  assign dvsr2 = dvsr<<1;


  always_ff @(clk, posedge reset)
    if (reset) begin
         r_reg <= 0;
         tick<=0;
    end
    else if(r_reg>=dvsr2-1) begin
        tick <= !tick;
        r_reg <= 0;
    end
    else 
        r_reg<= r_reg+1;


endmodule

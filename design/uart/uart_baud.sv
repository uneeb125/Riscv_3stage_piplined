module baud_gen (
    input logic clk,
    reset,
    input logic full,
    input logic [31:0] dvsr,
    output logic tick
);

  logic [11:0] count_reg;
  logic [31:0] dvsr2;


    always_ff @( posedge clk, posedge reset ) begin
        if (reset) begin
            dvsr2 <=0;
        end
        // else if(!full) begin
        //     dvsr2 = dvsr<<1;
        else begin
            dvsr2 = dvsr<<1;
    end
        
    end

  always_ff @(clk, posedge reset)
    if (reset) begin
         count_reg <= 0;
         tick<=0;
    end
    else if(count_reg>=dvsr2-1) begin
        tick <= !tick;
        count_reg <= 0;
    end
    else 
        count_reg<= count_reg+1;


endmodule
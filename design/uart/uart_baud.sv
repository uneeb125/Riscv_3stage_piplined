module baud_gen (
    input logic clk,
    reset,
    input logic full,
    input logic [10:0] dvsr,
    output logic tx_tick,
    output logic rx_tick
);

  logic [11:0] tx_count_reg;
  logic [11:0] rx_count_reg;
  logic [11:0] dvsr2;

    always_ff @( posedge clk, posedge reset ) begin
        if (reset) begin
            dvsr2 <=0;
        end
        // else if(!full) begin
        //     dvsr2 = dvsr<<1;
        else begin
            dvsr2 <= dvsr<<1;
        end
        
    end

  always_ff @(clk, posedge reset)
    if (reset) begin
         rx_count_reg <= 0;
         tx_count_reg <= 0;
         tx_tick<=0;
         rx_tick<=0;
    end
    else if(rx_count_reg>=dvsr-1) begin
        rx_tick <= !rx_tick;
        rx_count_reg <= 0;
    end
    else if(tx_count_reg>=dvsr2-1) begin
        tx_tick <= !tx_tick;
        tx_count_reg <= 0;
    end
    else begin
        tx_count_reg <= tx_count_reg+1;
        rx_count_reg <= rx_count_reg+1;
    end

endmodule

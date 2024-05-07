module baud_gen (
    input logic clk,
    reset,
    // input logic full,
    input logic [10:0] dvsr,
    output logic tx_tick,
    output logic rx_tick
);

  logic [11:0] tx_count_reg;
  logic [11:0] rx_count_reg;
  logic [11:0] dvsrtx;
  logic [11:0] dvsrrx;

  

    always_ff @( posedge clk, posedge reset ) begin
        if (reset) begin
            dvsrtx <=0;
        end
        // else if(!full) begin
        //     dvsrtx = dvsr<<1;
        else begin
            dvsrtx <= dvsr>>1;
            dvsrrx <= dvsr>>2;
        end
        
    end

  always_ff @(posedge clk, posedge reset)
    if (reset) begin
         rx_count_reg <= 0;
         rx_tick<=1;
    end
    else if(rx_count_reg>=dvsrrx) begin
        rx_tick <= !rx_tick;
        rx_count_reg <= 0;
    end
    else begin

        rx_count_reg <= rx_count_reg+1;
    end

always_ff @(posedge clk, posedge reset)
    if (reset) begin
         tx_count_reg <= 0;
         tx_tick<=0;
    end
    else if(tx_count_reg>=dvsrtx) begin
        tx_tick <= !tx_tick;
        tx_count_reg <= 0;
    end
    else begin
        tx_count_reg <= tx_count_reg+1;
    end

endmodule

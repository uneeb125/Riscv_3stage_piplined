module uart_tx #(
    DBIT = 8,
    SB_TICK = 16
) (
    input logic clk,
    reset,
    input logic tx_start,
    input logic [7:0] d_tx,
    output logic tx_done,
    output logic tx
);

  typedef enum {
    idle,
    load,
    data,
    stop
  } state_type;

  state_type state_current, state_next;
  logic [4:0] bit_count;
  logic [7:0] shift_reg;
  logic tx_reg, tx_next;

  always_ff @(posedge clk, posedge reset)
    if (reset) begin
      state_current <= idle;
    end else begin
      state_current <= state_next;
    end
    
    
  always_ff @(posedge clk, posedge reset)
    if (reset) begin
      // tx_done = 1;
      bit_count <= 0;
    end 
    else if(!(state_current==data)) begin
      bit_count <= 0;
    end
    else begin
      bit_count <= bit_count + 1;
    end
  


  always_comb begin
    
    case (state_current)
      idle: begin
        tx_reg = 1;
        tx_done = 0;
        if(tx_start==1)
          state_next = load;
        else
          state_next = idle;
      end 

      load: begin
        tx_reg = 0;
        tx_done = 0;
        if(bit_count==0)begin
          shift_reg = d_tx;
          state_next = data;
        end
        else
          state_next = load;
      end

      data: begin
        tx_done = 0;
        tx_reg = shift_reg[bit_count];
          if(bit_count>=DBIT-1)
            state_next = stop;
          else 
            state_next = data;
      end

      stop: begin
        tx_reg = 1;
          if(tx_start==0)
            state_next = idle;
          else
            state_next = stop;
            tx_done = 1;
      end
    endcase

  end

  assign tx = tx_reg;

endmodule

module uart_tx #(
    DBIT = 8,
    SB_TICK = 16
) (
    input logic clk,
    reset,
    input logic snum,
    input logic tx_start,
    input logic [7:0] d_tx,
    output logic tx_done,
    output logic tx
);

  typedef enum {
    IDLE,
    LOAD,
    DATA,
    STOP1,
    STOP2
  } state_type;

  state_type state_current, state_next;
  logic [4:0] bit_count;
  logic [7:0] shift_reg;
  logic tx_reg, tx_next;

  always_ff @(posedge clk, posedge reset) begin
    if (reset) begin
      state_current <= IDLE;
    end else begin
      state_current <= state_next;
    end
  end
    
    
  always_ff @(posedge clk, posedge reset) begin
    if (reset) begin
      // tx_done = 1;
      bit_count <= 0;
    end 
    else if(!(state_current==DATA)) begin
      bit_count <= 0;
    end
    else begin
      bit_count <= bit_count + 1;
    end
  end
  


  always_comb begin
    
    case (state_current)
      IDLE: begin
        tx_reg = 1;
        tx_done = 0;
        if(tx_start==1)
          state_next = LOAD;
        else
          state_next = IDLE;
      end 

      LOAD: begin
        tx_reg = 0;
        tx_done = 0;
        if(bit_count==0)begin
          shift_reg = d_tx;
          state_next = DATA;
        end
        else
          state_next = LOAD;
      end

      DATA: begin
        tx_done = 0;
        tx_reg = shift_reg[bit_count];
          if(bit_count>=DBIT-1)
            state_next = STOP1;
          else 
            state_next = DATA;
      end

      STOP1: begin
        tx_reg = 1;
          if(tx_start==0)
            if(!snum) state_next = IDLE;
            else state_next = STOP2;
          else
            state_next = STOP1;
            tx_done = 1;
      end

      STOP2: begin
        tx_reg = 1;
          if(tx_start==0)
            state_next = IDLE;
          else
            state_next = STOP2;
            tx_done = 1;
      end

      default: state_next = IDLE;
    endcase

  end

  assign tx = tx_reg;

endmodule

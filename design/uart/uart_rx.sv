module uart_rx #(
    DBIT = 8,
    SB_TICK = 16
) (
    input logic clk, reset,
    input logic snum,
    output logic [7:0] d_rx,
    output logic rx_done,
    output logic rxing,
    input logic rx
);

  typedef enum {
    IDLE,
    DATA,
    STOP1,
    STOP2,
    LOAD
  } state_type;

  state_type state_current, state_next;
  logic [4:0] bit_count;
  logic [7:0] shift_reg;
  logic sample;
  logic overing;

  always_ff @(posedge clk, posedge reset) begin
    if (reset) begin
      state_current <= IDLE;
    end 
    else if (sample)begin
      state_current <= state_next;
    end
    else begin
      state_current <= state_current;
    end
  end

    
    
  always_ff @(posedge clk, posedge reset) begin
    if (reset) begin
      // rx_done = 1;
      bit_count <= 0;
    end 
    else if(!(state_current==DATA)) begin
      bit_count <= 0;
    end
    else if(!(sample)) begin
      bit_count <= bit_count;
    end
    else begin
      bit_count <= bit_count + 1;
    end
  end



  always_ff @(negedge clk, posedge reset)
    if (reset) begin
      sample <= 1;
    end 
    else if(overing) begin
      sample <= !sample;
    end
    else begin
      sample <= 0;
    end


  always_comb begin
    
    case (state_current)
      IDLE: begin
        rxing = 0;
        rx_done = 0;
        shift_reg = 0;
        if(rx==0) begin 
          overing = 1;
          state_next = DATA;
        end
        else
          state_next = IDLE;
      end 

      DATA: begin
        rx_done = 0;
        rxing = 1;
        if(sample) begin
          shift_reg[bit_count]= rx  ;
        end
        else shift_reg = shift_reg;

          if(bit_count>=DBIT-1)
            state_next = STOP1;
          else 
            state_next = DATA;
      end

      STOP1: begin
          rx_done = 0;
          rxing = 1;
          if(rx==1)begin
            if(!snum) state_next = LOAD;
            else state_next = STOP2;
          end
          else
            state_next = STOP1;
      end

      STOP2: begin
          rx_done = 0;
          rxing = 1;
          if(rx==1)begin
            state_next = LOAD;
          end
          else
            state_next = STOP2;
            rx_done = 1;
      end

      LOAD: begin
          d_rx = shift_reg;
          state_next = IDLE;
          rx_done = 1;
          rxing = 0;
      end
    endcase

  end

endmodule

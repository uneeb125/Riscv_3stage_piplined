module uart_rx #(
  DBIT = 8,
  SB_TICK = 16
) (
  input logic clk,
  input logic reset,
  input logic rx,
  input logic rx_busy, // New input signal indicating receiver busy state
  input logic s_tick,
  output logic rx_done_tick,
  output logic [7:0] dout
);

typedef enum {
  idle,
  start,
  data,
  stop
} state_type;

state_type state_reg, state_next;
logic [3:0] s_reg, s_next;
logic [2:0] n_reg, n_next;
logic [7:0] b_reg, b_next;
logic [7:0] dout_reg, dout_next;

always_ff @(posedge clk, posedge reset) begin
  if (reset) begin
      state_reg <= idle;
      s_reg <= 0;
      n_reg <= 0;
      b_reg <= 0;
      dout_reg <= 0;
  end else begin
      state_reg <= state_next;
      s_reg <= s_next;
      n_reg <= n_next;
      b_reg <= b_next;
      dout_reg <= dout_next;
  end
end

always_comb begin
  state_next = state_reg;
  rx_done_tick = 1'b0;
  s_next = s_reg;
  n_next = n_reg;
  b_next = b_reg;
  dout_next = dout_reg;
  case (state_reg)
      idle:
          if (rx == 0 && !rx_busy) begin // Only proceed to start if not currently busy
              state_next = start;
              s_next = 0;
          end
      start:
          if (s_tick)
              if (s_reg == 15) begin  // Adjusted for 16 times faster baud rate
                  state_next = data;
                  s_next = 0;
                  n_next = 0;
              end else s_next = s_reg + 1;
      data:
          if (s_tick)
              if (s_reg == (SB_TICK - 1)) begin
                  b_next = {rx, b_reg[7:1]};
                  if (n_reg == (DBIT - 1)) state_next = stop;
                  else n_next = n_reg + 1;
              end else s_next = s_reg + 1;
      stop:
          if (s_tick)
              if (s_reg == (SB_TICK - 1)) begin
                  state_next = idle;
                  rx_done_tick = 1'b1;
              end else s_next = s_reg + 1;
  endcase
end

assign dout = b_reg;

endmodule

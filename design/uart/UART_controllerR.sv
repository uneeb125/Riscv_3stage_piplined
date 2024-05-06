module UART_controllerR(
    input logic tx,
    input logic clk,
    input logic rst,
    output logic en_reg,
    output logic recive_flag,
    output logic rx_data
);

    parameter IDLE_STATE = 2'b00, RECEPTION_STATE = 2'b01, STOP_STATE = 2'b10;
    logic [1:0] state;
    logic [3:0] count;  

    always_ff @(posedge clk, posedge rst) begin
        if (rst) begin
            state <= IDLE_STATE;
            count <= 0;
            recive_flag <= 0;
            rx_data <= 0;
        end else begin
            case (state)
                IDLE_STATE : begin
                    recive_flag <= 0;
                    rx_data <= 0;
                    if (tx) begin
                        state <= IDLE_STATE;
                    end else if (~tx) begin
                        state <= RECEPTION_STATE;
                    end
                end
    
                RECEPTION_STATE : begin
                    if (count == 4'h8) begin
                        recive_flag <= 1;
                        count <= 0;
                        // rx_data <= tx;
                        state <= STOP_STATE;
                    end else begin
                        rx_data <= tx;
                        count <= count + 1;
                    end
                end
    
                STOP_STATE : begin
                    recive_flag <= 0;
                    rx_data <= 0;
                    if (tx) state <= IDLE_STATE;
                end
    
                default : state <= IDLE_STATE;
            endcase
        end
    end

    always_comb begin
        if (rst) begin 
            en_reg = 0;
        end else begin 
            case (state)
                IDLE_STATE : begin
                    en_reg = 0;
                end
    
                RECEPTION_STATE : begin
                    en_reg = 1;
                end
    
                STOP_STATE : begin
                    en_reg = 0;
                end
    
                default : begin
                    en_reg = 0;
                end
    
            endcase
        end
    end

endmodule

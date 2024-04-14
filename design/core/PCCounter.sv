module PCCounter #(parameter Width = 32) 
    (
        input logic clk,
        input logic reset,  // Added reset signal
        input logic PCen,
        input logic [Width-1:0] next,
        output logic [Width-1:0] current
    );
    
    always @(posedge clk)  // Include reset in sensitivity list
    begin
        if (reset)
            current <= 0;  // Initialize current to 0 on reset
        else if (PCen)
            current <= next;  // Update current only when PCen is high
    end
    
    endmodule
    
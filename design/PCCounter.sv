module PCCounter #(parameter Width = 32) 
    (
        input logic clk,
        input logic reset,  // Added reset signal
        input logic PCen,
        input logic [Width-1:0] PC1,
        output logic [Width-1:0] PC
    );
    
    always @(posedge clk)  // Include reset in sensitivity list
    begin
        if (reset)
            PC <= 0;  // Initialize PC to 0 on reset
        else if (PCen)
            PC <= PC1;  // Update PC only when PCen is high
    end
    
    endmodule
    
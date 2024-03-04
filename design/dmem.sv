module dmem (
    input logic clk,  // Clock signal for synchronous write
    input logic[29:0] addr,  // Separate read address
    input logic[31:0] data_in,       // 32-bit input data for writing
    input logic w_en,        // Write enable signal
    input logic read_en,             // Read enable signal
    output logic[31:0] data_out      // 32-bit output data for reading
);

    // Declare the memory 2KB / 4 = 512 words of 32 bits each
    logic [31:0] mem[0:511];

    // Synchronous write
    always @(negedge clk) begin
        if (w_en) begin
            mem[addr] <= data_in;
            
        end
    end
    
    // Asynchronous read
    always_comb 
    begin
        // if (read_en) begin
            data_out = mem[addr];
            $writememh("data.mem", mem);
        // end
        // else begin
        //     data_out = {32{1'b0}}; // Output zeros or maintain previous value if not reading
        // end
    end

    // Initialize memory with contents from .mem file

endmodule

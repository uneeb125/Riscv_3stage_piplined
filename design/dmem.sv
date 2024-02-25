module dmem (
    input logic clk,  // Clock signal for synchronous write
    input logic[10:0] write_address, // 11-bit address for 2KB memory (2^11 = 2048)
    input logic[10:0] read_address,  // Separate read address
    input logic[31:0] data_in,       // 32-bit input data for writing
    input logic write_enable,        // Write enable signal
    input logic read_en,             // Read enable signal
    output logic[31:0] data_out      // 32-bit output data for reading
);

    // Declare the memory 2KB / 4 = 512 words of 32 bits each
    logic [31:0] memory_array[0:511];

    initial begin
        $readmemh("data.mem", memory_array);
    end

    // Synchronous write
    always @(negedge clk) begin
        if (write_enable) begin
            memory_array[write_address>>2] <= data_in;
            $writememh("data.mem", memory_array);
        end
    end
    
    // Asynchronous read
    always_comb 
    begin
        // if (read_en) begin
            data_out = memory_array[read_address];
        // end
        // else begin
        //     data_out = {32{1'b0}}; // Output zeros or maintain previous value if not reading
        // end
    end

    // Initialize memory with contents from .mem file

endmodule

module register_file (
    input logic clk,
    input logic write_enable,
    input logic [4:0] write_address, // 4 bits to select one of 16 registers
    input logic [31:0] write_data,   // 32-bit data to write
    input logic [4:0] read_address1, // First read address
    input logic [4:0] read_address2, // Second read address
    output logic [31:0] read_data1, // Data from first read address
    output logic [31:0] read_data2  // Data from second read address
);

    // Declare the register array
    logic [31:0] registers[0:31]; // 16 registers, each 32 bits wide

    // Write operation (synchronous with clock)
    always @(negedge clk) begin
        if (write_enable && write_address != 0) begin // Check for write enable and non-zero address
            registers[write_address] <= write_data;
        end
    end

    // Read operation (combinatorial, assuming it should be always accessible)
    always_comb begin
        // Register 0 always outputs 0
        read_data1 = (read_address1 == 0) ? 0 : registers[read_address1];
        read_data2 = (read_address2 == 0) ? 0 : registers[read_address2];
    end


endmodule

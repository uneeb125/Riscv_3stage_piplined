module imem #(
    parameter AddrWidth = 32 
)(
    input  logic [AddrWidth-1:0] address,  // Input address (usually from the Program Counter)
    output logic [31:0] instruction  // Output 32-bit instruction
);

    // Memory array to hold the instructions
    logic [31:0] memory_array [511:0];
    initial begin
        $readmemh("inst.mem", memory_array);
    end
    assign instruction = memory_array[address>>2];


endmodule

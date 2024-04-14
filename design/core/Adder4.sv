module Adder4 #(
    parameter Width = 32 // Default width of 8 bits
)(
    input logic [Width-1:0] in,  // Input port
    output logic [Width-1:0] out // Output port, result of in + 4
);

// Add 4 to the input and assign the result to the output
assign out = in + 4;

endmodule

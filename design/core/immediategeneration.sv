module immediategeneration(
    input [31:0] In,
    output reg [31:0] Out
);
    always @(*) begin
        case(In[6:0])
            7'b0000011 : Out <= {{20{In[31]}}, In[31:20]}; // Load-type instruction
            7'b0100011 : Out <= {{20{In[31]}}, In[31:25], In[11:7]}; // Store-type instruction
            7'b1100011 : Out <= {{20{In[31]}}, In[7], In[30:25], In[11:8],{1'b0}}; // Branch-type instruction
            7'b0010011 : Out <= {{20{In[31]}}, In[31:20]}; // Immediate-type instruction
            7'b0010111 : Out <= {In[31:12],12'b0}; //AUIPC
            7'b0110111 : Out <= {In[31:12],12'b0}; //LUI
            7'b1100111 : Out <= {{20{In[31]}}, In[31:20]}; // Immediate Jump-type instruction
            7'b1101111 : Out <= {{12{In[31]}} , In[19:12], In[20], In[30:21], 1'b0}; // Jump and link instruction
            default : Out <= 32'h00000000; // Default case
        endcase
    end
endmodule

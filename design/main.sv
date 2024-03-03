module main(input logic clk,input reset);

    parameter integer DATA_WIDTH = 32;
    parameter integer ADDR_WIDTH = 32;
    parameter integer REG_INDEX_WIDTH = 5; 

    logic [ADDR_WIDTH-1:0] pc_current, pc_next;
    logic PCen;

    logic [DATA_WIDTH-1:0] instruction;

    logic [REG_INDEX_WIDTH-1:0] read_reg1, read_reg2, write_reg;
    logic [DATA_WIDTH-1:0] read_data1, read_data2, write_data;
    logic reg_write_enable;

    logic [DATA_WIDTH-1:0]  alu_result;

    logic [DATA_WIDTH-1:0] immediate_value;

    logic [3:0] alu_control_signal; 
    logic reg_write_signal;
    logic read_en;
    logic wb_sel;
    logic write_en;

    logic mem_read, mem_write;
    logic [31:0] mem_data_out;

    //mux_pc
    logic br_taken;
    logic [31:0] pc;

    //mux_Sel_A
    logic sel_A;
    logic [31:0]ALU_in_A;

    //branch_cond Signal
    //logic br_taken;
    logic br_type;
    // Instantiating the PC
    PCCounter PCCounter (
        .clk(clk),
        .reset(reset),
        .PCen(PCen),
        .next(pc),
        .current(pc_current)
    );
    mux2x1 mux_operand_A(
        .sel(sel_A),
        .sel0(pc_current),
        .sel1(read_data1),
        .out(ALU_in_A)
    );

    Adder4 Adder4(
        .in(pc_current),
        .out(pc_next)
    );

    mux2x1 mux_pc (
        .sel(br_taken),
        .sel0(pc_next),
        .sel1(alu_result),
        .out(pc)
    );

    // Instantiating the Memory module
    dmem data_mem (
        .clk(clk),
        .addr(alu_result[31:2]),
        .data_in(read_data2),            
        .w_en(write_en),         
        .read_en(read_en),
        .data_out(mem_data_out)          
    );

    imem inst_mem (
        .address(pc_current),
        .instruction(instruction)
    );

    alu alu_1 (
        .operand_a_i(ALU_in_A), // Operand A is always from a register
        .operand_b_i((instruction[6:0] == 7'b0010011 || instruction[6:0] == 7'b0000011 || instruction[6:0]==7'b0100011 || instruction[6:0]==7'b1100011) ? immediate_value : read_data2), // Operand B depends on I-type or load instruction
        .alu_op(alu_control_signal[3:0]), // Make sure to match the bit-widths
        .result_o(alu_result)
    );
    // Instantiating the Register File
    register_file reg_file (
        .clk(clk),
        .write_enable(reg_write_enable),
        .write_address(instruction[11:7]),
        .write_data(write_data),
        .read_address1(instruction[19:15]),
        .read_address2(instruction[24:20]),
        .read_data1(read_data1),
        .read_data2(read_data2)
    );


    immediategeneration imm_gen (
        .In(instruction),
        .Out(immediate_value)
    );

    branch_cond branch (
    .br_type(br_type),
    .funct3(instruction[14:12]),
    .rs1_data(read_data1),
    .rs2_data(read_data2),
    .take_branch(br_taken)
    );

    controller ctrlr (
        .opcode(instruction[6:0]),
        .funct3(instruction[14:12]),
        .funct7(instruction[31:25]),
        .alu_op(alu_control_signal),
        .reg_write(reg_write_signal),
        .PCen(PCen),
        .read_en(read_en),
        .wb_sel(wb_sel),
        .write_en(write_en),
        .br_type(br_type),
        .sel_A(sel_A)
    );


    assign write_data = (wb_sel) ? mem_data_out : alu_result;

    assign reg_write_enable = reg_write_signal;
endmodule

module main#(
    DATA_WIDTH = 32,
    ADDR_WIDTH = 32,
    REG_INDEX_WIDTH = 5)
    (input logic clk,input reset);

    logic stall_FD, stall_MW;

    logic [ADDR_WIDTH-1:0] pc_next, pc_in_FD, pc_out_FD, pc_out_EM;
    logic PCen;

    //Instruction memory
    logic [DATA_WIDTH-1:0] inst_out_FD, inst_in_FD, inst_out_EM;


    logic [REG_INDEX_WIDTH-1:0] read_reg1, read_reg2, write_reg;
    logic [DATA_WIDTH-1:0] reg_rdata1, reg_rdata2, reg_wdata;
    logic reg_write_en;



    logic [DATA_WIDTH-1:0] immediate_value;

    logic [3:0] alu_op; 
    logic read_en;
    logic [1:0] wb_sel;
    logic write_en;

    logic [DATA_WIDTH-1:0] alu_in_EM;
    logic [DATA_WIDTH-1:0] alu_out_EM;
    logic [DATA_WIDTH-1:0] wb_in_EM;
    logic [DATA_WIDTH-1:0] wb_out_EM;

    logic [DATA_WIDTH-1:0] wd_out_EM;

    logic mem_read, mem_write;
    logic [31:0] dmem_out;

    //mux_pc
    logic br_taken;
    logic [31:0] pc;

    //mux_Sel_A
    logic sel_A;
    logic [31:0]ALU_in_A;
    logic sel_B;
    logic [31:0]ALU_in_B;

    //branch_cond Signal
    //logic br_taken;
    logic [1:0] br_type;

    logic reg_wrMW, wr_enMW, rd_enMW;
    logic [1:0] wb_selMW;






    Adder4 Adder4(
        .in(pc_in_FD),
        .out(pc_next)
    );

    mux2x1 mux_pc(
        .sel(br_taken),
        .sel0(pc_next),
        .sel1(alu_in_EM),
        .out(pc)
    );

    // Instantiating the PC
    PCCounter PCCounter (
        .clk(clk),
        .reset(reset),
        .PCen(PCen),
        .next(pc),
        .current(pc_in_FD)
    );







    imem inst_mem (
        .address(pc_in_FD),
        .instruction(inst_in_FD)
    );

    buff IR_FD(
        .rst(reset),
        .clk(clk),
        .en(1'b1),
        .din(inst_in_FD),
        .dout(inst_out_FD)
    );

    buff pc_FD(
        .rst(reset),
        .clk(clk),
        .en(1'b1),
        .din(pc_in_FD),
        .dout(pc_out_FD)
    );



//---------------------------------------------------------------------------------
//FETCH --- DECODE




    register_file reg_file (
        .clk(clk),
        .write_enable(reg_wrMW),
        .write_address(inst_out_FD[11:7]),
        .write_data(reg_wdata),
        .read_address1(inst_out_FD[19:15]),
        .read_address2(inst_out_FD[24:20]),
        .read_data1(reg_rdata1),
        .read_data2(reg_rdata2)
    );


    immediategeneration imm_gen (
        .In(inst_out_FD),
        .Out(immediate_value)
    );








    branch_cond branch (
    .br_type(br_type),
    .funct3(inst_out_FD[14:12]),
    .rs1_data(reg_rdata1),
    .rs2_data(reg_rdata2),
    .take_branch(br_taken)
    );

    mux2x1 mux_operand_A(
        .sel(sel_A),
        .sel0(pc_out_FD),
        .sel1(reg_rdata1),
        .out(ALU_in_A)
    );

    mux2x1 mux_operand_B(
        .sel(sel_B),
        .sel0(immediate_value),
        .sel1(reg_rdata2),
        .out(ALU_in_B)
    );

    alu alu_1 (
        .operand_a_i(ALU_in_A), 
        .operand_b_i(ALU_in_B),
        .alu_op(alu_op[3:0]), 
        .result_o(alu_in_EM)
    );

    buff alu_EM(
        .rst(reset),
        .clk(clk),
        .en(1'b1),
        .din(alu_in_EM),
        .dout(alu_out_EM)
    );


    buff pc_EM(
        .rst(reset),
        .clk(clk),
        .en(1'b1),
        .din(pc_out_FD),
        .dout(pc_out_EM)
    );


    buff wd_EM(
        .rst(reset),
        .clk(clk),
        .en(1'b1),
        .din(reg_rdata2),
        .dout(wd_out_EM)
    );

    buff IR_EM(
        .rst(reset),
        .clk(clk),
        .en(1'b1),
        .din(inst_out_FD),
        .dout(inst_out_EM)
    );



//--------------------------------------------------------------------------------
//Execute ---- MEMORY






    dmem data_mem (
        .clk(clk),
        .addr(alu_out_EM[31:2]),
        .data_in(reg_rdata2),            
        .w_en(wr_enMW),         
        .read_en(rd_enMW),
        .data_out(dmem_out)          
    );




    mux3x1 mux_wb(
        .sel(wb_selMW),
        .sel0(dmem_out),
        .sel1(alu_out_EM),
        .sel2(pc_out_EM+4),
        .out(reg_wdata)
    );


    controller ctrlr (
        .opcode(inst_out_FD[6:0]),
        .funct3(inst_out_FD[14:12]),
        .funct7(inst_out_FD[31:25]),
        .alu_op(alu_op),
        .reg_write(reg_write_en),
        .PCen(PCen),
        .read_en(read_en),
        .wb_sel(wb_sel),
        .write_en(write_en),
        .br_type(br_type),
        .sel_A(sel_A),
        .sel_B(sel_B)
    );

    ctrl_buff ctrl_buff(
        .clk (clk),
        .en  (1'b1),
        .rst (reset),
        .reg_wr (reg_write_en),
        .wr_en  (write_en),
        .rd_en  (read_en),
        .wb_sel (wb_sel),
        .reg_wrMW (reg_wrMW),
        .wr_enMW  (wr_enMW ),
        .rd_enMW  (rd_enMW ),
        .wb_selMW (wb_selMW)
    );


endmodule

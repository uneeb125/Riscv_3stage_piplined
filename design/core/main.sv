module main#(
    DATA_WIDTH = 32,
    ADDR_WIDTH = 32,
    REG_INDEX_WIDTH = 5)
    (input logic clk,input reset,input interrupt);

    logic stall, stall_MW;

    logic [ADDR_WIDTH-1:0] pc_next, pc_in_FD, pc_out_FD, pc_out_EM;
    logic PCen;

    //Instruction memory
    logic [DATA_WIDTH-1:0] inst_out_FD, inst_in_FD, inst_out_EM;


    logic [REG_INDEX_WIDTH-1:0] read_reg1, read_reg2, write_reg;
    logic [DATA_WIDTH-1:0] reg_rdata1, reg_rdata2, reg_wdata;
    logic reg_write_en;
    logic [31:0] immediate_value_EM;
    logic [31:0] ALU_in_A_EM;

    logic        csr_epc_taken;
    logic [31:0] csr_rdata, csr_evec;
    logic csr_reg_rdpin;
    logic csr_reg_wrpin;
    logic is_mret;
    logic [31:0] pc1;

    logic csr_reg_rdpin_MW;
    logic csr_reg_wrpin_MW;
    logic is_mret_MW;



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

    logic [31:0] forw_op_a, forw_op_b;
    //mux_Sel_A
    logic sel_A;
    logic [31:0]ALU_in_A;
    logic sel_B;
    logic [31:0]ALU_in_B;

    //branch_cond Signal
    //logic br_taken;
    logic [1:0] br_type;

    logic fora, forb;

    logic reg_wrMW, wr_enMW, rd_enMW;
    logic [1:0] wb_selMW;

    logic dmem_en, uart_en;

    logic [31:0] dmemout,uartout;



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

    mux2x1 mux_csr(
        .sel(csr_epc_taken),
        .sel0(csr_evec),
        .sel1(pc),
        .out(pc1)

    );

    // Instantiating the PC
    PCCounter PCCounter (
        .clk(clk),
        .reset(reset),
        .PCen(PCen),
        .next(pc1),
        .current(pc_in_FD)
    );


     imem inst_mem (
        .address(pc_in_FD),
        .instruction(inst_in_FD)
    );

    buff_sync IR_FD(
        .rst(flush||reset),
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
        .write_address(inst_out_EM[11:7]),
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


    mux2x1 mux_forw_op_a(
        .sel(fora),
        .sel0(reg_rdata1),
        .sel1(alu_out_EM),
        .out(forw_op_a)
        
    );


    mux2x1 mux_forw_op_b(
        .sel(forb),
        .sel0(reg_rdata2),
        .sel1(alu_out_EM),
        .out(forw_op_b)
        
    );


    mux2x1 mux_operand_A(
        .sel(sel_A),
        .sel0(pc_out_FD),
        .sel1(forw_op_a),
        .out(ALU_in_A)
    );

    mux2x1 mux_operand_B(
        .sel(sel_B),
        .sel0(immediate_value),
        .sel1(forw_op_b),
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

    buff imm(
        .rst(reset),
        .clk(clk),
        .en(1'b1),
        .din(immediate_value),
        .dout(immediate_value_EM)

    );

    buff w_data(
        .rst(reset),
        .clk(clk),
        .en(1'b1),
        .din(ALU_in_A),
        .dout(ALU_in_A_EM)

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

    LSU #(
        .DATA_WIDTH(32)
    )
    ls_unit 
    (
        .dbus_addr(alu_out_EM),
        .opcode_in(inst_out_EM[6:0]),
        .dmem_sel(dmem_en),
        .uart_sel(uart_en)
    );


    dmem data_mem (
        .clk(clk),
        .addr(alu_out_EM),
        .data_in(wd_out_EM),            
        .w_en(wr_enMW && dmem_en),         
        .read_en(rd_enMW),
        .data_out(dmemout)          
    );

    uart_top uart_mod(
        .clk(clk),
        .reset(reset),
        .cpu_address(alu_out_EM),
        .cpu_data(wd_out_EM),
        .write_enable(uart_en && wr_enMW),
        .cout(uartout)
    );

    uartmux DUmux(
        .uart_en(uart_en),
        .dmem_en(dmem_en),
        .dmemout(dmemout),
        .uartout(uartout),
        .dmem_out(dmem_out)
    );

    csr csr1(
        .clk(clk),
        .rst(reset),
        .csr_reg_wrpin(csr_reg_wrpin_MW),
        .csr_reg_rdpin(csr_reg_wrpin_MW),
        .csr_is_mret(is_mret_MW),
        .interrupt(interrupt),
        .csr_pc(pc_out_EM),
        .csr_addr32(immediate_value_EM),
        .csr_wdata(ALU_in_A_EM),
        .csr_epc_taken(csr_epc_taken),
        .csr_rdata(csr_rdata),
        .csr_evec(csr_evec)
       );




    mux3x1 mux_wb(
        .sel(wb_selMW),
        .sel0(dmem_out),
        .sel1(alu_out_EM),
        .sel2(pc_out_EM+4),
        .sel3(csr_rdata),
        .out(reg_wdata)
    );


    controller ctrlr (
        .opcode_in(inst_out_FD[6:0]),
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
        .sel_B(sel_B),
        .csr_reg_rdpin(csr_reg_rdpin),
        .csr_reg_wrpin(csr_reg_wrpin),
        .is_mret(is_mret)
    );


    forward_unit fw_unit(
        .dmem_en(dmem_en),
        .reg_wrMW(reg_wrMW),
        .br_taken(br_taken),
        .ir_FD(inst_out_FD),
        .ir_EM(inst_out_EM),
        .stall(stall),
        .stall_MW(stall_MW),
        .flush(flush),
        .fora(fora),
        .forb(forb)
    );

   ctrl_buff ctrl_buff(
        .clk (clk),
        .en  (1'b1),
        .rst (reset),
        .reg_wr (reg_write_en),
        .wr_en  (write_en),
        .rd_en  (read_en),
        .csr_reg_rdpin(csr_reg_rdpin),
        .csr_reg_wrpin(csr_reg_wrpin),
        .is_mret(is_mret),
        .wb_sel (wb_sel),
        .reg_wrMW (reg_wrMW),
        .wr_enMW  (wr_enMW ),
        .rd_enMW  (rd_enMW ),
        .wb_selMW (wb_selMW),
        .csr_reg_rdpin_MW(csr_reg_rdpin_MW),
        .csr_reg_wrpin_MW(csr_reg_wrpin_MW),
        .is_mret_MW(is_mret_MW)
    );


endmodule

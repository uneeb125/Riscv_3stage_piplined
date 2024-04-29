`include "../DEFS/DEFS.svh"
module csr (
    input  logic        clk,
    rst,
    csr_reg_wrpin,
    csr_reg_rdpin,
    csr_is_mret,
    interrupt,
    input  logic [31:0] csr_pc,
    input  logic [31:0] csr_addr32,
    input  logic [31:0] csr_wdata,
    output logic        csr_epc_taken,
    output logic [31:0] csr_rdata,
    csr_evec
);
    logic inexcept, inter_assert;

  type_csr_addr csr_addr;
  assign csr_addr = type_csr_addr'(csr_addr32[11:0]);

  logic [31:0] csr_mip_ff;
  logic [31:0] csr_mie_ff;
  logic [31:0] csr_mstatus_ff;
  logic [31:0] csr_mcause_ff;
  logic [31:0] csr_mtvec_ff;
  logic [31:0] csr_mepc_ff;

  logic        csr_mip_wr_flag;
  logic        csr_mie_wr_flag;
  logic        csr_mstatus_wr_flag;
  logic        csr_mcause_wr_flag;
  logic        csr_mtvec_wr_flag;
  logic        csr_mepc_wr_flag;

  logic        interrupt_ff;
  // Signal for Interrupt Handling
  logic csr_interrupt, INTR;
  logic [ 1:0] handler_mode;
  logic [31:2] handler_base;
  logic [30:0] Exception_Code;
  logic [31:0] csr_pre_evec;

  always_ff @( posedge clk, posedge rst ) begin : reset
    if (rst) begin
        inexcept <= 0;
        inter_assert <=1;

    end
  end




  //For Interrupt
  always_comb begin
    if (rst) begin
        interrupt_ff = 1'b0;
    end
    else if (interrupt) begin
        interrupt_ff = 1'b1;
    end
    else if (!inter_assert)
    begin
        interrupt_ff = inter_assert;
    end
  end


  logic MTIP, MTIE, MIE;
  assign MTIP = csr_mip_ff[7];
  assign MTIE = csr_mie_ff[7];
  assign MIE  = csr_mstatus_ff[3];

  always_comb begin
    if (MTIP & MTIE & MIE) begin
      csr_interrupt = MTIP;
    end
    else begin
      csr_interrupt = 1'b0;
    end
  end


always_comb begin
    handler_mode   = csr_mtvec_ff[1:0];
    handler_base   = {csr_mtvec_ff[31:2],2'b0};
    INTR           = csr_mcause_ff[31];
    Exception_Code = csr_mcause_ff[30:0];
end



  //Interupt Handling CSRs
  always_ff @(negedge clk) begin

    if (csr_interrupt & !(inexcept)) begin
      csr_epc_taken  <= 1'b1;
      csr_mepc_ff    <= csr_pc;
      inexcept <= 1'b1;
      case (handler_mode)
        2'b00: csr_evec <= handler_base;
        2'b01: csr_evec <= handler_base + Exception_Code << 2;
      endcase
    end

    else if (csr_is_mret) begin
      csr_evec <= csr_mepc_ff;
      csr_epc_taken <= 1'b1;
      inexcept <= 1'b0;

    end else begin
      csr_evec <= csr_pre_evec;
      csr_epc_taken <= 1'b0;
    end
  end


  //CSR read operation 
  always_comb begin
    if (csr_reg_rdpin) begin
      case (csr_addr)
        MIP_ADDR:     csr_rdata = csr_mip_ff;
        MIE_ADDR:     csr_rdata = csr_mie_ff;
        MSTATUS_ADDR: csr_rdata = csr_mstatus_ff;
        MCAUSE_ADDR:  csr_rdata = csr_mcause_ff;
        MTVEC_ADDR:   csr_rdata = csr_mtvec_ff;
        MEPC_ADDR:    csr_rdata = csr_mepc_ff;
      endcase
    end
  end



  //CSR write operation
  always_comb begin

    if (csr_reg_wrpin) begin
      case (csr_addr)
        MIP_ADDR:     csr_mip_wr_flag = 1'b1;
        MIE_ADDR:     csr_mie_wr_flag = 1'b1;
        MSTATUS_ADDR: csr_mstatus_wr_flag = 1'b1;
        MCAUSE_ADDR:  csr_mcause_wr_flag = 1'b1;
        MTVEC_ADDR:   csr_mtvec_wr_flag = 1'b1;
        MEPC_ADDR:    csr_mepc_wr_flag = 1'b1;
      endcase
    end else begin
      csr_mip_wr_flag     = 1'b0;
      csr_mie_wr_flag     = 1'b0;
      csr_mstatus_wr_flag = 1'b0;
      csr_mcause_wr_flag  = 1'b0;
      csr_mtvec_wr_flag   = 1'b0;
      csr_mepc_wr_flag    = 1'b0;
    end
  end


  //update the mip (machine interrupt pending) CSR
  always_ff @(posedge rst, negedge clk) begin
    if (rst) begin
      csr_mip_ff <= 32'b0;
    end else if (csr_mip_wr_flag) begin
      csr_mip_ff <= csr_wdata;
    end else if (interrupt_ff) begin
      csr_mip_ff[7] <= interrupt_ff;
      inter_assert <= 1'b0;

    end
  end

  //update the mie (Machine interrupt-enable register) CSR
  always_ff @(posedge rst, negedge clk) begin
    if (rst) begin
      csr_mie_ff <= 32'b0;
    end else if (csr_mie_wr_flag) begin
      csr_mie_ff <= csr_wdata;
    end
  end

  //update the mstatus ( Machine status register) CSR
  always_ff @(posedge rst, negedge clk) begin
    if (rst) begin
      csr_mstatus_ff <= 32'b0;
    end else if (csr_mstatus_wr_flag) begin
      csr_mstatus_ff <= csr_wdata;
    end
  end

  // //update the mcause ( Machine trap cause ) CSR
  always_ff @(posedge rst, negedge clk) begin
    if (rst) begin
      csr_mcause_ff <= 32'b0;
    end else if (csr_mcause_wr_flag) begin
      csr_mcause_ff <= csr_wdata;
    end
  end

  //update the mtvec ( Machine trap-handler base address ) CSR
  always_ff @(posedge rst, negedge clk) begin
    if (rst) begin
      csr_mtvec_ff <= 32'b0;
    end else if (csr_mtvec_wr_flag) begin
      csr_mtvec_ff <= csr_wdata;
    end
  end

  // //update the mepc ( Machine exception program counter ) CSR
  //always_ff @( posedge rst, posedge clk ) begin 
  //  if( rst ) begin
  //    csr_mepc_ff <= 32'b0;
  //  end
  //  else if ( csr_mepc_wr_flag ) begin 
  //      csr_mepc_ff <= csr_wdata;
  //  end
  //end


endmodule

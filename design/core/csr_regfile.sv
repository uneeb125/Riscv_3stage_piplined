`include "../DEFS/DEFS.svh"
module CSR_RegisterFile (
    input logic clk,
    reset,
    reg_wr,
    reg_rd,
    is_mret,
    input type_csr_addr addr,
    input logic [31:0] wdata,
    PC,
    input logic [1:0] interrupt,

    output logic epc_taken,
    output logic [31:0] rdata,
    exc_pc
);

  logic [31:0] mstatus, mie, mepc, mip, mtvec, mcause;



  always_ff @(posedge clk) begin
    if (reset) begin
      mstatus <= 0;
      mie <= 0;
      mip <= 2176;
      mtvec <= 0;
      mcause <= 0;
    end else if (interrupt) begin
      mepc <= PC;
      epc_taken <= 1;
      exc_pc <= 4;
    end else if (is_mret) begin
      epc_taken <= 1;
      exc_pc <= mepc;
    end else if (reg_wr) begin
      case (addr)
        MSTATUS_ADDR: mstatus <= wdata;
        MIE_ADDR:     mie <= wdata;
        MTVEC_ADDR:   mtvec <= wdata;
        MEPC_ADDR:    mepc <= wdata;
        MCAUSE_ADDR:  mcause <= wdata;
        MIP_ADDR:     mip <= wdata;
      endcase
    end
  end
  always_ff @(posedge clk) begin : epc_handle
    if (interrupt | is_mret) epc_taken <= 1;
    else epc_taken <= 0;
  end

  always_comb begin
    rdata <= 0;
    if (reg_rd) begin
      case (addr)
        MSTATUS_ADDR: rdata = mstatus;
        MIE_ADDR:     rdata = mie;
        MTVEC_ADDR:   rdata = mtvec;
        MEPC_ADDR:    rdata = mepc;
        MCAUSE_ADDR:  rdata = mcause;
        MIP_ADDR:     rdata = mip;
      endcase
    end
  end

endmodule

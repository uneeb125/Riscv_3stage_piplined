`include "../DEFS/DEFS.svh"
module LSU #(
    DATA_WIDTH = 32
) (
    input logic [DATA_WIDTH-1:0] dbus_addr,
    input logic [6:0] opcode_in,
    output logic dmem_sel,
    uart_sel
);
  type_mem_map dbus_msb_addr;
  type_opcode opcode;
  assign dbus_msb_addr = type_mem_map'(dbus_addr[31:28]);
  assign opcode = type_opcode'(opcode_in);

  assign dmem_sel = (opcode == OP_L | opcode == OP_S) && (dbus_msb_addr == DMEM_ADDR);
  assign uart_sel = (opcode == OP_L | opcode == OP_S) && (dbus_msb_addr == UART_ADDR);
endmodule

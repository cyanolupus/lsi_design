module exec_ldst (v_i, opr0_i, opr1_i, imm_i, opecode_i, addr_o, write_o, data_o);
    `include "./include/params.v"
    input v_i;
    input [W_OPR -1: 0] opr0_i, opr1_i;
    input [W_IMM -1: 0] imm_i;
    input [W_OPC -1: 0] opecode_i;
    output [ADDR -1: 0] addr_o;
    output write_o;
    output [W_OPR -1: 0] data_o;

    wire [ADDR -1: 0] load_addr;
    wire [ADDR -1: 0] store_addr;
    wire [W_OPR -1: 0] data;

    assign load_addr = (opr1_i + imm_i);
    assign store_addr = (opr0_i + imm_i);
    assign addr_o = (opecode_i == 7'b001_1001) ? store_addr[ADDR -1: 0] : load_addr[ADDR -1: 0];
    assign data_o = opr1_i;
    assign write_o = (opecode_i == 7'b001_1001) ? v_i : 1'b0;
endmodule
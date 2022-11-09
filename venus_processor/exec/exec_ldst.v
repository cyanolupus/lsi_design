module exec_ldst (opr0_i, opr1_i, imm_i, store_i, addr_o, write_o, data_o);
    `include "./include/params.v"
    input [W_OPR -1: 0] opr0_i, opr1_i;
    input [W_IMM -1: 0] imm_i;
    input store_i;
    output [W_OPR -1: 0] addr_o;
    output write_o;
    output [W_OPR -1: 0] data_o;

    wire [W_OPR -1: 0] load_addr;
    wire [W_OPR -1: 0] store_addr;
    wire [W_OPR -1: 0] data;

    assign load_addr = opr1_i + imm_i;
    assign store_addr = opr0_i + imm_i;
    assign addr_o = (store_i) ? store_addr : load_addr;
    assign data_o = opr1_i;
    assign write_o = store_i;
endmodule
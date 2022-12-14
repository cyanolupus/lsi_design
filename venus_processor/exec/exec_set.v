module exec_set (opr0_i, imm_i, high_i, result_o);
    `include "../include/params.v"
    input [W_OPR -1: 0] opr0_i;
    input [W_IMM -1: 0] imm_i;
    input high_i;
    output [W_OPR -1: 0] result_o;

    wire [W_OPR -1: 0] high;
    wire [W_OPR -1: 0] low;

    assign high = {imm_i[W_IMM -1:0], opr0_i[W_OPR -W_IMM -1:0]};
    assign low = {opr0_i[W_OPR -1:W_IMM], imm_i[W_IMM -1:0]};

    assign result_o = (high_i)?high:low;
endmodule
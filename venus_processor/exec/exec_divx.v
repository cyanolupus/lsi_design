module exec_divx (opr0_i, opr1_i, result_o);
    `include "./include/params.v"
    input [W_OPR -1: 0] opr0_i, opr1_i;
    output [W_OPR -1: 0] result_o;

    assign result_o = opr0_i / opr1_i;
endmodule
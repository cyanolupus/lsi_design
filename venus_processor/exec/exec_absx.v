module exec_absx (opr1_i, result_o);
    input [W_OPR -1: 0] opr1_i;
    output [W_OPR -1: 0] result_o;

    wire [W_OPR -1: 0] opr1_pre;

    assign opr1_pre = ~opr1_i + 1;
    assign result_o = opr1_i[W_OPR-1]?opr1_pre:opr1_i;
endmodule
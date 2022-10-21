module exec_addx (opr0_i, opr1_i, result_o, minus_i);
    input [W_OPR -1: 0] opr0_i, opr1_i;
    output [W_OPR -1: 0] result_o;
    input minus_i;

    wire [W_OPR -1: 0] opr1_pre;

    assign opr1_pre = minus ? ~opr1_i : opr1_i;
    assign result_o = opr0_i + opr1_pre + minus_i;
endmodule
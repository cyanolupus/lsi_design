module exec_divx ();
    input [W_OPR -1: 0] opr0_i, opr1_i;
    output [W_OPR -1: 0] result_o;

    assign result_o = opr0_i / opr1_i;
endmodule
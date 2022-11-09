module exec_shift (opr0_i, opr1_i, result_o, right_i, alith_i);
    `include "./include/params.v"
    input [W_OPR -1: 0] opr0_i, opr1_i;
    output [W_OPR -1: 0] result_o;
    input right_i, alith_i;

    wire [4:0] opr1_pre;
    wire [W_OPR -1: 0] result_shl, result_shr, result_ash;

    assign opr1_pre = opr1_i[4:0];
    assign result_shl = opr0_i << opr1_i;
    assign result_shr = opr0_i >> opr1_i;
    assign result_ash = opr0_i >>> opr1_i;

    assign result_o = right_i?result_shl:(alith_i?result_ash:result_shr);
endmodule
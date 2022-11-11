module exec_cmp (opr0_i, opr1_i, 
                carry_flag_o, zero_flag_o,
                sign_flag_o, overflow_flag_o);

    `include "./include/params.v"
    input [W_OPR -1: 0] opr0_i, opr1_i;
    output carry_flag_o, zero_flag_o, sign_flag_o, overflow_flag_o;

    wire [W_OPR : 0] result_sub;

    assign result_sub = opr0_i - opr1_i;
    assign carry_flag_o = result_sub[W_OPR];
    assign zero_flag_o = ~|result_sub;
    assign sign_flag_o = result_sub[W_OPR -2];
    assign overflow_flag_o = (opr0_i[W_OPR -1] == opr1_i[W_OPR -1]) & (opr0_i[W_OPR -1] != result_sub[W_OPR -1]);
endmodule
module exec_cmp (opr0_i, opr1_i, flags_o);

    `include "./include/params.v"
    input [W_OPR -1: 0] opr0_i, opr1_i;
    output [W_FLAGS -1: 0] flags_o;

    wire [W_OPR : 0] result_sub;
    wire carry;
    wire zero;
    wire sign;
    wire overflow;

    assign result_sub = opr0_i - opr1_i;
    assign carry = result_sub[W_OPR];
    assign zero = ~(|result_sub[W_OPR -1:0]);
    assign sign = result_sub[W_OPR -1];
    assign overflow = (opr0_i[W_OPR -1] ^ opr1_i[W_OPR -1]) & (opr0_i[W_OPR -1] ^ sign);
    assign flags_o = {overflow, sign, zero, carry};
endmodule
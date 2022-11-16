module exec_addx (opr0_i, opr1_i, result_o, minus_i, flags_o);
    `include "./include/params.v"
    input [W_OPR -1: 0] opr0_i, opr1_i;
    output [W_OPR -1: 0] result_o;
    input minus_i;
    output [W_FLAGS -1: 0] flags_o;

    wire [W_OPR -1: 0] opr1_pre;
    wire [W_OPR: 0] result_pre;
    wire carry;
    wire zero;
    wire sign;
    wire overflow;

    assign opr1_pre = minus_i ? ~opr1_i + 1: opr1_i;
    assign result_pre = opr0_i + opr1_pre;
    assign result_o = result_pre[W_OPR -1:0];
    assign carry = result_pre[W_OPR];
    assign zero = ~(|result_o);
    assign sign = result_o[W_OPR -1];
    assign overflow = ~(opr0_i[W_OPR -1] ^ opr1_pre[W_OPR -1]) & (opr0_i[W_OPR -1] ^ sign);
    assign flags_o = {overflow, sign, zero, carry};
endmodule
module exec_shift (opr0_i, opr1_i, result_o, select_i, flags_o);
    `include "../include/params.v"
    `include "../include/select2from4.v"
    input signed [W_OPR -1: 0] opr0_i, opr1_i;
    output [W_OPR -1: 0] result_o;
    input [1:0] select_i;
    output [W_FLAGS -1: 0] flags_o;

    wire carry;
    wire zero;
    wire sign;
    wire overflow;

    wire [4:0] opr1_pre;
    wire signed [W_OPR*2 -1: 0] opr0_pre_r, opr0_pre_l;
    wire [W_OPR*2 -1: 0] result_shl, result_shr, result_ash;
    wire [W_OPR -1: 0] result_over;

    assign opr1_pre = opr1_i[4:0];
    assign opr0_pre_r = {opr0_i, {W_OPR{1'b0}}};
    assign opr0_pre_l = {{W_OPR{1'b0}}, opr0_i};
    assign result_shl = opr0_pre_l << opr1_pre;
    assign result_shr = opr0_pre_r >> opr1_pre;
    assign result_ash = opr0_pre_r >>> opr1_pre;

    assign result_o = select2from4(select_i, result_shl[W_OPR -1:0], result_shr[W_OPR*2 -1:W_OPR], result_ash[W_OPR*2 -1:W_OPR], 32'b0);
    assign result_over = select2from4(select_i, result_shl[W_OPR*2 -1:W_OPR], result_shr[W_OPR -1:0], result_ash[W_OPR -1:0], 32'b0);
    assign carry = |result_over;
    assign zero = ~(|result_o);
    assign sign = result_o[W_OPR -1];
    assign overflow = opr0_i[W_OPR -1] ^ sign;
    assign flags_o = {overflow, sign, zero, carry};
endmodule
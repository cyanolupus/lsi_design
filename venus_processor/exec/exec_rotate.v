module exec_rotate (opr0_i, opr1_i, result_o, right_i, flags_o);
    `include "../include/params.v"
    input signed [W_OPR -1: 0] opr0_i, opr1_i;
    output [W_OPR -1: 0] result_o;
    input right_i;
    output [W_FLAGS -1: 0] flags_o;

    wire carry;
    wire zero;
    wire sign;
    wire overflow;

    wire [4:0] opr1_pre;
    wire [W_OPR -1: 0] result_rol_l, result_rol_r, result_ror_l, result_ror_r;
    wire [W_OPR -1: 0] result_over;

    assign opr1_pre = opr1_i[4:0];
    assign result_rol_l = opr0_i << opr1_pre;
    assign result_rol_r = opr0_i >> (W_OPR - opr1_pre);
    assign result_ror_l = opr0_i << (W_OPR - opr1_pre);
    assign result_ror_r = opr0_i >> opr1_pre;

    assign result_o = right_i ? result_ror_l | result_ror_r : result_rol_l | result_rol_r;
    assign carry = result_o[W_OPR -1];
    assign zero = ~(|result_o);
    assign sign = result_o[W_OPR -1];
    assign overflow = 1'b0;
    assign flags_o = {overflow, sign, zero, carry};
endmodule
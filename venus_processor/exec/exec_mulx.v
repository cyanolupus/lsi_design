module exec_mulx (opr0_i, opr1_i, result_o, flags_o);
    `include "./include/params.v"
    input [W_OPR -1: 0] opr0_i, opr1_i;
    output [W_OPR -1: 0] result_o;
    output [W_FLAGS -1: 0] flags_o;

    wire [W_OPR*2 -1: 0] result;
    wire carry;
    wire zero;
    wire sign;
    wire overflow;

    assign result = opr0_i * opr1_i;
    assign result_o = result[W_OPR -1:0];
    assign carry = (|result[W_OPR*2 -1:W_OPR]);
    assign zero = ~(|result_o);
    assign sign = opr0_i[W_OPR -1] ^ opr1_i[W_OPR -1];
    assign overflow = sign ^ result_o[W_OPR -1];
    assign flags_o = {overflow, sign, zero, carry};
endmodule
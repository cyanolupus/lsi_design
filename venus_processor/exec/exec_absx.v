module exec_absx (opr1_i, result_o, flags_o);
    `include "./include/params.v"
    input [W_OPR -1: 0] opr1_i;
    output [W_OPR -1: 0] result_o;
    output [W_FLAGS -1: 0] flags_o;

    wire [W_OPR -1: 0] opr1_pre;
    wire carry;
    wire zero;
    wire sign;
    wire overflow;

    assign opr1_pre = ~opr1_i + 1;
    assign result_o = opr1_i[W_OPR-1]?opr1_pre:opr1_i;
    assign carry = 0;
    assign zero = ~(|result_o);
    assign sign = result_o[W_OPR -1];
    assign overflow = 0;
    assign flags_o = {overflow, sign, zero, carry};
endmodule
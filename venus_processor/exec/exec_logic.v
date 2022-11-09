module exec_logic (opr0_i, opr1_i, result_o, select_i);
    input [W_OPR -1: 0] opr0_i, opr1_i;
    output [W_OPR -1: 0] result_o;
    input [1:0] select_i;
    `include "select2from4.v"

    wire [W_OPR -1: 0] and_pre;
    wire [W_OPR -1: 0] or_pre;
    wire [W_OPR -1: 0] xor_pre;
    wire [W_OPR -1: 0] not_pre;

    assign result_o = select2from4(select_i, and_pre, or_pre, not_pre, xor_pre);
endmodule
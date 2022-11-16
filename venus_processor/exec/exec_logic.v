module exec_logic (opr0_i, opr1_i, result_o, select_i);
    `include "./include/params.v"
    `include "./include/select2from4.v"
    
    input [W_OPR -1: 0] opr0_i, opr1_i;
    output [W_OPR -1: 0] result_o;
    input [1:0] select_i;

    wire [W_OPR -1: 0] and_pre;
    wire [W_OPR -1: 0] or_pre;
    wire [W_OPR -1: 0] xor_pre;
    wire [W_OPR -1: 0] not_pre;

    assign and_pre = opr0_i & opr1_i;
    assign or_pre = opr0_i | opr1_i;
    assign xor_pre = opr0_i ^ opr1_i;
    assign not_pre = ~opr0_i;

    assign result_o = select2from4(select_i, and_pre, or_pre, not_pre, xor_pre);
endmodule
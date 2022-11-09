module exec_mulx (opr0_i, opr1_i, result_o);
    `include "./include/params.v"
    input [W_OPR -1: 0] opr0_i, opr1_i;
    output [W_OPR -1: 0] result_o;

    wire [W_OPR*2 -1: 0] result;

    assign result = opr0_i * opr1_i;
    assign result_o = result[W_OPR -1:0];
endmodule
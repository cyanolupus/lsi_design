module exec_branch (cc, opr1_i,
                v_i, pc_i, opecode_i,
                flags,
                branch_o, branch_addr_o);

    `include "./include/params.v"
    `include "./include/select3from8.v"

    input [W_CC -1: 0] cc;
    input [ADDR -1: 0] opr1_i;
    input v_i;
    input [ADDR -1: 0] pc_i;
    input [W_OPC -1: 0] opecode_i;
    input [W_FLAGS -1: 0] flags;
    output branch_o;
    output [ADDR -1: 0] branch_addr_o;

    wire abs = opecode_i[0];

    assign branch_o = (opecode_i[W_OPC -1:1] == 6'b001_110)? v_i & select3from8(cc, 1'b1, zero_flag_i, (~sign_flag_i), sign_flag_i, carry_flag_i, overflow_flag_i, 1'b0, 1'b0) : 1'b0;
    assign branch_addr_o = (abs)? opr1_i : (pc_i + opr1_i);
endmodule
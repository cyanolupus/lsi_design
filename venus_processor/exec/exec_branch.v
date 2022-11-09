module exec_branch (opr0_i, opr1_i,
                v_i, pc_i, abs_i,
                carry_flag_i, zero_flag_i,
                sign_flag_i, overflow_flag_i,
                branch_o, branch_addr_o);

    `include "./include/params.v"
    `include "./include/select3from8.v"

    input [W_OPR -1: 0] opr0_i, opr1_i;
    input v_i;
    input [ADDR -1: 0] pc_i;
    input abs_i;
    input carry_flag_i, zero_flag_i, sign_flag_i, overflow_flag_i;
    output branch_o;
    output [ADDR -1: 0] branch_addr_o;

    assign branch_o = v_i & select3from8(opr0_i[2:0], 1'b1, zero_flag_i, (~sign_flag_i), sign_flag_i, carry_flag_i, overflow_flag_i, 1'b0, 1'b0);
    assign branch_addr_o = (abs_i)? opr1_i : (pc_i + opr1_i);
endmodule
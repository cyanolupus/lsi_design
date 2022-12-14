module branch_target (
    v_i, v_o,
    pc_i, pc_o,
    inst_i, pred_addr_o);

    `include "../include/params.v"

    input v_i;
    output v_o;
    input [ADDR -1: 0] pc_i;
    output [ADDR -1: 0] pc_o;
    input [WORD -1: 0] inst_i;
    output [ADDR -1: 0] pred_addr_o;

    wire is_branch;
    wire is_jr;
    wire immf;

    assign is_branch = inst_i[WORD - 1: WORD - W_OPC + 3] == 4'b0100;
    assign is_jr = &inst_i[WORD - W_OPC + 2: WORD - W_OPC + 1];
    assign immf = inst_i[WORD - W_OPC - 1];

    assign v_o = v_i & is_branch & ~is_jr & immf;
    assign pred_addr_o = inst_i[W_IMM - 1: 0];
    assign pc_o = pc_i;
endmodule

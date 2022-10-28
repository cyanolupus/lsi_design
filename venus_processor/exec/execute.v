module execute (clk, reset,
                v_i, v_o,
                stall_i, stall_o,
                pc_i, pc_o, imm_i,
                opecode_i, opr0_i, opr1_i,
                wb_r_i,
                result_o, wb_r_o, wb_o)

    `include "./include/params.v"
    `include "./include/select5from32.v"

    input  clk, reset;
    input  v_i;
    output v_o;
    input stall_i;
    output stall_o;
    input [ADDR -1: 0] pc_i;
    output [ADDR -1: 0] pc_o;
    input [W_IMM -1: 0] imm_i;

    input [W_OPC -1: 0] opecode_i;
    input [W_OPR -1: 0] opr0_i, opr1_i;
    input [W_RD -1: 0] wb_r_i;

    reg v_r;
    reg [W_OPR -1: 0] result_r;
    reg [W_RD -1: 0] wb_r_r;
    reg wb_r;
    reg [ADDR -1: 0] pc_r;

    reg carry_flag;
    reg zero_flag;
    reg sign_flag;
    reg overflow_flag;

    wire [W_OPR -1: 0] result_addx;
    wire [W_OPR -1: 0] result_mulx;
    wire [W_OPR -1: 0] result_divx;
    wire [W_OPR -1: 0] result_absx;
    wire [W_OPR -1: 0] result_shift;
    wire [W_OPR -1: 0] result_ldst;
    wire [W_OPR -1: 0] result_null;
    wire mem_write;
    wire [W_OPR -1: 0] mem_data;
    wire [W_OPR -1: 0] result_tmp;

    exec_addx addx (opr0_i, opr1_i, result_addx, opecode_i[0]);
    exec_mulx mulx (opr0_i, opr1_i, result_mulx);
    exec_divx divx (opr0_i, opr1_i, result_divx);
    exec_absx absx (opr0_i, result_absx);
    exec_shift shift (opr0_i, opr1_i, result_shift, opecode_i[0], opecode_i[1]);
    exec_ldst ldst (opr0_i, opr1_i, imm_i, opecode_i[0], result_ldst, mem_write, mem_data);
endmodule
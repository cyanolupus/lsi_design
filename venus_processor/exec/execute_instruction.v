module execute_instruction (clk, reset,
                v_i, v_o,
                stall_i, stall_o,
                pc_i, imm_i,
                opecode_i, opr0_i, opr1_i,
                wb_i, wb_r_i,
                ldst_addr_o, ldst_write_o, 
                ldst_data_i, ldst_data_o,
                result_o, wb_r_o, wb_o,
                branch_o, branch_addr_o);

    `include "./include/params.v"
    `include "./include/select5from32.v"

    input  clk, reset;
    input  v_i;
    output v_o;
    input stall_i;
    output stall_o;
    input [ADDR -1: 0] pc_i;
    input [W_IMM -1: 0] imm_i;

    input [W_OPC -1: 0] opecode_i;
    input [W_OPR -1: 0] opr0_i, opr1_i;
    input [W_RD -1: 0] wb_r_i;

    output [ADDR -1: 0] ldst_addr_o;
    output ldst_write_o;
    input [W_OPR -1: 0] ldst_data_i;
    output [W_OPR -1: 0] ldst_data_o;

    output [W_OPR -1: 0] result_o;
    output [W_RD -1: 0] wb_r_o;
    output wb_o;
    output branch_o;
    output [ADDR -1: 0] branch_addr_o;

    reg v_r;
    reg [W_OPR -1: 0] result_r;
    reg [W_RD -1: 0] wb_r_r;
    reg wb_r;

    reg carry_flag_r;
    reg zero_flag_r;
    reg sign_flag_r;
    reg overflow_flag_r;

    reg ld_r;

    wire [W_OPR -1: 0] result_addx;
    wire [W_OPR -1: 0] result_mulx;
    wire [W_OPR -1: 0] result_divx;
    wire [W_OPR -1: 0] result_absx;
    wire [W_OPR -1: 0] result_shift;
    wire [W_OPR -1: 0] result_logic;
    wire [W_OPR -1: 0] result_load;
    wire [W_OPR -1: 0] result_null;
    wire [W_OPR -1: 0] selected_result;

    exec_ldst ldst (opr0_i, opr1_i, imm_i, opecode_i[0] & v_i, ldst_addr_o, ldst_write_o, ldst_data_o);

    exec_addx addx (opr0_i, opr1_i, result_addx, opecode_i[0]);
    exec_mulx mulx (opr0_i, opr1_i, result_mulx);
    exec_divx divx (opr0_i, opr1_i, result_divx);
    exec_absx absx (opr0_i, result_absx);
    exec_shift shift (opr0_i, opr1_i, result_shift, opecode_i[0], opecode_i[1]);
    exec_logic logic (opr0_i, opr1_i, result_logic, opecode_i[1:0]);
    exec_branch branch (opr0_i, opr1_i, v_i, pc_i, opecode_i[0], carry_flag_r, zero_flag_r, sign_flag_r, overflow_flag_r, branch_o, branch_addr_o);

    // input [W_OPC - 3:0] select;
    // input [W_OPR - 1:0] result0, result1, result2, result3, result4, result5; // ADDx, SUBx, MULx, DIVx, (CMPx), ABSx
    // input [W_OPR - 1:0] result6, result7, result8, result9, result10, result11; // ADCx, SBCx, SHLx, SHRx, ASHx, none
    // input [W_OPR - 1:0] result12, result13, result14, result15, result16, result17; // ROLx, RORx, none, none, AND, OR
    // input [W_OPR - 1:0] result18, result19, result20, result21, result22, result23; // NOT, XOR, none, none, SETL, SETH
    // input [W_OPR - 1:0] result24, result25, result26, result27, result28, result29; // LD, ST, none, none, J, JA
    // input [W_OPR - 1:0] result30, result31; // NOP, HLT
    assign selected_result = select5from32(opecode_i[4:0],
        result_addx, result_addx, result_mulx, result_divx, result_null, result_absx,
        result_null, result_null, result_shift, result_shift, result_shift, result_null,
        result_null, result_null, result_null, result_null, result_logic, result_logic,
        result_logic, result_logic, result_null, result_null, result_null, result_null,
        result_null, result_null, result_null, result_null, result_null, result_null,
        result_null, result_null);

    assign v_o = v_r;
    assign stall_o = stall_i;
    assign result_o = (ld_r)?result_load:result_r;
    assign wb_r_o = wb_r_r;
    assign wb_o = wb_r;

    always @(posedge clk or negedge reset) begin
        if (~reset) begin
            v_r <= 0;
            result_r <= 0;
            wb_r_r <= 0;
            wb_r <= 0;

            carry_flag_r <= 0;
            zero_flag_r <= 0;
            sign_flag_r <= 0;
            overflow_flag_r <= 0;

            opecode_r <= 0;
        end else begin
            if (~stall_i) begin
                v_r <= v_i;
                result_r <= selected_result;
                wb_r_r <= wb_r_i;
                wb_r <= 1'b1;

                carry_flag_r <= addx.carry_flag_o;
                zero_flag_r <= addx.zero_flag_o;
                sign_flag_r <= addx.sign_flag_o;
                overflow_flag_r <= addx.overflow_flag_o;

                ld_r <= (opecode_i == 7'b1000000);
            end
        end
    end
endmodule
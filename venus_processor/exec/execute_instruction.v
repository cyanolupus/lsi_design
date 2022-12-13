module execute_instruction (clk, reset,
                v_i, v_o,
                stall_i, stall_o,
                pc_i, imm_i,
                opr0_i, opr1_i,
                d_info_i, wb_r_i,
                ldst_addr_o, ldst_write_o, 
                ldst_data_i, ldst_data_o,
                result_o, wb_r_o, wb_o,
                branch_o, branch_addr_o);

    `include "./include/params.v"
    `include "./include/select4from16.v"

    input  clk, reset;
    input  v_i;
    output v_o;
    input stall_i;
    output stall_o;
    input [ADDR -1: 0] pc_i;
    input [W_IMM -1: 0] imm_i;

    input [W_OPR -1: 0] opr0_i, opr1_i;
    input [D_INFO -1: 0] d_info_i;
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

    reg [W_FLAGS -1: 0] flags_r; // 0: carry, 1: zero, 2: sign, 3: overflow

    reg ld_r;

    wire [W_OPR -1: 0] result_addx;
    wire [W_OPR -1: 0] result_mulx;
    wire [W_OPR -1: 0] result_divx;
    wire [W_OPR -1: 0] result_absx;
    wire [W_OPR -1: 0] result_shift;
    wire [W_OPR -1: 0] result_rotate;
    wire [W_OPR -1: 0] result_logic;
    wire [W_OPR -1: 0] result_set;

    wire [W_FLAGS -1: 0] flags_addx;
    wire [W_FLAGS -1: 0] flags_mulx;
    wire [W_FLAGS -1: 0] flags_divx;
    wire [W_FLAGS -1: 0] flags_cmp;
    wire [W_FLAGS -1: 0] flags_absx;
    wire [W_FLAGS -1: 0] flags_shift;
    wire [W_FLAGS -1: 0] flags_rotate;
    wire [W_FLAGS -1: 0] flags_logic;
    
    wire [W_OPR -1: 0] result_null = {W_OPR{1'b0}};
    wire [W_OPR -1: 0] selected_result;

    wire [W_FLAGS -1: 0] flags_null = {W_FLAGS{1'b0}};
    wire [W_OPR -1: 0] selected_flags_pre;
    wire [W_FLAGS -1: 0] selected_flags;

    wire [W_CC -1: 0] cc = opr0_i[W_CC -1:0];

    wire [W_OPR -1: 0] imm_signed = d_info_i[SIGN]?{{16{imm_i[15]}},imm_i}:{{16{1'b0}},imm_i};
    wire [W_OPR -1: 0] opr1_or_imm = d_info_i[IMMF] ? imm_signed : opr1_i;
    wire [ADDR -1: 0] opr1_or_imm_low = d_info_i[IMMF] ? imm_signed[ADDR -1:0] : opr1_i[ADDR -1:0];

    wire [W_EXEC -1: 0] executor = d_info_i[D_INFO -1:D_INFO - W_EXEC];
    wire [W_SELECT -1: 0] select = d_info_i[D_INFO - W_EXEC -1:D_INFO - W_EXEC - W_SELECT];

    exec_ldst ldst (opr0_i, opr1_i, d_info_i[IMMF], imm_i, d_info_i[LSTF] & select[0] & v_i, ldst_addr_o, ldst_write_o, ldst_data_o);

    exec_addx addx (opr0_i, opr1_or_imm, result_addx, select[1:0], flags_r, flags_addx);
    exec_mulx mulx (opr0_i, opr1_or_imm, result_mulx, flags_mulx);
    exec_divx divx (opr0_i, opr1_or_imm, result_divx, flags_divx);
    exec_cmp cmp (opr0_i, opr1_or_imm, flags_cmp);
    exec_absx absx (opr1_or_imm, result_absx, flags_absx);
    exec_shift shift (opr0_i, opr1_or_imm, result_shift, select[1:0], flags_shift);
    exec_rotate rotate (opr0_i, opr1_or_imm, result_rotate, select[0], flags_rotate);
    exec_logic logic (opr0_i, opr1_i, result_logic, select[1:0], flags_logic);
    exec_set set (opr0_i, imm_i, select[0], result_set);
    exec_branch branch (cc, opr1_or_imm_low, pc_i, v_i & d_info_i[BRF], select, flags_r, branch_o, branch_addr_o);

    // input [W_OPR -1: 0] data0, data1, data2, data3; // addx mulx divx cmp
    // input [W_OPR -1: 0] data4, data5, data6, data7; // absx none shift rotate
    // input [W_OPR -1: 0] data8, data9, dataa, datab; // logic set none none
    // input [W_OPR -1: 0] datac, datad, datae, dataf; // none none none none

    assign selected_result = select4from16(executor,
        result_addx, result_mulx, result_divx, result_null,
        result_absx, result_null, result_shift, result_rotate,
        result_logic, result_set, result_null, result_null,
        result_null, result_null, result_null, result_null);

    assign selected_flags_pre = select4from16(executor,
        flags_addx, flags_mulx, flags_divx, flags_cmp,
        flags_absx, flags_null, flags_shift, flags_rotate,
        flags_logic, flags_null, flags_null, flags_null,
        flags_null, flags_null, flags_null, flags_null);
    
    assign selected_flags = selected_flags_pre[W_FLAGS - 1:0];

    assign v_o = v_r;
    assign stall_o = stall_i;
    assign result_o = (ld_r)?ldst_data_i:result_r;
    assign wb_r_o = wb_r_r;
    assign wb_o = v_r & wb_r;

    always @(posedge clk or negedge reset) begin
        if (~reset) begin
            v_r <= 0;
            result_r <= 0;
            wb_r_r <= 0;
            wb_r <= 0;
            ld_r <= 0;
            flags_r <= 0;
        end else begin
            if (~stall_i | ~v_r) begin
                v_r <= v_i;
                result_r <= selected_result;
                wb_r_r <= wb_r_i;
                wb_r <= d_info_i[WRSV];
                flags_r <= selected_flags;
                ld_r <= ~select[0] & d_info_i[LSTF];

                if (d_info_i[HLTF] & v_i) begin
                    $finish;
                end
            end
        end
    end
endmodule
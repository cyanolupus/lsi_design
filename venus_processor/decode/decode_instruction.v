module decode_instruction(clk, reset,
                v_i, v_o,
                stall_i, stall_o,
                inst_i,
                pc_i, pc_o,
                w_reserve_o, 
                r0_o, r1_o,
                r_opr0_i, r_opr1_i,
                imm_o,
                reserved_i,
                opr0_o, opr1_o,
                d_info_o,
                wb_r_o, branch_i);

    `include "./include/params.v"
    `include "./include/decode_inst.v"

    input  clk, reset;
    input  v_i;
    output v_o;
    input stall_i;
    output stall_o;
    input [WORD -1: 0] inst_i;
    input [ADDR -1: 0] pc_i;
    output [ADDR -1: 0] pc_o;
    output w_reserve_o;
    output [W_RD -1: 0] r0_o, r1_o;
    input [W_OPR -1: 0] r_opr0_i, r_opr1_i;
    output [W_IMM -1: 0] imm_o;
    input reserved_i;
    output [W_OPR -1: 0] opr0_o, opr1_o;
    output [D_INFO -1: 0] d_info_o;
    output [W_RD -1: 0] wb_r_o;
    input branch_i;

    reg v_r;
    reg [W_IMM -1: 0] imm_r;
    reg [ADDR -1: 0] pc_r;
    reg [W_OPR -1: 0] r0_r, r1_r;
    reg [D_INFO -1: 0] d_info_r;

    wire [W_IMM -1: 0] imm;
    wire [D_INFO -1: 0] d_info;

    assign d_info = decode_inst(inst_i[WORD -1: W_RD + W_RD + W_IMM]);
    assign r0_o = r0_r;
    assign r1_o = r1_r;
    assign imm = inst_i[W_IMM - 1: 0];
    
    assign w_reserve_o = v_r & d_info_r[WRSV] & ~reserved_i;
    assign opr0_o = r_opr0_i;
    assign opr1_o = r_opr1_i;
    assign wb_r_o = r0_r;
    assign imm_o = imm_r;
    assign pc_o = pc_r;
    assign d_info_o = d_info_r;

    assign stall_o = stall_i & v_r | reserved_i;
    assign v_o = v_r & (~stall_o | stall_i);

    always @(posedge clk or negedge reset) begin
        if (~reset) begin
            v_r <= 0;
            imm_r <= 0;
            r0_r <= 0;
            r1_r <= 0;
            pc_r <= 0;
            d_info_r <= 0;
        end else begin
            if ((~stall_i | ~v_r) & ~reserved_i) begin
                v_r <= v_i & ~branch_i;
                r0_r <= inst_i[W_RD + W_RD + W_IMM - 1: W_RD + W_IMM];
                r1_r <= inst_i[W_RD + W_IMM - 1: + W_IMM];
                d_info_r <= d_info;
                imm_r <= imm;
                pc_r <= pc_i;
            end
        end
    end
endmodule
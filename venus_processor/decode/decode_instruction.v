module decode_instruction(clk, reset,
                v_i, v_o,
                stall_i, stall_o,
                inst_i,
                pc_i, pc_o,
                w_reserve_o, 
                r0_o, r1_o,
                r_opr0_i, r_opr1_i,
                immf_o, immsign_o,
                imm_o, stf_o,
                reserved_i,
                opecode_o, opr0_o, opr1_o,
                wb_o, wb_r_o, branch_i);

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
    output immf_o;
    output immsign_o;
    output [W_IMM -1: 0] imm_o;
    output stf_o;
    input reserved_i;
    output [W_OPC -1: 0] opecode_o;
    output [W_OPR -1: 0] opr0_o, opr1_o;
    output wb_o;
    output [W_RD -1: 0] wb_r_o;
    input branch_i;

    reg v_r;
    reg [W_OPC -1: 0] opecode_r;
    reg [W_IMM -1: 0] imm_r;
    reg immf_r;
    reg immsign_r;
    reg [ADDR -1: 0] pc_r;
    reg [W_OPR -1: 0] r0_r, r1_r;
    reg w_reserve_r;
    reg wb_r;
    reg stf_r;

    wire [W_OPC -1: 0] opecode;
    wire [W_IMM -1: 0] imm;
    wire reserved;
    wire [D_INFO -1: 0] d_info;

    assign opecode = inst_i[WORD -1: 1 + W_RD + W_RD + W_IMM];
    assign d_info = decode_inst(inst_i[WORD -1: W_RD + W_RD + W_IMM]);
    assign r0_o = r0_r;
    assign r1_o = r1_r;
    assign imm = inst_i[W_IMM - 1: 0];
    
    assign w_reserve_o = w_reserve_r & ~reserved_i;
    assign opecode_o = opecode_r;
    assign opr0_o = r_opr0_i;
    assign opr1_o = r_opr1_i;
    assign wb_o = v_r & w_reserve_r;
    assign wb_r_o = r0_r;
    assign immf_o = immf_r;
    assign immsign_o = immsign_r;
    assign imm_o = imm_r;
    assign stf_o = stf_r;
    assign pc_o = pc_r;

    assign stall_o = stall_i & v_r | reserved_i;
    assign v_o = v_r & (~stall_o | stall_i);

    always @(posedge clk or negedge reset) begin
        if (~reset) begin
            v_r <= 0;
            opecode_r <= 0;
            imm_r <= 0;
            immsign_r <= 0;
            immf_r <= 0;
            stf_r <= 0;
            r0_r <= 0;
            r1_r <= 0;
            pc_r <= 0;
        end else begin
            if (~stall_i) begin
                if (branch_i) begin
                    v_r <= 0;
                end else begin
                    v_r <= v_i;
                end
                opecode_r <= opecode;
                r0_r <= inst_i[W_RD + W_RD + W_IMM - 1: W_RD + W_IMM];
                r1_r <= inst_i[W_RD + W_IMM - 1: + W_IMM];
                immf_r <= d_info[3];
                imm_r <= imm;
                stf_r <= d_info[0];
                w_reserve_r <= d_info[1] & v_i & ~branch_i;
                wb_r <= d_info[1] & v_i;
                immsign_r <= d_info[2];
                pc_r <= pc_i;
            end
        end
    end
endmodule
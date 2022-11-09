module decode_instruction(clk, reset,
                v_i, v_o,
                stall_i, stall_o,
                inst_i,
                pc_i, pc_o,
                w_reserve_o, 
                r0_o, r1_o,
                r_opr0_i, r_opr1_i,
                imm_o, reserved_i,
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
    output [W_IMM -1: 0] imm_o;
    input reserved_i;
    output [W_OPC -1: 0] opecode_o;
    output [W_OPR -1: 0] opr0_o, opr1_o;
    output wb_o;
    output [W_RD -1: 0] wb_r_o;
    input branch_i;

    reg v_r;
    reg [W_OPC -1: 0] opecode_r;
    reg wb_r;
    reg [W_RD -1: 0] wb_r_r;
    reg [W_OPR -1: 0] imm_r;
    reg immf_r;
    reg reserved_r;
    reg [ADDR -1: 0] pc_r;

    wire [W_OPC -1: 0] opecode;
    wire [W_IMM -1: 0] imm;
    wire reserved;
    wire [D_INFO -1: 0] d_info;

    assign opecode = inst_i[WORD -1: 1 + W_RD + W_RD + W_IMM];
    assign d_info = decode_inst(inst_i[WORD -1: W_RD + W_RD + W_IMM]);
    assign r0_o = inst_i[W_RD + W_RD + W_IMM - 1: W_RD + W_IMM];
    assign r1_o = inst_i[W_RD + W_IMM - 1: + W_IMM];
    assign imm = inst_i[W_IMM - 1: 0];

    assign w_reserve_o = d_info[0] & v_i & ~reserved_r;
    assign stall_o = (stall_i & v_r) | reserved_r;
    assign v_o = v_r & (stall_i|~stall_o);
    assign opecode_o = opecode_r;
    assign opr0_o = r_opr0_i;
    assign opr1_o = (immf_r)?imm_r:r_opr1_i;
    assign wb_o = wb_r;
    assign wb_r_o = wb_r_r;
    assign imm_o = imm_r;
    assign pc_o = pc_r;

    always @(posedge clk or negedge reset) begin
        if (~reset) begin
            v_r <= 0;
            opecode_r <= 0;
            wb_r <= 0;
            wb_r_r <= 0;
            imm_r <= 0;
            immf_r <= 0;
            reserved_r <= 0;
            pc_r <= 0;
        end else begin
            if (~stall_i) begin
                if (branch_i) begin
                    v_r <= 0;
                end else begin
                    v_r <= v_i;
                end
                opecode_r <= opecode;
                wb_r <= d_info[0];
                wb_r_r <= r0_o;
                immf_r <= d_info[2];
                if (d_info[1]) begin
                    imm_r <= {{16{imm[15]}},imm};
                end else begin
                    imm_r <= {{16{1'b0}},imm};
                end
                reserved_r <= reserved_i;
                pc_r <= pc_i;
            end else if (~reserved_i) begin
                reserved_r <= 0;
            end
        end
    end
endmodule
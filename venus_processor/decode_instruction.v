module decode_instruction(clk, reset,
                v_i, v_o,
                stall_i, stall_o,
                inst_i,
                opecode_o, opr0_o, opr1_o,
                wb_i, wb_r_i, result_i,
                wb_r_o);

    `include "./include/params.v"

    input  clk, reset;
    output v_o;
    input stall_i;
    output stall_o;
    input [WORD -1: 0] inst_i;
    output [W_OPC -1: 0] opecode_o;
    output [W_OPR -1: 0] opr0_o, opr1_o;
    input wb_i;
    input [W_RD -1: 0] wb_r_i;
    input [W_OPR -1: 0] result_i;
    output [W_RD -1: 0] wb_r_o;

    reg v_r;
    reg [W_OPC -1: 0] opecode_r;
    reg [W_OPR -1: 0] opr0_r, opr1_r;
    reg [W_RD -1: 0] wb_r_r;
    
    wire [W_OPC -1: 0] opecode;
    wire [W_RD -1:0] reg0_addr;
    wire [W_RD -1:0] reg1_addr;
    wire [W_OPR -1: 0] reg0;
    wire [W_OPR -1: 0] reg1;
    wire reserved;
    wire [D_INFO -1: 0] d_info;

    assign opecode = inst_i[WORD -1: 1 + W_RD + W_RD + W_IMM];
    assign d_info = decode_inst(inst_i[WORD -1: W_RD + W_RD + W_IMM]);
    assign reg0_addr = inst_i[W_RD + W_RD + W_IMM - 1: W_RD + W_IMM];
    assign reg1_addr = inst_i[W_RD + W_IMM - 1: + W_IMM];

    assign stall_o = stall_i | reserved;
    assign v_o = v_r;
    assign opecode_o = opecode_r;
    assign opr0_o = opr0_r;
    assign opr1_o = opr1_r;
    assign wb_r_o = wb_r_r;

    g_reg_x16 register(
        .clk(clk),
        .reset(reset),
        .w_reserve_i(d_info[0]),
        .r0_i(reg0_addr),
        .r1_i(reg1_addr),
        .r_opr0_o(reg0),
        .r_opr1_o(reg1),
        .reserved_o(reserved),
        .wb_i(wb_i),
        .wb_r_i(wb_r_i),
        .result_i(result_i)
    );

    always @(posedge clk or negedge reset) begin
        if (~reset) begin
            next_addr_r <= 0;
            v_r <= 0;
        end else begin
            if (~stall_i) begin
                v_r <= v_i
                opecode_r <= opecode;
                opr0_r <= reg0;
                opr1_r <= reg1;
                wb_r_r <= reg0_addr;
            end
        end
    end
endmodule
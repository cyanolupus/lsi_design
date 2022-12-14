module queue_instruction (
    clk, reset,
    v_i, v_o,
    stall_i, stall_o,
    inst_i, inst_o,
    pc_i, pc_o, branch_i);

    `include "../include/params.v"

    input clk;
    input reset;
    input v_i;
    output v_o;
    input stall_i;
    output stall_o;

    input [WORD -1: 0] inst_i;
    output [WORD -1: 0] inst_o;
    input [ADDR -1: 0] pc_i;
    output [ADDR -1: 0] pc_o;

    input branch_i;

    reg [ADDR + WORD -1: 0] data0_r, data1_r, data2_r, data3_r;
    reg v0_r, v1_r, v2_r, v3_r;

    wire stall_1;
    wire stall_0;
    wire write_1;

    assign stall_1 = stall_i & v1_r;
    assign stall_0 = stall_1 & v0_r;

    assign write_1 = ~v0_r & ~stall_1;

    assign inst_o = data1_r[WORD -1:0];
    assign pc_o = data1_r[ADDR + WORD -1:WORD];
    assign v_o = v1_r;
    assign stall_o = stall_0;

    always @(posedge clk or negedge reset) begin
        if (~reset) begin
            data0_r <= 0;
            data1_r <= 0;
            v0_r <= 0;
            v1_r <= 0;
        end else begin
            if (branch_i) begin
                v0_r <= 0;
                v1_r <= 0;
            end else begin
                if (~v0_r & ~stall_1) begin
                    data1_r <= {pc_i, inst_i};
                    v1_r <= v_i;
                end else if (~stall_1) begin
                    data1_r <= data0_r;
                    v1_r <= v0_r;
                end

                if (~stall_0 & ~write_1) begin
                    data0_r <= {pc_i, inst_i};
                    v0_r <= v_i;
                end
            end
        end
    end
endmodule
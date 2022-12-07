module fetch_instruction(clk, reset,
                v_o,
                stall_i, stall_o,
                inst_i, inst_o, 
                pc_i, pc_o,
                branch_i);

    `include "../include/params.v"

    input  clk, reset;
    output v_o;
    input stall_i;
    output stall_o;

    input [WORD -1: 0] inst_i;
    output [WORD -1: 0] inst_o;

    input [ADDR -1: 0] pc_i;
    output [ADDR -1: 0] pc_o;

    input branch_i;

    reg v_r;
    reg [ADDR -1: 0] pc_r;
    reg [WORD -1: 0] inst_r;

    assign inst_o = inst_i;
    assign v_o = v_r;
    assign stall_o = stall_i & v_r;
    assign pc_o = pc_r;

    always @(posedge clk or negedge reset) begin
        if (~reset) begin
            v_r <= 0;
            pc_r <= 0;
            inst_r <= 0;
        end else begin
            if (~stall_i | ~v_r) begin
                pc_r <= pc_i;
                inst_r <= inst_i;
                v_r <= ~branch_i;
            end
        end
    end
endmodule
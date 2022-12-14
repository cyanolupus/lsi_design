module fetch_instruction(clk, reset,
                v_o,
                stall_i, stall_o,
                inst_i, inst_o, 
                pc_i, pc_o,
                brid_i, brid_o,
                branch_i,
                pred_i, pred_addr_i);

    `include "../include/params.v"

    input  clk, reset;
    output v_o;
    input stall_i;
    output stall_o;

    input [WORD -1: 0] inst_i;
    output [WORD -1: 0] inst_o;

    input [ADDR -1: 0] pc_i;
    output [ADDR -1: 0] pc_o;

    input [W_BRID -1: 0] brid_i;
    output [W_BRID -1: 0] brid_o;

    input branch_i;
    input pred_i;
    input [ADDR -1: 0] pred_addr_i;

    reg v_r;
    reg [ADDR -1: 0] pc_r;
    reg [WORD -1: 0] inst_r;
    reg [W_BRID -1: 0] brid_r;

    assign inst_o = inst_i;
    assign v_o = v_r;
    assign stall_o = stall_i & v_r;
    assign pc_o = pc_r;
    assign brid_o = brid_r;

    always @(posedge clk or negedge reset) begin
        if (~reset) begin
            v_r <= 0;
            pc_r <= 0;
            inst_r <= 0;
            brid_r <= 0;
        end else begin
            if (~stall_i | ~v_r) begin
                inst_r <= inst_i;
                v_r <= ~branch_i;
                if (pred_i) begin
                    pc_r <= pred_addr_i;
                end else begin
                    pc_r <= pc_i;
                end
                brid_r <= brid_i;
            end
        end
    end
endmodule
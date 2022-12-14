module pc(clk, reset,
            stall_i, stall_o,
            pc_o,
            branch_i, branch_addr_i,
            pred_i, pred_addr_i);

    `include "../include/params.v"

    input  clk, reset;
    input stall_i;
    output stall_o;
    output [ADDR -1: 0] pc_o;

    input branch_i;
    input [ADDR -1: 0] branch_addr_i;
    input pred_i;
    input [ADDR -1: 0] pred_addr_i;

    reg [ADDR -1: 0] pc_r;
    reg [ADDR -1: 0] pc_prev;

    wire [ADDR -1: 0] pc_next;

    assign pc_next = pc_r + 1;
    assign pc_o = stall_i?pc_prev:pc_r;
    assign stall_o = stall_i;

    always @(posedge clk or negedge reset) begin
        if (~reset) begin
            pc_r <= 0;
        end else begin
            if (branch_i) begin
                pc_r <= branch_addr_i;
            end else if (pred_i) begin
                pc_r <= pred_addr_i + 1;
            end else if (~stall_i) begin
                pc_prev <= pc_r;
                pc_r <= pc_next;
            end
        end
    end
endmodule

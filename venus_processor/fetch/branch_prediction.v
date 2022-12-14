module branch_prediction (
    clk, reset,
    v_i,
    table_i, branch_i,
    pred_o, pred_id_o);

    `include "../include/params.v"

    input clk, reset;
    input v_i;
    input table_i;
    input branch_i;
    output [W_BRID -1: 0] pred_o;
    output [W_BRID -1: 0] pred_id_o;

    reg [W_BRID -1: 0] pred_r;

    wire [W_BRID -1: 0] pred_prev;
    wire [W_BRID -1: 0] pred_next;
    wire prev;
    wire next;

    assign pred_prev = pred_r - 1;
    assign pred_next = pred_r + 1;
    assign prev = table_i ^ branch_i & &pred_r;
    assign next = ~(table_i ^ branch_i) & ~|pred_r;

    assign pred_o = pred_r[1];
    assign pred_id_o = pred_r;

    always @(posedge clk or negedge reset) begin
        if (~reset) begin
            pred_r <= 2'b01;
        end else begin
            if (v_i) begin
                if (prev) begin
                    pred_r <= pred_prev;
                end else if (next) begin
                    pred_r <= pred_next;
                end
            end
        end
    end
endmodule
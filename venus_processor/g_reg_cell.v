module g_reg_cell(clk, reset,
                        data_i,
                        data_o,
                        w_reserve_i,
                        w_reserve_o,
                        wb_i
                        );

    `include "./include/params.v"

    input clk, reset;
    input [W_OPR -1: 0] data_i;
    output [W_OPR -1: 0] data_o;
    input w_reserve_i;
    output w_reserve_o;
    input wb_i;

    reg [W_OPR-1: 0] data_cell;
    reg w_res;

    assign data_o = data_cell;
    assign w_reserve_o = w_res;

    always @(posedge clk or negedge reset) begin
        if (~reset) begin
            w_res <= 1'b0;
            data_cell <= 32'b0;
        end else begin
            if (w_reserve_i) begin
                w_res <= 1'b1;
            end else if (wb_i) begin
                w_res <= 1'b0;
            end

            if (wb_i) begin
                data_cell <= data_i;
            end
        end
    end
endmodule

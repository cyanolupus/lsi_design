module add_stage(clk, reset,
                v_i1, v_i2, v_o,
                data_i1, data_i2, data_o,
                stall_i, stall_o1, stall_o2);

    input  clk, reset;
    input  v_i1, v_i2;
    output v_o;
    input [31:0] data_i1, data_i2;
    output [31:0] data_o;
    input stall_i;
    output stall_o1, stall_o2;

    wire [31:0] add_tmp;
    wire only_1;
    wire only_2;

    reg v_r;
    reg [31:0] data_r;

    assign v_o = v_r;
    assign data_o = data_r;
    assign add_tmp = data_i1 + data_i2;
    assign only_1 = v_i1 & ~v_i2;
    assign only_2 = ~v_i1 & v_i2;
    assign stall_o1 = (v_r & stall_i) | only_1;
    assign stall_o2 = (v_r & stall_i) | only_2;

    always @(posedge clk or negedge reset) begin
        if (~reset) begin
            v_r <= 0;
            data_r <= 0;
        end else begin
            if (~stall_i) begin
                if (v_i1 & v_i2 | only_1 & v_i2 | only_2 & v_i1) begin
                    v_r <= 1;
                    data_r <= add_tmp;
                end else begin
                    v_r <= 0;
                end
            end
        end
    end
endmodule
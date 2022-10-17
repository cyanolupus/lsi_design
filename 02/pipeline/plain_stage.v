module plain_stage(clk, reset,
                v_i, v_o,
                data_i, data_o,
                stall_i, stall_o);

    input  clk, reset;
    input  v_i;
    output v_o;
    input [31:0] data_i;
    output [31:0] data_o;
    input stall_i;
    output stall_o;

    reg v_r;
    reg [31:0] data_r;

    assign v_o = v_r;
    assign data_o = data_r;
    assign stall_o = (v_r & stall_i);

    always @(posedge clk or negedge reset) begin
        if (~reset) begin
            v_r <= 0;
            data_r <= 0;
        end else begin
            if (~stall_i) begin
                v_r <= v_i;
                data_r <= data_i;
            end
        end
    end
endmodule
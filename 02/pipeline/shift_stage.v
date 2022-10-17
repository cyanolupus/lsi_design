module shift_stage(clk, reset,
                v_i, v_o1, v_o2,
                data_i, data_o1, data_o2,
                stall_i1, stall_i2, stall_o);

    input  clk, reset;
    input  v_i;
    output v_o1, v_o2;
    input [31:0] data_i;
    output [31:0] data_o1, data_o2;
    input stall_i1, stall_i2;
    output stall_o;

    reg v_r1, v_r2;
    reg [31:0] data_r1, data_r2;

    assign v_o1 = v_r1;
    assign v_o2 = v_r2;
    assign data_o1 = data_r1;
    assign data_o2 = data_r2;
    assign stall_o = (v_r1 & v_r2 & stall_i1 & stall_i2);

    always @(posedge clk or negedge reset) begin
        if (~reset) begin
            v_r1 <= 0;
            data_r1 <= 0;
            v_r2 <= 0;
            data_r2 <= 0;
        end else begin
            if (~stall_i1) begin
                v_r1 <= v_i;
                data_r1 <= data_i;
                v_r2 <= 0;
            end else if (~stall_i2) begin
                v_r2 <= v_i;
                data_r2 <= data_i;
                v_r1 <= 0;
            end
        end
    end
endmodule
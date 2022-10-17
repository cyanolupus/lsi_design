module alu_stage(clk, reset,
                v_i1, v_i2, v_o,
                data_i1, data_i2, data_o,
                stall_i, stall_o1, stall_o2,
                opcode);

    input clk, reset;
    input v_i1, v_i2;
    output v_o;
    input [31:0] data_i1, data_i2;
    output [31:0] data_o;
    input stall_i;
    output stall_o1, stall_o2;
    input [1:0] opcode;

    wire [31:0] add_tmp;
    wire [31:0] sub_tmp;
    wire [31:0] mul_tmp;
    wire [31:0] div_tmp;
    wire only_1;
    wire only_2;

    reg v_r;
    reg [31:0] data_r;

    assign v_o = v_r;
    assign data_o = data_r;

    assign only_1 = v_i1 & ~v_i2;
    assign only_2 = ~v_i1 & v_i2;
    assign stall_o1 = (v_r & stall_i) | only_1;
    assign stall_o2 = (v_r & stall_i) | only_2;

    assign add_tmp = data_i1 + data_i2;
    assign sub_tmp = data_i1 - data_i2;
    assign mul_tmp = data_i1 * data_i2;
    assign div_tmp = data_i1 / data_i2;

    always @(posedge clk or negedge reset) begin
        if (~reset) begin
            v_r <= 0;
            data_r <= 0;
        end else begin
            if (~stall_i) begin
                if (v_i1 & v_i2 | only_1 & v_i2 | only_2 & v_i1) begin
                    v_r <= 1;
                    if (opcode == 2'b00) begin
                        data_r <= add_tmp;
                    end else if (opcode == 2'b01) begin
                        data_r <= sub_tmp;
                    end else if (opcode == 2'b10) begin
                        data_r <= mul_tmp;
                    end else if (opcode == 2'b11) begin
                        data_r <= div_tmp;
                    end
                end else begin
                    v_r <= 0;
                end
            end
        end
    end
endmodule
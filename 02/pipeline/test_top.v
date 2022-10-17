`timescale 1ns/100ps

module test_top();
    parameter STEP = 10;
    integer i;

    reg clk, reset;
    reg v_i1, v_i2;
    reg stall_i;
    reg [31:0] data_i1, data_i2;
    
    wire v_buf1, v_buf2;
    wire v_wire1_1, v_wire1_2;
    wire v_wire2;
    wire [31:0] data_buf1, data_buf2;
    wire [31:0] data_wire1_1, data_wire1_2;
    wire [31:0] data_wire2;
    wire [31:0] data_o;
    wire stall_buf1, stall_buf2;
    wire stall_wire1_1, stall_wire1_2;
    wire stall_wire2;
    wire stall_o1, stall_o2;

    plain_stage buffer1(
        .clk(clk), .reset(reset),
        .v_i(v_i1), .v_o(v_buf1),
        .data_i(data_i1), .data_o(data_buf1),
        .stall_i(stall_buf1), .stall_o(stall_o1)
    );

    plain_stage buffer2(
        .clk(clk), .reset(reset),
        .v_i(v_i2), .v_o(v_buf2),
        .data_i(data_i2), .data_o(data_buf2),
        .stall_i(stall_buf2), .stall_o(stall_o2)
    );

    plain_stage stage1_1 (
        .clk(clk), .reset(reset),
        .v_i(v_buf1), .v_o(v_wire1_1),
        .data_i(data_buf1), .data_o(data_wire1_1),
        .stall_i(stall_wire1_1), .stall_o(stall_buf1)
    );

    plain_stage stage1_2 (
        .clk(clk), .reset(reset),
        .v_i(v_buf2), .v_o(v_wire1_2),
        .data_i(data_buf2), .data_o(data_wire1_2),
        .stall_i(stall_wire1_2), .stall_o(stall_buf2)
    );

    add_stage stage2 (
        .clk(clk),
        .reset(reset),
        .v_i1(v_wire1_1),
        .v_i2(v_wire1_2),
        .v_o(v_wire2),
        .data_i1(data_wire1_1),
        .data_i2(data_wire1_2),
        .data_o(data_wire2),
        .stall_i(stall_wire2),
        .stall_o1(stall_wire1_1),
        .stall_o2(stall_wire1_2)
    );

    plain_stage stage3 (
        .clk(clk),
        .reset(reset),
        .v_i(v_wire2),
        .v_o(v_o),
        .data_i(data_wire2),
        .data_o(data_o),
        .stall_i(stall_i),
        .stall_o(stall_wire2)
    );



    always begin
        #(STEP/2) clk = ~clk;
    end

    initial begin
        clk = 1'b0;
        reset = 1'b0;

        #(STEP*2) reset = 1'b1;

        v_i1 = 1'b1;
        v_i2 = 1'b1;
        data_i1 = 32'hf;
        data_i2 = 32'hf;
        stall_i = 1'b0;

        #STEP;

        v_i1 = 1'b1;
        v_i2 = 1'b0;
        data_i1 = 32'd100;
        data_i2 = 32'd1000;
        stall_i = 1'b0;

        #STEP;

        v_i1 = 1'b0;
        v_i2 = 1'b1;
        data_i1 = 32'd200;
        data_i2 = 32'd10;
        stall_i = 1'b0;

        #STEP;
        #STEP;
        #STEP;
        #STEP;
        #STEP;
        #STEP;

        $finish;
    end

    always @(posedge clk) begin
        $display("-------------------------------------------------------------");
        $display("buffer1      : data_o=%d, valid_o=%b, stall_o=%b", data_buf1, v_buf1, stall_o1);
        $display("buffer2      : data_o=%d, valid_o=%b, stall_o=%b", data_buf2, v_buf2, stall_o2);
        $display("stage1_1(op1): data_o=%d, valid_o=%b, stall_o=%b", data_wire1_1, v_wire1_1, stall_buf1);
        $display("stage1_2(op2): data_o=%d, valid_o=%b, stall_o=%b", data_wire1_2, v_wire1_2, stall_buf2);
        $display("stage2  (add): data_o=%d, valid_o=%b, stall_o1=%b, stall_o2=%b", data_wire2, v_wire2, stall_wire1_1, stall_wire1_2);
        $display("stage3  (res): data_o=%d, valid_o=%b, stall_o=%b", data_o, v_o, stall_wire2);
    end
endmodule
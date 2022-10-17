`timescale 1ns/100ps

module test2_top();
    parameter STEP = 10;
    integer i;

    reg clk, reset;
    reg v_i1, v_i2;
    reg stall_i;
    reg [31:0] data_i1, data_i2;
    reg [1:0] opcode;
    
    wire v_wire1_1, v_wire1_2;
    wire v_wire2;
    wire [31:0] data_wire1_1, data_wire1_2;
    wire [31:0] data_wire2;
    wire [31:0] data_o;
    wire stall_wire1_1, stall_wire1_2;
    wire stall_wire2;
    wire stall_o1, stall_o2;

    plain_stage stage1_1 (
        .clk(clk), .reset(reset),
        .v_i(v_i1), .v_o(v_wire1_1),
        .data_i(data_i1), .data_o(data_wire1_1),
        .stall_i(stall_wire1_1), .stall_o(stall_o1)
    );

    plain_stage stage1_2 (
        .clk(clk), .reset(reset),
        .v_i(v_i2), .v_o(v_wire1_2),
        .data_i(data_i2), .data_o(data_wire1_2),
        .stall_i(stall_wire1_2), .stall_o(stall_o2)
    );

    alu_stage stage2 (
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
        .stall_o2(stall_wire1_2),
        .opcode(opcode)
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
        data_i1 = 32'd5;
        data_i2 = 32'd3;
        stall_i = 1'b0;
        opcode = 2'b00;

        #STEP;
        #STEP;

        opcode = 2'b01;

        #STEP;

        opcode = 2'b10;

        #STEP;

        opcode = 2'b11;

        #STEP;

        $finish;
    end

    always @(posedge clk) begin
        $display("-------------------------------------------------------------");
        $display("input1       : data_o=%d, valid_o=%b, stall_o=", data_i1, v_i1);
        $display("input2       : data_o=%d, valid_o=%b, stall_o=", data_i2, v_i2);
        $display("stage1_1(op1): data_o=%d, valid_o=%b, stall_o=%b", data_wire1_1, v_wire1_1, stall_o1);
        $display("stage1_2(op2): data_o=%d, valid_o=%b, stall_o=%b", data_wire1_2, v_wire1_2, stall_o2);
        $display("stage2  (alu): data_o=%d, valid_o=%b, stall_o1=%b, stall_o2=%b, opcode=%b", data_wire2, v_wire2, stall_wire1_1, stall_wire1_2, opcode);
        $display("stage3  (res): data_o=%d, valid_o=%b, stall_o=%b", data_o, v_o, stall_wire2);
    end
endmodule
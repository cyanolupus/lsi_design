`timescale 1ns/100ps

module test_fetch();
    parameter STEP = 10;
    parameter WORD = 32;
    parameter ADDR = 16;
    parameter LEN = 65535;

    integer i;

    wire v_o;
    reg stall_i;
    wire stall_o;
    wire [WORD -1: 0] inst_i;
    wire [WORD -1: 0] inst_o;
    wire [ADDR -1: 0] next_addr;
    reg branch;
    reg [ADDR -1: 0] branch_addr;

    reg clk, reset;
    reg mem_write;
    reg mem_in;

    fetch_instruction fetch(
        .clk(clk),
        .reset(reset),
        .v_o(v_o),
        .stall_i(stall_i),
        .stall_o(stall_o),
        .inst_i(inst_i),
        .inst_o(inst_o),
        .next_addr(next_addr),
        .branch(branch),
        .branch_addr(branch_addr)
    );

    DP_mem32x64k mem_read(
        .clk(clk),
        .A(next_addr),
        .W(mem_write),
        .D(mem_in),
        .Q(inst_i)
    );

    always begin
        #(STEP/2) clk = ~clk;
    end

    initial begin
        clk = 1'b0;
        reset = 1'b0;
        mem_write = 1'b0;
        mem_in = 32'h00000000;

        #(STEP) reset = 1'b1;

        stall_i = 1'b0;
        branch = 1'b0;
        branch_addr = 16'h0000;
        
        for (i = 0; i < 3; i = i + 1) begin
            #(STEP);
        end

        stall_i = 1'b1;

        for (i = 0; i < 3; i = i + 1) begin
            #(STEP);
        end

        stall_i = 1'b0;

        for (i = 0; i < 3; i = i + 1) begin
            #(STEP);
        end

        branch = 1'b1;
        branch_addr = 16'h0012;

        #STEP;

        branch = 1'b0;

        for (i = 0; i < 3; i = i + 1) begin
            #(STEP);
        end

        $finish;
    end

    always @(posedge clk) begin
        $display("-------------------------------------------------------------");
        $display("next_addr: %h, fetch_inst: %h, v_o=%b", next_addr, inst_o, v_o);
    end
endmodule
`timescale 1ns/100ps

module test_mem();
    parameter STEP = 10;
    `include "../include/params.v"

    integer i;

    reg clk, reset;
    reg [ADDR -1: 0] mem_addr;
    reg mem_write;
    reg [WORD -1: 0] mem_in;
    wire [WORD -1: 0] mem_out;

    DP_mem32x64k mem_read(
        .clk(clk),
        .A(mem_addr),
        .W(mem_write),
        .D(mem_in),
        .Q(mem_out)
    );

    always begin
        #(STEP/2) clk = ~clk;
    end

    initial begin
        clk = 1'b0;
        reset = 1'b0;

        #(STEP*2) reset = 1'b1;

        mem_addr = 16'h0000;
        mem_write = 1'b0;
        mem_in = 32'h00000000;
        
        for (i = 0; i < 10; i = i + 1) begin
            #(STEP) mem_addr = mem_addr + 1;
        end

        $finish;
    end

    always @(posedge clk) begin
        $display("-------------------------------------------------------------");
        $display("mem_out: %h", mem_out);
    end
endmodule
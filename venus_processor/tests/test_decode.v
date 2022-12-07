`timescale 1ns/100ps

module test_decode();
    parameter STEP = 10;
    `include "../include/params.v"

    integer i;

    wire v_wire1;
    wire stall_wire1;
    wire v_o;
    reg stall_i;
    wire stall_o;
    wire [WORD -1: 0] inst_i;
    wire [WORD -1: 0] inst_o;
    wire [ADDR -1: 0] mem_o;
    reg branch;
    reg [ADDR -1: 0] branch_addr;

    wire [W_OPC -1: 0] opecode_o;
    wire [W_OPR -1: 0] opr0_o, opr1_o;
    reg wb_i;
    reg [W_RD -1: 0] wb_r_i;
    reg [W_OPR -1: 0] result_i;
    wire [W_RD -1: 0] wb_r_o;

    wire w_reserve;
    wire [W_RD -1: 0] r0, r1;
    wire [W_OPR -1: 0] r_opr0, r_opr1;
    wire reserved;
    wire [ADDR -1:0] pc_wire1;
    wire [ADDR -1:0] pc_o;

    reg clk, reset;
    reg mem_write;
    reg mem_in;

    decode_instruction decode(
        .clk(clk),
        .reset(reset),
        .v_i(v_wire1),
        .v_o(v_o),
        .stall_i(stall_i),
        .stall_o(stall_wire1),
        .inst_i(inst_o),
        .w_reserve_o(w_reserve),
        .r0_o(r0),
        .r1_o(r1),
        .r_opr0_i(r_opr0),
        .r_opr1_i(r_opr1),
        .reserved_i(reserved),
        .opecode_o(opecode_o),
        .opr0_o(opr0_o),
        .opr1_o(opr1_o),
        .wb_r_o(wb_r_o),
        .pc_i(pc_wire1),
        .pc_o(pc_o)
    );

    g_reg_x16 register(
        .clk(clk),
        .reset(reset),
        .w_reserve_i(w_reserve),
        .r0_i(r0),
        .r1_i(r1),
        .r_opr0_o(r_opr0),
        .r_opr1_o(r_opr1),
        .reserved_o(reserved),
        .wb_i(wb_i),
        .wb_r_i(wb_r_i),
        .result_i(result_i)
    );

    fetch_instruction fetch(
        .clk(clk),
        .reset(reset),
        .v_o(v_wire1),
        .stall_i(stall_wire1),
        .stall_o(stall_o),
        .inst_i(inst_i),
        .inst_o(inst_o),
        .mem_o(mem_o),
        .pc_o(pc_wire1),
        .branch(branch),
        .branch_addr(branch_addr)
    );

    test_decode_mem mem_read(
        .clk(clk),
        .A(mem_o),
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
        
        #(STEP);
        #(STEP);
        #(STEP);
        #(STEP);
        stall_i = 1'b1;
        #(STEP);
        #(STEP);
        stall_i = 1'b0;
        #(STEP);
        #(STEP);
        #(STEP);
        #(STEP);
        wb_i = 1'b1;
        wb_r_i = 4'h2;
        result_i = 32'h89abcdef;
        #(STEP);
        #(STEP);
        #(STEP);

        $finish;
    end

    always @(posedge clk) begin
        $display("-------------------------------------------------------------");
        $display("mem_o=%h, pc_o=%h, inst_o=%h, v_o=%b, stall_o=%b", mem_o, pc_wire1, inst_o, v_wire1, stall_o);
        $display("pc_o=%h, opc=%d, opr0=%h, opr1=%h, wb_r=%h, v_o=%b, stall_o=%b, stall_i=%b", pc_o, opecode_o, opr0_o, opr1_o, wb_r_o, v_o, stall_wire1, stall_i);
    end
endmodule
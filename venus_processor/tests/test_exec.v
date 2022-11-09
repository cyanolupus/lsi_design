`timescale 1ns/100ps

module test_decode();
    parameter STEP = 10;
    `include "./include/params.v"

    integer i;

    // general
    reg clk, reset;
    reg stall_i;
    reg mem_write;
    reg mem_in;
    wire stall_o;
    wire v_o;
    wire [ADDR -1:0] pc_o;
    wire branch_wire;
    wire [ADDR -1: 0] branch_addr_wire;

    // fetch - memory
    wire [WORD -1: 0] inst_mf;
    wire [ADDR -1: 0] addr_fm;

    // fetch - decode
    wire v_fd;
    wire stall_df;
    wire [WORD -1: 0] inst_fd;
    wire [ADDR -1:0] pc_fd;

    // decode - register
    wire w_reserve_dr;
    wire [W_RD -1: 0] r0_dr, r1_dr;
    wire [W_OPR -1: 0] r_opr0_rd, r_opr1_rd;
    wire reserved_rd;

    // decode - execute
    wire v_de;
    wire stall_ed;
    wire [W_OPC -1: 0] opecode_de;
    wire [W_OPR -1: 0] opr0_de, opr1_de;
    wire wb_de;
    wire [W_RD -1: 0] wb_r_de;
    wire [ADDR -1:0] pc_de;
    wire [W_IMM -1:0] imm_de;

    // execute - memory
    wire [ADDR -1:0] ldst_addr_em;
    wire [W_OPR -1:0] ldst_data_mem_em, ldst_data_mem_me;
    wire ldst_write_em;

    // execute - writeback
    wire wb_ew;
    wire [W_RD -1: 0] wb_r_ew;
    wire [W_OPR -1: 0] result_ew;

    // writeback - register
    reg wb_i;
    reg [W_RD -1: 0] wb_r_i;
    reg [W_OPR -1: 0] result_i;

// module execute_instruction (clk, reset,
//                 v_i, v_o,
//                 stall_i, stall_o,
//                 pc_i, imm_i,
//                 opecode_i, opr0_i, opr1_i,
//                 wb_i, wb_r_i,
//                 ldst_addr_o, ldst_write_o, 
//                 ldst_data_i, ldst_data_o,
//                 result_o, wb_r_o, wb_o,
//                 branch_o, branch_addr_o);

    execute_instruction exec(
        .clk(clk),
        .reset(reset),
        .v_i(v_de),
        .v_o(v_o),
        .stall_i(stall_i),
        .stall_o(stall_ed),
        .pc_i(pc_de),
        .imm_i(imm_de),
        .opecode_i(opecode_de),
        .opr0_i(opr0_de),
        .opr1_i(opr1_de),
        .wb_i(wb_de),
        .wb_r_i(wb_r_de),
        .ldst_addr_o(ldst_addr_em),
        .ldst_write_o(ldst_write_em),
        .ldst_data_i(ldst_data_mem_me),
        .ldst_data_o(ldst_data_mem_em),
        .result_o(result_ew),
        .wb_r_o(wb_r_ew),
        .wb_o(wb_ew),
        .branch_o(branch_wire),
        .branch_addr_o(branch_addr_wire)
    );

    mem_data mem_rw (
        .clk(clk), .reset(reset),
        .A(ldst_addr_em), .W(ldst_write_em),
        .D(ldst_data_mem_em), .Q(ldst_data_mem_me),
    );

    decode_instruction decode(
        .clk(clk), .reset(reset),
        .v_i(v_fd), .v_o(v_de),
        .stall_i(stall_ed), .stall_o(stall_df),
        .inst_i(inst_fd),
        .pc_i(pc_fd), .pc_o(pc_de),
        .w_reserve_o(w_reserve_dr),
        .r0_o(r0_dr), .r1_o(r1_dr),
        .r_opr0_i(r_opr0_rd), .r_opr1_i(r_opr1_rd),
        .imm_o(imm_de), .reserved_i(reserved_rd),
        .opecode_o(opecode_de), .opr0_o(opr0_de), .opr1_o(opr1_de),
        .wb_o(wb_de), .wb_r_o(wb_r_de), .branch_i(branch_wire)
    );

    g_reg_x16 register(
        .clk(clk), .reset(reset),
        .w_reserve_i(w_reserve_dr),
        .r0_i(r0_dr), .r1_i(r1_dr),
        .r_opr0_o(r_opr0_rd), .r_opr1_o(r_opr1_rd),
        .reserved_o(reserved_rd),
        .wb_i(wb_i), .wb_r_i(wb_r_i),
        .result_i(result_i)
    );

    fetch_instruction fetch(
        .clk(clk), .reset(reset),
        .v_o(v_fd),
        .stall_i(stall_df), .stall_o(stall_o),
        .inst_i(inst_mf), .inst_o(inst_fd),
        .mem_o(addr_fm), .pc_o(pc_fd),
        .branch(branch_wire), .branch_addr(branch_addr_wire)
    );

    test_decode_mem mem_read(
        .clk(clk), .reset(reset),
        .A(addr_fm), .W(mem_write),
        .D(mem_in), .Q(inst_mf)
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
        $display("mem_o=%h, pc_o=%h, inst_o=%h, v_o=%b, stall_o=%b", mem_o, pc_fd, inst_o, v_fd, stall_o);
        $display("pc_o=%h, opc=%d, opr0=%h, opr1=%h, wb_r=%h, v_o=%b, stall_o=%b, stall_i=%b", pc_o, opecode_o, opr0_o, opr1_o, wb_r_o, v_o, stall_df, stall_i);
    end
endmodule
`timescale 1ns/100ps

module test_exec();
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

    // execute - register
    wire v_er;
    wire stall_re;
    wire wb_er;
    wire [W_RD -1: 0] wb_r_er;
    wire [W_OPR -1: 0] result_er;

    execute_instruction exec(
        .clk(clk), .reset(reset),
        .v_i(v_de), .v_o(v_er),
        .stall_i(stall_i), .stall_o(stall_ed),
        .pc_i(pc_de), .imm_i(imm_de),
        .opecode_i(opecode_de), .opr0_i(opr0_de), .opr1_i(opr1_de),
        .wb_i(wb_de), .wb_r_i(wb_r_de),
        .ldst_addr_o(ldst_addr_em), .ldst_write_o(ldst_write_em),
        .ldst_data_i(ldst_data_mem_me), .ldst_data_o(ldst_data_mem_em),
        .result_o(result_er), .wb_r_o(wb_r_er), .wb_o(wb_er),
        .branch_o(branch_wire), .branch_addr_o(branch_addr_wire)
    );

    mem_data mem_rw (
        .clk(clk),
        .A(ldst_addr_em), .W(ldst_write_em),
        .D(ldst_data_mem_em), .Q(ldst_data_mem_me)
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
        .wb_i(wb_er), .wb_r_i(wb_r_er),
        .result_i(result_er)
    );

    fetch_instruction fetch(
        .clk(clk), .reset(reset),
        .v_o(v_fd),
        .stall_i(stall_df), .stall_o(stall_o),
        .inst_i(inst_mf), .inst_o(inst_fd),
        .mem_o(addr_fm), .pc_o(pc_fd),
        .branch_i(branch_wire), .branch_addr_i(branch_addr_wire)
    );

    mem_instruction mem_read(
        .clk(clk),
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
        stall_i = 1'b0;

        #(STEP) reset = 1'b1;
        
        #(STEP);
        #(STEP);
        #(STEP);
        #(STEP);
        #(STEP);
        #(STEP);
        #(STEP);
        #(STEP);
        #(STEP);
        #(STEP);
        #(STEP);
        #(STEP);
        #(STEP);

        $finish;
    end

    always @(posedge clk) begin
        $display("-------------------------------------------------------------");
        $display("[  fetch] v=%b inst=%h, pc=%h, stall=%b", v_fd, inst_fd, pc_fd, stall_o);
        $display("[ decode] v=%b opc=%h, opr0=%h, opr1=%h, pc=%h, stall=%b", v_de, opecode_de, opr0_de, opr1_de, pc_de, stall_df);
        $display("[execute] v=%b result=%h, wb=%b, wb_r=%h, stall=%b", v_er, result_er, wb_er, wb_r_er, stall_ed);
    end
endmodule
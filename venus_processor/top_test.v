`timescale 1ns/100ps

module top_test();
    `include "../include/params.v"
    `include "../include/encode_inst.v"
    parameter STEP = 10;
    integer i;

    reg clk, reset;
    reg stall_i;
    reg inst_write;
    reg [WORD -1:0] inst_in;

    wire hlt_o;

    // top - mem_inst
    wire [WORD -1:0] inst_mt;
    wire [ADDR -1:0] inst_addr_tm;

    // top - mem_rw
    wire [ADDR -1:0] ldst_addr_tm;
    wire [W_OPR -1:0] ldst_data_tm, ldst_data_mt;
    wire ldst_write_tm;

    top top(
        .clk(clk), .reset(reset),
        .stall_i(stall_i),
        .inst_i(inst_mt), .inst_addr_o(inst_addr_tm),
        .ldst_data_i(ldst_data_mt), .ldst_data_o(ldst_data_tm),
        .ldst_addr_o(ldst_addr_tm), .ldst_write_o(ldst_write_tm),
        .hlt_o(hlt_o)
    );

    mem_instruction mem_read(
        .clk(clk),
        .A(inst_addr_tm), .W(inst_write),
        .D(inst_in), .Q(inst_mt)
    );

    mem_data mem_rw (
        .clk(clk),
        .A(ldst_addr_tm), .W(ldst_write_tm),
        .D(ldst_data_tm), .Q(ldst_data_mt)
    );

    always begin
        #(STEP/2) clk = ~clk;
    end

    initial begin
        $display("|--------------------------------------------------------------------|");
        $display("|pc_p,st|pc_f,st| pc_d|OPC|      opr0|      opr1|  imm|    result|reg|");
        clk = 1'b0;
        reset = 1'b0;
        inst_write = 1'b0;
        inst_in = 32'h00000000;
        stall_i = 1'b0;

        #(STEP) reset = 1'b1;
        
        while (1) begin
            #STEP;
        end

        for (i = 0; i < 100; i = i + 1) begin
            #STEP;
        end
        $finish;
    end

    always @(posedge clk) begin
        if (top.v_de) begin
            $display("|-------|-------|-----|---|----------|----------|-----|----------|---|");
            $write("|%d,%b", top.pc_pf, top.stall_fp);
            $write("|%d,%b", top.pc_fd, top.stall_df);
            $write("|%d|", top.pc_de);
            encode_inst(top.d_info_de);
            $write("|%d|%d|%d|", top.opr0_de, top.opr1_de, top.imm_de);
            if (top.d_info_de[WRSV]) begin
                $write("%d| r%h|", top.exec.selected_result, top.wb_r_de);
            end else if (top.d_info_de[BRF] & top.branch_wire) begin
                $write("         o|   |");
            end else if (top.d_info_de[BRF]) begin
                $write("         x|   |");
            end else begin
                $write("          |   |");
            end

            $display("");
        end else begin
            $display("|-------|-------|-----|---|----------|----------|-----|----------|---|");
            $write("|%d,%b", top.pc_pf, top.stall_fp);
            $write("|%d,%b", top.pc_fd, top.stall_df);
            $write("|%d|   ", top.pc_de);
            $write("|          |          |     |          |   |");
            $display("");
        end

        if (hlt_o) begin
            $display("|----------------------------------dump---------------------------------|");
            $display("|      r0|      r1|      r2|      r3|      r4|      r5|      r6|      r7|");
            $display("|--------|--------|--------|--------|--------|--------|--------|--------|");
            $display("|%h|%h|%h|%h|%h|%h|%h|%h|", top.register.data1, top.register.data2, top.register.data3, top.register.data4, top.register.data5, top.register.data6, top.register.data7, top.register.data8);
            $display("|-----------------------------------------------------------------------|");
            $display("|      r8|      r9|      ra|      rb|      rc|      rd|      re|      rf|");
            $display("|--------|--------|--------|--------|--------|--------|--------|--------|");
            $display("|%h|%h|%h|%h|%h|%h|%h|%h|", top.register.data9, top.register.data10, top.register.data11, top.register.data12, top.register.data13, top.register.data14, top.register.data15, top.register.data16);
            $display("|-----------------------------------------------------------------------|");
            $display("|  mem[0]|  mem[1]|  mem[2]|  mem[3]|  mem[4]|  mem[5]|  mem[6]|  mem[7]|");
            $display("|--------|--------|--------|--------|--------|--------|--------|--------|");
            $display("|%h|%h|%h|%h|%h|%h|%h|%h|", mem_rw.mem_bank[0], mem_rw.mem_bank[1], mem_rw.mem_bank[2], mem_rw.mem_bank[3], mem_rw.mem_bank[4], mem_rw.mem_bank[5], mem_rw.mem_bank[6], mem_rw.mem_bank[7]);
            $display("|-----------------------------------------------------------------------|");
            $display("|  mem[8]|  mem[9]|  mem[a]|  mem[b]|  mem[c]|  mem[d]|  mem[e]|  mem[f]|");
            $display("|--------|--------|--------|--------|--------|--------|--------|--------|");
            $display("|%h|%h|%h|%h|%h|%h|%h|%h|", mem_rw.mem_bank[8], mem_rw.mem_bank[9], mem_rw.mem_bank[10], mem_rw.mem_bank[11], mem_rw.mem_bank[12], mem_rw.mem_bank[13], mem_rw.mem_bank[14], mem_rw.mem_bank[15]);
            $display("|-----------------------------------------------------------------------|");
            $finish;
        end

        $writememh("./result.dat", mem_rw.mem_bank, 0, 255);
    end
endmodule
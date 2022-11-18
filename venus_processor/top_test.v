`timescale 1ns/100ps

module top_test();
    `include "./include/params.v"
    `include "./include/encode_inst.v"
    parameter STEP = 10;
    integer i;

    reg clk, reset;
    reg stall_i;
    reg mem_write;
    reg [WORD -1:0] mem_in;

    top top(
        .clk(clk), .reset(reset),
        .stall_i(stall_i),
        .mem_write(mem_write), .mem_in(mem_in)
    );

    always begin
        #(STEP/2) clk = ~clk;
    end

    initial begin
        $display("  pc:OPC       opr0       opr1   imm       result");
        clk = 1'b0;
        reset = 1'b0;
        mem_write = 1'b0;
        mem_in = 32'h00000000;
        stall_i = 1'b0;

        #(STEP) reset = 1'b1;
        
        while (1) begin
            #STEP;
        end
        $finish;
    end

    always @(posedge clk) begin
        if (top.v_de) begin
            $write("%h:", top.pc_de);
            encode_inst(top.d_info_de);
            $write(" %d %d %d", top.opr0_de, top.opr1_de, top.imm_de);
            if (top.d_info_de[WRSV]) begin
                $write(" = %d", top.exec.selected_result);
            end else begin
                $write("             ");
            end
            $display("");
        end

        if (top.d_info_de[HLTF] & top.v_de) begin
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
            $display("|%h|%h|%h|%h|%h|%h|%h|%h|", top.mem_rw.mem_bank[0], top.mem_rw.mem_bank[1], top.mem_rw.mem_bank[2], top.mem_rw.mem_bank[3], top.mem_rw.mem_bank[4], top.mem_rw.mem_bank[5], top.mem_rw.mem_bank[6], top.mem_rw.mem_bank[7]);
            $display("|-----------------------------------------------------------------------|");
            $display("|  mem[8]|  mem[9]|  mem[a]|  mem[b]|  mem[c]|  mem[d]|  mem[e]|  mem[f]|");
            $display("|--------|--------|--------|--------|--------|--------|--------|--------|");
            $display("|%h|%h|%h|%h|%h|%h|%h|%h|", top.mem_rw.mem_bank[8], top.mem_rw.mem_bank[9], top.mem_rw.mem_bank[10], top.mem_rw.mem_bank[11], top.mem_rw.mem_bank[12], top.mem_rw.mem_bank[13], top.mem_rw.mem_bank[14], top.mem_rw.mem_bank[15]);
            $display("|-----------------------------------------------------------------------|");
        end

        $writememh("./result.dat", top.mem_rw.mem_bank, 0, 255);
    end
endmodule
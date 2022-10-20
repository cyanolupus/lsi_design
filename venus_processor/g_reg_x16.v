module g_reg_x16(clk, reset,
                    w_reserve_i,
                    r0_i,
                    r1_i,
                    r_opr0_o,
                    r_opr1_o,
                    reserved_o,
                    wb_i,
                    wb_r_i,
                    result_i);

    `include "./include/params.v"
    `include "./include/decode4to16.v"
    `include "./include/select4from16.v"

    input clk, reset;
    input w_reserve_i;
    input [W_RD -1: 0] r0_i;
    input [W_RD -1: 0] r1_i;
    output [W_OPR -1: 0] r_opr0_o;
    output [W_OPR -1: 0] r_opr1_o;
    output reserved_o;

    input wb_i;
    input [W_RD -1: 0] wb_r_i;
    input [W_OPR -1: 0] result_i;

    wire [REG_S -1: 0] w_reserve;
    wire [REG_S -1: 0] w_reserved;
    wire [REG_S -1: 0] wb_r;

    wire [W_OPR -1: 0] data1, data2, data3, data4;
    wire [W_OPR -1: 0] data5, data6, data7, data8;
    wire [W_OPR -1: 0] data9, data10, data11, data12;
    wire [W_OPR -1: 0] data13, data14, data15, data16;

    wire [REG_S -1: 0] opr_req0;
    wire [REG_S -1: 0] opr_req1;

    assign opr_req0 = decode4to16(r0_i);
    assign opr_req1 = decode4to16(r1_i);

    assign w_reserve = opr_req0 & {16{w_reserve_i}};
    assign wb_r = decode4to16(wb_r_i) & {16{wb_i}};

    g_reg_cell reg0(clk, reset, result_i, data1, w_reserve[0], w_reserved[0], wb_r[0]);
    g_reg_cell reg1(clk, reset, result_i, data2, w_reserve[1], w_reserved[1], wb_r[1]);
    g_reg_cell reg2(clk, reset, result_i, data3, w_reserve[2], w_reserved[2], wb_r[2]);
    g_reg_cell reg3(clk, reset, result_i, data4, w_reserve[3], w_reserved[3], wb_r[3]);
    g_reg_cell reg4(clk, reset, result_i, data5, w_reserve[4], w_reserved[4], wb_r[4]);
    g_reg_cell reg5(clk, reset, result_i, data6, w_reserve[5], w_reserved[5], wb_r[5]);
    g_reg_cell reg6(clk, reset, result_i, data7, w_reserve[6], w_reserved[6], wb_r[6]);
    g_reg_cell reg7(clk, reset, result_i, data8, w_reserve[7], w_reserved[7], wb_r[7]);
    g_reg_cell reg8(clk, reset, result_i, data9, w_reserve[8], w_reserved[8], wb_r[8]);
    g_reg_cell reg9(clk, reset, result_i, data10, w_reserve[9], w_reserved[9], wb_r[9]);
    g_reg_cell reg10(clk, reset, result_i, data11, w_reserve[10], w_reserved[10], wb_r[10]);
    g_reg_cell reg11(clk, reset, result_i, data12, w_reserve[11], w_reserved[11], wb_r[11]);
    g_reg_cell reg12(clk, reset, result_i, data13, w_reserve[12], w_reserved[12], wb_r[12]);
    g_reg_cell reg13(clk, reset, result_i, data14, w_reserve[13], w_reserved[13], wb_r[13]);
    g_reg_cell reg14(clk, reset, result_i, data15, w_reserve[14], w_reserved[14], wb_r[14]);
    g_reg_cell reg15(clk, reset, result_i, data16, w_reserve[15], w_reserved[15], wb_r[15]);

    assign reserved_o = (opr_req0 | opr_req1) & w_reserved;

    assign r_opr0_o = select4from16(opr_req0, data1, data2, data3, data4,
                                    data5, data6, data7, data8,
                                    data9, data10, data11, data12,
                                    data13, data14, data15, data16);
    assign r_opr1_o = select4from16(opr_req1, data1, data2, data3, data4,
                                    data5, data6, data7, data8,
                                    data9, data10, data11, data12,
                                    data13, data14, data15, data16);
endmodule
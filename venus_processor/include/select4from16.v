function [W_OPR -1: 0] select4from16;
      input [W_RD -1: 0] select;

      input [W_OPR -1: 0] data0, data1, data2, data3;
      input [W_OPR -1: 0] data4, data5, data6, data7;
      input [W_OPR -1: 0] data8, data9, dataa, datab;
      input [W_OPR -1: 0] datac, datad, datae, dataf;
      
      case (select)
        4'b0000: select4from16 = data0;
        4'b0001: select4from16 = data1;
        4'b0010: select4from16 = data2;
        4'b0011: select4from16 = data3;
        4'b0100: select4from16 = data4;
        4'b0101: select4from16 = data5;
        4'b0110: select4from16 = data6;
        4'b0111: select4from16 = data7;
        4'b1000: select4from16 = data8;
        4'b1001: select4from16 = data9;
        4'b1010: select4from16 = dataa;
        4'b1011: select4from16 = datab;
        4'b1100: select4from16 = datac;
        4'b1101: select4from16 = datad;
        4'b1110: select4from16 = datae;
        4'b1111: select4from16 = dataf;
      endcase
endfunction
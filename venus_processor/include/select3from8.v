function [W_OPR -1: 0] select3from8;
    input [W_RD -1: 0] select;

    input [W_OPR -1: 0] data0, data1, data2, data3;
    input [W_OPR -1: 0] data4, data5, data6, data7;
      
    case (select)
        3'b000: select3from8 = data0;
        3'b001: select3from8 = data1;
        3'b010: select3from8 = data2;
        3'b011: select3from8 = data3;
        3'b100: select3from8 = data4;
        3'b101: select3from8 = data5;
        3'b110: select3from8 = data6;
        3'b111: select3from8 = data7;
    endcase
endfunction
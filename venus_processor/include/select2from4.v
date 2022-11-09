function [W_OPR -1: 0] select2from4;
    input [1:0] select;

    input [W_OPR -1: 0] data0, data1, data2, data3;
      
    case (select)
        2'b00: select2from4 = data0;
        2'b01: select2from4 = data1;
        2'b10: select2from4 = data2;
        2'b11: select2from4 = data3;
    endcase
endfunction
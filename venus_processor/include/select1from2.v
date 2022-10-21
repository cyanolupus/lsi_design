function [W_OPR -1: 0] select1from2;
    input select;

    input [W_OPR -1: 0] data0, data1;
    
    case (select)
        1'b0: select1from2 = data0;
        1'b1: select1from2 = data1;
    endcase
endfunction
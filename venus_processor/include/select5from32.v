function [W_OPR -1:0] select5from32;
    input [W_OPC - 3:0] select;
    input [W_OPR - 1:0] result0, result1, result2, result3, result4, result5; // ADDx, SUBx, MULx, DIVx, (CMPx), ABSx
    input [W_OPR - 1:0] result6, result7, result8, result9, result10, result11; // ADCx, SBCx, SHLx, SHRx, ASHx, none
    input [W_OPR - 1:0] result12, result13, result14, result15, result16, result17; // ROLx, RORx, none, none, AND, OR
    input [W_OPR - 1:0] result18, result19, result20, result21, result22, result23; // NOT, XOR, none, none, SETL, SETH
    input [W_OPR - 1:0] result24, result25, result26, result27, result28, result29; // LD, ST, none, none, J, JA
    input [W_OPR - 1:0] result30, result31; // NOP, HLT

    case (select)
        5'b0_0000: select5from32 = result0;
        5'b0_0001: select5from32 = result1;
        5'b0_0010: select5from32 = result2;
        5'b0_0011: select5from32 = result3;
        5'b0_0100: select5from32 = result4;
        5'b0_0101: select5from32 = result5;
        5'b0_0110: select5from32 = result6;
        5'b0_0111: select5from32 = result7;
        5'b0_1000: select5from32 = result8;
        5'b0_1001: select5from32 = result9;
        5'b0_1010: select5from32 = result10;
        5'b0_1011: select5from32 = result11;
        5'b0_1100: select5from32 = result12;
        5'b0_1101: select5from32 = result13;
        5'b0_1110: select5from32 = result14;
        5'b0_1111: select5from32 = result15;
        5'b1_0000: select5from32 = result16;
        5'b1_0001: select5from32 = result17;
        5'b1_0010: select5from32 = result18;
        5'b1_0011: select5from32 = result19;
        5'b1_0100: select5from32 = result20;
        5'b1_0101: select5from32 = result21;
        5'b1_0110: select5from32 = result22;
        5'b1_0111: select5from32 = result23;
        5'b1_1000: select5from32 = result24;
        5'b1_1001: select5from32 = result25;
        5'b1_1010: select5from32 = result26;
        5'b1_1011: select5from32 = result27;
        5'b1_1100: select5from32 = result28;
        5'b1_1101: select5from32 = result29;
        5'b1_1110: select5from32 = result30;
        5'b1_1111: select5from32 = result31;
    endcase
endfunction
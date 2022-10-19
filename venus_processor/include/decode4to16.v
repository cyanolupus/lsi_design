function [15:0] decode4to16;
      input [3:0] d;
      case (d)
        4'b0000: decode4to16 = 16'b0000000000000001;
        4'b0001: decode4to16 = 16'b0000000000000010;
        4'b0010: decode4to16 = 16'b0000000000000100;
        4'b0011: decode4to16 = 16'b0000000000001000;
        4'b0100: decode4to16 = 16'b0000000000010000;
        4'b0101: decode4to16 = 16'b0000000000100000;
        4'b0110: decode4to16 = 16'b0000000001000000;
        4'b0111: decode4to16 = 16'b0000000010000000;
        4'b1000: decode4to16 = 16'b0000000100000000;
        4'b1001: decode4to16 = 16'b0000001000000000;
        4'b1010: decode4to16 = 16'b0000010000000000;
        4'b1011: decode4to16 = 16'b0000100000000000;
        4'b1100: decode4to16 = 16'b0001000000000000;
        4'b1101: decode4to16 = 16'b0010000000000000;
        4'b1110: decode4to16 = 16'b0100000000000000;
        4'b1111: decode4to16 = 16'b1000000000000000;
      endcase
endfunction
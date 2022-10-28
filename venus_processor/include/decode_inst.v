function [D_INFO -1:0] decode_inst;
      input [W_OPC + IMMF - 1:0] d;
      // {immf, signed, w_reserve, sum}
      case (d[W_OPC + IMMF - 1:IMMF])
        7'b000_0000: decode_inst = {d[0],1'b1,1'b1,1'b0}; // ADDx
        7'b000_0001: decode_inst = {d[0],1'b1,1'b1,1'b0}; // SUBx
        7'b000_0010: decode_inst = {d[0],1'b1,1'b1,1'b0}; // MULx
        7'b000_0011: decode_inst = {d[0],1'b1,1'b1,1'b0}; // DIVx
        7'b000_0100: decode_inst = {d[0],1'b1,1'b0,1'b0}; // CMPx
        7'b000_0101: decode_inst = {d[0],1'b1,1'b1,1'b0}; // ABSx
        7'b000_0110: decode_inst = {d[0],1'b1,1'b1,1'b0}; // ADCx
        7'b000_0111: decode_inst = {d[0],1'b1,1'b1,1'b0}; // SBCx

        7'b000_1000: decode_inst = {d[0],1'b0,1'b1,1'b0}; // SHLx
        7'b000_1001: decode_inst = {d[0],1'b0,1'b1,1'b0}; // SHRx
        7'b000_1010: decode_inst = {d[0],1'b0,1'b1,1'b0}; // ASHx
        
        7'b000_1100: decode_inst = {d[0],1'b0,1'b1,1'b0}; // ROLx
        7'b000_1101: decode_inst = {d[0],1'b0,1'b1,1'b0}; // RORx

        7'b001_0000: decode_inst = {1'b0,1'b0,1'b1,1'b0}; // AND
        7'b001_0001: decode_inst = {1'b0,1'b0,1'b1,1'b0}; // OR
        7'b001_0010: decode_inst = {1'b0,1'b0,1'b1,1'b0}; // NOT
        7'b001_0011: decode_inst = {1'b0,1'b0,1'b1,1'b0}; // XOR

        7'b001_0110: decode_inst = {1'b0,1'b0,1'b1,1'b1}; // SETL
        7'b001_0111: decode_inst = {1'b0,1'b0,1'b1,1'b1}; // SETH

        7'b001_1000: decode_inst = {1,1'b1,1'b1,1'b0}; // LD
        7'b001_1001: decode_inst = {1,1'b1,1'b0,1'b0}; // ST

        7'b001_1100: decode_inst = {d[0],1'b1,1'b0,1'b0}; // J
        7'b001_1101: decode_inst = {d[0],1'b1,1'b0,1'b0}; // JA
        7'b001_1110: decode_inst = {1'b0,1'b0,1'b0,1'b0}; // NOP
        7'b001_1111: decode_inst = {1'b0,1'b0,1'b0,1'b0}; // HLT
      endcase
endfunction
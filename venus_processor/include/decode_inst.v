function [2:0] decode_inst;
      input [7:0] d;
      // {immf, signed, w_reserve}
      case (d)
        7'b000_0000: decode_inst = {d[7],1,1}; // ADDx
        7'b000_0001: decode_inst = {d[7],1,1}; // SUBx
        7'b000_0010: decode_inst = {d[7],1,1}; // MULx
        7'b000_0011: decode_inst = {d[7],1,1}; // DIVx
        7'b000_0100: decode_inst = {d[7],1,0}; // CMPx
        7'b000_0101: decode_inst = {d[7],1,1}; // ABSx
        7'b000_0110: decode_inst = {d[7],1,1}; // ADCx
        7'b000_0111: decode_inst = {d[7],1,1}; // SBCx

        7'b000_1000: decode_inst = {d[7],0,1}; // SHLx
        7'b000_1001: decode_inst = {d[7],0,1}; // SHRx
        7'b000_1010: decode_inst = {d[7],0,1}; // ASHx
        
        7'b000_1100: decode_inst = {d[7],0,1}; // ROLx
        7'b000_1101: decode_inst = {d[7],0,1}; // RORx

        7'b001_0000: decode_inst = {0,0,1}; // AND
        7'b001_0001: decode_inst = {0,0,1}; // OR
        7'b001_0010: decode_inst = {0,0,1}; // NOT
        7'b001_0011: decode_inst = {0,0,1}; // XOR

        7'b001_0110: decode_inst = {0,0,1}; // SETL
        7'b001_0111: decode_inst = {0,0,1}; // SETH

        7'b001_1000: decode_inst = {1,1,1}; // LD
        7'b001_1001: decode_inst = {1,1,0}; // ST

        7'b001_1100: decode_inst = {d[7],1,0}; // J
        7'b001_1101: decode_inst = {d[7],1,0}; // JA
        7'b001_1110: decode_inst = {0,0,0}; // NOP
        7'b001_1111: decode_inst = {0,0,0}; // HLT
      endcase
endfunction
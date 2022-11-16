function [D_INFO -1:0] decode_inst;
      input [W_OPC + IMMF - 1:0] d;
      // {executor, immf, signed, w_reserve, stf}
      case (d[W_OPC + IMMF - 1:IMMF])
        7'b000_0000: decode_inst = {d[0],1'b1,1'b1,1'b0}; // ADDx impl o
        7'b000_0001: decode_inst = {d[0],1'b1,1'b1,1'b0}; // SUBx impl o
        7'b000_0010: decode_inst = {d[0],1'b1,1'b1,1'b0}; // MULx impl o
        7'b000_0011: decode_inst = {d[0],1'b1,1'b1,1'b0}; // DIVx impl o
        7'b000_0100: decode_inst = {d[0],1'b1,1'b0,1'b0}; // CMPx impl o
        7'b000_0101: decode_inst = {d[0],1'b1,1'b1,1'b0}; // ABSx impl o
        7'b000_0110: decode_inst = {d[0],1'b1,1'b1,1'b0}; // ADCx 
        7'b000_0111: decode_inst = {d[0],1'b1,1'b1,1'b0}; // SBCx

        7'b000_1000: decode_inst = {d[0],1'b0,1'b1,1'b0}; // SHLx impl o
        7'b000_1001: decode_inst = {d[0],1'b0,1'b1,1'b0}; // SHRx impl o
        7'b000_1010: decode_inst = {d[0],1'b0,1'b1,1'b0}; // ASHx impl o
        
        7'b000_1100: decode_inst = {d[0],1'b0,1'b1,1'b0}; // ROLx
        7'b000_1101: decode_inst = {d[0],1'b0,1'b1,1'b0}; // RORx

        7'b001_0000: decode_inst = {1'b0,1'b0,1'b1,1'b0}; // AND impl o
        7'b001_0001: decode_inst = {1'b0,1'b0,1'b1,1'b0}; // OR impl o
        7'b001_0010: decode_inst = {1'b0,1'b0,1'b1,1'b0}; // NOT impl o
        7'b001_0011: decode_inst = {1'b0,1'b0,1'b1,1'b0}; // XOR impl o

        7'b001_0110: decode_inst = {1'b0,1'b0,1'b1,1'b0}; // SETL impl o
        7'b001_0111: decode_inst = {1'b0,1'b0,1'b1,1'b0}; // SETH impl o

        7'b001_1000: decode_inst = {1'b1,1'b1,1'b1,1'b0}; // LD impl o
        7'b001_1001: decode_inst = {1'b1,1'b1,1'b0,1'b1}; // ST impl o

        7'b001_1100: decode_inst = {d[0],1'b1,1'b0,1'b0}; // J impl o
        7'b001_1101: decode_inst = {d[0],1'b1,1'b0,1'b0}; // JA impl o
        7'b001_1110: decode_inst = {1'b0,1'b0,1'b0,1'b0}; // NOP impl o
        7'b001_1111: decode_inst = {1'b0,1'b0,1'b0,1'b0}; // HLT impl o
        default: decode_inst = {1'b0,1'b0,1'b0,1'b0}; // NOP impl o
      endcase
endfunction
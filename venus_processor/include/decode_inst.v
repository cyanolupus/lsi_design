function [D_INFO -1:0] decode_inst;
      input [W_OPC :0] d;
      // {executor[3:0], select[1:0], hltf, brf, lstf, immf, signed, w_reserve}
      case (d[W_OPC :1])
        7'b000_0000:  decode_inst = {ADD,2'b00,3'b000,d[0],1'b1,1'b1}; // ADDx impl o
        7'b000_0001:  decode_inst = {ADD,2'b01,3'b000,d[0],1'b1,1'b1}; // SUBx impl o
        7'b000_0010:  decode_inst = {MUL,2'b00,3'b000,d[0],1'b1,1'b1}; // MULx impl o
        7'b000_0011:  decode_inst = {DIV,2'b00,3'b000,d[0],1'b1,1'b1}; // DIVx impl o
        7'b000_0100:  decode_inst = {CMP,2'b00,3'b000,d[0],1'b1,1'b0}; // CMPx impl o
        7'b000_0101:  decode_inst = {ABS,2'b00,3'b000,d[0],1'b1,1'b1}; // ABSx impl o
        7'b000_0110:  decode_inst = {ADC,2'b00,3'b000,d[0],1'b1,1'b1}; // ADCx impl o
        7'b000_0111:  decode_inst = {ADC,2'b01,3'b000,d[0],1'b1,1'b1}; // SBCx impl o

        7'b000_1000:  decode_inst = {SHT,2'b00,3'b000,d[0],1'b0,1'b1}; // SHLx impl o
        7'b000_1001:  decode_inst = {SHT,2'b01,3'b000,d[0],1'b0,1'b1}; // SHRx impl o
        7'b000_1010:  decode_inst = {SHT,2'b10,3'b000,d[0],1'b0,1'b1}; // ASHx impl o
        
        7'b000_1100:  decode_inst = {ROT,2'b00,3'b000,d[0],1'b0,1'b1}; // ROLx impl o
        7'b000_1101:  decode_inst = {ROT,2'b01,3'b000,d[0],1'b0,1'b1}; // RORx impl o

        7'b001_0000:  decode_inst = {LGC,2'b00,3'b000,1'b0,1'b0,1'b1}; // AND impl o
        7'b001_0001:  decode_inst = {LGC,2'b01,3'b000,1'b0,1'b0,1'b1}; // OR impl o
        7'b001_0010:  decode_inst = {LGC,2'b10,3'b000,1'b0,1'b0,1'b1}; // NOT impl o
        7'b001_0011:  decode_inst = {LGC,2'b11,3'b000,1'b0,1'b0,1'b1}; // XOR impl o

        7'b001_0110:  decode_inst = {SET,2'b00,3'b000,1'b0,1'b0,1'b1}; // SETL impl o
        7'b001_0111:  decode_inst = {SET,2'b01,3'b000,1'b0,1'b0,1'b1}; // SETH impl o

        7'b001_1000:  decode_inst = {NOP,2'b00,3'b001,1'b1,1'b1,1'b1}; // LD impl o
        7'b001_1001:  decode_inst = {NOP,2'b01,3'b001,1'b1,1'b1,1'b0}; // ST impl o

        7'b001_1100:  decode_inst = {NOP,2'b00,3'b010,d[0],1'b1,1'b0}; // J impl o
        7'b001_1101:  decode_inst = {NOP,2'b01,3'b010,d[0],1'b1,1'b0}; // JA impl o
        7'b001_1110:  decode_inst = {NOP,2'b00,3'b000,1'b0,1'b0,1'b0}; // NOP impl o
        7'b001_1111:  decode_inst = {NOP,2'b00,3'b100,1'b0,1'b0,1'b0}; // HLT impl o
        default:      decode_inst = {NOP,2'b00,3'b000,1'b0,1'b0,1'b0};
      endcase
endfunction
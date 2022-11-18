// EXECUTOR
// parameter ADD = 4'b0000;
// parameter MUL = 4'b0001;
// parameter DIV = 4'b0010;
// parameter CMP = 4'b0011;
// parameter ABS = 4'b0100;
// parameter SHT = 4'b0110;
// parameter ROT = 4'b0111;
// parameter LGC = 4'b1000;
// parameter SET = 4'b1001;
// parameter NOP = 4'b1111;

task encode_inst;
    input [D_INFO -1: 0] d_info;

    if (d_info[HLTF]) begin
        $write("HLT");
    end else if (d_info[BRF]) begin
        $write("JMP");
    end else if (d_info[LSTF]) begin
        if (d_info[D_INFO - W_EXEC - W_SELECT]) begin
            $write("ST ");
        end else begin
            $write("LD ");
        end
    end else begin
        case (d_info[D_INFO -1:D_INFO - W_EXEC])
            ADD: $write("ADD");
            MUL: $write("MUL");
            DIV: $write("DIV");
            CMP: $write("CMP");
            ABS: $write("ABS");
            SHT: $write("SHT");
            ROT: $write("ROT");
            LGC: $write("LGC");
            SET: $write("SET");
            NOP: $write("NOP");
        endcase
    end
endtask
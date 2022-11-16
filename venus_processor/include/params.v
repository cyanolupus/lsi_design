parameter WORD = 32;
parameter ADDR = 16;
parameter LEN = 65535;

parameter W_OPR = 32;
parameter W_OPC = 7;
parameter W_RD = 4;
parameter W_IMM = 16;
parameter W_FLAGS = 4;
parameter W_CC = 3;

parameter REG_S = 16;

// DECODE INFO
parameter W_EXEC = 4;
parameter W_SELECT = 2;

parameter WRSV = 0;
parameter SIGN = 1;
parameter IMMF = 2;
parameter LSTF = 3;
parameter BRF = 4;
parameter HLTF = 5;

parameter D_INFO = 6 + W_EXEC + W_SELECT;

// EXECUTOR
parameter ADD = 4'b0000;
parameter MUL = 4'b0001;
parameter DIV = 4'b0010;
parameter CMP = 4'b0011;
parameter ABS = 4'b0100;
parameter ADC = 4'b0101;
parameter SHT = 4'b0110;
parameter ROT = 4'b0111;
parameter LGC = 4'b1000;
parameter SET = 4'b1001;
parameter NOP = 4'b1111;
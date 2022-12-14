parameter integer WORD = 32;
parameter integer ADDR = 16;
parameter integer LEN = 65535;

parameter integer W_OPR = 32;
parameter integer W_OPC = 7;
parameter integer W_RD = 4;
parameter integer W_IMM = 16;
parameter integer W_CC = 3;
parameter integer W_BRID = 2;

parameter integer BTB_S = 4;
parameter integer REG_S = 16;

// FLAGS
parameter integer W_FLAGS = 4;
parameter integer F_CRRY = 0;
parameter integer F_ZERO = 1;
parameter integer F_SIGN = 2;
parameter integer F_OVRF = 3;

// DECODE INFO
parameter integer W_EXEC = 4;
parameter integer W_SELECT = 3;

parameter integer WRSV = 0;
parameter integer SIGN = 1;
parameter integer IMMF = 2;
parameter integer LSTF = 3;
parameter integer BRF = 4;
parameter integer HLTF = 5;

parameter integer D_INFO = 6 + W_EXEC + W_SELECT;

// EXECUTOR
parameter integer ADD = 4'b0000;
parameter integer MUL = 4'b0001;
parameter integer DIV = 4'b0010;
parameter integer CMP = 4'b0011;
parameter integer ABS = 4'b0100;
parameter integer SHT = 4'b0110;
parameter integer ROT = 4'b0111;
parameter integer LGC = 4'b1000;
parameter integer SET = 4'b1001;
parameter integer NOP = 4'b1111;
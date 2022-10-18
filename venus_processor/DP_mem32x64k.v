module DP_mem32x64k(clk,
                    A,
                    W,
                    D,
                    Q
                    );
    parameter WORD = 32;
    parameter ADDR = 16;
    parameter LEN = 65535;

    input clk;
    input [ADDR -1: 0] A;
    input W;
    input [WORD -1: 0] D;
    output [WORD -1: 0] Q;

    reg [WORD -1: 0] mem_bank [0: LEN];

    reg [WORD -1: 0] o_reg;

    assign Q = o_reg;

    always @(posedge clk) begin // or negedge rst)
        if (W == 1'b1)
            mem_bank[A] <= D; // write
        else
            o_reg <= mem_bank[A]; //read
    end

    initial begin
        $readmemh("../memfiles/mem.dat", mem_bank);
    end
endmodule
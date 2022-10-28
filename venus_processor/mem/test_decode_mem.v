module test_decode_mem(clk,
                    A,
                    W,
                    D,
                    Q);

    `include "./include/params.v"

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
        $readmemh("./mem/memfiles/test_decode_mem.dat", mem_bank);
    end
endmodule
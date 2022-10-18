module fetch_instruction(clk, reset,
                stall_i, stall_o,
                inst_i, inst_o, next_addr,
                branch, branch_addr);

    parameter WORD = 32;
    parameter ADDR = 16;
    parameter LEN = 65535;

    input  clk, reset;
    input stall_i;
    output stall_o;

    input [WORD -1: 0] inst_i;
    output [WORD -1: 0] inst_o;

    output [ADDR -1: 0] next_addr;

    input branch;
    input [ADDR -1: 0] branch_addr;

    reg [WORD -1: 0] inst_r;
    reg [ADDR -1: 0] next_addr_r;

    wire [ADDR -1: 0] next_addr_succ;

    assign inst_o = inst_r;
    assign next_addr = next_addr_r;
    assign next_addr_succ = next_addr_r + 1;
    assign stall_o = stall_i;

    always @(posedge clk or negedge reset) begin
        if (~reset) begin
            inst_r <= 0;
            next_addr_r <= 0;
        end else begin
            if (~stall_i) begin
                if (branch) begin
                    inst_r <= inst_i;
                    next_addr_r <= branch_addr;
                end else begin
                    inst_r <= inst_i;
                    next_addr_r <= next_addr_succ;
                end
            end
        end
    end
endmodule
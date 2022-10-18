module fetch_instruction(clk, reset,
                v_o,
                stall_i, stall_o,
                inst_i, inst_o, next_addr,
                branch, branch_addr);

    parameter WORD = 32;
    parameter ADDR = 16;
    parameter LEN = 65535;

    input  clk, reset;
    output v_o;
    input stall_i;
    output stall_o;

    input [WORD -1: 0] inst_i;
    output [WORD -1: 0] inst_o;

    output [ADDR -1: 0] next_addr;

    input branch;
    input [ADDR -1: 0] branch_addr;

    reg v_r;
    reg [ADDR -1: 0] next_addr_r;

    wire [WORD -1: 0] inst_wire;
    wire [ADDR -1: 0] next_addr_succ;

    assign v_o = v_r;
    assign inst_o = inst_i;
    assign next_addr = next_addr_r;
    assign next_addr_succ = next_addr_r + 1;
    assign stall_o = stall_i;

    always @(posedge clk or negedge reset) begin
        if (~reset) begin
            next_addr_r <= 0;
            v_r <= 0;
        end else begin
            if (~stall_i) begin
                if (branch) begin
                    next_addr_r <= branch_addr;
                    v_r <= 0;
                end else begin
                    next_addr_r <= next_addr_succ;
                    v_r <= 1;
                end
            end
        end
    end
endmodule
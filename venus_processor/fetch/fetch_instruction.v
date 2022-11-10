module fetch_instruction(clk, reset,
                v_o,
                stall_i, stall_o,
                inst_i, inst_o, 
                mem_o, pc_o,
                branch_i, branch_addr_i);

    `include "./include/params.v"

    input  clk, reset;
    output v_o;
    input stall_i;
    output stall_o;

    input [WORD -1: 0] inst_i;
    output [WORD -1: 0] inst_o;

    output [ADDR -1: 0] mem_o;
    output [ADDR -1: 0] pc_o;

    input branch_i;
    input [ADDR -1: 0] branch_addr_i;

    reg v_r;
    reg [ADDR -1: 0] mem_r;
    reg [ADDR -1: 0] pc_r;
    reg [WORD -1: 0] inst_r;

    wire [ADDR -1: 0] mem_next;
    wire [ADDR -1: 0] mem_prev;
    wire [ADDR -1: 0] pc_prev;

    assign inst_o = stall_i?inst_r:inst_i;
    assign mem_next = branch_i?(branch_addr_i + 1):(mem_r + 1);
    assign mem_prev = mem_r - 1;
    assign pc_prev = pc_r - 1;
    assign mem_o = stall_i?mem_prev:(branch_i?branch_addr_i:mem_r);
    assign v_o = v_r;
    assign stall_o = stall_i & v_r;
    assign pc_o = stall_i?pc_prev:pc_r;

    always @(posedge clk or negedge reset) begin
        if (~reset) begin
            mem_r <= 0;
            v_r <= 0;
            pc_r <= 0;
            inst_r <= 0;
        end else begin
            if (~stall_i) begin
                pc_r <= mem_o;
                inst_r <= inst_i;
                mem_r <= mem_next;
                v_r <= 1;
            end
        end
    end
endmodule
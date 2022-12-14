module branch_target_buffer (
    clk, reset,
    v_i, v_o,
    delete_i,
    pred_id_i, branch_id_i,
    pc_i, branch_addr_i,
    pc_o, branch_addr_o);

    `include "../include/params.v"
    `include "../include/select2from4.v"

    input clk, reset;
    input v_i;
    output v_o;
    input delete_i;
    input [W_BRID -1: 0] pred_id_i;
    input [W_BRID -1: 0] branch_id_i;
    input [ADDR -1: 0] pc_i;
    input [ADDR -1: 0] branch_addr_i;
    output [ADDR -1: 0] pc_o;
    output [ADDR -1: 0] branch_addr_o;

    reg [ADDR + ADDR -1: 0] table0_r;
    reg [ADDR + ADDR -1: 0] table1_r;
    reg [ADDR + ADDR -1: 0] table2_r;
    reg [ADDR + ADDR -1: 0] table3_r;

    reg v0_r, v1_r, v2_r, v3_r;

    wire [ADDR + ADDR -1: 0] branch_table_select;

    assign branch_table_select = select2from4(branch_id_i, table0_r, table1_r, table2_r, table3_r);
    assign v_o = select2from4(branch_id_i, v0_r, v1_r, v2_r, v3_r);
    assign pc_o = branch_table_select[ADDR + ADDR -1: ADDR];
    assign branch_addr_o = branch_table_select[ADDR -1: 0];

    always @(posedge clk or negedge reset) begin
        if (~reset) begin
            table0_r <= 0;
            table1_r <= 0;
            table2_r <= 0;
            table3_r <= 0;
            v0_r <= 0;
            v1_r <= 0;
            v2_r <= 0;
            v3_r <= 0;
        end else begin
            if (v_i) begin
                case (pred_id_i)
                    2'b00: begin
                        table0_r <= {pc_i, branch_addr_i};
                        v0_r <= 1;
                    end
                    2'b01: begin
                        table1_r <= {pc_i, branch_addr_i};
                        v1_r <= 1;
                    end
                    2'b10: begin
                        table2_r <= {pc_i, branch_addr_i};
                        v2_r <= 1;
                    end
                    2'b11: begin
                        table3_r <= {pc_i, branch_addr_i};
                        v3_r <= 1;
                    end
                    default: begin
                        table0_r <= 0;
                        table1_r <= 0;
                        table2_r <= 0;
                        table3_r <= 0;
                        v0_r <= 0;
                        v1_r <= 0;
                        v2_r <= 0;
                        v3_r <= 0;
                    end
                endcase
            end
        end
    end
endmodule

module shift_reg4(clk, reset, set, sin, d, q);
    input clk, reset, set, sin;
    input [3:0] d;
    output [3:0] q;
    reg [3:0] register;
    wire [3:0] register_shift;

    assign q = register;
    assign register_shift = register << 1'b1;

    always @(posedge clk or negedge reset or posedge set) begin
        if (~reset) begin
            register <= 4'b0000;
        end else if (set) begin
            register <= d;
        end else begin
            register <= register_shift;
            register[0] <= sin;
        end
    end
endmodule
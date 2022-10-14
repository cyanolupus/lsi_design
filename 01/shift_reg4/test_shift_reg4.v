`timescale 1ns/100ps

module test_shift_reg4;
    parameter STEP = 10;
    reg clk, reset, set, sin;
    reg [3:0] d;
    wire [3:0] q;
    integer i;

    shift_reg4 shift_reg4_instance (
        .clk(clk),
        .reset(reset),
        .set(set),
        .sin(sin),
        .d(d),
        .q(q)
    );

    always begin
        #(STEP/2) clk = ~clk;
    end

    initial begin
        clk = 1'b0;
        reset = 1'b0;
        set = 1'b0;

        #(STEP*5) reset = 1'b1;

        sin = 1'b1;
        for (i = 0; i < 4; i = i + 1) begin
            #STEP;
        end

        sin = 1'b0;
        for (i = 0; i < 4; i = i + 1) begin
            #STEP;
        end

        $finish;
    end

    always @(posedge clk) begin
        $display("i = %h, dec = %b, set = %b, d = %h, q = %h", i, shift_reg4_instance.sin, shift_reg4_instance.set, shift_reg4_instance.d, shift_reg4_instance.q);
    end
endmodule


`timescale 1ns/100ps

module test_count4;
    parameter STEP = 10;
    reg clk, reset, dec, set;
    reg [3:0] set_count;
    wire [3:0] count;
    integer i;

    count4 count4_instance (
        .clk(clk),
        .reset(reset),
        .dec(dec),
        .set(set),
        .set_count(set_count),
        .count(count)
    );

    always begin
        #(STEP/2) clk = ~clk;
    end

    initial begin
        clk = 1'b0;
        reset = 1'b0;
        set = 1'b0;
        dec = 1'b0;

        #(STEP*5) reset = 1'b1;

        for (i = 0; i < 15; i = i + 1) begin
            #STEP;
        end

        dec = 1'b1;

        for (i = 0; i < 16; i = i + 1) begin
            #STEP;
        end

        set = 1'b1;
        set_count = 4'b1000;
        #STEP;

        set = 1'b0;
        for (i = 0; i < 2; i = i + 1) begin
            #STEP;
        end

        dec = 1'b0;
        set = 1'b1;
        set_count = 4'b0010;
        #STEP;

        set = 1'b0;
        for (i = 0; i < 2; i = i + 1) begin
            #STEP;
        end

        $finish;
    end

    always @(posedge clk) begin
        $display("i = %h, dec = %b, set = %b, set_count = %h, count = %h", i, count4_instance.dec, count4_instance.set, count4_instance.set_count, count4_instance.count);
    end
endmodule


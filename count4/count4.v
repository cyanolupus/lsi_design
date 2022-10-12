module count4 (clk, reset, dec, set, set_count, count);
    input clk, reset, dec, set;
    input [3:0] set_count;
    output [3:0] count;
    reg [3:0] counter;
    wire [3:0] counter_inc;
    wire [3:0] counter_dec;

    assign count = counter;
    assign counter_inc = counter + 1'b1;
    assign counter_dec = counter - 1'b1;

    always @(posedge clk or posedge set or negedge reset) begin
        if (~reset) begin
            counter <= 4'b0000;
        end else if (set) begin
            counter <= set_count;
        end else if (dec) begin
            counter <= counter_dec;
        end else begin
            counter <= counter_inc;
        end
    end
endmodule
module Multiplier #(
    parameter DATA_WIDTH = 32
) (
    mult_in0,
    mult_in1,
    mult_out
);

input  [DATA_WIDTH-1:0] mult_in0;
input  [DATA_WIDTH-1:0] mult_in1;
output [DATA_WIDTH+DATA_WIDTH-1:0] mult_out;    // 192

assign mult_out = {{DATA_WIDTH{1'b0}},mult_in0} * {{DATA_WIDTH{1'b0}},mult_in1};
//assign mult_out = mult_in0 * mult_in1;

endmodule

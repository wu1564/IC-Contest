module Multiplier #(
    parameter DATA_WIDTH = 16
)(
    a,
    b,
    result
);

input  signed [DATA_WIDTH/2-1:0] a;
input  signed [DATA_WIDTH/2-1:0] b;
output signed [DATA_WIDTH-1:0] result;

assign result = a * b;

endmodule

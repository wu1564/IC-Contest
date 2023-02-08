module Substract #(
    parameter DATA_WIDTH = 32
)(
    sub_in_0,
    sub_in_1,
    result
);

input  [DATA_WIDTH-1:0] sub_in_0;
input  [DATA_WIDTH-1:0] sub_in_1;
output [DATA_WIDTH-1:0] result;

assign result = sub_in_0 - sub_in_1;

endmodule

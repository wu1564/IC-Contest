module Compare #(
    parameter DATA_WIDTH = 32
)(
    comp_in_a,
    comp_in_b,
    comp_res
);

input  signed [DATA_WIDTH-1:0] comp_in_a;
input  signed [DATA_WIDTH-1:0] comp_in_b;
output comp_res;

assign comp_res = ($signed(comp_in_a) > $signed(comp_in_b)) ? 1'b1 : 1'b0;

endmodule

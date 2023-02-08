module Alu #(
    parameter DATA_WIDTH = 16
)(
    a,
    b,
    control,      
    result
);

//-------------------------------------------------------
// Input & Output Declaraiton
//-------------------------------------------------------
input  control;
input  signed [DATA_WIDTH-1:0] a;
input  signed [DATA_WIDTH-1:0] b;
output wire signed [DATA_WIDTH-1:0] result;

assign result = (control) ? a + b : a - b;

endmodule

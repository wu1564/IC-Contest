module Alu #(
    parameter MODE = 0,
    parameter DATA_WIDTH = 64
)(
    alu_in_0,
    alu_in_1,
    alu_in_2,
    alu_in_3,
    result
);

//----------------------------------------------------------------------------
// Input & Output Declaration
//----------------------------------------------------------------------------
input  [DATA_WIDTH-1:0] alu_in_0, alu_in_1, alu_in_2, alu_in_3;
output [DATA_WIDTH+DATA_WIDTH-1:0] result;

//----------------------------------------------------------------------------
// Register & Wire Declaration
//----------------------------------------------------------------------------
wire [DATA_WIDTH-1:0] sub_out_0;

generate
    if (MODE == 0) begin: two_sub
        wire [DATA_WIDTH-1:0] sub_out_1;
        Substract #(
            .DATA_WIDTH(DATA_WIDTH)
        )mode0_sub0(
            .sub_in_0(alu_in_0),
            .sub_in_1(alu_in_1),
            .result(sub_out_0)
        );
        Substract #(
            .DATA_WIDTH(DATA_WIDTH)
        )mode0_sub1(
            .sub_in_0(alu_in_2),
            .sub_in_1(alu_in_3),
            .result(sub_out_1)
        );
        assign result = {{DATA_WIDTH{sub_out_0[47]}},sub_out_0} * {{DATA_WIDTH{sub_out_1[47]}},sub_out_1};
    end else begin: one_sub
        Substract #(
            .DATA_WIDTH(DATA_WIDTH)
        )mode1_sub0(
            .sub_in_0(alu_in_0),
            .sub_in_1(alu_in_1),
            .result(sub_out_0)
        );
        assign result = {{DATA_WIDTH{alu_in_2[47]}},alu_in_2} * {{DATA_WIDTH{sub_out_0[47]}},sub_out_0};
    end
endgenerate

endmodule

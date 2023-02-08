module Interpolation #(
    parameter DATA_WIDTH = 128
)(
    // Control Signal
    clk,
    reset_n,
    interpolation_start,
    alu_sel,
    // calculate Signal
    x,
    x0,
    x1,
    result,
    interpolation_done,
    alu_out
);
 
//----------------------------------------------------------------------------
// Parameter Declaration
//----------------------------------------------------------------------------
localparam IDLE     = 0;
localparam ADD      = 1;
localparam DIVISION = 2;

//----------------------------------------------------------------------------
// Input & Output Declaration
//----------------------------------------------------------------------------
// Control Signal
input clk;
input reset_n;
input interpolation_start;
input alu_sel;
// calculate Signal
input      [DATA_WIDTH/2-1:0] x; //  64
input      [DATA_WIDTH-1:0]   x0;// 128
input      [DATA_WIDTH-1:0]   x1;// 128
output     [95:0] alu_out;
output reg interpolation_done;
output [DATA_WIDTH-1:0]   result;

//----------------------------------------------------------------------------
// Register & Wire Declaration
//----------------------------------------------------------------------------
wire [DATA_WIDTH/2-1:0] sub_out;
wire [DATA_WIDTH-1:0] alu_out_0, alu_out_1;
wire [DATA_WIDTH-1:0] adder;
wire [DATA_WIDTH-1:0] sub_divide;
wire [DATA_WIDTH-1:0] compare;
reg  [DATA_WIDTH/2-1:0] alu_in_sel_0, alu_in_sel_1, alu_in_sel_2;
reg  [1:0] state, next_state; 
reg  [6:0] cnt;
reg  [DATA_WIDTH+DATA_WIDTH-1:0] result_reg;

//----------------------------------------------------------------------------
// Module
//----------------------------------------------------------------------------
Alu #(
    .MODE(0),
    .DATA_WIDTH(DATA_WIDTH/2)       // 64
)alu_0(
    .alu_in_0(x),
    .alu_in_1(x0[127:64]),           // x0   64
    .alu_in_2(x1[63:0]),            // y1  64
    .alu_in_3(x0[63:0]),            // y0  64
    .result(alu_out_0)
);

Alu #(
    .MODE(1),
    .DATA_WIDTH(DATA_WIDTH/2)          // 48   64
)alu_1(
    .alu_in_0(alu_in_sel_0),           // x1
    .alu_in_1(alu_in_sel_1),           // x0
    .alu_in_2(alu_in_sel_2),           // y0
    .alu_in_3({DATA_WIDTH/2{1'b0}}),
    .result(alu_out_1)
);

Substract #(
    .DATA_WIDTH(DATA_WIDTH/2)
)sub0(
    .sub_in_0(x1[127:64]),           // x1 
    .sub_in_1(x0[127:64]),           // x0
    .result(sub_out)
);

//----------------------------------------------------------------------------
// State Machine
//----------------------------------------------------------------------------
// reg [1:0] state; 
always @(posedge clk or negedge reset_n) begin
    if(~reset_n) state <= IDLE;
    else state <= next_state;
end

// reg [1:0] next_state;
always @(*) begin
    case (state)
        IDLE:       next_state = (interpolation_start) ? ADD : IDLE;
        ADD:        next_state = DIVISION;
        DIVISION:   next_state = (cnt == 7'd127) ? IDLE : DIVISION;
        default:    next_state = IDLE;
    endcase
end

//----------------------------------------------------------------------------
// ALU Input Select
//----------------------------------------------------------------------------
//reg  [DATA_WIDTH-1:0] alu_in_sel_0, alu_in_sel_1;
always @(*) begin
    if(~alu_sel) begin
        alu_in_sel_0 = x1[127:64];
        alu_in_sel_1 = x0[127:64];
        alu_in_sel_2 = x0[63:0];
    end else begin
        alu_in_sel_0 = x1[63:0];
        alu_in_sel_1 = x0[63:0];
        alu_in_sel_2 = x;
    end
end

//----------------------------------------------------------------------------
// Flag
//----------------------------------------------------------------------------
// cnt
always @(posedge clk or negedge reset_n) begin
    if(~reset_n) begin
        cnt <= 7'd0;
    end else if(state == DIVISION) begin
        cnt <= cnt + 7'd1;
    end
end

//wire [DATA_WIDTH-1:0] adder;
assign adder = alu_out_0 + alu_out_1;

//wire [DATA_WIDTH-1:0] compare;
assign compare = (result_reg[DATA_WIDTH+:DATA_WIDTH] >= {{DATA_WIDTH/2{1'b0}},sub_out});

//wire [DATA_WIDTH-1:0] sub;
assign sub_divide = result_reg[DATA_WIDTH+:DATA_WIDTH] - {{DATA_WIDTH/2{1'b0}},sub_out};

//----------------------------------------------------------------------------
// Output Signal
//----------------------------------------------------------------------------
// wire alu_out;
assign alu_out = alu_out_1[95:0];

// output result
assign result = result_reg[0+:DATA_WIDTH];

// output reg [DATA_WIDTH+DATA_WIDTH-1:0]   result; 128+128     127
always @(posedge clk or negedge reset_n) begin
    if(~reset_n) begin
        result_reg <= 0;     
    end else begin
        case (state)
            ADD:        result_reg <= {127'd0,adder[0+:96],33'd0};
            DIVISION:   result_reg <= (compare) ? {sub_divide[0+:DATA_WIDTH-1],result_reg[0+:DATA_WIDTH],1'b1} : {result_reg[0+:DATA_WIDTH+DATA_WIDTH-1],1'b0};
            default:    result_reg <= result_reg;    
        endcase
    end
end

//output reg interpolation_done;
always @(posedge clk or negedge reset_n) begin
    if(~reset_n) begin
        interpolation_done <= 1'b0;
    end else if(state == DIVISION && cnt == 7'd127) begin
        interpolation_done <= 1'b1;
    end else begin
        interpolation_done <= 1'b0;
    end
end

//----------------------------------------------------------------------
// FOR DEBUG
//----------------------------------------------------------------------

endmodule

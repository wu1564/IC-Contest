module Analysis #(
    parameter DATA_WIDTH = 32
)(
    clk, 
    rst,
    fft_res_in,
    analysis_start,
    analysis_done,
    highest
);

//--------------------------------------------------------------------
// Parameter Define
//--------------------------------------------------------------------
localparam IDLE    = 0;
localparam PROCESS = 1;
localparam DONE    = 2;

//--------------------------------------------------------------------
// Input / Output Define
//--------------------------------------------------------------------
input  clk;
input  rst;
input  [DATA_WIDTH * 16-1:0] fft_res_in;
input  analysis_start;
output reg analysis_done;
output reg [3:0] highest;

//--------------------------------------------------------------------
// Reg / Wire Define
//--------------------------------------------------------------------
wire porcess_done;
reg  [1:0] state, next_state;
reg  [3:0] cnt, largerIndex;
// compare
wire comp_res;
reg  [DATA_WIDTH-1:0] comp_in_a, comp_in_b;

//--------------------------------------------------------------------
// Module
//--------------------------------------------------------------------
Compare #(
    .DATA_WIDTH(DATA_WIDTH)
)comp(
    .comp_in_a(comp_in_a),
    .comp_in_b(comp_in_b),
    .comp_res(comp_res)
);

//--------------------------------------------------------------------
// State Machine
//--------------------------------------------------------------------
//reg [1:0] state;
always @(posedge clk or posedge rst) begin
    if(rst) state <= IDLE;
    else state <= next_state;
end

//reg [1:0] next_state;
always @(*) begin
    case (state)
        IDLE:       next_state = (analysis_start) ? PROCESS : IDLE;
        PROCESS:    next_state = (porcess_done) ? DONE : PROCESS;
        default:    next_state = IDLE;
    endcase
end

//--------------------------------------------------------------------
// Flag
//--------------------------------------------------------------------
// wire process_done;
assign porcess_done = (cnt == 4'd14) ? 1'b1 : 1'b0;

//reg [3:0] cnt;
always @(posedge clk or posedge rst) begin
    if(rst) begin
        cnt <= 4'd0;
    end else begin
        case(state)
            PROCESS:    cnt <= (porcess_done) ? 4'd0 : cnt + 4'd1;
            default:    cnt <= 4'd0;
        endcase
    end
end

//reg  [DATA_WIDTH-1:0] comp_in_a;
always @(*) begin
    case (largerIndex)
        4'd0:    comp_in_a = fft_res_in[ 0+:DATA_WIDTH];         
        4'd1:    comp_in_a = fft_res_in[32+:DATA_WIDTH];         
        4'd2:    comp_in_a = fft_res_in[64+:DATA_WIDTH];
        4'd3:    comp_in_a = fft_res_in[96+:DATA_WIDTH]; 
        4'd4:    comp_in_a = fft_res_in[128+:DATA_WIDTH]; 
        4'd5:    comp_in_a = fft_res_in[160+:DATA_WIDTH]; 
        4'd6:    comp_in_a = fft_res_in[192+:DATA_WIDTH]; 
        4'd7:    comp_in_a = fft_res_in[224+:DATA_WIDTH]; 
        4'd8:    comp_in_a = fft_res_in[256+:DATA_WIDTH]; 
        4'd9:    comp_in_a = fft_res_in[288+:DATA_WIDTH]; 
        4'd10:   comp_in_a = fft_res_in[320+:DATA_WIDTH]; 
        4'd11:   comp_in_a = fft_res_in[352+:DATA_WIDTH]; 
        4'd12:   comp_in_a = fft_res_in[384+:DATA_WIDTH]; 
        4'd13:   comp_in_a = fft_res_in[416+:DATA_WIDTH]; 
        4'd14:   comp_in_a = fft_res_in[448+:DATA_WIDTH]; 
        4'd15:   comp_in_a = fft_res_in[512+:DATA_WIDTH]; 
        default: comp_in_a = 0;
    endcase
end

//reg  [DATA_WIDTH-1:0] comp_in_b;
// always @(*) begin
//     comp_in_b = fft_res_in[(cnt+1) * DATA_WIDTH +: DATA_WIDTH];
// end

always @(*) begin
    case (cnt)
        4'd0:    comp_in_b = fft_res_in[32+:DATA_WIDTH];         // array[x + 1]
        4'd1:    comp_in_b = fft_res_in[64+:DATA_WIDTH];
        4'd2:    comp_in_b = fft_res_in[96+:DATA_WIDTH]; 
        4'd3:    comp_in_b = fft_res_in[128+:DATA_WIDTH]; 
        4'd4:    comp_in_b = fft_res_in[160+:DATA_WIDTH]; 
        4'd5:    comp_in_b = fft_res_in[192+:DATA_WIDTH]; 
        4'd6:    comp_in_b = fft_res_in[224+:DATA_WIDTH]; 
        4'd7:    comp_in_b = fft_res_in[256+:DATA_WIDTH]; 
        4'd8:    comp_in_b = fft_res_in[288+:DATA_WIDTH]; 
        4'd9:    comp_in_b = fft_res_in[320+:DATA_WIDTH]; 
        4'd10:   comp_in_b = fft_res_in[352+:DATA_WIDTH]; 
        4'd11:   comp_in_b = fft_res_in[384+:DATA_WIDTH]; 
        4'd12:   comp_in_b = fft_res_in[416+:DATA_WIDTH]; 
        4'd13:   comp_in_b = fft_res_in[448+:DATA_WIDTH]; 
        default: comp_in_b = 0;
    endcase
end

//--------------------------------------------------------------------
// Compare
//--------------------------------------------------------------------
//reg  [3:0] cnt, largerIndex;
always @(posedge clk or posedge rst) begin
    if(rst) begin
        largerIndex <= 4'd0;
    end else begin
        case(state)
            PROCESS:    largerIndex <= (comp_res) ? largerIndex : cnt + 4'd1;
            default:    largerIndex <= 4'd0;
        endcase
    end
end

//--------------------------------------------------------------------
// Output Signal
//--------------------------------------------------------------------
// output reg analysis_done;
always @(posedge clk or posedge rst) begin
    if(rst) begin
        analysis_done <= 1'b0;
    end else if(state == DONE) begin
        analysis_done <= 1'b1;
    end else begin
        analysis_done <= 1'b0;
    end
end

// output reg highest;
always @(posedge clk or posedge rst) begin
    if(rst) begin
        highest <= 1'b0;
    end else if(state == DONE) begin
        highest <= largerIndex;
    end
end

endmodule

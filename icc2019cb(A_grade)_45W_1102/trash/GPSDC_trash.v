`timescale 1ns/10ps
module GPSDC(
    clk, 
    reset_n, 
    DEN, 
    LON_IN, 
    LAT_IN, 
    COS_ADDR, 
    COS_DATA, 
    ASIN_ADDR, 
    ASIN_DATA, 
    Valid, 
    a, 
    D
);

//----------------------------------------------------------------------------
// Parameter Declaration
//----------------------------------------------------------------------------
// GPS Process Done
localparam GPS_PROCESS_TIME = 3'd6;
// State Machine
localparam IDLE             = 0;
localparam LUT              = 1;
localparam INTER_PROCESS    = 2;
localparam GPS_PROCESS      = 3;
localparam SIN_TABLE        = 4;
localparam DISTANCE_PROCESS = 5;

//----------------------------------------------------------------------------
// Input & Output Declaration
//----------------------------------------------------------------------------
input              clk;
input              reset_n;     // active low
input              DEN;
input      [23:0]  LON_IN;      // 8 + 16
input      [23:0]  LAT_IN;      // 8 + 16
input      [95:0]  COS_DATA;    // COS_DATA[95:48] 16 + 32      COS_DATA[47:0] 16 + 32
input      [127:0] ASIN_DATA;   // ASIN_DATA[127:64]，0 + 64    ASIN_DATA[63:0] 0 + 64
output reg [6:0]   COS_ADDR;    // 
output reg [5:0]   ASIN_ADDR;   // arcsine
output reg Valid;
output [39:0]  D;           // 8 + 32
output [63:0]  a;           // all float

//----------------------------------------------------------------------------
// Register & Wire Declaration
//----------------------------------------------------------------------------
// State Machine
wire gps_process_done;
reg  [2:0]  state, next_state;
// Interpolation
wire alu_sel;
wire find_out_cosTable;
wire found_sinTable;
wire interpolation_done;
wire [47:0] compare_data0, compare_data1;
wire [95:0] alu_out;
wire [127:0] interpolation_out;
reg  interpolation_start;
reg  [63:0] inter_in_0;
reg  [127:0] inter_in_1, inter_in_2;
// Multiplier
reg  [127:0] mult_in0, mult_in1;
wire [255:0] mult_out;
// Data Store
reg  [23:0] LON, LON_pre;
reg  [23:0] LAT, LAT_pre;
reg  [127:0] table_data_store;
reg  [127:0] buffer;
reg  [127:0] a_reg;
reg  [127:0] temp;
//
reg  sinFlag;
reg  [2:0]  cnt;

//----------------------------------------------------------------------------
// Module
//----------------------------------------------------------------------------
Interpolation #(
    .DATA_WIDTH(128)
)u_interpolation(
    // Control Signal
    .clk(clk),
    .reset_n(reset_n),
    .interpolation_start(interpolation_start),
    .alu_sel(alu_sel),
    // calculate Signal
    .x(inter_in_0),                             //   64
    .x0(inter_in_1),                            //  128
    .x1(inter_in_2),                            //  128
    .result(interpolation_out),                 //  128
    .interpolation_done(interpolation_done),
    .alu_out(alu_out)                           //  128
);

// 128 * 128
Multiplier #(
    .DATA_WIDTH(128)
)mult0(
    .mult_in0(mult_in0),
    .mult_in1(mult_in1),
    .mult_out(mult_out)     // 256
);

//----------------------------------------------------------------------------
// State Machine
//----------------------------------------------------------------------------
//reg [2:0] state
always @(posedge clk or negedge reset_n) begin
    if(~reset_n) 
        state <= IDLE;
    else state <= next_state;
end

//reg [2:0] next_state;
always @(*) begin
    case (state)
        IDLE:               next_state = (DEN) ?  LUT : IDLE;
        LUT:                next_state = (~find_out_cosTable) ? INTER_PROCESS : LUT;
        INTER_PROCESS:      next_state = (interpolation_done) ? (sinFlag) ? DISTANCE_PROCESS : GPS_PROCESS : INTER_PROCESS;
        GPS_PROCESS:        next_state = (cnt == 3'd1) ? IDLE : (gps_process_done) ? SIN_TABLE : GPS_PROCESS;
        SIN_TABLE:          next_state = (found_sinTable) ? INTER_PROCESS : SIN_TABLE;
        DISTANCE_PROCESS:   next_state = IDLE;
        default:            next_state = state;
    endcase
end

//----------------------------------------------------------------------------
// Store Data
//----------------------------------------------------------------------------
// reg  [23:0]  LON, LON_pre;
// reg  [23:0]  LAT, LAT_pre;
always @(posedge clk or negedge reset_n) begin
    if(~reset_n) begin
        LON <= 24'd0;
        LAT <= 24'd0;
        LON_pre <= 24'd0;
        LAT_pre <= 24'd0;
    end else if(DEN) begin
        LON <= LON_IN;
        LAT <= LAT_IN;
        LON_pre <= LON;
        LAT_pre <= LAT;
    end
end 

//reg  [127:0] table_data_store;
always @(posedge clk or negedge reset_n) begin
    if(~reset_n) begin
        table_data_store <= 128'd0;
    end else if(state == LUT && find_out_cosTable) begin
        table_data_store <= {16'd0,COS_DATA[95:48],16'd0,COS_DATA[47:0]};
    end else if(state == SIN_TABLE && ~found_sinTable) begin
        table_data_store <= ASIN_DATA;
    end
end

//reg [127:0] a_reg;
always @(posedge clk or negedge reset_n) begin
    if(~reset_n) begin
        a_reg <= 128'd0;
    end else begin
        case (state)
            IDLE:           a_reg <= (DEN) ? temp : a_reg;
            INTER_PROCESS:  a_reg <= (interpolation_done && cnt == 3'd0 && !sinFlag) ? interpolation_out : a_reg;
            GPS_PROCESS:    begin
                                case(cnt)
                                    3'd2:       a_reg <= {{33{alu_out[95]}},alu_out[95:1]} + (alu_out[0] & alu_out[95]);
                                    3'd3:       a_reg <= mult_out[127:0];
                                    3'd4:       a_reg <= mult_out[128+:128];
                                    3'd6:       a_reg <= a_reg + buffer;
                                    default:    a_reg <= a_reg;
                                endcase
                            end
            default:        a_reg <= a_reg;
        endcase
    end
end

//reg [127:0] buffer
always @(posedge clk or negedge reset_n) begin
    if(~reset_n) begin
        buffer <= 128'd0;
    end else begin
        case (cnt)
            3'd2:       buffer <= mult_out[127:0];
            3'd4:       buffer <= {{33{alu_out[95]}},alu_out[95:1]} + (alu_out[0] & alu_out[95]);
            3'd5:       buffer <= mult_out[127:0];
            default:    buffer <= buffer;
        endcase
    end
end

//reg  [127:0] temp;
always @(posedge clk or negedge reset_n) begin
    if(~reset_n) begin
        temp <= 128'd0;
    end else if(interpolation_done && !sinFlag) begin
        temp <= interpolation_out;
    end 
end

//----------------------------------------------------------------------------
// Look Up Table Process
//----------------------------------------------------------------------------
// reg  [63:0] inter_in_0;
// reg  [127:0] inter_in_1, inter_in_2;
always @(*) begin
    if(~sinFlag) begin
        case (cnt)
            3'd2,
            3'd3:       begin
                            inter_in_0 = 64'h0000000000000477;  //x            (x1-x0)x
                            inter_in_1 = {104'd0,LON_pre};      //x0
                            inter_in_2 = {104'd0,LON};          //x1               
                        end
            3'd4,
            3'd5,
            3'd6:       begin
                            inter_in_0 = 64'h0000000000000477;  //x            (x1-x0)x      
                            inter_in_1 = {104'd0,LAT_pre};      //x0
                            inter_in_2 = {104'd0,LAT};          //x1    
                        end
            default:    begin
                            inter_in_0 = {16'd0,compare_data0};
                            inter_in_1 = table_data_store;
                            inter_in_2 = {16'd0,COS_DATA[95:48],16'd0,COS_DATA[47:0]};      // 128    128:64      63:0
                        end
        endcase    
    end else begin
        inter_in_0 = a;
        inter_in_1 = table_data_store;
        inter_in_2 = ASIN_DATA;
    end
end

//reg interpolation_start;
always @(posedge clk or negedge reset_n) begin
    if(~reset_n) begin
        interpolation_start <= 1'b0;
    end else if(state == LUT && ~find_out_cosTable || (state == SIN_TABLE && found_sinTable)) begin
        interpolation_start <= 1'b1;
    end else begin
        interpolation_start <= 1'b0;
    end
end

//wire [47:0] compare_data0;
assign compare_data0 = {{8{LAT[23]}},LAT,16'd0};

//wire [47:0] compare_data1;
assign compare_data1 = COS_DATA[95:48];

//wire find_out_cosTable;
assign find_out_cosTable = (compare_data0 > compare_data1) ? 1'b1 : 1'b0;

//output     [6:0]   COS_ADDR;    
always @(posedge clk or negedge reset_n) begin
    if(~reset_n) begin
        COS_ADDR <= 7'd0;
    end else begin
        case(state)
            LUT:            COS_ADDR <= (~find_out_cosTable) ? COS_ADDR : COS_ADDR + 7'd1;
            INTER_PROCESS:  COS_ADDR <= COS_ADDR;
            default:        COS_ADDR <= 7'd0;
        endcase
    end
end

//input      [127:0] ASIN_DATA;   // x : ASIN_DATA[127:64]，0 + 64    sin^-1(x) : ASIN_DATA[63:0] 0 + 64
//output reg [5:0]   ASIN_ADDR;   // arcsine
always @(posedge clk or negedge reset_n) begin
    if(~reset_n) begin
        ASIN_ADDR <= 6'd0;
    end else begin
        case (state)
            IDLE:       ASIN_ADDR <= 6'd0;
            SIN_TABLE:  ASIN_ADDR <= (~found_sinTable) ? ASIN_ADDR + 6'd1 : ASIN_ADDR;
            default:    ASIN_ADDR <= ASIN_ADDR;
        endcase
    end
end

//----------------------------------------------------------------------------
// Flag
//----------------------------------------------------------------------------
//wire found_sinTable;
assign found_sinTable = (a < ASIN_DATA[127:64]);

//wire alu_sel;
assign alu_sel = (cnt > 3'd1) ? 1'b1 : 1'b0;
 
//wire gps_process_done;
assign gps_process_done = (cnt == GPS_PROCESS_TIME) ? 1'b1 : 1'b0;

//reg  [2:0]  cnt;
always @(posedge clk or negedge reset_n) begin
    if(~reset_n) begin
        cnt <= 3'd0;
    end else begin
        case (state)
            INTER_PROCESS:  cnt <= (interpolation_done) ? cnt + 3'd1 : cnt;
            GPS_PROCESS:    begin                   
                                if(gps_process_done) begin
                                    cnt <= 3'd0;
                                end else if(cnt > 3'd1) begin
                                    cnt <= cnt + 3'd1;
                                end
                            end
            default:        cnt <= cnt;
        endcase
    end
end

//reg sinFlag
always @(posedge clk or negedge reset_n) begin
    if(~reset_n) begin
        sinFlag <= 1'b0;
    end else if(state == SIN_TABLE) begin
        sinFlag <= 1'b1;
    end else if(state == DISTANCE_PROCESS) begin
        sinFlag <= 1'b0;
    end
end

//----------------------------------------------------------------------------
// Multiplier
//----------------------------------------------------------------------------
//reg  [127:0]  mult_in0, mult_in1;
always @(*) begin
    if(state == GPS_PROCESS) begin
        case (cnt)
            3'd2:      begin    // unsigned cosA * cosB
                            mult_in0 = a_reg;             // cosA
                            mult_in1 = interpolation_out; // cosB
                        end
            3'd3:       begin   // signed   sin^2
                            mult_in0 = a_reg;
                            mult_in1 = a_reg;
                        end
            3'd4:       begin   // unsigned
                            mult_in0 = a_reg;     // sin^2 small
                            mult_in1 = buffer;  // cosA * cosB large
                        end 
            3'd5:       begin
                            mult_in0 = buffer; //sin^2
                            mult_in1 = buffer;
                        end
            default:    begin
                            mult_in0 = 128'd0;    
                            mult_in1 = 128'd0;    
                        end
        endcase
    end else begin
        mult_in0 = 127'd12756274;
        mult_in1 = interpolation_out;
    end
end

//----------------------------------------------------------------------------
// Output Signal
//----------------------------------------------------------------------------
// output a
assign a = a_reg[63:0];

// output D
assign D = mult_out[64+:40];

//output reg Valid
always @(posedge clk or negedge reset_n) begin
    if(~reset_n) begin
        Valid <= 1'b0;
    end else if(state == DISTANCE_PROCESS) begin
        Valid <= 1'b1;
    end else begin
        Valid <= 1'b0;
    end
end


integer i = 0;
initial begin
    forever begin
        @(posedge clk);
        if(Valid) begin
            $display("%d -> %3d", i, $time);
            i = i + 1;
        end
    end
end

endmodule

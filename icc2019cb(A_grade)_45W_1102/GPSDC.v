`timescale 1ns/10ps

//`define DEBUG

module GPSDC(
    clk, 
    reset_n, 
    DEN, 
    LON_IN,         //24 bits
    LAT_IN,         //24 bits
    COS_ADDR,       //96 bits
    COS_DATA,       //
    ASIN_ADDR,      //128 bits
    ASIN_DATA,      
    Valid, 
    a, 
    D
);

//Parameter
localparam IDLE         = 0;    // receive first location
localparam COS_TABLE    = 1;
localparam CAL          = 2;
localparam DIVISION     = 3;
localparam GPS          = 4;
localparam SINE_TABLE   = 5;
localparam FINAL        = 6;

//Input/Output Declaration
input              clk;
input              reset_n;     // active low
input              DEN;
input      [23:0]  LON_IN;      // 8 + 16
input      [23:0]  LAT_IN;      // 8 + 16
                                //          x                           cos(x)
input      [95:0]  COS_DATA;    // COS_DATA[95:48] 16 + 32      COS_DATA[47:0] 16 + 32 / 48 bits
input      [127:0] ASIN_DATA;   // ASIN_DATA[127:64]，0 + 64    ASIN_DATA[63:0] 0 + 64
output reg [6:0]   COS_ADDR;    // 
output reg [5:0]   ASIN_ADDR;   // arcsine
output Valid;
output [39:0]  D;               // 8 + 32
output reg [63:0]  a;               // all float

//Wire&Reg
wire final;
wire sine_done;
wire cos_done;
wire cal_done;
wire gps_cal_done;
wire round_bit;
wire [15:0] rad;
wire [15:0] rad_neg;
wire [47:0] x, cos_x;
wire [63:0] sine_table_x, sine_table_num;
wire [63:0] table_x_neg, table_num_neg;
reg  sineProcess;
reg  secondData;
reg  [2:0]  state, next_state;
reg  [23:0] lon_a, lat_a, lon_b, lat_b;
reg  [63:0] table_num, table_x;
reg  [127:0] temp;
// adder
wire signed [127:0] adder;
reg  signed [127:0] adder_in0, adder_in1;
reg  signed [127:0] add_sel0, add_sel1;
reg  signed [127:0] add_tempReg0, add_tempReg1;
// multiplier
wire signed [255:0] multiplier;
reg  signed [127:0] mult_sel0, mult_sel1;
reg  signed [127:0] mult_in0, mult_in1;
// Dividor
wire subtract_condition;
wire division_done;
wire [63:0]  divide_compare;
reg  [127:0] dividend;
reg  [63:0]  divisor;
// cnt
reg [6:0] cnt;

// state machine
always @(*)  begin
    case(state) 
        IDLE:       next_state = (DEN) ? COS_TABLE : IDLE;
        COS_TABLE:  next_state = (cos_done) ? CAL : COS_TABLE;
        CAL:        next_state = (cal_done) ? DIVISION : CAL;
        DIVISION:   begin
            if(division_done) begin
                if(sineProcess) begin
                    next_state = FINAL;
                end else if(secondData) begin
                    next_state = GPS;
                end else begin
                    next_state = IDLE;
                end
            end else begin
                next_state = DIVISION;
            end
        end
        GPS: begin
            if(gps_cal_done) begin
                next_state = SINE_TABLE;
            end else begin
                next_state = GPS;
            end
        end
        SINE_TABLE: next_state = (sine_done) ? CAL : SINE_TABLE;
        FINAL:      next_state = (final) ? IDLE : FINAL;
        default:    next_state = IDLE;
    endcase    
end

always @(posedge clk or negedge reset_n) begin
    if(!reset_n) begin
        state <= IDLE;
    end else
        state <= next_state;
end

// receive the first location
//reg [23:0] lon_a, lat_a;
always @(posedge clk or negedge reset_n) begin
    if(!reset_n) begin
        lon_a <= 24'd0;
        lat_a <= 24'd0;
        lon_b <= 24'd0;
        lat_b <= 24'd0;
    end else if(DEN) begin
        lon_a <= LON_IN;
        lat_a <= LAT_IN;
        lon_b <= lon_a;
        lat_b <= lat_a;
    end
end

// cosine look up table
assign x        = COS_DATA[95:48];
assign cos_x    = COS_DATA[47:0];
assign cos_done = (x > {8'd0,lat_a,16'd0});

// sine look up table
//wire [63:0] sine_table_x, sine_table_num;
assign sine_table_x   = ASIN_DATA[127:64];
assign sine_table_num = ASIN_DATA[63:0];
assign sine_done      = (sine_table_x > temp[63:0]);

//wire [48:0] table_x_neg, table_num_neg;
assign table_num_neg = ~table_num + 64'd1;
assign table_x_neg   = ~table_x + 64'd1;

//reg  [63:0] table_num, table_x;
always @(posedge clk or negedge reset_n) begin
    if(!reset_n) begin
        table_x   <= {16'd0,x};
        table_num <= {16'd0,cos_x};
    end else if(state == COS_TABLE && !cos_done) begin
        table_x   <= {16'd0,x};
        table_num <= {16'd0,cos_x}; // get the cos data from table
    end else if(state == SINE_TABLE && !sine_done) begin
        table_x   <= sine_table_x;
        table_num <= sine_table_num;
    end 
end

//output reg [6:0]   COS_ADDR;
always @(posedge clk or negedge reset_n) begin
    if(!reset_n) begin
        COS_ADDR <= 7'd0;
    end else if(state == COS_TABLE && !cos_done) begin
        COS_ADDR <= COS_ADDR + 7'd1;
    end else if(state == IDLE) begin
       COS_ADDR <= 7'd0; 
    end
end

//reg  [127:0] temp;
always @(posedge clk or negedge reset_n) begin
    if(!reset_n) begin
        temp <= 128'd0;
    end else begin
        case (state)
            CAL: begin
                if(cal_done) begin
                    temp <= 128'd0;
                end else if(secondData && cnt == 7'd0) begin
                    temp <= (sineProcess) ? dividend : mult_in0;
                end
            end
            DIVISION: begin
                if(division_done) begin
                    temp <= 128'd0;
                end else if(subtract_condition) begin
                    temp <= adder;
                end else begin
                    temp <= {temp,dividend[127]};
                end
            end
            GPS: begin
                case(cnt)
                    1: temp <= $unsigned(multiplier[64+:128]);     // fiexd 64bits
                    4: temp <= $unsigned(multiplier[64+:128]);     // 128 -> 64
                    7: temp <= adder;
                    default: temp <= temp;
                endcase
            end
            FINAL: begin
                temp <= (final) ? 128'd0 : temp;
            end
            default: temp <= temp;
        endcase
    end
end

// Calculation Unit
// Adder
assign adder = adder_in0 + adder_in1;

//reg signed [127:0] adder_in0;, adder_in1;
always @(*) begin
    if(state == DIVISION) begin
        adder_in0 = divide_compare;
        adder_in1 = {64'd1,~divisor + 64'd1};
    end else begin
        adder_in0 = add_tempReg0;
        adder_in1 = add_tempReg1;
    end
end

//reg  signed [127:0] add_tempReg0, add_tempReg0;
always @(posedge clk or negedge reset_n) begin
    if(!reset_n) begin
        add_tempReg0 <= 128'd0;
        add_tempReg1 <= 128'd0;
    end else begin  
        add_tempReg0 <= add_sel0;
        add_tempReg1 <= add_sel1;
    end 
end

//reg [127:0] add_sel0, add_sel1;
always @(*) begin
    add_sel0 = 128'd0;
    add_sel1 = 128'd0;
    case (state)
        CAL: begin               
            case(cnt)
                0: begin    // x - x0
                    if(sineProcess) begin
                        add_sel0 = $signed({{64{1'b0}},temp[63:0]});
                    end else begin
                        add_sel0 = $signed({{88{lat_a[23]}},lat_a,16'd0});
                    end
                    add_sel1 = $signed({{64{table_x_neg[63]}},table_x_neg});
                end
                1: begin    // y1 - y0
                    if(sineProcess) begin
                        add_sel0 = $signed({{64{1'b0}},sine_table_num});
                    end else begin
                        add_sel0 = $signed({{80{cos_x[47]}},cos_x});
                    end
                    add_sel1 = $signed({{64{table_num_neg[63]}},table_num_neg});
                end
                3: begin    // x1 - x0
                    if(sineProcess) begin
                        add_sel0 = $signed({{64{1'b0}},sine_table_x});
                    end else begin
                        add_sel0 = $signed({{80{1'b0}},x});
                    end
                    add_sel1 = $signed({{64{table_x_neg[63]}},table_x_neg});
                end
                5: begin
                    add_sel0 = $signed(multiplier);
                    add_sel1 = $signed(dividend);
                end
                6: begin
                    add_sel0 = $signed(temp);
                    add_sel1 = add_tempReg1;
                end
                default: begin
                    add_sel0 = add_tempReg0;
                    add_sel1 = add_tempReg1;
                end
            endcase 
        end
        GPS: begin
            case(cnt)
                0: begin    // longtitude b - a
                    add_sel0 = $signed({88'd0,lon_a,16'd0});
                    add_sel1 = $signed({{88{1'b1}},~{lon_b,16'd0} + 40'd1});
                end
                1: begin    // latitude b - a
                    add_sel0 = $signed({88'd0,lat_a,16'd0});
                    add_sel1 = $signed({{88{1'b1}},~{lat_b,16'd0} + 40'd1});
                end
                5: begin
                    add_sel0 = $signed(temp);
                    add_sel1 = add_tempReg1;
                end
                6: begin
                   add_sel0 = add_tempReg0;
                   add_sel1 = $signed(multiplier[32+:128]);
                end
                default: begin
                    add_sel0 = add_tempReg0;
                    add_sel1 = add_tempReg1;
                end
            endcase
        end
        default: begin
            add_sel0 = add_tempReg0;
            add_sel1 = add_tempReg1;
        end
    endcase
end

// round bit
assign round_bit = (multiplier[255]) ? (multiplier[16]) : 1'b0;
//assign round_bit = multiplier[255] & multiplier[16];

// multiplier
//reg [127:0] mult_sel0, mult_sel1;
assign multiplier = mult_in0 * mult_in1;

//reg signed [127:0] mult_reg0, mult_reg1;
always @(posedge clk or negedge reset_n) begin
    if(!reset_n) begin
        mult_in0 <= 128'd0;
        mult_in1 <= 128'd0;
    end else begin
        mult_in0 <= mult_sel0;
        mult_in1 <= mult_sel1;
    end
end

always @(*) begin
    mult_sel0 = mult_in0;
    mult_sel1 = mult_in1;
    case(state) 
        COS_TABLE: begin
            mult_sel0 = (secondData) ? add_tempReg0 : mult_sel0;
            mult_sel1 = mult_in1;
        end
        CAL: begin
            case(cnt)
                1: begin
                    mult_sel0 = $signed(adder);
                    mult_sel1 = mult_in1;
                end
                2: begin
                    mult_sel0 =  mult_in0;
                    mult_sel1 = $signed(adder);
                end
                4: begin
                    mult_sel0 = $signed(adder);
                    mult_sel1 = $signed({{64{table_num[63]}},table_num});
                end
                6: begin
                    mult_sel0 = 128'd0;
                    mult_sel1 = mult_in1;
                end
                default: begin
                    mult_sel0 = mult_in0;
                    mult_sel1 = mult_in1;
                end
            endcase
        end
        DIVISION: begin // used to be Q in division
            if(subtract_condition) begin
                mult_sel0 = $signed({mult_sel0[126:0],1'b1});
            end else begin
                mult_sel0 = $signed({mult_sel0[126:0],1'b0});
            end
            mult_sel1 = mult_in1;
        end
        GPS: begin
            case(cnt)
                0: begin
                    mult_sel0 = mult_in0;
                    mult_sel1 = $signed(add_tempReg0);
                end
                1: begin
                    mult_sel0 = $signed(adder);
                    mult_sel1 = $signed({{112{1'b0}},rad});
                end
                2, 5: begin     // rounding after multiplying
                    mult_sel0 = $signed({multiplier[17+:112],16'd0}) + $signed({{112{1'b0}},round_bit,16'd0}); // 48 bits fixed
                    mult_sel1 = $signed({multiplier[17+:112],16'd0}) + $signed({{112{1'b0}},round_bit,16'd0});
                end
                3: begin
                    mult_sel0 = $signed(multiplier[32+:128]); // 96 -> 64 bits fixed
                    mult_sel1 = $signed(temp);//64
                end
                4: begin
                    mult_sel0 = $signed(adder);                 // 32 fixed
                    mult_sel1 = $signed({{112{1'b0}},rad});
                end
                default: begin
                    mult_sel0 = mult_sel0;
                    mult_sel1 = mult_sel1;
                end
            endcase
        end
        FINAL: begin
            mult_sel0 = mult_in0;
            mult_sel1 = 128'd12756274;
        end
        default: begin
            mult_sel0 = mult_in0;
            mult_sel1 = mult_in1;
        end
    endcase
end

//wire [15:0] rad_neg;
assign rad_neg = ~rad + 16'd1;

//wire [15:0] rad;
assign rad = 16'h477;

// Dividor
//wire subtract_condition;
assign subtract_condition = (divide_compare >= divisor);

//wire division_done;
assign division_done = (sineProcess) ? (cnt == 7'd127) : (cnt == 7'd95);

//wire [63:0]  divide_compare;
assign divide_compare = {temp[62:0],dividend[127]};

// reg [127:0] dividend;
// reg [63:0] divisor;
always @(posedge clk or negedge reset_n) begin
    if(!reset_n) begin
        dividend <= 128'd0;
        divisor <= 64'd0;
    end else begin
        case (state)
            CAL: begin
                if(cnt == 7'd3) begin
                    dividend <= multiplier;
                end else if(cnt == 7'd6) begin
                    `ifdef DEBUG
                        dividend <= 128'd1589090;
                    `else
                        dividend <= (sineProcess) ? {adder,32'd0} : {adder,64'd0};  //adjust fixed 
                    `endif
                end
                if(cnt == 7'd5) begin
                    `ifdef DEBUG
                        divisor <= 64'd88;
                    `else
                        divisor <= adder;
                    `endif
                end
            end
            DIVISION: begin
                dividend <= {dividend[126:0],1'b0}; // left shift
            end
            GPS: begin
                dividend <= (cnt == 7'd0) ? mult_in0 : dividend;
            end
            default: begin
                dividend <= dividend;
                divisor <= divisor;
            end
        endcase
    end
end

assign gps_cal_done = (cnt == 7'd7);
assign cal_done = (cnt == 7'd6);

// Counter
// reg [5:0] cnt;
always @(posedge clk or negedge reset_n) begin
    if(!reset_n) begin
        cnt <= 7'd0;
    end else begin
        case(state)
            CAL: begin
                if(cal_done) begin
                    cnt <= 7'd0;
                end else begin
                    cnt <= cnt + 7'd1;
                end
            end
            DIVISION: begin
                if(division_done) begin
                    cnt <= 7'd0;
                end else begin
                    cnt <= cnt + 7'd1;
                end
            end
            GPS: begin
                if(gps_cal_done) begin
                    cnt <= 7'd0;
                end else begin
                    cnt <= cnt + 7'd1;
                end
            end
            FINAL: begin
                if(final) begin
                    cnt <= 7'd0;
                end else begin
                    cnt <= cnt + 7'd1;
                end
            end
            default: cnt <= 7'd0;
        endcase
    end    
end

//reg  secondData;
always @(posedge clk or negedge reset_n) begin
    if(!reset_n) begin
        secondData <= 1'b0;
    end else if(state == COS_TABLE && cos_done && lat_b != 24'd0) begin
        secondData <= 1'b1;
    end
end

// look up table for asine
//output reg [5:0]   ASIN_ADDR;   // arcsine
always @(posedge clk or negedge reset_n) begin
    if(!reset_n) begin
        ASIN_ADDR <= 6'd0;
    end else if(state == SINE_TABLE && !sine_done) begin
        ASIN_ADDR <= ASIN_ADDR + 6'd1;
    end else if(state == IDLE) begin
        ASIN_ADDR <= 6'd0;
    end
end

// sine flag
always @(posedge clk or negedge reset_n) begin
    if(!reset_n) begin
        sineProcess <= 1'b0;
    end else if(state == IDLE) begin
        sineProcess <= 1'b0;
    end else if(state == SINE_TABLE) begin
        sineProcess <= 1'b1;
    end
end

// final output
assign D     = multiplier[64+:40];
assign final = (cnt == 7'd1);
assign Valid = (final && state == FINAL);

always @(posedge clk or negedge reset_n) begin
    if(!reset_n) begin
        a <= 64'd0;
    end else if(state == GPS && gps_cal_done) begin
        a <= adder[63:0];
    end
end

// debug
// integer i = 0;
// `ifdef DEBUG
//     initial begin
//         forever begin
//             @(posedge clk);
//             if(Valid) begin
//                 $display("%d -> %3d", i, $time);
//                 i = i + 1;
//             end
//         end
//     end
// `endif

endmodule

// 00010001110111000 23b8 X
// 00010001111000000 23C0 X

// 00010001110110000 23b0 O
// 00100011101110000 477


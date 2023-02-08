module geofence ( 
    clk,
    reset,
    X,
    Y,
    R,
    valid,
    is_inside
);

//--------------------------------------------------------------------
// Parameter Declaration
//--------------------------------------------------------------------
localparam WIDTH        = 20;
localparam IDLE         = 4'd0;
localparam VECTOR       = 4'd1;
localparam PRODUCT      = 4'd2;
localparam EXCHANGE     = 4'd3;
localparam AREA_HEXAGON = 4'd4;
localparam NEXT_POINT   = 4'd5;
localparam CREATE_SIDE  = 4'd6;
localparam TRIANGLE     = 4'd7;
localparam COMPARE      = 4'd8;

//--------------------------------------------------------------------
// Input & Output Declaration
//--------------------------------------------------------------------
input clk;
input reset;
input [9:0] X;
input [9:0] Y;
input [10:0] R;     // distance
output reg valid;
output reg is_inside;
//reg valid;
//reg is_inside;

//--------------------------------------------------------------------
// Reg & Wire Declaration
//--------------------------------------------------------------------
integer i;
// flag
wire area_start;
wire vector_done;
wire receive_done;
wire product_done;
wire triangle_area_done;
reg sort_done;
// state machine
reg [3:0] state, next_state;
// store input data
reg [10:0] distance[0:5];
reg signed [10:0] pointX[0:5];   
reg signed [10:0] pointY[0:5];   
// vector
reg signed [10:0] vector_a[0:1]; // x y
reg signed [10:0] vector_b[0:1]; // x y
reg signed [21:0] product_result;
// multiplier
reg  signed [11:0] mult_in1, mult_in2;
wire signed [23:0] mult_out;
// substrct
reg  signed [21:0] sub_in1, sub_in2;
wire signed [21:0] sub_out;
// cnt
reg [2:0] nextPointCnt;
reg [3:0] cnt;
// root function
wire signed [9:0]  root_out; 
reg  signed [19:0] root_in;
// triangle
reg signed [19:0] side;
reg signed [11:0] s;
reg [21:0] triangle;
// hexagon
reg [19:0] hexagon;
// adder
reg  signed [11:0] add_in1, add_in2;
wire signed [11:0] add_out;
//
reg signed [21:0] buffer;
reg signed [21:0] buffer2;

//--------------------------------------------------------------------
// State Machine
//--------------------------------------------------------------------
//reg [3:0] state, next_state;
always @(posedge clk or posedge reset) begin
    if(reset) state <= IDLE;
    else state <= next_state;
end

always @(*) begin
    case(state)
        IDLE:           next_state = (receive_done) ? VECTOR : IDLE;
        VECTOR:         next_state = (vector_done) ? PRODUCT : VECTOR;
        PRODUCT:        begin
                            if(area_start) begin
                                next_state = AREA_HEXAGON;
                            end else begin
                                next_state = (product_done) ? EXCHANGE : PRODUCT; 
                            end
                        end
        EXCHANGE:       next_state = VECTOR;
        AREA_HEXAGON:   next_state = (vector_done) ? NEXT_POINT : AREA_HEXAGON;
        NEXT_POINT:     next_state = (nextPointCnt == 3'd5) ? CREATE_SIDE : AREA_HEXAGON;
        CREATE_SIDE:    next_state = (cnt == 4'd6) ? TRIANGLE : CREATE_SIDE;
        TRIANGLE:       begin
                            if(nextPointCnt == 3'd5 && triangle_area_done) begin
                                next_state = COMPARE;
                            end else if(triangle_area_done) begin
                                next_state = CREATE_SIDE;
                            end else begin
                                next_state = TRIANGLE;
                            end
                        end
        default:        next_state = IDLE;
    endcase
end

//--------------------------------------------------------------------
// Received Data
//--------------------------------------------------------------------
//reg signed [10:0] pointX[0:5], pointY[0:5];
always @(posedge clk or posedge reset) begin
    if(reset) begin
        for(i = 0; i < 6; i = i + 1) begin
            pointX[i] <= 11'd0;
            pointY[i] <= 11'd0;
            distance[i] <= 11'd0;
        end
    end else begin
        case(state)
            IDLE:       begin
                            pointX[cnt] <= $signed({1'b0,X});
                            pointY[cnt] <= $signed({1'b0,Y});
                            distance[cnt] <= R;
                        end
            EXCHANGE:   begin
                            if(~product_result[21]) begin
                                pointX[nextPointCnt+1] <= pointX[nextPointCnt+2];
                                pointX[nextPointCnt+2] <= pointX[nextPointCnt+1];
                                pointY[nextPointCnt+1] <= pointY[nextPointCnt+2];
                                pointY[nextPointCnt+2] <= pointY[nextPointCnt+1];
                                distance[nextPointCnt+2] <= distance[nextPointCnt+1];
                                distance[nextPointCnt+1] <= distance[nextPointCnt+2];
                            end
                        end
            default:    begin
                            for(i = 0; i < 6; i = i + 1) begin
                                pointX[i] <= pointX[i];
                                pointY[i] <= pointY[i];
                                distance[i] <= distance[i];
                            end
                        end
        endcase
    end
end

//--------------------------------------------------------------------
// Vector
//--------------------------------------------------------------------
// reg signed [10:0] vector_a[0:1]; // x y
// reg signed [10:0] vector_b[0:1]; // x y
always @(posedge clk or posedge reset) begin
    if(reset) begin
        vector_a[0] <= 11'd0;
        vector_a[1] <= 11'd0;
        vector_b[0] <= 11'd0;
        vector_b[1] <= 11'd0;
    end else begin
        case(state)
            VECTOR:     begin
                            case (cnt)
                                4'd0:       vector_a[0] <= sub_out;      // vectorA x
                                4'd1:       vector_a[1] <= sub_out;      // vectorA y
                                4'd2:       vector_b[0] <= sub_out;      // vectorB x
                                4'd3:       vector_b[1] <= sub_out;      // vectorB y
                                default:    begin
                                                vector_a[0] <= vector_a[0];
                                                vector_a[1] <= vector_a[1];
                                                vector_b[0] <= vector_b[0];
                                                vector_b[1] <= vector_b[1];
                                            end
                            endcase
                        end
            default:    begin
                            vector_a[0] <= vector_a[0];
                            vector_a[1] <= vector_a[1];
                            vector_b[0] <= vector_b[0];
                            vector_b[1] <= vector_b[1];
                        end
        endcase
    end
end

//reg signed [21:0] product_result;
always @(posedge clk or posedge reset) begin
    if(reset) begin
        product_result <= 22'd0;
    end else begin
        case(state)
            PRODUCT:    begin
                            case(cnt)
                                4'd0:       product_result <= $signed(mult_out[21:0]);
                                4'd2:       product_result <= $signed(product_result - mult_out[21:0]);
                                default:    product_result <= product_result;
                            endcase
                        end
            default:    product_result <= product_result;
        endcase
    end
end

//--------------------------------------------------------------------
// Counter & Flags
//--------------------------------------------------------------------
// wire triangle_area_done;
assign triangle_area_done = (cnt == 4'd9);

//wire receive_done;
assign receive_done = (cnt == 4'd5);

//wire vector_done;
assign vector_done = (cnt == 4'd3);

//wire product_done;
assign product_done = (cnt == 4'd2);

//wire area_start;
assign area_start = (sort_done && nextPointCnt == 3'd0);

//reg [3:0] cnt;
//reg [2:0] nextPointCnt;
always @(posedge clk or posedge reset) begin
    if(reset) begin
        //cnt <= 4'd0;
        nextPointCnt <= 3'd0;
    end else begin
        case(state)
            IDLE:           begin
                                //cnt <= (receive_done || valid) ? 4'd0 : cnt + 4'd1;
                                nextPointCnt <= 3'd0;    
                            end
           //VECTOR,
           //AREA_HEXAGON:    cnt <= (vector_done) ? 4'd0 : cnt + 4'd1;
           //PRODUCT:         cnt <= (product_done || area_start) ? 4'd0 : cnt + 4'd1;
            EXCHANGE:       nextPointCnt <= (nextPointCnt == 3'd3) ? 3'd0 : nextPointCnt + 3'd1;
            NEXT_POINT:     nextPointCnt <= (nextPointCnt == 3'd5) ? 3'd0 : nextPointCnt + 3'd1;
           //CREATE_SIDE:     cnt <= (cnt == 4'd6) ? 3'd0 : cnt + 4'd1;
            TRIANGLE:       begin
                                if(triangle_area_done) begin
                                    nextPointCnt <= nextPointCnt + 3'd1;
                                //    cnt <= 4'd0;
                                //end else begin
                                //   cnt <= cnt + 4'd1; 
                                end
                            end     
            default:        begin
                                //cnt <= 4'd0;    
                                nextPointCnt <= nextPointCnt;
                            end
        endcase
    end
end

//reg [3:0] cnt;
always @(posedge clk or posedge reset) begin
    if(reset) begin
        cnt <= 4'd0;
    end else begin
        case (state)
            IDLE:       cnt <= (receive_done || valid) ? 4'd0 : cnt + 4'd1;
            VECTOR,
            AREA_HEXAGON:   cnt <= (vector_done) ? 4'd0 : cnt + 4'd1;
            PRODUCT:        cnt <= (product_done || area_start) ? 4'd0 : cnt + 4'd1;
            CREATE_SIDE:    cnt <= (cnt == 4'd6) ? 4'd0 : cnt + 4'd1;
            TRIANGLE:       cnt <= (triangle_area_done) ? 4'd0 : cnt + 4'd1;
            default:    cnt <= 4'd0;
        endcase
    end
end


//reg sort_done;
always @(posedge clk or posedge reset) begin
    if(reset) begin
        sort_done <= 1'b1;
    end else begin
        case(state)
            VECTOR:     begin
                            if(nextPointCnt == 3'd0 && cnt == 4'd0) begin
                               sort_done <= ~sort_done; 
                            end
                        end
            EXCHANGE:   begin
                           if(~product_result[21]) begin
                               sort_done <= 1'b1;
                           end
                        end
            COMPARE:    sort_done <= 1'b1;
            default:    sort_done <= sort_done;
        endcase
    end
end


//---------------------------------------------------------------------
// Buffer
//---------------------------------------------------------------------
//reg[21:0] signed buffer, buffer2;
always @(posedge clk or posedge reset) begin
    if(reset) begin
        buffer <= 22'd0;
        buffer2 <= 22'd0;
    end else begin
        case (state)
            AREA_HEXAGON:   begin
                                case (cnt)
                                    4'd0:       buffer <= $signed({mult_out[23],mult_out[21:1]});
                                    4'd2:       buffer <= $signed(buffer - {mult_out[23],mult_out[21:1]});
                                    default:    buffer <= buffer;
                                endcase
                            end
            TRIANGLE:       begin
                                case (cnt)
                                    4'd2:       buffer <= sub_out;
                                    4'd3:       buffer <= $signed(mult_out[21:0]);
                                    4'd4:       begin
                                                    buffer <= $signed({{12{1'b0}},root_out});
                                                    buffer2 <= sub_out;
                                                end
                                    4'd6:       buffer2 <= $signed(mult_out[21:0]);
                                    4'd7:       buffer2 <= $signed({{12{1'b0}},root_out});
                                    4'd8:       buffer2 <= $signed(mult_out[21:0]);
                                    default:    buffer2 <= buffer2;
                                endcase
                            end 
            default:        buffer <= buffer;
        endcase
    end
end

//---------------------------------------------------------------------
// Substract
//---------------------------------------------------------------------
// wire signed [10:0] sub_out;
assign sub_out = sub_in1 - sub_in2;

// wire signed [10:0] sub_in1, sub_in2;
always @(*) begin
    case(state)
        VECTOR:         begin
                            case(cnt)
                                // vector A
                                4'd0:       begin
                                                sub_in1 = $signed({{11{pointX[nextPointCnt+1][10]}},pointX[nextPointCnt+1]});
                                                sub_in2 = $signed({{11{pointX[0][10]}},pointX[0]});
                                            end
                                4'd1:       begin
                                                sub_in1 = $signed({{11{pointY[nextPointCnt+1][10]}},pointY[nextPointCnt+1]});
                                                sub_in2 = $signed({{11{pointY[0][10]}},pointY[0]});   
                                            end
                                // vector B
                                4'd2:       begin
                                                sub_in1 = $signed({{11{pointX[nextPointCnt+2][10]}},pointX[nextPointCnt+2]});
                                                sub_in2 = $signed({{11{pointX[0][10]}},pointX[0]});    
                                            end
                                4'd3:       begin
                                                sub_in1 = $signed({{11{pointY[nextPointCnt+2][10]}},pointY[nextPointCnt+2]});
                                                sub_in2 = $signed({{11{pointY[0][10]}},pointY[0]});  
                                            end
                                default:    begin
                                                sub_in1 = 22'd0;
                                                sub_in2 = 22'd0;                                
                                            end
                            endcase
                        end
        AREA_HEXAGON:   begin
                            case(cnt)
                                4'd2:       begin
                                                sub_in1 = buffer;
                                                sub_in2 = $signed({mult_out[23],mult_out[21:1]});
                                            end
                                default:    begin
                                                sub_in1 = 22'd0;
                                                sub_in2 = 22'd0;                                
                                            end
                            endcase
                        end
        CREATE_SIDE:    begin
                            case(cnt)
                                4'd0,
                                4'd1,
                                4'd2:       begin
                                                sub_in1 = (nextPointCnt == 3'd5) ? $signed(pointX[0]) : $signed(pointX[nextPointCnt+1]);     // x0 - x1
                                                sub_in2 = pointX[nextPointCnt];
                                            end
                                default:    begin
                                                sub_in1 = (nextPointCnt == 3'd5) ? $signed(pointY[0]) : $signed(pointY[nextPointCnt+1]);
                                                sub_in2 = $signed(pointY[nextPointCnt]);
                                            end
                            endcase            
                        end
        TRIANGLE:       begin
                            case(cnt)
                                4'd2:       begin
                                                sub_in1 = s;     // s - a
                                                sub_in2 = $signed(distance[nextPointCnt]);
                                            end
                                4'd4:       begin
                                                sub_in1 = s;     // s - b
                                                sub_in2 = (nextPointCnt == 3'd5) ? $signed(distance[0]) : $signed(distance[nextPointCnt+1]);
                                            end
                                4'd5,
                                4'd6:       begin
                                                sub_in1 = s;     // s - c
                                                sub_in2 = $signed({{2{side[19]}},side});
                                            end
                                default:    begin
                                                sub_in1 = 22'd0;
                                                sub_in2 = 22'd0;   
                                            end
                            endcase  
                        end
        default:    begin
                        sub_in1 = 22'd0;
                        sub_in2 = 22'd0;
                    end
    endcase
end

//---------------------------------------------------------------------
// Multiplier
//---------------------------------------------------------------------
//wire signed [21:0] mult_out;
assign mult_out = $signed({{12{mult_in1[11]}},mult_in1} * {{12{mult_in2[11]}},mult_in2});
//assign mult_out = {{11{1'b0}},mult_in1} * {{11{1'b0}},mult_in2};

//wire signed [11:0] mult_in1, mult_in2;
always @(*) begin
    case(state)
        PRODUCT:         begin
                            case(cnt)
                                4'd0:       begin
                                                mult_in1 = vector_a[0]; // Ax
                                                mult_in2 = vector_b[1]; // By
                                            end
                                4'd1,
                                4'd2:       begin
                                                mult_in1 = vector_b[0]; // Bx
                                                mult_in2 = vector_a[1]; // Ay                    
                                            end
                                default:    begin
                                                mult_in1 = 11'd0;
                                                mult_in2 = 11'd0;                                
                                            end
                            endcase
                        end
        AREA_HEXAGON:   begin
                            case (cnt)
                                4'd0:       begin   // x1 * y0    nextPointCnt -> 0~4
                                                mult_in1 = (nextPointCnt == 3'd5) ? pointX[0] : pointX[nextPointCnt+1];  // x1 * y0
                                                mult_in2 = pointY[nextPointCnt];
                                            end
                                4'd1,       
                                4'd2:       begin   // y1 * x0
                                                mult_in1 = pointX[nextPointCnt];    // x0
                                                mult_in2 = (nextPointCnt == 3'd5) ? pointY[0] : pointY[nextPointCnt+1];  // y1
                                            end
                                default:    begin
                                                mult_in1 = 12'd0;
                                                mult_in2 = 12'd0;
                                            end
                            endcase
                        end
        CREATE_SIDE:    begin
                            mult_in1 = $signed(sub_out[11:0]);
                            mult_in2 = $signed(sub_out[11:0]);
                        end
        TRIANGLE:       begin
                            case (cnt)
                                4'd3:       begin   // s * (s-a)
                                                mult_in1 = $signed(buffer[11:0]);
                                                mult_in2 = $signed({s[11],s});
                                            end
                                4'd6:       begin
                                                mult_in1 = $signed(sub_out[11:0]);
                                                mult_in2 = $signed(buffer2[11:0]);
                                            end
                                4'd8:       begin
                                                mult_in1 = $signed(buffer[11:0]);
                                                mult_in2 = $signed(buffer2[11:0]);
                                            end
                                default:    begin
                                                mult_in1 = 12'd0;
                                                mult_in2 = 12'd0;
                                            end
                            endcase
                        end
        default:    begin
                        mult_in1 = 12'd0;
                        mult_in2 = 12'd0;
                    end
    endcase
end

//---------------------------------------------------------------------
// adder
//---------------------------------------------------------------------
// reg  signed [11:0] add_in1, add_in2;
always @(*) begin
    if(state == TRIANGLE) begin
        case(cnt) 
            4'd0:       begin
                            add_in1 = (nextPointCnt == 3'd5) ? $signed(distance[0]) : $signed(distance[nextPointCnt+1]);
                            add_in2 = $signed(distance[nextPointCnt]);
                        end
            4'd1:       begin
                            add_in1 = $signed(s[11:0]);
                            add_in2 = $signed(side[11:0]);
                        end
            default:    begin
                            add_in1 = 10'd0;
                            add_in2 = 10'd0;
                        end
        endcase
    end else begin
        add_in1 = 10'd0;
        add_in2 = 10'd0;
    end   
end

// wire signed [11:0] add_out;
assign add_out = add_in1 + add_in2;

//---------------------------------------------------------------------
// Area of Hexagon
//---------------------------------------------------------------------
//reg [19:0] hexagon
always @(posedge clk or posedge reset) begin
    if(reset) begin
        hexagon <= 20'd0;
    end else if(state == AREA_HEXAGON && vector_done) begin
        hexagon <= hexagon + $unsigned(buffer);
    end else if(state == COMPARE) begin
        hexagon <= 20'd0;
    end
end

//--------------------------------------------------------------------
// Triangle
//--------------------------------------------------------------------
//reg signed [21:0] triangle;
always @(posedge clk or posedge reset) begin
    if(reset) begin
        triangle <= 22'd0;
    end else if(state == TRIANGLE && triangle_area_done) begin
        triangle <= triangle + $unsigned(buffer2);
    end else if(state == IDLE) begin
        triangle <= 22'd0;
    end
end

//reg signed [19:0] side;
always @(posedge clk or posedge reset) begin
    if(reset) begin
        side <= 20'd0;
    end else begin
        case (state)
            CREATE_SIDE:    begin
                                case (cnt)
                                    4'd2:       side <= $signed(mult_out[19:0]);
                                    4'd5:       side <= $signed(side + mult_out[19:0]);
                                    4'd6:       side <= $signed({10'd0,root_out});
                                    default:    side <= side;
                                endcase
                            end
            default:        side <= side;
        endcase
    end
end

//reg signed [11:0] s;
always @(posedge clk or posedge reset) begin
    if(reset) begin
        s <= 12'd0;
    end else if(state == TRIANGLE) begin
        case (cnt)
            4'd0:       s <= add_out;
            4'd1:       s <= $signed({1'b0, add_out[11:1]});
            default:    s <= s;
        endcase
    end
end

//--------------------------------------------------------------------
// Root
//--------------------------------------------------------------------
// wire root_out
assign root_out = DWF_sqrt_uns(root_in);
//assign root_out = root_in;
//assign root_out = $sqrt($unsigned(root_in));
//reg root_in;
always @(*) begin
    case (state)
        CREATE_SIDE:    root_in = side;
        TRIANGLE:       begin
                            case (cnt)
                                4'd4:       root_in = (buffer[21]) ? $signed(~buffer[19:0] + 20'd1) : $signed(buffer[19:0]); 
                                4'd7:       root_in = (buffer2[21]) ? $signed(~buffer2[19:0] + 20'd1) : $signed(buffer2[19:0]);
                                default:    root_in = 20'd0;
                            endcase
                        end
        default:        root_in = 20'd0;
    endcase
end

//---------------------------------------------------------------------
// Output Signal
//---------------------------------------------------------------------
// output reg valid;
// output reg is_inside;
always @(posedge clk or posedge reset) begin
    if(reset) begin
        valid <= 1'b0;
        is_inside <= 1'b0;
    end else if(state == COMPARE) begin
        valid <= 1'b1;
        if(triangle > {2'd0,hexagon}) begin
            is_inside <= 1'b0;
        end else begin
            is_inside <= 1'b1;
        end
    end else begin
        is_inside <= 1'b0;
        valid <= 1'b0;
    end
end

//---------------------------------------------------------------------
// Function
//---------------------------------------------------------------------

////////////////////////////////////////////////////////////////////////////////
//
//       This confidential and proprietary software may be used only
//     as authorized by a licensing agreement from Synopsys Inc.
//     In the event of publication, the following notice is applicable:
//
//                    (C) COPYRIGHT 2000 - 2020 SYNOPSYS INC.
//                           ALL RIGHTS RESERVED
//
//       The entire notice above must be reproduced on all authorized
//     copies.
//
// AUTHOR:    Reto Zimmermann		May 10, 2000
//
// VERSION:   Verilog Simulation Functions
//
// NOTE:      This is a subentity.
//            This file is for internal use only.
//
// DesignWare_version: f4854cdd
// DesignWare_release: Q-2019.12-DWBB_201912.0
//
////////////////////////////////////////////////////////////////////////////////
//
// ABSTRACT: Verilog Function Descriptions for Combinational Square Root
//
//           Function descriptions for square root computation
//           used for synthesis inference of function calls
//           and for behavioral Verilog simulation.
//
//           The following functions are declared:
//
//           DWF_sqrt_uns (a, b)
//           DWF_sqrt_tc (a, b)
//
// MODIFIED: 
//
//-----------------------------------------------------------------------------

  function [(WIDTH+1)/2-1 : 0] DWF_sqrt_uns;
    // Function to compute the unsigned square root
    
    // synopsys map_to_operator SQRT_UNS_OP
    // synopsys return_port_name ROOT

    input [WIDTH-1 : 0] A;

    reg [(WIDTH+1)/2-1 : 0] ROOT_v;
    reg A_x;
    integer i;

    begin
      // synopsys translate_off
      A_x = ^A;
      if (A_x === 1'bx) begin
	    ROOT_v = {(WIDTH+1)/2{1'bx}};
      end else begin
	    ROOT_v = {(WIDTH+1)/2{1'b0}};
	    for (i = (WIDTH+1)/2-1; i >= 0; i = i-1) begin
	        ROOT_v[i] = 1'b1;
	        if (ROOT_v*ROOT_v > {1'b0,A}) begin
                ROOT_v[i] = 1'b0;
            end
	    end
      end
      DWF_sqrt_uns = ROOT_v;
      // synopsys translate_on
    end
  endfunction // DWF_sqrt_uns

  
  function [(WIDTH+1)/2-1 : 0] DWF_sqrt_tc;
    // Function to compute the signed square root
    
    // synopsys map_to_operator SQRT_TC_OP
    // synopsys return_port_name ROOT

    input [WIDTH-1 : 0] A;

    reg [(WIDTH+1)/2-1 : 0] ROOT_v;
    reg [WIDTH-1 : 0] A_v, A_x;
    integer i;

    begin
      // synopsys translate_off
      A_x = ^A;
      if (A_x === 1'bx) begin
	    ROOT_v = {(WIDTH+1)/2{1'bx}};
      end else begin
	    if (A[WIDTH-1] == 1'b1) begin
            A_v = ~A + 1'b1;
        end else begin
            A_v = A;
        end
	    ROOT_v = DWF_sqrt_uns (A_v);
      end
      DWF_sqrt_tc = ROOT_v;
      // synopsys translate_on
    end
  endfunction // DWF_sqrt_tc

//-----------------------------------------------------------------------------

endmodule

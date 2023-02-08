module temp (
    CLK,
    RST,
    Cost,
    W,
    J,
    MatchCount,
    MinCost,
    Valid 
);

//---------------------------------------------------------
// Parameter Declaraiton
//---------------------------------------------------------
localparam IDLE           = 0;
localparam EXCHANGE_POINT = 1;
localparam FIND_INDEX     = 2;
localparam EXCHANGE       = 3;
localparam INVERSE        = 4;
localparam COST           = 5;

//---------------------------------------------------------
// Input & Output Declaration
//---------------------------------------------------------
input CLK;
input RST;
// Work List
input  [6:0] Cost;
output reg [2:0] W;     // w worker
output reg [2:0] J;     // j job
// Ouput Signal
output reg [3:0] MatchCount;
output reg [9:0] MinCost;
output reg Valid;
// n = 8

//---------------------------------------------------------
// Reg & Wire
//---------------------------------------------------------
integer i;
//  State Machine
reg [2:0] state, next_state;
//  Algorithm
reg [3:0] cnt;
reg [2:0] array[0:7];   // 7 6 5 4 3 2 1 0   ---->  0 1 2 3 4 5 6 7
// reg [2:0] change_point; // all stage
// reg [2:0] change_index; // stage 2
reg [9:0] cost;
// compare
wire compare_out;
reg  [9:0] compare_in1, compare_in2;
// flags
wire inverse_done;
wire find_index_done;
wire cost_done;
wire find_change_point_done;
wire final_point;
wire first_point;

//---------------------------------------------------------
// State Machine
//---------------------------------------------------------
//reg [2:0] state, next_state;
always @(posedge CLK or posedge RST) begin
    if(RST) state <= IDLE;
    else state <= next_state;
end

always @(*) begin
    case(state)
        IDLE:           next_state = (first_point) ? COST : EXCHANGE_POINT;
        EXCHANGE_POINT: next_state = (find_change_point_done) ? FIND_INDEX : EXCHANGE_POINT;
        FIND_INDEX:     next_state = (find_index_done) ? EXCHANGE : FIND_INDEX;
        EXCHANGE:       next_state = INVERSE;
        INVERSE:        next_state = (inverse_done) ? COST : INVERSE;
        COST:           begin
                            if(first_point) begin
                                next_state = (cost_done) ? EXCHANGE_POINT : COST;
                            end else begin
                                next_state = (cost_done || compare_out) ? EXCHANGE_POINT : COST;
                            end
                        end
        default:        next_state = IDLE;
    endcase
end

//---------------------------------------------------------
//  Algorithm
//---------------------------------------------------------
// reg [2:0] change_point; // all stage
// always @(posedge CLK or posedge RST) begin
//     if(RST) begin
//         change_point <= 3'd0;
//     end else if(state == EXCHANGE_POINT) begin
//         change_point <= (compare_out) ? cnt[2:0] + 3'd1 : 3'd0;
//     end
// end

// //reg [2:0] change_index; // stage 2
// always @(posedge CLK or posedge RST) begin
//     if(RST) begin
//         change_index <= 3'd0;
//     end else begin
//         case(state)
//             EXCHANGE_POINT: change_index <= (find_change_point_done) ? cnt[2:0] : change_index;
//             FIND_INDEX:     change_index <= (compare_out && array[cnt] < array[change_index]) ? cnt : change_index;
//             default:        change_index <= 3'd0;
//         endcase
//     end
// end

// reg [2:0] array[0:7];   // 7 6 5 4 3 2 1 0   ---->  0 1 2 3 4 5 6 7
always @(posedge CLK or posedge RST) begin
    if(RST) begin
        for(i = 7; i >= 0; i = i - 1) begin
            array[7-i] <= i;
        end
    end else begin
        case(state)
            EXCHANGE:   begin
                            array[W] <= array[J];
                            array[J] <= array[W];
                        end
            INVERSE:    begin
                            for(i = cnt; i < J[2:1]; i = i + 1) begin
                                array[i] <= array[J-1-i];
                                array[J-cnt-1] <= array[cnt];
                            end
                            // if(~inverse_done) begin
                            //     array[cnt] <= array[J-cnt-1];
                            //     array[J-cnt-1] <= array[cnt];
                            // end
                        end
            default:    begin
                            for(i = 0; i < 8; i = i + 1) begin
                                array[i] <= array[i];
                            end
                        end
        endcase
    end
end

//reg [8:0] cost;
always @(posedge CLK or posedge RST) begin
    if(RST) begin
        cost <= 10'd0;
    end else begin
        case(state)
            COST:       cost <= (cnt != 4'd0) ? cost + Cost : 10'd0;
            default:    cost <= 10'd0;
        endcase
    end
end

//---------------------------------------------------------
// Counter & Flags
//---------------------------------------------------------
//wire inverse_done
assign inverse_done = (cnt == {2'd0,J[2:1]});

//wire find_index_done;
assign find_index_done = (cnt == 4'd0);

//wire cost_done
assign cost_done = (cnt == 4'd9);

//wire first_point;
assign first_point = (array[0] == 3'd7 && array[1] == 3'd6 && array[2] == 3'd5 && array[3] == 3'd4 && array[4] == 3'd3 && array[5] == 3'd2 && array[6] == 3'd1 && array[7] == 3'd0);

//final_point 0 1 2 3 4 5 6 7
assign final_point = (array[0] == 3'd0 && array[1] == 3'd1 && array[2] == 3'd2 && array[3] == 3'd3 && array[4] == 3'd4 && array[5] == 3'd5 && array[6] == 3'd6 && array[7] == 3'd7);

//wire find_change_point_done;
assign find_change_point_done = (cnt == 4'd6 | compare_out);

//reg [3:0] cnt;
always @(posedge CLK or posedge RST) begin
    if(RST) begin
        cnt <= 4'd0;
    end else begin
        case(state)
            EXCHANGE_POINT: cnt <= (find_change_point_done && ~find_change_point_done) ? cnt - 4'd1 : cnt + 4'd1;
            FIND_INDEX:     cnt <= (find_index_done) ? cnt : cnt - 4'd1;
            INVERSE:        cnt <= (inverse_done) ? 4'd0 : cnt + 4'd1;
            COST:           cnt <= ((~first_point && compare_out) || cost_done) ? 4'd0 : cnt + 4'd1;
            default:        cnt <= 4'd0;
        endcase
    end
end

//---------------------------------------------------------
// Compare
//---------------------------------------------------------
assign compare_out = (compare_in1 > compare_in2) ? 1'b1 : 1'b0;
// output reg [2:0] J;     // j job     J --> change_point
// output reg [2:0] W;     // w worker  W --> change_index
//reg  [2:0] compare_in1, compare_in2;
always @(*) begin
    case(state)
        EXCHANGE_POINT: begin
                            compare_in1 = {7'd0,array[cnt]};
                            compare_in2 = {7'd0,array[cnt+1]};
                        end
        FIND_INDEX:     begin
                            compare_in1 = {7'd0,array[cnt]};
                            compare_in2 = {7'd0,array[J]};
                        end
        COST:           begin
                            compare_in1 = cost;
                            compare_in2 = MinCost;
                        end
        default:        begin
                            compare_in1 = 3'd0;
                            compare_in2 = 3'd0;
                        end
    endcase
end

//---------------------------------------------------------
// Output Signal Table
//---------------------------------------------------------
// input  [6:0] Cost;

// output reg [2:0] J;     // j job     J --> change_point
always @(posedge CLK or posedge RST) begin
    if(RST) begin
        J <= 3'd0;
    end else begin
        case(state)
            EXCHANGE_POINT: J <= (compare_out) ? cnt[2:0] + 3'd1 : 3'd0;    
            COST:           J <= (cnt < 4'd8) ? array[cnt] : 3'd0;
            default:        J <= J;
        endcase
    end
end

// output reg [2:0] W;     // w worker  W --> change_index
always @(posedge CLK or posedge RST) begin
    if(RST) begin
        W <= 3'd0;
    end else begin
        case(state)
            EXCHANGE_POINT: W <= (find_change_point_done) ? cnt[2:0] : W;
            FIND_INDEX:     W <= (compare_out && array[cnt] < array[W]) ? cnt : W;
            COST:           W <= (cnt != 4'd0) ? W + 4'd1 : 3'd0;
            default:        W <= 3'd0;
        endcase
    end
end

//---------------------------------------------------------
// Output Signal Cost
//---------------------------------------------------------
// output reg [3:0] MatchCount;
always @(posedge CLK or posedge RST) begin
    if(RST) begin
        MatchCount <= 4'd1;
    end else if(state == COST && cost_done) begin
        if(cost < MinCost)
            MatchCount <= 4'd1;
        else begin
            MatchCount <= (cost == MinCost) ? MatchCount + 4'd1 : MatchCount;
        end
    end
end

// output reg [9:0] MinCost;
always @(posedge CLK or posedge RST) begin
    if(RST) begin
        MinCost <= 10'd0;
    end else begin
        case(state)
            COST:       MinCost <= ((first_point && cost_done) || cost_done && ~compare_out) ? cost : MinCost;
            default:    MinCost <= MinCost;
        endcase
    end
end

// output reg Valid ;
always @(posedge CLK or posedge RST) begin
    if(RST) begin
        Valid <= 1'b0;
    end else if(state == COST && (cost_done || compare_out) && final_point) begin
        Valid <= 1'b1;
    end else begin
        Valid <= 1'b0;
    end
end

//---------------------------------------------------------
// FOR DEBUG
//---------------------------------------------------------
always @(posedge CLK) begin
    if(state == COST && cost_done && cost == 119) begin
       $display("time : %d\n", $time); 
    end
end

endmodule

********************************************************************************************************************
// for one clock
********************************************************************************************************************
module JAM (
    CLK,
    RST,
    Cost,
    W,
    J,
    MatchCount,
    MinCost,
    Valid 
);

//---------------------------------------------------------
// Parameter Declaraiton
//---------------------------------------------------------
localparam IDLE           = 0;
localparam EXCHANGE_POINT = 1;
localparam FIND_INDEX     = 2;
localparam EXCHANGE       = 3;
localparam INVERSE        = 4;
localparam COST           = 5;

//---------------------------------------------------------
// Input & Output Declaration
//---------------------------------------------------------
input CLK;
input RST;
// Work List
input  [6:0] Cost;
output reg [2:0] W;     // w worker
output reg [2:0] J;     // j job
// Ouput Signal
output reg [3:0] MatchCount;
output reg [9:0] MinCost;
output reg Valid;
// n = 8

//---------------------------------------------------------
// Reg & Wire
//---------------------------------------------------------
integer i;
//  State Machine
reg [2:0] state, next_state;
//  Algorithm
reg [3:0] cnt;
reg [2:0] array[0:7];   // 7 6 5 4 3 2 1 0   ---->  0 1 2 3 4 5 6 7
// reg [2:0] change_point; // all stage
// reg [2:0] change_index; // stage 2
reg [9:0] cost;
// compare
wire compare_out;
reg  [9:0] compare_in1, compare_in2;
// flags
//wire inverse_done;
wire find_index_done;
wire cost_done;
wire find_change_point_done;
wire final_point;
wire first_point;

//---------------------------------------------------------
// State Machine
//---------------------------------------------------------
//reg [2:0] state, next_state;
always @(posedge CLK or posedge RST) begin
    if(RST) state <= IDLE;
    else state <= next_state;
end

always @(*) begin
    case(state)
        IDLE:           next_state = (first_point) ? COST : EXCHANGE_POINT;
        EXCHANGE_POINT: next_state = (find_change_point_done) ? FIND_INDEX : EXCHANGE_POINT;
        FIND_INDEX:     next_state = (find_index_done) ? EXCHANGE : FIND_INDEX;
        EXCHANGE:       next_state = INVERSE;
        INVERSE:        next_state = COST;
        COST:           begin
                            if(first_point) begin
                                next_state = (cost_done) ? EXCHANGE_POINT : COST;
                            end else begin
                                next_state = (cost_done || compare_out) ? EXCHANGE_POINT : COST;
                            end
                        end
        default:        next_state = IDLE;
    endcase
end

//---------------------------------------------------------
//  Algorithm
//---------------------------------------------------------
// reg [2:0] change_point; // all stage
// always @(posedge CLK or posedge RST) begin
//     if(RST) begin
//         change_point <= 3'd0;
//     end else if(state == EXCHANGE_POINT) begin
//         change_point <= (compare_out) ? cnt[2:0] + 3'd1 : 3'd0;
//     end
// end

// //reg [2:0] change_index; // stage 2
// always @(posedge CLK or posedge RST) begin
//     if(RST) begin
//         change_index <= 3'd0;
//     end else begin
//         case(state)
//             EXCHANGE_POINT: change_index <= (find_change_point_done) ? cnt[2:0] : change_index;
//             FIND_INDEX:     change_index <= (compare_out && array[cnt] < array[change_index]) ? cnt : change_index;
//             default:        change_index <= 3'd0;
//         endcase
//     end
// end

// reg [2:0] array[0:7];   // 7 6 5 4 3 2 1 0   ---->  0 1 2 3 4 5 6 7
always @(posedge CLK or posedge RST) begin
    if(RST) begin
        for(i = 7; i >= 0; i = i - 1) begin
            array[7-i] <= i;
        end
    end else begin
        case(state)
            EXCHANGE:   begin
                            array[W] <= array[J];
                            array[J] <= array[W];
                        end
            INVERSE:    begin
                            for(i = cnt; i < J[2:1]; i = i + 1) begin
                                array[i] <= array[J-1-i];
                                array[J-i-1] <= array[i];
                            end
                        end
            default:    begin
                            for(i = 0; i < 8; i = i + 1) begin
                                array[i] <= array[i];
                            end
                        end
        endcase
    end
end

//reg [8:0] cost;
always @(posedge CLK or posedge RST) begin
    if(RST) begin
        cost <= 10'd0;
    end else begin
        case(state)
            COST:       cost <= (cnt != 4'd0) ? cost + Cost : 10'd0;
            default:    cost <= 10'd0;
        endcase
    end
end

//---------------------------------------------------------
// Counter & Flags
//---------------------------------------------------------
//wire find_index_done;
assign find_index_done = (cnt == 4'd0);

//wire cost_done
assign cost_done = (cnt == 4'd9);

//wire first_point;
assign first_point = (array[0] == 3'd7 && array[1] == 3'd6 && array[2] == 3'd5 && array[3] == 3'd4 && array[4] == 3'd3 && array[5] == 3'd2 && array[6] == 3'd1 && array[7] == 3'd0);

//final_point 0 1 2 3 4 5 6 7
assign final_point = (array[0] == 3'd0 && array[1] == 3'd1 && array[2] == 3'd2 && array[3] == 3'd3 && array[4] == 3'd4 && array[5] == 3'd5 && array[6] == 3'd6 && array[7] == 3'd7);

//wire find_change_point_done;
assign find_change_point_done = (cnt == 4'd6 | compare_out);

//reg [3:0] cnt;
always @(posedge CLK or posedge RST) begin
    if(RST) begin
        cnt <= 4'd0;
    end else begin
        case(state)
            EXCHANGE_POINT: cnt <= (find_change_point_done && ~find_change_point_done) ? cnt - 4'd1 : cnt + 4'd1;
            FIND_INDEX:     cnt <= (find_index_done) ? cnt : cnt - 4'd1;
            //INVERSE:        cnt <= (inverse_done) ? 4'd0 : cnt + 4'd1;
            INVERSE:        cnt <= 4'd0;
            COST:           cnt <= ((~first_point && compare_out) || cost_done) ? 4'd0 : cnt + 4'd1;
            default:        cnt <= 4'd0;
        endcase
    end
end

//---------------------------------------------------------
// Compare
//---------------------------------------------------------
assign compare_out = (compare_in1 > compare_in2) ? 1'b1 : 1'b0;
// output reg [2:0] J;     // j job     J --> change_point
// output reg [2:0] W;     // w worker  W --> change_index
//reg  [2:0] compare_in1, compare_in2;
always @(*) begin
    case(state)
        EXCHANGE_POINT: begin
                            compare_in1 = {7'd0,array[cnt]};
                            compare_in2 = {7'd0,array[cnt+1]};
                        end
        FIND_INDEX:     begin
                            compare_in1 = {7'd0,array[cnt]};
                            compare_in2 = {7'd0,array[J]};
                        end
        COST:           begin
                            compare_in1 = cost;
                            compare_in2 = MinCost;
                        end
        default:        begin
                            compare_in1 = 3'd0;
                            compare_in2 = 3'd0;
                        end
    endcase
end

//---------------------------------------------------------
// Output Signal Table
//---------------------------------------------------------
// input  [6:0] Cost;

// output reg [2:0] J;     // j job     J --> change_point
always @(posedge CLK or posedge RST) begin
    if(RST) begin
        J <= 3'd0;
    end else begin
        case(state)
            EXCHANGE_POINT: J <= (compare_out) ? cnt[2:0] + 3'd1 : 3'd0;    
            COST:           J <= (cnt < 4'd8) ? array[cnt] : 3'd0;
            default:        J <= J;
        endcase
    end
end

// output reg [2:0] W;     // w worker  W --> change_index
always @(posedge CLK or posedge RST) begin
    if(RST) begin
        W <= 3'd0;
    end else begin
        case(state)
            EXCHANGE_POINT: W <= (find_change_point_done) ? cnt[2:0] : W;
            FIND_INDEX:     W <= (compare_out && array[cnt] < array[W]) ? cnt : W;
            COST:           W <= (cnt != 4'd0) ? W + 4'd1 : 3'd0;
            default:        W <= 3'd0;
        endcase
    end
end

//---------------------------------------------------------
// Output Signal Cost
//---------------------------------------------------------
// output reg [3:0] MatchCount;
always @(posedge CLK or posedge RST) begin
    if(RST) begin
        MatchCount <= 4'd1;
    end else if(state == COST && cost_done) begin
        if(cost < MinCost)
            MatchCount <= 4'd1;
        else begin
            MatchCount <= (cost == MinCost) ? MatchCount + 4'd1 : MatchCount;
        end
    end
end

// output reg [9:0] MinCost;
always @(posedge CLK or posedge RST) begin
    if(RST) begin
        MinCost <= 10'd0;
    end else begin
        case(state)
            COST:       MinCost <= ((first_point && cost_done) || cost_done && ~compare_out) ? cost : MinCost;
            default:    MinCost <= MinCost;
        endcase
    end
end

// output reg Valid ;
always @(posedge CLK or posedge RST) begin
    if(RST) begin
        Valid <= 1'b0;
    end else if(state == COST && (cost_done || compare_out) && final_point) begin
        Valid <= 1'b1;
    end else begin
        Valid <= 1'b0;
    end
end

//---------------------------------------------------------
// FOR DEBUG
//---------------------------------------------------------
always @(posedge CLK) begin
    if(state == COST && cost_done && cost == 119) begin
       $display("time : %d\n", $time); 
    end
end

endmodule

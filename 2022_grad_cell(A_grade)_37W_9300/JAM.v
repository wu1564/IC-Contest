module JAM (
    CLK,
    RST,
    W,
    J,
    Cost,
    MatchCount,
    MinCost,
    Valid
);

//------------------------------------------------------------------
// Parameter Declaration
//------------------------------------------------------------------
localparam IDLE           = 0;
localparam POINT_INDEX    = 1;
localparam GET_POINT      = 2;
localparam INVERSE        = 3;
localparam COST           = 4;
localparam LAST_SUM       = 5;
localparam JUDGE          = 6;
localparam PENDING        = 7;

//------------------------------------------------------------------
// Input & Output Declaration
//------------------------------------------------------------------
input CLK;
input RST;
output reg [2:0] W;
output reg [2:0] J;
input  [6:0] Cost;
output reg [3:0] MatchCount;
output reg [9:0] MinCost;
output reg Valid;

//------------------------------------------------------------------
// Reg & Wire
//------------------------------------------------------------------
genvar index;
integer i;
// state machine
reg [2:0] state, next_state;
// algorithm
reg [2:0] array[0:7];
reg [2:0] change_point_index, exchange_index;
reg [9:0] cost;
// compare
wire compare_out[0:2];
reg  [9:0] compare_in1[0:2], compare_in2[0:2];
// counter 
reg [2:0] cnt;
// flag
wire getResult;
wire jump_flag;
wire special_case;
wire cost_done_flag;
wire get_point_done;
wire first_case;
wire last_case;

//------------------------------------------------------------------
// State Machine
//------------------------------------------------------------------
always @(posedge CLK or posedge RST) begin
    if(RST) state <= IDLE;
    else state <= next_state;
end

always @(*) begin
    case (state)
        IDLE:           next_state = COST;
        POINT_INDEX:    next_state = (change_point_index != 3'd0 || getResult) ? GET_POINT : POINT_INDEX;
        GET_POINT:      next_state = (get_point_done) ? INVERSE : GET_POINT;
        INVERSE:        next_state = (special_case) ? PENDING : COST;
        COST:           next_state = (jump_flag) ? POINT_INDEX : (cost_done_flag) ? LAST_SUM : COST;
        LAST_SUM:       next_state = (jump_flag) ? POINT_INDEX : JUDGE;
        JUDGE:          next_state = POINT_INDEX;
        PENDING:        next_state = COST;
        default:        next_state = IDLE;
    endcase
end

//------------------------------------------------------------------
// Algorithm
//------------------------------------------------------------------
//wire first_case;
assign first_case = (array[0] == 3'd7 && array[1] == 3'd6 && array[2] == 3'd5 && array[3] == 3'd4 && array[4] == 3'd3 && array[5] == 3'd2 && array[6] == 3'd1 && array[7] == 3'd0);

//wire last_case;
assign last_case = (array[0] == 3'd0 && array[1] == 3'd1 && array[2] == 3'd2 && array[3] == 3'd3 && array[4] == 3'd4 && array[5] == 3'd5 && array[6] == 3'd6 && array[7] == 3'd7);

//wire getResult;
assign getResult = compare_out[0] | compare_out[1] | compare_out[2];

//reg [2:0] change_point_index;
//reg [2:0] array[0:7];     // 7 6 5 4 3 2 1 0
                            //  0 1 2 0 1 2 3
always @(posedge CLK or posedge RST) begin
    if(RST) begin
        change_point_index <= 3'd0;
        for(i = 0; i < 8; i = i + 1) begin
            array[i] <= 7 - i;
        end
    end else begin
        case(state)
            POINT_INDEX  : begin
                                if(cnt == 3'd0)begin
                                    case(1'b1)
                                        compare_out[0]:     change_point_index <= 3'd1;
                                        compare_out[1]:     change_point_index <= 3'd2;
                                        compare_out[2]:     change_point_index <= 3'd3;
                                        default:            change_point_index <= 3'd0;
                                    endcase    
                                end else begin
                                    case(1'b1)
                                        compare_out[0]:     change_point_index <= 3'd4;
                                        compare_out[1]:     change_point_index <= 3'd5;
                                        compare_out[2]:     change_point_index <= 3'd6;
                                        default:            change_point_index <= 3'd7;
                                    endcase    
                                end
                            end
            GET_POINT:      begin
                                if(get_point_done) begin
                                    array[change_point_index] <= array[exchange_index];
                                    array[exchange_index] <= array[change_point_index];
                                end
                                change_point_index <= change_point_index;
                            end
            INVERSE:        begin
                                for(i = 0; i < change_point_index[2:1]; i = i + 1) begin
                                    array[i] <= array[change_point_index-i-1];
                                    array[change_point_index-i-1] <= array[i];
                                end
                            end
            default:        begin
                                for (i = 0; i < 8; i = i + 1) begin
                                    array[i] <= array[i];
                                end
                                change_point_index <= 3'd0;
                            end
        endcase
    end
end

//reg [2:0] exchange_index
always @(posedge CLK or posedge RST) begin
    if(RST) begin
        exchange_index <= 3'd7;
    end else if(state == GET_POINT) begin
        exchange_index <= (compare_out[0] && (array[cnt] < array[exchange_index] || exchange_index == 3'd7)) ? cnt : exchange_index;
    end else begin
        exchange_index <= 3'd7;
    end
end

//reg [9:0] cost;
always @(posedge CLK or posedge RST) begin
    if(RST) begin
        cost <= 10'd0;
    end else begin
        case(state)
            POINT_INDEX:    cost <= 10'd0;
            GET_POINT:      cost <= (cnt <= 3'd3 || cnt < change_point_index - 3'd1) ? cost + Cost : cost;
            INVERSE:        cost <= (W <= change_point_index) ? cost : cost + Cost;
            COST,
            LAST_SUM:       cost <= cost + Cost;
            default:        cost <= cost;
        endcase
    end
end

//------------------------------------------------------------------
// Compare
//------------------------------------------------------------------
//                             0 1 2 3 4 5 6 7
//reg [9:0] array[0:7];     // 7 6 5 4 3 2 1 0
                            //  0 1 2 0 1 2 3
generate
    for(index = 0; index < 3; index = index + 1) begin : compare
        assign compare_out[index] = (compare_in1[index] > compare_in2[index]) ? 1'b1 : 1'b0;
        always @(*) begin
            case(state)
                POINT_INDEX  : begin
                                    case(cnt)
                                        3'd0:       begin
                                                        compare_in1[index] = {7'd0,array[index]};
                                                        compare_in2[index] = {7'd0,array[index+1]};                                            
                                                    end
                                        3'd1:       begin
                                                        compare_in1[index] = {7'd0,array[index+3]};
                                                        compare_in2[index] = {7'd0,array[index+4]};
                                                    end
                                        default:    begin
                                                        compare_in1[index] = 10'd0;
                                                        compare_in2[index] = 10'd0;
                                                    end
                                    endcase
                                end
                GET_POINT:      begin
                                    compare_in1[index] = {7'd0,array[cnt]};
                                    compare_in2[index] = {7'd0,array[change_point_index]};
                                end
                COST,
                LAST_SUM,
                JUDGE:          begin
                                    compare_in1[index] = cost;
                                    compare_in2[index] = MinCost;
                                end
                default:        begin
                                    compare_in1[index] = 3'd0;
                                    compare_in2[index] = 3'd0;
                                end
            endcase
        end
    end
endgenerate

//---------------------------------------------------------------------
// Flag & Counter
//---------------------------------------------------------------------
//wire jump_flag;
assign jump_flag = (compare_out[0] && ~first_case);

//wire special_case;
assign special_case = (W == change_point_index);

//wire cost_done_flag;
assign cost_done_flag = (W == 3'd0);
 
//wire get_point_done;
assign get_point_done = (cnt == change_point_index);

//reg [2:0] cnt;
always @(posedge CLK or posedge RST) begin
    if(RST) begin
        cnt <= 3'd0;
    end else begin
        case (state)
            POINT_INDEX:    cnt <= (change_point_index != 3'd0 || getResult) ? 3'd0 : cnt + 3'd1;
            GET_POINT:      cnt <= cnt + 3'd1;
            default:        cnt <= 3'd0;
        endcase
    end
end

//---------------------------------------------------------------------
// Output Table
//---------------------------------------------------------------------
// output reg [2:0] W;
always @(negedge CLK or posedge RST) begin
    if(RST) begin
        W <= 3'd7;
    end else begin
        case(state)
            IDLE,
            POINT_INDEX:    W <= 3'd7;
            GET_POINT,
            INVERSE:        W <= (special_case) ? W : W - 3'd1;
            COST,
            LAST_SUM:       W <= (compare_out[0] && ~first_case) ? 3'd7 : W - 3'd1;
            default:        W <= W;
        endcase
    end
end

// output reg [2:0] J;
always @(negedge CLK or posedge RST) begin
    if(RST) begin
        J <= 3'd0;
    end else begin
        case(state)
            IDLE,
            POINT_INDEX:    J <= array[7];
            GET_POINT,
            INVERSE:        J <= (W != 0) ? array[W-1] : J;
            PENDING:        J <= array[W];
            COST,
            LAST_SUM:       begin
                                if(compare_out[0] && ~first_case) begin
                                    J <= array[7];
                                end else if(W != 0) begin
                                    J <= array[W-1];
                                end
                            end
            default:        J <= J;
        endcase
    end
end

//---------------------------------------------------------------------
// Output Signal
//---------------------------------------------------------------------
// output reg [3:0] MatchCount;
always @(posedge CLK or posedge RST) begin
    if(RST) begin
        MatchCount <= 4'd1;
    end else begin
        case(state)
            JUDGE:      MatchCount <= (cost == MinCost) ? MatchCount + 4'd1 : (~compare_out[0]) ? 4'd1 : MatchCount;
            default:    MatchCount <= MatchCount;
        endcase
    end
end

// output reg [9:0] MinCost;
always @(posedge CLK or posedge RST) begin
    if(RST) begin
        MinCost <= 10'd0;
    end else begin
        case(state)
            JUDGE:      MinCost <= (first_case || ~compare_out[0]) ? cost : MinCost;
            default:    MinCost <= MinCost;
        endcase
    end
end

// output reg Valid;
always @(posedge CLK or posedge RST) begin
    if(RST) begin
        Valid <= 1'b0;
    end else if(last_case) begin
        case(state)
            COST,
            LAST_SUM:   Valid <= (compare_out[0]) ? Valid <= 1'b1 : 1'b0; 
            JUDGE:      Valid <= 1'b1;
            default:    Valid <= Valid;
        endcase
    end 
end

//---------------------------------------------------------------------
// For Debug
//---------------------------------------------------------------------
//5 4 2 7 6 0 3 1 
// wire find_flag = (  array[0] == 3'd3 &&
//                     array[1] == 3'd2 &&
//                     array[2] == 3'd1 &&
//                     array[3] == 3'd0 &&
//                     array[4] == 3'd4 &&
//                     array[5] == 3'd5 &&
//                     array[6] == 3'd6 &&
//                     array[7] == 3'd7);
// always @(posedge CLK) begin
//     if(state == JUDGE && cost == 485) begin
//         $display("time : \n array : %d %d %d %d %d %d %d %d ", $time,
//             array[0],
//             array[1],
//             array[2],
//             array[3],
//             array[4],
//             array[5],
//             array[6],
//             array[7]
//         );
//     end else if(find_flag && state == LAST_SUM) begin
//         $display("WRONG !!! time : \n array : %d %d %d %d %d %d %d %d ", $time,
//             array[0],
//             array[1],
//             array[2],
//             array[3],
//             array[4],
//             array[5],
//             array[6],
//             array[7]
//         );
//     end else if(change_point_index > 3'd3 && change_point_index != 3'd7) begin
//         //$display("Change Point index > 3 ---->>> time : %d\n", $time);
//     end else if(find_flag) begin
//         //$display("32104567  time : %d\n", $time);
//     end
// end

endmodule

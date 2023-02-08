module LCD_CTRL(
    clk,
    reset, 
    datain, 
    cmd, 
    cmd_valid, 
    dataout, 
    output_valid, 
    busy
);

//-----------------------------------------------------------------
// Parameter Declaration
//-----------------------------------------------------------------
localparam IMAGE_SIZE = 64;
localparam IDLE       = 0;
localparam REFLASH    = 1;
localparam LOAD       = 2;
localparam ZOOM_IN    = 3;
localparam ZOOM_OUT   = 4;
localparam RIGHT      = 5;
localparam LEFT       = 6;
localparam UP         = 7;
localparam DOWN       = 8;
localparam DONE       = 9;

//-----------------------------------------------------------------
// Input / Output Declaration
//-----------------------------------------------------------------
input               clk;
input               reset;          // active high asynchronous
input   [7:0]       datain;
input   [2:0]       cmd;
input               cmd_valid;
output reg [7:0]    dataout;
output reg          output_valid;
output reg          busy;

//-----------------------------------------------------------------
// Integer / Wires / Registers
//-----------------------------------------------------------------
integer i;
wire receive_data_done;
wire output_done;
reg  line_change;
reg  zoom_out_detect;
reg  [3:0] state, next_state;
reg  [5:0] cnt, point;
reg  [5:0] address;
reg  [7:0] image[0:63];

//-----------------------------------------------------------------
// Flag
//-----------------------------------------------------------------
//wire receive_data_done;
assign receive_data_done = (cnt == IMAGE_SIZE-1) ? 1'b1 : 1'b0;

//wire output_done;
assign output_done = (line_change && ((cnt[3:2] == 2'd3 && cnt[2:0] != 3'd6) || cnt[4:3] == 2'd3 && cnt[1:0] != 2'd3)) ? 1'b1 : 1'b0;

//wire line_change;
always @(*) begin
    if(zoom_out_detect) begin
        line_change = (cnt[2:0] == 3'd6) ? 1'b1 : 1'b0;
    end else begin
        line_change = (cnt[1:0] == 2'd3) ? 1'b1 : 1'b0;    
    end
end

//reg zoom_out_detect;
always @(posedge clk or posedge reset) begin
    if(reset) begin
        zoom_out_detect <= 1'b0;
    end else begin
        case (state)
            LOAD,
            ZOOM_OUT:   zoom_out_detect <= 1'b1;
            ZOOM_IN:    zoom_out_detect <= 1'b0;
            default:    zoom_out_detect <= zoom_out_detect;
        endcase
    end
end

//-----------------------------------------------------------------
// State Machine
//-----------------------------------------------------------------
//reg [3:0] state;
always @(*) begin
    case (state)
        IDLE:      begin
                        if(cmd_valid) begin
                            case(cmd)
                                3'd0:    next_state = REFLASH;
                                3'd1:    next_state = LOAD;
                                3'd2:    next_state = ZOOM_IN;
                                3'd3:    next_state = ZOOM_OUT;
                                3'd4:    next_state = RIGHT;
                                3'd5:    next_state = LEFT;
                                3'd6:    next_state = UP;
                                3'd7:    next_state = DOWN;
                                default: next_state = IDLE;
                            endcase
                        end else begin
                            next_state = IDLE;
                        end
                    end
        LOAD:       next_state = (receive_data_done) ? DONE : LOAD;
        DONE:       next_state = (output_done) ? IDLE : DONE;      //flag
        default:    next_state = DONE;
    endcase 
end

//reg [3:0] state;
always @(posedge clk or posedge reset) begin
    if(reset) begin
        state <= IDLE;
    end else begin
       state <= next_state; 
    end
end

//-----------------------------------------------------------------
// LCD Control Signel
//-----------------------------------------------------------------
//reg [5:0] address
always @(*) begin
    if(zoom_out_detect) begin
        case (cnt[4:3])       // origin + column + row
            2'd0:       address = point + {3'd0, cnt[2:0]};
            2'd1:       address = point + {3'd0, cnt[2:0]} + 6'd16;
            2'd2:       address = point + {3'd0, cnt[2:0]} + 6'd32;
            2'd3:       address = point + {3'd0, cnt[2:0]} + 6'd48;
            default:    address = point;
        endcase
    end else begin
        case (cnt[3:2])       // origin + column + row
            2'd0:       address = point + {4'd0, cnt[1:0]};
            2'd1:       address = point + {4'd0, cnt[1:0]} + 6'd8;
            2'd2:       address = point + {4'd0, cnt[1:0]} + 6'd16;
            2'd3:       address = point + {4'd0, cnt[1:0]} + 6'd24;
            default:    address = point;
        endcase
    end
end

//reg  [5:0] point;
always @(posedge clk or posedge reset) begin
    if(reset) begin
        point <= 6'd0;
    end else begin
        case (state)
            LOAD:       point <= 6'd0;
            ZOOM_IN:    point <= 6'd18;     // origin(2,2)
            ZOOM_OUT:   point <= 6'd0;
            RIGHT:      point <= (zoom_out_detect) ? 6'd0 : (point[2:0] == 3'd4) ? point : point + 6'd1;
            LEFT:       point <= (zoom_out_detect) ? 6'd0 : (point[2:0] == 3'd0) ? point : point - 6'd1;
            UP:         point <= (zoom_out_detect) ? 6'd0 : (point < 6'd5) ? point : point - 6'd8;
            DOWN:       point <= (zoom_out_detect) ? 6'd0 : (point > 6'h1f) ? point : point + 6'd8;
            default:    point <= point;
        endcase
    end
end

// output          busy;
always @(negedge clk or posedge reset) begin
    if(reset) begin
        busy <= 1'b1;
    end else if(~busy) begin
        busy <= 1'b1;
    end else if(state == IDLE) begin
        busy <= 1'b0; 
    end 
end

// output          output_valid;
always @(posedge clk or posedge reset) begin
    if(reset) begin
        output_valid <= 1'b0; 
    end else if(state == DONE) begin
        output_valid <= 1'b1;
    end else begin
        output_valid <= 1'b0;
    end
end

// output  [7:0]   dataout;
always @(posedge clk or posedge reset) begin
    if(reset) begin
        dataout <= 8'd0;
    end else if(state == DONE) begin
        dataout <= image[address];
    end
end

//-----------------------------------------------------------------
// Image Buffer
//-----------------------------------------------------------------
//reg [7:0] image[0:63];
always @(posedge clk or posedge reset) begin
    if(reset) begin
        for(i = 0; i < IMAGE_SIZE; i = i + 1) begin
            image[i] <= 8'd0;
        end
    end else begin
        case (state)
            IDLE:       begin
                            if(cmd == 3'd1) begin
                                image[0] <= datain;
                            end
                        end
            LOAD:       begin
                            image[cnt] <= datain;
                        end
            default:    begin
                            for(i = 0; i < IMAGE_SIZE; i = i + 1) begin
                                image[i] <= image[i];
                            end
                        end
        endcase
    end
end

//-----------------------------------------------------------------
// Counter
//-----------------------------------------------------------------
//reg [5:0] cnt;
always @(posedge clk or posedge reset) begin
    if(reset) begin
        cnt <= 6'd0;
    end else begin
        case (state)
            LOAD:       cnt <= (receive_data_done) ? 6'd0 : cnt + 6'd1;
            DONE:       begin
                            if(zoom_out_detect) begin
                                if(line_change) begin
                                    cnt[2:0] <= 3'd0;
                                    cnt[4:3] <= cnt[4:3] + 2'd1;
                                end else begin
                                    cnt[2:0] <= cnt[2:0] + 3'd2;
                                end
                            end else begin
                                if(line_change) begin
                                    cnt[3:2] <= cnt[3:2] + 2'd1;
                                    cnt[1:0] <= 2'd0;
                                end else begin
                                    cnt[1:0] <= cnt[1:0] + 2'd1;
                                end
                            end
                        end
            default:    cnt <= 6'd0;
        endcase
    end
end

endmodule

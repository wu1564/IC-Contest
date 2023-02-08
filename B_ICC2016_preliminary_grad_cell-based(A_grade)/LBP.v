
`timescale 1ns/10ps
module LBP (
    // system control
    clk, 
    reset, 
    // 
    gray_addr, 
    gray_req, 
    gray_ready, 
    gray_data, 
    //
    lbp_addr, 
    lbp_valid, 
    lbp_data, 
    finish
);

//---------------------------------------------------------------------
// Parameter Declaration
//---------------------------------------------------------------------
localparam IDLE       = 0;
localparam SELECT     = 1;
localparam PROCESS    = 2;
localparam ZERO       = 3;

//---------------------------------------------------------------------
// Input / Output Declaration
//---------------------------------------------------------------------
// system control
input   	    clk;
input   	    reset;
// lbp(local binary pattern)
input   	        gray_ready;
input  [7:0]    	gray_data;
output reg [13:0] 	gray_addr;
output reg        	gray_req;
// lbp_mem
output reg [13:0] 	lbp_addr;
output reg  	    lbp_valid;
output reg [7:0] 	lbp_data;
output reg 	        finish;

//---------------------------------------------------------------------
// Wire / Register Declaration
//---------------------------------------------------------------------
wire process_done;
reg  bound_detect;
reg  finish_flag;
reg  [2:0]  state, next_state;
reg  [3:0]  cnt;
reg  [7:0]  gc_data, data;
reg  [13:0] address;

//---------------------------------------------------------------------
// State Machine
//---------------------------------------------------------------------
//reg [2:0] state;
always @(posedge clk or posedge reset) begin
    if(reset) begin
        state <= IDLE;
    end else begin
        state <= next_state;
    end
end

//reg [2:0] next_state;
always @(*) begin
    case (state)
        IDLE:       next_state = (gray_ready) ? ZERO : IDLE;
        PROCESS:    begin
                        if(process_done) begin
                            next_state = (bound_detect) ? ZERO : PROCESS;
                        end else begin
                            next_state = PROCESS;
                        end
                    end
        ZERO:       next_state = (~bound_detect) ? PROCESS : ZERO;
        default:    next_state = IDLE;
    endcase
end

//---------------------------------------------------------------------
// Local Binary Pattern
//---------------------------------------------------------------------
// output         	gray_req;
always @(posedge clk or posedge reset) begin
    if(reset) begin
        gray_req <= 1'b0;
    end else begin
        gray_req <= ~finish;
    end
end

// output  [13:0] 	gray_addr;
always @(posedge clk or posedge reset) begin
    if(reset) begin
        gray_addr <= 14'd0;
    end else begin
        case(state)
            PROCESS:    gray_addr <= (process_done) ? address : address;
            ZERO:       gray_addr <= (bound_detect) ? gray_addr + 14'd1 : gray_addr;
            default:    gray_addr <= gray_addr;
        endcase
    end
end

//reg  [7:0]  gc_data;
always @(posedge clk or posedge reset) begin
    if(reset) begin
        gc_data <= 8'd0;
    end else if(cnt == 4'd0) begin
        gc_data <= gray_data;
    end
end

always @(*) begin
    if(gray_data >= gc_data) begin
        // Method 1
        //data = {1'b1, {(cnt-2){1'b0}}}; // Ilegal
        // Method 2
        case (cnt)
            4'd1:       data = 8'd1;
            4'd2:       data = 8'd2;
            4'd3:       data = 8'd4;
            4'd4:       data = 8'd8;
            4'd5:       data = 8'd16;
            4'd6:       data = 8'd32;
            4'd7:       data = 8'd64;
            4'd8:       data = 8'd128;
            default:    data = 8'd0;    
        endcase
    end else begin
        data = 8'd0;
    end
end

//wire [13:0] address;
always @(*) begin
    case (cnt)
        4'd0:       address = gray_addr - 14'd129;       
        4'd8:       address = gray_addr - 14'd128;       
        4'd1, 4'd2, 4'd6,
        4'd7:       address = gray_addr + 14'd1;
        4'd4:       address = gray_addr + 14'd2;
        4'd3,
        4'd5:       address = gray_addr + 14'd126;
        default:    address = gray_addr;
    endcase
end

//---------------------------------------------------------------------
// LBP Memory
//---------------------------------------------------------------------
// output  	    lbp_valid;
always @(posedge clk or posedge reset) begin
    if(reset) begin
        lbp_valid <= 1'b0;
    end else begin
        case (state)
            PROCESS:    lbp_valid <= (process_done) ? 1'b1 : 1'b0;
            ZERO:       lbp_valid <= 1'b1;
            default:    lbp_valid <= 1'b0;
        endcase
    end
end

// output  [13:0] 	lbp_addr;
always @(posedge clk or posedge reset) begin
    if(reset) begin
        lbp_addr <= 14'h3fff;
    end else begin
        case (state)
            PROCESS:    lbp_addr <= (process_done) ? address - 14'd1 : lbp_addr;
            ZERO:       lbp_addr <= lbp_addr + 14'd1;
            default:    lbp_addr <= lbp_addr;
        endcase
    end
end

// output  [7:0] 	lbp_data;
always @(posedge clk or posedge reset) begin
    if(reset) begin
        lbp_data <= 8'd0;
    end else begin
        case (state)
            PROCESS:    begin
                            case(cnt)
                                4'd0:       lbp_data <= 8'd0;
                                default:    lbp_data <= lbp_data + data;
                            endcase
                        end
            default:    lbp_data <= 8'd0;
        endcase
    end
end

//---------------------------------------------------------------------
// Register and Flags
//---------------------------------------------------------------------
//reg  [3:0]  cnt;
always @(posedge clk or posedge reset) begin
    if(reset) begin
        cnt <= 4'd0;
    end else begin
        case (state)
            PROCESS:    cnt <= (process_done) ? 4'd0 : cnt + 4'd1;
            default:    cnt <= 4'd0;
        endcase
    end
end

//wire process_done
assign process_done = (cnt == 4'd8) ? 1'b1 : 1'b0;

//reg bound_detect
always @(*) begin
    if(gray_addr[6:0] == 7'd0 || gray_addr[6:0] == 7'd127 || gray_addr[13:7] == 7'd0 || gray_addr[13:7] == 7'd127) begin
        bound_detect = 1'b1;
    end else begin
        bound_detect = 1'b0;
    end
end

//---------------------------------------------------------------------
// Finish
//---------------------------------------------------------------------
wire total_done = (state == ZERO && lbp_addr == 14'h3fff && gray_addr == 14'd0);

//reg finish_flag;
always @(posedge clk or posedge reset) begin
    if(reset) begin
        finish_flag <= 1'b0;
    end else begin
        finish_flag <= (total_done) ? finish_flag + 1'b1 : finish_flag;
    end
end

always @(posedge clk or posedge reset) begin
    if(reset) begin
        finish <= 1'b0;
    end else if(finish_flag && total_done) begin
        finish <= 1'b1;
    end else begin
        finish <= 1'b0;
    end
end

endmodule

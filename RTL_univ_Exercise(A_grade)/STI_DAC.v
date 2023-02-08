module STI_DAC(
	clk,
	reset, 
	load, 
	pi_data, 
	pi_length, 
	pi_fill, 
	pi_msb, 
	pi_low, 
	pi_end,
	so_data, 
	so_valid,
	pixel_finish, 
	pixel_dataout, 
	pixel_addr,
	pixel_wr
);

//---------------------------------------------------------------------
// Parameter Declaration
//---------------------------------------------------------------------
// 16 states upmost
localparam IDLE 	  = 0;
localparam SELECT 	  = 1;
localparam SEND_8BIT  = 2;
localparam SEND_16BIT = 3;
localparam FILL		  = 4;
localparam DATA 	  = 5;

//---------------------------------------------------------------------
// Input & Output Declaration
//---------------------------------------------------------------------
input  clk;
input  reset;	// high active
input  load;	// when it's high, STI get data
input  pi_msb;	// high ->  /  low <-
input  pi_low;	// valid whem pi_length is 00
input  pi_end; 
input  [15:0]	pi_data;
input  [1:0]	pi_length;	// 00 -> 8bit	01 -> 16bit		10 -> 24bit		11 -> 32bit
input  pi_fill;			// valid when pi_lenght is 10 or 11
output reg so_data;
output reg so_valid;
output reg pixel_finish;
output reg pixel_wr;
output reg [7:0] pixel_addr;
output reg [7:0] pixel_dataout;

//---------------------------------------------------------------------
// Regs & Wires
//---------------------------------------------------------------------
wire process_flag;
wire data_done;
reg  wr_mem_time;
reg  fill_done;
reg  [3:0]   state, next_state;
reg  [5-1:0] cnt;

//---------------------------------------------------------------------
// State Machine
//---------------------------------------------------------------------
always @(posedge clk or posedge reset) begin
	if(reset) state <= IDLE;
	else state <= next_state;
end

always @(*) begin
	case(state)
		IDLE:			next_state = (load) ? SELECT : IDLE;
		SELECT:			begin
							case (pi_length)
								2'd0:	 next_state = SEND_8BIT;
								2'd1:	 next_state = SEND_16BIT;
								default: next_state = (process_flag) ? DATA : FILL;
							endcase
						end
		SEND_8BIT:		begin
							next_state = (cnt == 5'd7) ? IDLE : SEND_8BIT;
						end
		SEND_16BIT:		begin
							next_state = (data_done) ? IDLE : SEND_16BIT;
						end
		FILL:			begin
							if(process_flag && fill_done) begin
								next_state = IDLE;								 
							end else begin
								next_state = (fill_done) ? DATA : FILL;								
							end
						end
		DATA:			begin
							if(~process_flag && data_done) begin
								next_state = IDLE;								 
							end else begin
								next_state = (data_done) ? FILL : DATA;		
							end
						end
		default:		next_state = IDLE;
	endcase
end

//---------------------------------------------------------------------
//	Serial Transmitter Interface
//---------------------------------------------------------------------
// input	load;	// when it's high, STI get data
// input	pi_msb;	// high ->  /  low <-
// input	pi_low,	// valid whem pi_length is 00
// input 	pi_end; 
// input	[15:0]	pi_data;
// input	[1:0]	pi_length;	// 00 -> 8bit	01 -> 16bit		10 -> 24bit		11 -> 32bit
// input	pi_fill;			// valid when pi_lenght is 10 or 11
// output	so_data;
always @(posedge clk or posedge reset) begin
	if(reset) begin
		so_data <= 1'b0;
	end	else begin
		case(state)
			SEND_8BIT:		begin
								case({pi_msb,pi_low})
									2'b00:	so_data <= pi_data[cnt];
									2'b01:	so_data <= pi_data[8 + cnt];
									2'b10:	so_data <= pi_data[7 - cnt];
									2'b11:	so_data <= pi_data[15 - cnt];
								endcase
							end
			SEND_16BIT:		begin
								if(pi_msb) begin
									so_data <= pi_data[15-cnt];
								end else begin
									so_data <= pi_data[cnt];
								end
							end
			DATA:			begin
								if(pi_msb) begin
									so_data <= pi_data[15-cnt];
								end else begin
									so_data <= pi_data[cnt];
								end
							end
			default:		so_data <= 1'b0;
		endcase
	end
end

// output 	so_valid;
always @(posedge clk or posedge reset) begin
	if(reset) begin
		so_valid <= 1'b0;
	end else begin
		case(state)
			IDLE,		
			SELECT:		so_valid <= 1'b0;
			default:	so_valid <= 1'b1;
		endcase
	end
end

//---------------------------------------------------------------------
// Data Arrange Controller
//---------------------------------------------------------------------
// output reg pixel_finish;
always @(negedge clk or posedge reset) begin
	if(reset) begin
		pixel_finish <= 1'b0;
	end else if(pixel_wr && pixel_addr == 8'd255) begin
		pixel_finish <= 1'b1;
	end
end

// output reg pixel_wr;
always @(posedge clk or posedge reset) begin
	if(reset) begin
		pixel_wr <= 1'b0;
	end else if(pixel_wr) begin
		pixel_wr <= 1'b0;
	end else if(wr_mem_time || (state == IDLE && (so_valid || pi_end))) begin
		pixel_wr <= 1'b1;
	end
end

// output reg [7:0] pixel_dataout;
always @(negedge clk or posedge reset) begin
	if(reset) begin
		pixel_dataout <= 8'd0;
	end else if(pi_end && ~so_valid) begin
		pixel_dataout <= 8'd0;
	end else if(so_valid) begin
		pixel_dataout <= {pixel_dataout[6:0], so_data};
	end
end

// output reg [7:0] pixel_addr;
always @(negedge clk or posedge reset) begin
	if(reset) begin
		pixel_addr <= 8'd255;
	end else begin
		case(state)
			IDLE:		pixel_addr <= ((pi_end && pixel_addr != 8'd255 && ~pixel_wr) || so_valid) ? pixel_addr + 8'd1 : pixel_addr;
			default:	pixel_addr <= (wr_mem_time) ? pixel_addr + 8'd1 : pixel_addr;
		endcase
	end
end

//---------------------------------------------------------------------
// Flags & Counter
//---------------------------------------------------------------------
//reg [5-1:0] cnt;
always @(posedge clk or posedge reset) begin
	if(reset) cnt <= 5'd0;
	else begin
		case (state)
			SEND_8BIT:	cnt <= (cnt == 5'd7) ? 5'd0 : cnt + 5'd1;
			SEND_16BIT:	cnt <= (data_done) ? 5'd0 : cnt + 5'd1;
			DATA:		cnt <= (data_done) ? 5'd0 : cnt + 5'd1;		
			FILL:		cnt <= (fill_done) ? 5'd0 : cnt + 5'd1;
			default:	cnt <= 5'd0;
		endcase
	end
end

//wire wr_mem_time;
//assign wr_mem_time = (cnt == 5'd8 || cnt == 5'd16 || cnt == 5'd24) ? 1'b1 : 1'b0;
always @(*) begin
	wr_mem_time = (cnt == 5'd8 || (~process_flag && cnt == 5'd0 && state == DATA) || (process_flag && cnt == 5'd0 && state == FILL)) ? 1'b1 : 1'b0;
end

//wire data_done;
assign data_done = (cnt == 5'd15) ? 1'b1 : 1'b0;

//reg fill_done;
always @(*) begin
	case (pi_length)
		2'd2:		fill_done = (cnt == 5'd7) ? 1'b1 : 1'b0;
		2'd3:		fill_done = (cnt == 5'd15) ? 1'b1 : 1'b0;
		default:	fill_done = 1'b0;
	endcase
end

//wire process_flag;
assign process_flag = (pi_msb == pi_fill) ? 1'b1 : 1'b0;

endmodule

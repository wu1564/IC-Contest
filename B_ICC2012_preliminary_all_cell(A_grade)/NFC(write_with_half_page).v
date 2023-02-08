`timescale 1ns/100ps
module NFC(
	clk, 
	rst, 
	done, 
	// Read from flash memory A
	F_IO_A, 
	F_CLE_A, 
	F_ALE_A, 
	F_REN_A, 
	F_WEN_A, 
	F_RB_A, 
	// Write to flash memory B
	F_IO_B, 
	F_CLE_B, 
	F_ALE_B, 
	F_REN_B, 
	F_WEN_B, 
	F_RB_B
);

//-----------------------------------------------------------------------
// Parameter Declaration
//-----------------------------------------------------------------------
localparam IDLE 		= 0;
localparam PAGE_CMD 	= 1;
localparam ADDRESS 		= 2;
localparam WAIT 		= 3;
localparam READ_DATA 	= 4;
localparam WRITE_DONE 	= 5;

//-----------------------------------------------------------------------
// Input / Output Declaration
//-----------------------------------------------------------------------
// System Control
input  clk;
input  rst;
output reg done;
// Read flash mermory A
input  F_RB_A;
output reg F_CLE_A;
output reg F_ALE_A;
output reg F_REN_A;
output reg F_WEN_A;
inout  [7:0] F_IO_A;
// write flash memory B
input  F_RB_B;
output reg F_CLE_B;
output reg F_ALE_B;
output reg F_WEN_B;
output F_REN_B;
inout  [7:0] F_IO_B;

//-----------------------------------------------------------------------
// Wires / Registers Declaration
//-----------------------------------------------------------------------
wire address_done;
wire f_rb_posedge_a;
wire f_rb_posedge_b;
wire read_data_done;
wire write_done_flag;
reg  cmd_done;
reg  page_select;
reg  [1:0] f_rb_reg_a;
reg  [1:0] f_rb_reg_b;
reg  [2:0] state, next_state;
reg  [7:0] F_IO_A_reg, F_IO_B_reg;
reg  [7:0] cnt;
reg  [8:0] row_cnt;

//-----------------------------------------------------------------------
// Flags
//-----------------------------------------------------------------------
//wire cmd_done;
always @(*) begin
	if(page_select) begin
		if(cnt == 8'd5) begin
			cmd_done = 1'b1;
		end else begin
			cmd_done = 1'b0;
		end
	end else begin
		if(cnt == 8'd2) begin
			cmd_done = 1'b1;
		end else begin
			cmd_done = 1'b0;
		end
	end
end

//wire address_done;
assign address_done = (cnt == 8'd6) ? 1'b1 : 1'b0;

//wire f_rb_posedge_a;
assign f_rb_posedge_a = f_rb_reg_a[0] & ~f_rb_reg_a[1];

//wire f_rb_posedge_b;
assign f_rb_posedge_b = f_rb_reg_b[0] & ~f_rb_reg_b[1];

//wire read_data_done;
assign read_data_done = (cnt == 8'hff) ? 1'b1 : 1'b0;

//wire write_done_flag;
assign write_done_flag = (state == WRITE_DONE && f_rb_posedge_b) ? 1'b1 : 1'b0;

//reg [1:0] f_rb_reg_a;
always @(posedge clk or posedge rst) begin
	if(rst) begin
		f_rb_reg_a <= 2'd0;
	end else begin
		f_rb_reg_a <= {f_rb_reg_a[0], F_RB_A};
	end
end

//reg  [1:0] f_rb_reg_b;
always @(posedge clk or posedge rst) begin
	if(rst) begin
		f_rb_reg_b <= 2'd0;
	end else begin
		f_rb_reg_b <= {f_rb_reg_b[0], F_RB_B};
	end
end

//reg page_select;
always @(posedge clk or posedge rst) begin
	if(rst) begin
		page_select <= 1'b0;
	end else if(write_done_flag) begin
		page_select <= ~page_select;
	end
end

//-----------------------------------------------------------------------
// State Machine
//-----------------------------------------------------------------------
//reg [2:0] state;
always @(posedge clk or posedge rst) begin
	if(rst) begin
		state <= IDLE;
	end else begin
		state <= next_state;
	end
end

//reg [2:0] next_state;
always @(*) begin
	case (state)
		IDLE:		next_state = PAGE_CMD;
		PAGE_CMD:	next_state = (cmd_done) ? ADDRESS : PAGE_CMD;
		ADDRESS:	next_state = (address_done) ? WAIT : ADDRESS;
		WAIT:		next_state = (f_rb_posedge_a) ? READ_DATA : WAIT;
		READ_DATA:	next_state = (read_data_done) ? WRITE_DONE : READ_DATA;
		WRITE_DONE:	next_state = (f_rb_posedge_b) ? IDLE : WRITE_DONE;
		default:	next_state = IDLE;
	endcase
end

//-----------------------------------------------------------------------
// Counter
//-----------------------------------------------------------------------
//reg [8:0] row_cnt;
always @(posedge clk or posedge rst) begin
	if(rst) begin
		row_cnt <= 8'd0;
	end else if(write_done_flag && page_select) begin
		row_cnt <= row_cnt + 8'd1;
	end
end

//reg [7:0] cnt
always @(posedge clk or posedge rst) begin
	if(rst) begin
		cnt <= 8'd0;
	end else begin
		case (state)
			PAGE_CMD:	cnt <= (cmd_done) ? 8'd0 : cnt + 8'd1;
			ADDRESS:	cnt <= cnt + 8'd1;
			READ_DATA:	cnt <= (~F_REN_A) ? cnt + 8'd1 : cnt;
			WRITE_DONE:	cnt <= cnt + 8'd1;
			default:	cnt <= 8'd0;
		endcase
	end
end

//-----------------------------------------------------------------------
// Read Flash Memory A
//-----------------------------------------------------------------------
// output F_CLE_A;
always @(posedge clk or posedge rst) begin
	if(rst) begin
		F_CLE_A <= 1'b0;
	end else begin
		case (state)
			PAGE_CMD:	F_CLE_A <= 1'b1;
			default:	F_CLE_A <= 1'b0;
		endcase
	end
end

// output F_WEN_A;
always @(negedge clk or posedge rst) begin
	if (rst) begin
		F_WEN_A <= 1'b1;
	end else begin
		case (state)
			PAGE_CMD:	begin
							case (cnt)
								8'd1,
								8'd4:		F_WEN_A <= 1'b0; 
								default:	F_WEN_A <= 1'b1;
							endcase
						end
			ADDRESS:	begin
							if(address_done) begin
								F_WEN_A <= 1'b1;
							end else if(F_ALE_A) begin
								F_WEN_A <= ~F_WEN_A;
							end
						end
			default:	F_WEN_A <= 1'b1;
		endcase
	end
end

// output F_ALE_A;
always @(posedge clk or posedge rst) begin
	if(rst) begin
		F_ALE_A <= 1'b0;
	end else begin
		case (state)
			ADDRESS:	F_ALE_A <= 1'b1;
			default:	F_ALE_A <= 1'b0;
		endcase
	end
end

//output F_REN_A;
always @(posedge clk or posedge rst) begin
	if(rst) begin
		F_REN_A <= 1'b1;
	end else begin
		case (state)
			READ_DATA:	F_REN_A <= (F_WEN_A && ~F_CLE_A) ? ~F_REN_A : 1'b1;
			default:	F_REN_A <= 1'b1;
		endcase
	end
end

//inout  [7:0] F_IO_A;
assign F_IO_A = F_IO_A_reg;

//reg  [7:0] F_IO_A_reg;
always @(posedge clk or posedge rst) begin
	if(rst) begin
		F_IO_A_reg <= 8'dz;
	end else begin
		case (state)
			PAGE_CMD:		case(cnt) 
								8'd1,
								8'd4: 		F_IO_A_reg <= (page_select) ? 8'h01 : 8'h00;
								default:	F_IO_A_reg <= 8'dz;
							endcase
			ADDRESS:	begin
							case (cnt)
								8'd1:		F_IO_A_reg <= 8'h00;
								8'd3:		F_IO_A_reg <= row_cnt[7:0];
								8'd5:		F_IO_A_reg <= {7'd0, row_cnt[8]};
								default:	F_IO_A_reg <= 8'dz;
							endcase
						end
			default:	F_IO_A_reg <= 8'dz;
		endcase
	end
end

//-----------------------------------------------------------------------
// Write Flash Memory B
//-----------------------------------------------------------------------
//output F_REN_B;
assign F_REN_B = 1'b1;

// output F_CLE_B;
always @(posedge clk or posedge rst) begin
	if(rst) begin
		F_CLE_B <= 1'b0;
	end else begin
		case (state)
			PAGE_CMD:	F_CLE_B <= 1'b1;
			WRITE_DONE:	F_CLE_B <= (~read_data_done) ? 1'b1 : 1'b0;
			default:	F_CLE_B <= 1'b0;
		endcase
	end
end

// output F_WEN_B;
always @(negedge clk or posedge rst) begin
	if (rst) begin
		F_WEN_B <= 1'b1;
	end else begin
		case (state)
			PAGE_CMD:	begin
							case (cnt)
								8'd1,
								8'd4:		F_WEN_B <= 1'b0; 
								default:	F_WEN_B <= 1'b1;
							endcase
						end
			ADDRESS:	begin
							if(address_done) begin
								F_WEN_B <= 1'b1;
							end else if(F_ALE_B) begin
								F_WEN_B <= ~F_WEN_B;
							end
						end
			READ_DATA:	begin
							if (F_REN_A) begin
								F_WEN_B <= 1'b1;
							end else begin
								F_WEN_B <= 1'b0;
							end
						end
			WRITE_DONE:	begin
							case (cnt)
								8'h1ff:		F_WEN_B <= 1'b0;
								8'd2:		F_WEN_B <= 1'b0;
								default:	F_WEN_B <= 1'b1;
							endcase
						end
			default:	F_WEN_B <= 1'b1;
		endcase
	end
end

// output F_ALE_B;
always @(posedge clk or posedge rst) begin
	if(rst) begin
		F_ALE_B <= 1'b0;
	end else begin
		case (state)
			ADDRESS:	F_ALE_B <= 1'b1;
			default:	F_ALE_B <= 1'b0;
		endcase
	end
end

//inout  [7:0] F_IO_B;
assign F_IO_B = F_IO_B_reg;

//reg  [7:0] F_IO_B_reg;
always @(posedge clk or posedge rst) begin
	if(rst) begin
		F_IO_B_reg <= 8'dz;
	end else begin
		case (state)
			PAGE_CMD:	begin
							case(cnt) 
								8'd1: 		F_IO_B_reg <= (page_select) ? 8'h01 : 8'h80;
								8'd4:		F_IO_B_reg <= 8'h80;
								default:	F_IO_B_reg <= 8'dz;
							endcase
						end
			ADDRESS:	begin
							case (cnt)
								8'd1:		F_IO_B_reg <= 8'h00;
								8'd3:		F_IO_B_reg <= row_cnt[7:0];
								8'd5:		F_IO_B_reg <= {7'd0, row_cnt[8]};
								default:	F_IO_B_reg <= 8'dz;
							endcase
						end
			READ_DATA:	begin
							F_IO_B_reg <= (~F_REN_A) ? F_IO_A : 8'dz;
						end
			WRITE_DONE:	begin
							if(read_data_done) begin
								F_IO_B_reg <= F_IO_A;
							end else if(~F_WEN_B) begin
								F_IO_B_reg <= 8'h10;
							end else begin
								F_IO_B_reg <= 8'dz;
							end
						end	
			default:	F_IO_B_reg <= 8'dz;
		endcase
	end
end

//-----------------------------------------------------------------------
// System Output Signal
//-----------------------------------------------------------------------
//output done;
always @(posedge clk or posedge rst) begin
	if(rst) begin
		done <= 1'b0;
	end else if(page_select && write_done_flag && row_cnt == 9'h1ff) begin
		done <= 1'b1;
	end
end

endmodule

`timescale 1ns/100ps
module FC(
  // mater control 
  clk,
  rst,
  cmd, 
  done, 
  // internal memory
  M_RW, 
  M_A, 
  M_D, 
  // flash memory
  F_IO, 
  F_CLE, 
  F_ALE, 
  F_REN, 
  F_WEN, 
  F_RB
);

// cmd 0_010010001101000101_0000000_1101110
// flash memory   0_ 10010001_   1_    01000101 
//				 3rd    2ed      cmd		1st

//---------------------------------------------------------------------
// Parameter Declaration
//---------------------------------------------------------------------
localparam IDLE      	    = 0;
localparam INITIAL_FLASH    = 1;
localparam JUDGE    	    = 2;
localparam WRITE_CMD        = 3;
localparam ADDRESS	        = 4;
localparam WRITE_DATA 	    = 5;
localparam WRITE_FINISH_CMD = 6;
localparam READ_CMD         = 7;
localparam READ_DATA 	    = 8;
localparam WAIT 			= 9;

//--------------------------------------------------------------------
// Input / Output Declaration
//--------------------------------------------------------------------
// master control
input clk;
input rst;
input [32:0] cmd;
output reg done;
// internal memory
inout  [7:0] M_D;
output reg [6:0] M_A;
output reg M_RW;
// flash memory
inout  [7:0] F_IO;    // command / address / data
input  F_RB;
output reg F_CLE;
output reg F_ALE;
output reg F_REN;
output reg F_WEN;

//---------------------------------------------------------------------
// Wires / Registers
//---------------------------------------------------------------------
wire initial_done;
wire flash_address_time;
wire count_done;
wire f_rb_pos;
wire [6:0] internal_mem_addr;
reg	 temp[0:1];
reg  cmd_done;
reg  [3:0] state, next_state;
reg  [6:0] cnt;
reg  [7:0] F_IO_reg;
reg  [7:0] M_D_reg;

//---------------------------------------------------------------------
// Flag
//---------------------------------------------------------------------
//wire initial_done;
assign initial_done = (cnt == 6'd2) ? 1'b1 : 1'b0;

//wire flash_address_time;
assign flash_address_time = (cnt == 7'd6) ? 1'b1 : 1'b0;

//wire count_done;
assign count_done = (cnt == cmd[6:0]) ? 1'b1 : 1'b0;

//wire internal_mem_addr;
assign internal_mem_addr = cmd[13:7];

//wire f_rb_pos;
assign f_rb_pos = (temp[0] & ~temp[1]);

//reg	 temp[0:1];
always @(posedge clk) begin
	temp[0] <= F_RB;
	temp[1] <= temp[0];
end

//wire cmd_done;
always @(*) begin
	case (state)
		WRITE_CMD,
		WRITE_FINISH_CMD:	begin
								if(cmd[22] && ~cmd[32]) begin // A8 in Flash address
									cmd_done = (cnt == 7'd5) ? 1'b1 : 1'b0;
								end else begin
									cmd_done = (cnt == 7'd1) ? 1'b1 : 1'b0;
								end
							end
		default:			cmd_done = 1'b0;
	endcase
end

//---------------------------------------------------------------------
// State Machine 
//---------------------------------------------------------------------
//cmd[32] == 1 -> flash -> internel (read)
//cmd[32] == 0 -> internel to flash	(write)
//reg [2:0] next_state;
always @(*) begin
	case (state)
		INITIAL_FLASH:		next_state = (initial_done) ? IDLE : INITIAL_FLASH;
		IDLE:	        	next_state = JUDGE;
		JUDGE:		   		next_state = WRITE_CMD;
		WRITE_CMD:			next_state = (cmd_done) ? ADDRESS : WRITE_CMD;
		ADDRESS:			begin
								if(flash_address_time) begin
									next_state = (cmd[32]) ? WAIT : WRITE_DATA;
								end else begin
									next_state = ADDRESS;
								end
							end
		// temporart	
		WRITE_DATA:			next_state = (count_done) ? WRITE_FINISH_CMD : WRITE_DATA;
		WRITE_FINISH_CMD:	next_state = (cmd_done) ? WAIT : WRITE_FINISH_CMD;
		READ_DATA:			next_state = (count_done) ? IDLE : READ_DATA;
		WAIT:				begin
								if(f_rb_pos) begin
									next_state = (cmd[32]) ? READ_DATA : IDLE;
								end else begin
									next_state = WAIT;
								end
							end
		default:        	next_state = IDLE;
  	endcase
end

//reg [2:0] state;
always @(posedge clk or posedge rst) begin
	if(rst) begin
		state <= INITIAL_FLASH;
	end else begin
		state <= next_state;
	end
end

//---------------------------------------------------------------------
// Master Signal
//---------------------------------------------------------------------
//output reg done;
always @(posedge clk or posedge rst) begin
	if(rst) begin
		done <= 1'b0;
	end else begin
		done <= (state == IDLE) ? 1'b1 : 1'b0;
	end
end

//---------------------------------------------------------------------
// Internel Memory Signel
//---------------------------------------------------------------------
//output reg M_RW;
always @(negedge clk or posedge rst) begin
	if(rst) begin
		M_RW <= 1'b1;
	end else begin
		case (state)
			READ_DATA:	M_RW <= (~F_REN) ? 1'b0 : 1'b1;
			default:	M_RW <= 1'b1;
		endcase
	end
end

//output reg [6:0] M_A;
always @(negedge clk or posedge rst) begin
	if(rst) begin
		M_A <= 7'd0;
	end else begin
		case (state)
			WRITE_DATA:	M_A <= internal_mem_addr + cnt;
			READ_DATA:	M_A <= (~F_REN) ? internal_mem_addr + cnt : M_A;
			default:	M_A <= 7'd0;
		endcase
	end
end

//inout [7:0] M_D;
assign M_D = M_D_reg;

//reg [7:0] M_D_reg
always @(negedge clk or posedge rst) begin
	if(rst) begin
		M_D_reg <= 8'dz;
	end else if(state == READ_DATA) begin
		M_D_reg <= (~F_REN) ? F_IO : 8'dz;
	end
end

//---------------------------------------------------------------------
// Flash Memory Signal
//---------------------------------------------------------------------
// output reg F_CLE;
always @(posedge clk or posedge rst) begin
	if(rst) begin
		F_CLE <= 1'b0;
	end else begin
		case (state)
			INITIAL_FLASH,
			WRITE_FINISH_CMD:	F_CLE <= (cnt <= 7'd1) ? 1'b1 : 1'b0;
			WRITE_CMD: 	  		begin
									case(cnt)
										7'd2,
										7'd5:	 F_CLE <= 1'b0;
										default: F_CLE <= 1'b1;
									endcase
						  		end
			default:   	   		F_CLE <= 1'b0;
		endcase
	end
end

// output reg F_WEN;
always @(negedge clk or posedge rst) begin
	if(rst) begin
		F_WEN <= 1'b1;
	end else begin
		case (state)
			INITIAL_FLASH,
			WRITE_FINISH_CMD:	F_WEN <= (F_CLE) ? ~F_WEN : F_WEN;
			WRITE_CMD:	   		begin
									case (cnt)
										7'd1, 
										7'd4: 	 F_WEN <= 1'b0;
										default: F_WEN <= 1'b1;
									endcase
						   		end
			ADDRESS:			begin
									case (cnt) 
										7'd1,
										7'd3,
										7'd5:		F_WEN <= 1'b0;
										default:	F_WEN <= 1'b1;
									endcase
								end
			WRITE_DATA:			begin
									if(~count_done && ~F_ALE) begin
										F_WEN <= ~F_WEN;
									end else begin
										F_WEN <= 1'b1;
									end
								end
			default:   	   		F_WEN <= 1'b1;
		endcase
	end
end

//output reg F_ALE;
always @(posedge clk or posedge rst) begin
	if(rst) begin
		F_ALE <= 1'b1;
	end else begin
		case (state)
			INITIAL_FLASH: 		F_ALE <= (cnt <= 7'd1) ? 1'b0 : 1'b1;
			WRITE_CMD,
			WRITE_FINISH_CMD:  	begin
									case(cnt)
										7'd2,
										7'd5:	 F_ALE <= 1'b1;	
										default: F_ALE <= 1'b0;
									endcase
								end			
			WRITE_DATA,
			READ_DATA:			F_ALE <= 1'b0;
			default:   	   		F_ALE <= 1'b1;
		endcase
	end
end

//reg [7:0] F_IO_reg;
assign F_IO = F_IO_reg;
always @(posedge clk or posedge rst) begin
	if(rst) begin
		F_IO_reg <= 8'dz;
	end else begin
		case (state)
			INITIAL_FLASH: 		F_IO_reg <= (cnt == 7'd1) ? 8'hff : F_IO_reg;
			WRITE_CMD:			begin
									case (cnt)
											7'd1:		begin
															if(cmd[32]) begin
																F_IO_reg <= (cmd[22]) ? 8'h01 : 8'h00;
															end else begin
																F_IO_reg <= (cmd[22]) ? 8'h01 : 8'h80;	
															end
														end
											7'd4: 		F_IO_reg <= 8'h80;
											default:	F_IO_reg <= 8'dz;
									endcase
								end
			ADDRESS:			begin
									case (cnt)
										7'd1:		F_IO_reg <= cmd[21:14];			// flash address 
										7'd3:		F_IO_reg <= cmd[30:23];
										7'd5:		F_IO_reg <= {7'd0, cmd[31]};
										default: 	F_IO_reg <= 8'dz;
									endcase
								end
			WRITE_DATA:			begin
									if(~F_WEN) begin
										F_IO_reg <= M_D;
									end else begin
										F_IO_reg <= 8'dz;
									end
								end
			WRITE_FINISH_CMD:	begin
									if(cnt == 7'd1) begin
										F_IO_reg <= 8'h10;
									end else begin
										F_IO_reg <= 8'dz;
									end
								end
			default:   	   		F_IO_reg <= 8'dz;
		endcase
	end
end

// output F_REN;
always @(posedge clk or posedge rst) begin
	if(rst) begin
		F_REN <= 1'b1;
	end else if(state == READ_DATA) begin
		F_REN <= (count_done) ? 1'b1 : ~F_REN;
	end else begin
		F_REN <= 1'b1;
	end
end

//---------------------------------------------------------------------
// Timing 
//---------------------------------------------------------------------
//reg [6:0] cnt;
always @(posedge clk or posedge rst) begin
	if(rst) begin
		cnt <= 7'd0;
	end else begin
		case (state)
			INITIAL_FLASH:  	cnt <= cnt + 7'd1;
			WRITE_CMD,
			WRITE_FINISH_CMD:	cnt <= (cmd_done) ? 7'd0 : cnt + 7'd1;
			ADDRESS:			cnt <= (flash_address_time) ? 7'd0 : cnt + 7'd1;
			WRITE_DATA,
			READ_DATA:			begin
									if(count_done) begin
										cnt <= 7'd0;
									end else if(~F_WEN || (F_WEN && ~F_REN)) begin
										cnt <= cnt + 7'd1;
									end
								end
			default: 	   		cnt <= 7'd0;
		endcase
	end
end

endmodule

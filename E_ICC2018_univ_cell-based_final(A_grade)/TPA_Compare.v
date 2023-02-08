module TPA(
	clk, 
	reset_n, 
	SCL, 
	SDA, 
	cfg_req, 
	cfg_rdy, 
	cfg_cmd, 
	cfg_addr, 
	cfg_wdata, 
	cfg_rdata
);

//----------------------------------------------------------------------------
// Parameter Declaration
//----------------------------------------------------------------------------
localparam IDLE 	  	 = 0;
localparam I2C_WRITE  	 = 1;
localparam REG_WRITE  	 = 2;
localparam READ_ADDR	 = 3;
localparam READ_START 	 = 4;
localparam READ_SEND 	 = 5;
localparam END			 = 6;

//----------------------------------------------------------------------------
// Input & Output Declaration
//----------------------------------------------------------------------------
input 		clk; 
input 		reset_n;
// Two-Wire Protocol slave interface 
input 		SCL;  
inout		SDA;
// Register Protocal Master interface 
input				cfg_req;
input				cfg_cmd;		// 1 -> write 0 -> read
output	reg			cfg_rdy;
input	[7:0]		cfg_addr;
input	[15:0]		cfg_wdata;
output	reg [15:0]  cfg_rdata;

//----------------------------------------------------------------------------
// Register & Wire Declaration
//----------------------------------------------------------------------------
integer i;
// RIM
wire rim_process_time;
wire rim_write_time;
wire rim_read_time;
// I2C
wire i2c_start;
wire finish;
wire read_addr_done;
reg  SDA_reg;
reg  [1:0] temp;
reg	 [7:0]	i2c_addr;
reg	 [15:0]	i2c_wdata;
// Register
reg	 [15:0] Register_Spaces	[0:255];
// state machine
reg  [2:0] state, next_state;
//
wire concur_write_flag;
reg  [1:0] concur_write_catch;
reg  [3:0] cnt;
reg	 [7:0] cfg_addr_temp;
// ===== Coding your RTL below here ================================= 

//----------------------------------------------------------------------------
// Register Protocal Master interface
//----------------------------------------------------------------------------
// wire rim_process_time;
assign rim_process_time = cfg_req & cfg_rdy;

// wire rim_write_time;
assign rim_write_time = rim_process_time & cfg_cmd;

// wire rim_read_time;
assign rim_read_time = rim_process_time & ~cfg_cmd;

//output		cfg_rdy;
always @(posedge clk or negedge reset_n) begin
	if(~reset_n) begin
		cfg_rdy <= 1'b0;
	end else if(cfg_req) begin
		cfg_rdy <= 1'b1;
	end else begin
		cfg_rdy <= 1'b0;
	end
end

//output	[15:0]  cfg_rdata;
always @(posedge clk or negedge reset_n) begin
	if(~reset_n) begin
		cfg_rdata <= 16'd0;
	end else if(rim_read_time) begin
		cfg_rdata <= Register_Spaces[cfg_addr];
	end
end

//----------------------------------------------------------------------------
// Two-Wire Protocol
//----------------------------------------------------------------------------
// inout SDA;
assign SDA = SDA_reg;

//reg  SDA_reg;
always @(posedge clk or negedge reset_n) begin
	if(~reset_n) begin
		SDA_reg <= 1'b0;
	end else begin
		case(state)
			READ_START:	SDA_reg <= (cnt == 4'd0) ? 1'b1 : 1'b0;
			READ_SEND:	SDA_reg <= i2c_wdata[cnt];
			END:		SDA_reg <= 1'b1;
			default:	SDA_reg <= 1'bz;
		endcase
	end
end

// wire i2c_start;
assign i2c_start = (temp == 2'd2) ? 1'b1 : 1'b0;

// reg	 [7:0]	i2c_addr;
always @(posedge clk or negedge reset_n) begin
	if(~reset_n) begin
		i2c_addr <= 8'd0;
	end else begin
		case (state)
			READ_ADDR,
			I2C_WRITE:	begin
							if(temp == 2'd0 || (temp == 2'd1 && cnt == 4'd7)) begin
								case(cnt)
									4'd0: 		i2c_addr[0] <= SDA;
									4'd1: 		i2c_addr[1] <= SDA;
									4'd2: 		i2c_addr[2] <= SDA;
									4'd3: 		i2c_addr[3] <= SDA;
									4'd4: 		i2c_addr[4] <= SDA;
									4'd5: 		i2c_addr[5] <= SDA;
									4'd6: 		i2c_addr[6] <= SDA;
									4'd7: 		i2c_addr[7] <= SDA;
									default:	i2c_addr <= i2c_addr;
								endcase
							end
						end
			default:	i2c_addr <= 8'd0;
		endcase
	end
end

// reg	 [15:0]	i2c_wdata;
always @(posedge clk or negedge reset_n) begin
	if(~reset_n) begin
		i2c_wdata <= 8'd0;
	end else begin
		case (state)
			I2C_WRITE:	i2c_wdata[cnt] <= SDA;
			READ_ADDR:	i2c_wdata = (read_addr_done) ? Register_Spaces[i2c_addr] : i2c_wdata;
			default:	i2c_wdata <= i2c_wdata;
		endcase
	end
end

//wire finish;
assign finish = (cnt == 4'd15) ? 1'b1 : 1'b0;

//wire read_addr_done;
assign read_addr_done = (cnt == 4'd8) ? 1'b1 : 1'b0;

//----------------------------------------------------------------------------
// State Macine For Two-Wire Protocal
//----------------------------------------------------------------------------
//reg  state, next_state;
always @(posedge clk or negedge reset_n) begin
	if(~reset_n) state <= IDLE;
	else state <= next_state;
end

//reg  next_state;
always @(*) begin
	case (state)
		IDLE:			begin
							if(i2c_start) begin
								next_state = (SDA) ? I2C_WRITE : READ_ADDR;
							end else begin
								next_state = IDLE;
							end
						end
		I2C_WRITE:		next_state = (finish) ? REG_WRITE : I2C_WRITE;
		READ_ADDR:		next_state = (read_addr_done) ? READ_START : READ_ADDR;
		READ_START:		next_state = (cnt == 2'd1) ? READ_SEND : READ_START;
		READ_SEND:		next_state = (finish) ? END : READ_SEND;
		default:		next_state = IDLE;
	endcase
end

//----------------------------------------------------------------------------
// Register Space
//----------------------------------------------------------------------------
//reg	[15:0] Register_Spaces	[0:255];
always @(posedge clk or negedge reset_n) begin
	if(~reset_n) begin
		for(i = 0; i < 256; i = i + 1) begin
			Register_Spaces[i] <= 16'd0;
		end
	end else if(rim_write_time) begin
		Register_Spaces[cfg_addr] <= cfg_wdata;
	end else if(state == REG_WRITE && (concur_write_flag && cfg_addr_temp != i2c_addr || ~concur_write_flag)) begin
		Register_Spaces[i2c_addr] <= i2c_wdata;
	end
end

//----------------------------------------------------------------------------
// Flag & Counter
//----------------------------------------------------------------------------
//reg [1:0] temp;
always @(posedge clk or negedge reset_n) begin
	if(~reset_n) temp <= 2'd0;
	else begin
		case (state)
			IDLE:		temp <= (i2c_start) ? 2'd0 : {temp[0],SDA};
			I2C_WRITE:	temp <= (cnt == 4'd6) ? temp + 2'd1 : temp;
			default:	temp <= 2'd0;
		endcase
	end
end

//reg  [3:0] cnt;
always @(posedge clk or negedge reset_n) begin
	if(~reset_n) begin
		cnt <= 4'd0;
	end else begin
		case (state)
			READ_ADDR:	cnt <= (read_addr_done) ? 4'd0 : cnt + 4'd1;
			I2C_WRITE:		cnt <= (temp == 2'd1 && cnt == 4'd7) ? 4'd0 : cnt + 4'd1;	
			READ_START:		cnt <= (cnt == 4'd1) ? 4'd0 : cnt + 4'd1;
			READ_SEND:		cnt <= (finish) ? 4'd0 : cnt + 4'd1;
			default:		cnt <= 4'd0;
		endcase
	end
end

//wire concur_write_flag;
assign concur_write_flag =(concur_write_catch == 2'd1) ? 1'b1 : 1'b0;

//reg concur_write_catch
//reg	 [7:0] cfg_addr_temp;
always @(posedge clk or negedge reset_n) begin
	if(~reset_n) begin
		concur_write_catch <= 2'd0;
		cfg_addr_temp <= 8'd0;
	end else begin
		case(state)
			IDLE:		begin
							if(cfg_req && cfg_cmd) begin	// RIM Write Time
								concur_write_catch <= {concur_write_catch[0],SDA};
							end
						end
			I2C_WRITE:	begin
							concur_write_catch <= concur_write_catch;
							cfg_addr_temp <= (concur_write_flag) ? cfg_addr : 8'd0;
						end
			default:	begin
							concur_write_catch <= 3'd0;
							cfg_addr_temp <= 8'd0;
						end
		endcase
	end
end

//--------------------------------------------------------------------
// Debug
//--------------------------------------------------------------------
// initial begin
// 	forever begin
// 		@(posedge clk);
// 		if(cfg_req && cfg_cmd && cfg_addr == 128) begin
// 			$display("\nRIM WRITE time : %d \n", $time);
// 		end else if(state == REG_WRITE && i2c_addr == 128) begin
// 			$display("\nI2C WRITE time : %d \n", $time);
// 		end
// 	end
// end

endmodule

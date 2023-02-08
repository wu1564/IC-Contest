module modified_booth (
	clk,
	reset,
	multiplicand,  // multiplicand * multiplier
	multiplier,
	result,
	start_flag,
	strobe	
);

//////////////////Parameters//////////////////////
localparam IDLE = 3'd0;
localparam ENCODE = 3'd1;
localparam SHIFT = 3'd2;
localparam CAL = 3'd3;
localparam OUT = 3'd4;
//////////////////////////////////////////////////

/////////////////Port Declaration/////////////////
input clk;
input reset;
input start_flag;
input signed [11:0] multiplicand; //multiplied
input signed [11:0] multiplier;
output reg strobe;
output reg signed [23:0] result;
//////////////////////////////////////////////////

/////////////////Private Declaration//////////////
reg [2:0] encode_value;
reg [2:0] state, next_state;
reg [2:0] round_cnt;
reg signed [23:0] encode_cal;
//////////////////////////////////////////////////

//////////////////////encode_value////////////////
always @(*) begin
	case (round_cnt)
		3'd0: 	 encode_value = {multiplier[1:0],1'b0};
		3'd1: 	 encode_value = multiplier[3:1];
		3'd2: 	 encode_value = multiplier[5:3];
		3'd3: 	 encode_value = multiplier[7:5];
		3'd4:	 encode_value = multiplier[9:7];
		3'd5:	 encode_value = multiplier[11:9];	 
		default: encode_value = 3'd0;
	endcase
end
//////////////////////////////////////////////////

//////////////////////next_state//////////////////
always @(*) begin
	case (state)
		IDLE: 	 next_state = (start_flag) ? ENCODE : IDLE;
		ENCODE:  next_state = SHIFT;
		SHIFT:	 next_state = CAL;
		CAL: 	 next_state = (round_cnt == 3'd5) ? OUT : ENCODE;
		default: next_state = IDLE;
	endcase
end
//////////////////////////////////////////////////

/////////////////////state////////////////////////
always @(posedge clk or posedge reset) begin
	if(reset) begin
		state <= IDLE;
	end else begin
		state <= next_state;
	end
end
//////////////////////////////////////////////////

/////////////////////round_cnt////////////////////
always @(posedge clk or posedge reset) begin
	if(reset) begin
		round_cnt <= 3'd0;
	end else begin
		case (state)
			IDLE:	 round_cnt <= 3'd0;
			CAL: 	 round_cnt <= round_cnt + 3'd1;
			default: round_cnt <= round_cnt;
		endcase
	end
end
//////////////////////////////////////////////////

////////////////////encode_cal////////////////////
always @(posedge clk or posedge reset) begin
	if(reset) begin
		encode_cal <= 24'd0;
	end else begin
		case (state)
			ENCODE:		begin
							case (encode_value)
								3'd0, 3'd7:	encode_cal <= 24'd0;
								3'd1, 3'd2: encode_cal <= {{12{multiplicand[11]}},multiplicand};
								3'd5, 3'd6: encode_cal <= ~({{12{multiplicand[11]}},multiplicand}) + 24'd1;
								3'd3: 		encode_cal <= {{11{multiplicand[11]}},multiplicand,1'b0};
								3'd4:		encode_cal <= ~({{11{multiplicand[11]}},multiplicand,1'b0}) + 24'd1;
								default:	encode_cal <= 24'd0;
							endcase
						end
			SHIFT:		begin
							case (round_cnt)
								3'd1: 	 encode_cal <= {encode_cal[21:0],2'd0};
								3'd2: 	 encode_cal <= {encode_cal[19:0],4'd0};
								3'd3: 	 encode_cal <= {encode_cal[17:0],6'd0};
								3'd4:	 encode_cal <= {encode_cal[15:0],8'd0};
								3'd5:	 encode_cal <= {encode_cal[13:0],10'd0};
								default: encode_cal <= encode_cal;
							endcase
						end
			default:	encode_cal <= encode_cal;
		endcase
	end
end
///////////////////////////////////////////////////

/////////////////////result////////////////////////
always @(posedge clk or posedge reset) begin
	if(reset) begin
		result <= 24'd0;
	end else begin
		case (state)
			IDLE:	 result <= 24'd0;
			CAL: 	 result <= result + encode_cal;
			default: result <= result;
		endcase
	end
end
///////////////////////////////////////////////////

//////////////////////strobe////////////////////////
always @(posedge clk or posedge reset) begin
	if(reset) begin
		strobe <= 1'b0;
	end else begin
		case (state)
			OUT: 	 strobe <= 1'b1;
			default: strobe <= 1'b0;
		endcase
	end
end
///////////////////////////////////////////////////

endmodule

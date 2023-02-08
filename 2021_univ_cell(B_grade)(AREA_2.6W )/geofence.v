module geofence_v1 (
	clk,
	reset,
	X,
	Y,
	valid,
	is_inside
);

input clk;
input reset;
input [9:0] X;
input [9:0] Y;
output reg valid;
output reg is_inside;

////////////////////Parameters//////////////////////
localparam IDLE = 4'd0;
localparam RECEIVE = 4'd1;
localparam CREATE_VECTOR = 4'd2;
localparam CROSS_PRODUCT = 4'd3;
localparam JUDGE = 4'd4;
localparam TWO_VECTOR = 4'd5;
localparam CROSS_PRODUCT2 = 4'd6;
localparam JUDGE2 = 4'd7;
localparam FINAL = 4'd8;
////////////////////////////////////////////////////

//////////////Private Declaration///////////////////
// necessary
reg [9:0] target_x;
reg [9:0] target_y;
reg [9:0] point_x[0:5];
reg [9:0] point_y[0:5];
// my algorithm used 
reg [3:0] state, next_state;
reg [2:0] receive_cnt, cycle_cnt;
reg [2:0] record;
reg signed [10:0] vector_x[0:1];
reg signed [10:0] vector_y[0:1];
reg signed [21:0] calculate;
////////////////////////////////////////////////////

//////////////////////next_state////////////////////
always @(*) begin
	case (state) 
	    IDLE: 			next_state = RECEIVE;
	    RECEIVE:		next_state = (receive_cnt == 3'd5) ? CREATE_VECTOR : RECEIVE;
	    CREATE_VECTOR: 	next_state = (record != 3'd4) ? CROSS_PRODUCT : TWO_VECTOR;
	    CROSS_PRODUCT: 	next_state = JUDGE;
	    JUDGE:			next_state = CREATE_VECTOR;
	    TWO_VECTOR:		next_state = (cycle_cnt == 3'd6) ? FINAL : CROSS_PRODUCT2;
	    CROSS_PRODUCT2: next_state = JUDGE2;
	    JUDGE2:			next_state = TWO_VECTOR;
	    FINAL:			next_state = (cycle_cnt == 3'd1) ? IDLE : FINAL;
	    default:		next_state = IDLE;
	endcase
end
////////////////////////////////////////////////////

//////////////////////state/////////////////////////
always @(posedge clk or posedge reset) begin
	if(reset) begin
		state <= IDLE;
	end else begin
		state <= next_state;
	end
end
////////////////////////////////////////////////////

//////////////////////receive_cnt///////////////////
always @(posedge clk or posedge reset) begin
	if(reset) begin
		receive_cnt <= 3'd0;
	end else begin
		case (state)
			RECEIVE: receive_cnt <= receive_cnt + 3'd1;
			default: receive_cnt <= 3'd0;
		endcase
	end
end
////////////////////////////////////////////////////

///////////////////////target_x/////////////////////
always @(posedge clk or posedge reset) begin
	if(reset) begin
		target_x <= 10'd0;
	end else begin
		case (state)
			IDLE: 	 target_x <= X;
			default: target_x <= target_x; 
		endcase
	end
end
////////////////////////////////////////////////////

///////////////////////target_y/////////////////////
always @(posedge clk or posedge reset) begin
	if(reset) begin
		target_y <= 10'd0;
	end else begin
		case (state)
			IDLE:	 target_y <= Y;
			default: target_y <= target_y;
		endcase
	end
end
////////////////////////////////////////////////////

//////////////////////point_x///////////////////////
integer i;
always @(posedge clk or posedge reset) begin
	if(reset) begin
		for(i = 0; i < 6; i = i + 1) begin
			point_x[i] <= 10'd0;
		end
	end else begin
		case (state)
			RECEIVE:	point_x[receive_cnt] <= X;
			JUDGE:		begin
							if(~calculate[21]) begin
								point_x[cycle_cnt+1] <= point_x[cycle_cnt+2];
								point_x[cycle_cnt+2] <= point_x[cycle_cnt+1];
							end
						end
			default:	begin
							for(i = 0; i < 6; i = i + 1) begin
								point_x[i] <= point_x[i];
							end
						end
		endcase
	end
end
////////////////////////////////////////////////////

//////////////////////point_y///////////////////////
integer j;
always @(posedge clk or posedge reset) begin
	if(reset) begin
		for(i = 0; i < 6; i = i + 1) begin
			point_y[i] <= 10'd0;
		end
	end else begin
		case (state)
			RECEIVE:	point_y[receive_cnt] <= Y;
			JUDGE:		begin
							if(~calculate[21]) begin
								point_y[cycle_cnt+1] <= point_y[cycle_cnt+2];
								point_y[cycle_cnt+2] <= point_y[cycle_cnt+1];
							end
						end
			default:	begin
							for(i = 0; i < 6; i = i + 1) begin
								point_y[i] <= point_y[i];
							end
						end
		endcase
	end
end
////////////////////////////////////////////////////

///////////////////record/////////////////////////
always @(posedge clk or posedge reset) begin
	if(reset) begin
		record <= 3'd0;
	end else begin
		case (state)
			IDLE:	 		record <= 3'd0;
			CREATE_VECTOR:	record <= (record == 3'd4) ? 3'd0 : record;
			JUDGE:	 		record <= (calculate[21]) ? record + 3'd1 : 3'd0;
			JUDGE2:			record <= (~calculate[21]) ? record + 3'd1 : record;
			default: 		record <= record;
		endcase
	end
end
////////////////////////////////////////////////////

/////////////////////cycle_cnt//////////////////////
always @(posedge clk or posedge reset) begin
	if(reset) begin
		cycle_cnt <= 3'd0;
	end else begin
		case (state)
			IDLE:	 		cycle_cnt <= 3'd0;
			CREATE_VECTOR:	cycle_cnt <= (record == 3'd4) ? 3'd0 : cycle_cnt;
			JUDGE:	 		cycle_cnt <= (cycle_cnt != 3'd3) ? cycle_cnt + 3'd1 : 3'd0;
			JUDGE2:			cycle_cnt <= (cycle_cnt != 3'd6) ? cycle_cnt + 3'd1 : 3'd0;
			FINAL:			cycle_cnt <= 3'd1;
			default: 		cycle_cnt <= cycle_cnt;
		endcase
	end
end
////////////////////////////////////////////////////

////////////////////////vector_x////////////////////
always @(posedge clk or posedge reset) begin
	if(reset) begin
		vector_x[0] <= 11'd0;
		vector_x[1] <= 11'd0;
	end else begin
		case (state) 
			CREATE_VECTOR: 	begin
								vector_x[0] <= {1'b0,point_x[cycle_cnt + 3'd1]} - {1'b0,point_x[0]};
								vector_x[1] <= {1'b0,point_x[cycle_cnt + 3'd2]} - {1'b0,point_x[0]};		
							end
			TWO_VECTOR:		begin
								case (cycle_cnt)
									3'd5:		begin
													vector_x[0] <= {1'b0,target_x} - {1'b0,point_x[5]};
													vector_x[1] <= {1'b0,point_x[0]} - {1'b0,point_x[5]};
												end
									3'd6:		begin
													vector_x[0] <= vector_x[0];
													vector_x[1] <= vector_x[1];
												end
									default:	begin
													vector_x[0] <= {1'b0,target_x} - {1'b0,point_x[cycle_cnt]};
													vector_x[1] <= {1'b0,point_x[cycle_cnt + 3'd1]} - {1'b0,point_x[cycle_cnt]};			
												end
								endcase
							end
		    default: 		begin
		    					vector_x[0] <= vector_x[0];
		    					vector_x[1] <= vector_x[1];	
		    				end
		endcase
	end
end
////////////////////////////////////////////////////

////////////////////////vector_y////////////////////
always @(posedge clk or posedge reset) begin
	if(reset) begin
		vector_y[0] <= 11'd0;
		vector_y[1] <= 11'd0;
	end else begin
		case (state) 
			CREATE_VECTOR: 	begin
								vector_y[0] <= {1'b0,point_y[cycle_cnt + 3'd1]} - {1'b0,point_y[0]};
								vector_y[1] <= {1'b0,point_y[cycle_cnt + 3'd2]} - {1'b0,point_y[0]};		
							end
			TWO_VECTOR:		begin
								case (cycle_cnt)
									3'd5:		begin
													vector_y[0] <= {1'b0,target_y} - {1'b0,point_y[5]};
													vector_y[1] <= {1'b0,point_y[0]} - {1'b0,point_y[5]};
												end
									3'd6:		begin
													vector_y[0] <= vector_y[0];
													vector_y[1] <= vector_y[1];
												end
									default:	begin
													vector_y[0] <= {1'b0,target_y} - {1'b0,point_y[cycle_cnt]};
													vector_y[1] <= {1'b0,point_y[cycle_cnt + 3'd1]} - {1'b0,point_y[cycle_cnt]};			
												end
								endcase
							end
		    default: 		begin
		    					vector_y[0] <= vector_y[0];
		    					vector_y[1] <= vector_y[1];	
		    				end
		endcase
	end
end
////////////////////////////////////////////////////

///////////////////////calculate////////////////////
always @(posedge clk or posedge reset) begin
	if(reset) begin
		calculate <= 22'd0;
	end else begin
		case (state)       //vec_x[0] * vec_y[1] - vec_x[1] * vec_y[0]
			CROSS_PRODUCT,
			CROSS_PRODUCT2: calculate <= ({{11{vector_x[0][10]}},vector_x[0]} * {{11{vector_y[1][10]}},vector_y[1]})
									 -	({{11{vector_x[1][10]}},vector_x[1]} * {{11{vector_y[0][10]}},vector_y[0]});
		    default: calculate <= calculate;
		endcase
	end
end
////////////////////////////////////////////////////

///////////////////////valid////////////////////////
always @(posedge clk or posedge reset) begin
	if(reset) begin
		valid <= 1'b0;
	end else begin
		case (state)
			FINAL: 	 valid <= (cycle_cnt == 3'd1) ? 1'b0 : 1'b1;
			default: valid <= 1'b0;
		endcase
	end
end
////////////////////////////////////////////////////

/////////////////////is_inside//////////////////////
always @(posedge clk or posedge reset) begin
	if(reset) begin
		is_inside <= 1'b0;
	end else begin
		case (state) 
			FINAL:	 is_inside <= (cycle_cnt != 3'd1) ? (record == 3'd6) ? 1'b1 : 1'b0 : 1'd0;
		    default: is_inside <= 1'b0;
		endcase
	end
end
////////////////////////////////////////////////////

endmodule


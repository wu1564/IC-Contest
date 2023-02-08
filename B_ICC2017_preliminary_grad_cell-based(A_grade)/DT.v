module DT(
	input 			clk, 
	input			reset,
	output	reg		done ,

	output	reg		sti_rd ,
	output	reg 	[9:0]	sti_addr ,
	input	[15:0]	sti_di,

	output	reg		res_wr ,
	output	reg		res_rd ,
	output	reg 	[13:0]	res_addr ,
	output	reg 	[7:0]	res_do,
	input	[7:0]	res_di
);

localparam Idle = 0,
           Forward = 1,
           Set = 2,
           Backward = 3;

reg start;
reg [1:0] temp;
reg [2:0] state, next_state;
reg [3:0] counter, cycle_cnt;
reg [13:0] index_cnt;
wire period, pulse;

always @(*) begin
	case (state) 
		Idle : next_state = (sti_addr == 1015 && counter == 15) ? Forward : Idle;
		Forward : next_state = (res_addr == 16257) ? Set : Forward;
		Set : next_state = Backward;
		Backward : next_state = (res_addr == 126) ? Idle : Backward;
		default : next_state = Idle;
	endcase
end

always @(posedge clk or negedge reset) begin
	if(~reset) begin
		state <= Idle;
	end else
		state <= next_state;
end

always @(posedge clk) begin
	temp[0] <= reset;
	temp[1] <= temp;
end

always @(posedge clk or negedge reset) begin
	if(~reset) begin
		sti_rd <= 1'b0;
	end else if(temp[0] && ~temp[1]) begin
		sti_rd <= 1'b1;
	end else if(sti_addr == 1015 && counter == 15) begin
		sti_rd <= 1'b0;
	end
end

always @(posedge clk or negedge reset) begin
    if(~reset) begin
    	counter <= 1;
    end else if(sti_rd) begin
        counter <= (counter == 15) ? 0 : counter + 1;
    end
end

always @(posedge clk or negedge reset) begin
	if(~reset) begin
		sti_addr <= 8;
	end else if(sti_rd) begin
		sti_addr <= (sti_addr == 1015) ? sti_addr : (counter == 15) ? sti_addr + 1 : sti_addr;
	end
end

always @(posedge clk or negedge reset) begin
	if(~reset) begin
		res_rd <= 1'b1;
		res_wr <= 1'b0;
		res_addr <= 0;
		res_do <= 0;
	end else if(sti_rd) begin
		res_wr <= (res_addr == 16254) ? 1'b0 : 1'b1;
		res_rd <= (res_addr == 16254) ? 1'b1 : 1'b0;
		res_addr <= (res_addr == 16254) ? 129 : sti_addr * 16 + counter;
		res_do <= sti_di[15 - counter];
	end else begin
		case (state)
			Forward : 	begin
				res_rd <= 1'b1;
				res_wr <= period;

				case(res_wr) 
					1'b1 :	begin
						case (res_addr[6:0])	
							7'd126 : res_addr <= res_addr + 3;
							default : res_addr <= res_addr + 1;
						endcase	
					end

					1'b0 :	begin
						if(res_di == 0 && res_addr[6:0] == 7'd126 && cycle_cnt == 0) begin
							res_addr <= res_addr + 3;
						end else if(res_di == 0 && cycle_cnt == 0) begin
							res_addr <= res_addr + 1;
						end else begin
							case(cycle_cnt) 
								0 : res_addr <= res_addr - 129;//NW
								1 : res_addr <= res_addr + 1;//N
								2 : res_addr <= res_addr + 1;//Ne
								3 : res_addr <= res_addr + 126;//W
								default : res_addr <= index_cnt;
							endcase
						end 
					end
					default : res_addr <= res_addr;
				endcase

				case (period)
					1'b0 :	begin
						res_do <= (res_addr == 16254) ? res_do :
						          (cycle_cnt == 1) ? res_di : 
						          (res_di < res_do) ? res_di : res_do;
					end
					1'b1 : res_do <= (res_di > 0) ? res_do + 1 : 1'b0;
				endcase		
			end
			
			Set : 	begin
				res_rd <= 0;
				res_wr <= 0;
				res_do <= 0;
			end

			Backward : 	begin
				res_rd <= 1'b1;
				res_wr <= period;

				case(res_wr)
					1'b1 :	begin
						case (res_addr[6:0])	
							7'd1 : res_addr <= res_addr - 3;
							default : res_addr <= res_addr - 1;
						endcase		
					end

					1'b0 : begin
						if(res_di == 0 && res_addr[6:0] == 7'd1 && cycle_cnt == 0) begin
							res_addr <= res_addr - 3;
						end else if(res_di == 0 && cycle_cnt == 0) begin
							res_addr <= res_addr - 1;
						end else begin
							case(cycle_cnt) 
								0 : res_addr <= res_addr + 129;//NW
								1 : res_addr <= res_addr - 1;//N
								2 : res_addr <= res_addr - 1;//Ne
								3 : res_addr <= res_addr - 126;//W
								default : res_addr <= index_cnt;
							endcase
						end 
					end
					default : res_addr <= res_addr;
				endcase
				case (period)
					1'b0 : res_do <= (cycle_cnt == 1) ? res_di : (res_di < res_do) ? res_di : res_do;
					1'b1 : res_do <= (res_di > 0) ? (res_di < res_do + 1) ? res_di : res_do + 1 : 1'b0;
				endcase
			end

			default :	begin
				res_rd <= res_rd;
				res_wr <= res_wr;
				res_addr <= res_addr;
				res_do <= res_do;
			end
		endcase
	end
end

assign period = (cycle_cnt == 5) ? 1'b1 : 1'b0;
assign pulse = (res_di > 0 && cycle_cnt == 0 && ~res_wr) ? 1'b1 : 1'b0;
always @(posedge clk or negedge reset) begin
    if(~reset) begin
    	cycle_cnt <= 0;
    	start <= 1'b0;
    end else begin
    	case (state)
    		Forward,Backward : begin
				if(pulse) begin
					start <= 1'b1;
				end else if(cycle_cnt == 4) begin
					start <= 1'b0;
				end

    			if(start || pulse) begin
    				cycle_cnt <= cycle_cnt + 1;
    			end else begin
    			    cycle_cnt <= 0;
    			end
    		end
    		
    		default : cycle_cnt <= cycle_cnt;
    	endcase 
    end 
end

always @(posedge clk or negedge reset) begin
    if(~reset) begin
    	index_cnt <= 129;
    end else begin
    	case (state)
    		Forward, Backward: begin
				if(res_di > 0 && cycle_cnt == 0) begin
					index_cnt <= res_addr;
				end
    		end
    		Set : index_cnt <= 16254;
    		default : index_cnt <= index_cnt;
    	endcase
    end
end

always @(posedge clk) begin
	if(state == Backward && res_addr == 126) begin
		done <= 1'b1;
	end else
		done <= 1'b0;
end

endmodule
 

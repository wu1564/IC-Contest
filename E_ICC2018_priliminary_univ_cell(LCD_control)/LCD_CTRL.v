module LCD_CTRL(clk, reset, cmd, cmd_valid, IROM_Q, IROM_rd, IROM_A, IRAM_valid, IRAM_D, IRAM_A, busy, done);
input clk;
input reset;

// command
input [3:0] cmd;
input cmd_valid;

// rom
input [7:0] IROM_Q; //data
output reg IROM_rd;
output reg [5:0] IROM_A; //0-63

// ram
output reg IRAM_valid;
output reg [7:0] IRAM_D;
output reg [5:0] IRAM_A;

output reg busy;
output reg done; 

// state 
localparam IDLE = 3'd0; 
localparam DATA = 3'd1;
localparam CMD = 3'd2;
localparam PROCESS = 3'd3;
localparam TRANSMIT = 3'd4;
localparam DONE = 3'd5;

// command
localparam WRITE = 4'd0;
localparam SHIFT_UP = 4'd1;
localparam SHIFT_DOWN = 4'd2;
localparam SHIFT_LEFT = 4'd3;
localparam SHIFT_RIGHT = 4'd4;
localparam MAX = 4'd5;
localparam MIN = 4'd6;
localparam AVG = 4'd7;
localparam COUNTER_CLOCKWISE_ROTATE = 4'd8;
localparam CLOCKWISE_ROTATE = 4'd9;
localparam MIRROR_X = 4'd10;
localparam MIRROR_Y = 4'd11;

wire data_finish;
wire process_done;
wire transmit_done;
wire [7:0] avg;
wire [7:0] upper_left;
wire [7:0] upper_right;
wire [7:0] under_left;
wire [7:0] under_right;
reg [3:0] state, next_state, cmd_value;
reg [5:0] cnt;
reg [7:0] rom_data[0:63];
reg [7:0] compare;
reg [7:0] point[0:1];
reg [7:0] index[0:3];

//////////////////////combinational logic/////////////////////
assign data_finish = (rom_data[63] != 8'd0) ? 1'b1 : 1'b0;
assign process_done = (cnt == 6'd4) ? 1'b1 : 1'b0;
assign transmit_done = (cnt == 6'd63) ? 1'b1 : 1'b0;
assign upper_left = index[0];
assign upper_right = index[1];
assign under_left = index[2];
assign under_right = index[3];
assign avg = (rom_data[upper_left] + rom_data[upper_right] + rom_data[under_left] + rom_data[under_right]) / 4;
//////////////////////////////////////////////////////////////

/////////////////////////////index////////////////////////////
always @(posedge clk or posedge reset) begin
    if (reset) begin
        index[0] <= 8'd0;
        index[1] <= 8'd0;
        index[2] <= 8'd0;
        index[3] <= 8'd0;
    end else begin
        case (state)
            PROCESS:    begin 
                            case (cmd_value)
                                SHIFT_RIGHT,
                                SHIFT_LEFT,
                                SHIFT_DOWN,
                                SHIFT_UP:    begin 
                                                case (cnt)
                                                    6'd1:       index[0] = (point[1] - 8'd1) * 8'd8 + point[0] - 8'd1;
                                                    6'd2:       index[1] = index[0] + 8'd1;
                                                    6'd3:       index[2] = index[0] + 8'd8;
                                                    6'd4:       index[3] = index[2] + 8'd1;
                                                    default:    begin 
                                                                index[0] <= index[0];
                                                                index[1] <= index[1];
                                                                index[2] <= index[2];
                                                                index[3] <= index[3];
                                                    end
                                                endcase
                                            end
                                default:    begin   
                                                index[0] <= index[0];
                                                index[1] <= index[1];
                                                index[2] <= index[2];
                                                index[3] <= index[3];
                                            end
                            endcase
                        end
            default:    begin
                            index[0] <= index[0];
                            index[1] <= index[1];
                            index[2] <= index[2];
                            index[3] <= index[3];
                        end
        endcase
    end
end
//////////////////////////////////////////////////////////////

///////////////////////////next_state/////////////////////////
always @(*) begin
    case (state)
   		IDLE: 		next_state = DATA;
   		DATA: 		next_state = (data_finish) ? CMD : DATA;
   		CMD: 		next_state = (cnt == 6'd1) ? PROCESS : CMD;
   		PROCESS:	begin
						case (cmd_value)
							WRITE: next_state = TRANSMIT;
							MAX,MIN: next_state = (process_done) ? CMD : PROCESS;
                            SHIFT_RIGHT,
                            SHIFT_LEFT,
                            SHIFT_DOWN,
                            SHIFT_UP: next_state = (cnt == 6'd4) ? CMD : state;
							default: next_state = CMD;
						endcase
   					end
   		TRANSMIT:	next_state = (transmit_done) ? DONE : TRANSMIT;
   		DONE: 		next_state = IDLE;
   		default: 	next_state = IDLE;
    endcase
end
//////////////////////////////////////////////////////////////

///////////////////////////state//////////////////////////////
always @(posedge clk or posedge reset) begin
    if(reset) begin
        state <= IDLE;
    end else begin
    	state <= next_state;
    end
end
//////////////////////////////////////////////////////////////

//////////////////////////////cnt/////////////////////////////
always @(posedge clk or posedge reset) begin
    if(reset) begin
        cnt <= 6'd0;
    end else begin
    	case (state)
    		CMD:		begin
    						cnt <= (cnt == 6'd1) ? 6'd0 : cnt + 6'd1;
    					end
    		PROCESS:	begin
    						case (cmd_value)
    							MAX,MIN: cnt <= (process_done) ? 6'd0 : cnt + 6'd1;
                                SHIFT_RIGHT,SHIFT_LEFT,SHIFT_DOWN,SHIFT_UP: cnt <= (cnt == 6'd4) ? 6'd0 : cnt + 6'd1;
    							default: cnt <= 6'd0;
    						endcase
    					end
    		TRANSMIT: 	cnt <= cnt + 6'd1;
    		default: 	cnt <= 6'd0;
    	endcase
    end
end
//////////////////////////////////////////////////////////////

////////////////////////////IROM_rd///////////////////////////
always @(posedge clk or posedge reset) begin
    if(reset) begin
        IROM_rd <= 1'b0;
    end else begin
    	case (state)
    		IDLE,DATA:	IROM_rd <= 1'b1;
    		default: 	IROM_rd <= 1'b0;
    	endcase
    end
end
//////////////////////////////////////////////////////////////

///////////////////////////IROM_A/////////////////////////////
always @(posedge clk or posedge reset) begin
    if(reset) begin
        IROM_A <= 6'd0;
    end else begin
    	case (state)
    		DATA: 	 IROM_A <= (data_finish) ? 4'd0 : IROM_A + 4'd1;
    		default: IROM_A <= 6'd0;
    	endcase
    end
end
//////////////////////////////////////////////////////////////

///////////////////////////rom_data///////////////////////////
integer i;
always @(posedge clk or posedge reset) begin
    if(reset) begin
        for (i = 0; i < 64; i = i + 1) begin
        	rom_data[i] <= 8'd0;
        end
    end else begin
    	case (state)
    		DATA: 		rom_data[IROM_A] <= IROM_Q;
    		PROCESS:	begin
    						case (cmd_value) 
				    			MAX,MIN:					begin
				    											if(process_done) begin
				    												rom_data[upper_left] <= compare;
					    											rom_data[upper_right] <= compare;
					    											rom_data[under_left] <= compare;
					    											rom_data[under_right] <= compare;
				    											end
				    										end
				    			AVG:						begin
				    											rom_data[upper_left] <= avg;
				    											rom_data[upper_right] <= avg;
				    											rom_data[under_left] <= avg;
				    											rom_data[under_right] <= avg;
				    										end
    							COUNTER_CLOCKWISE_ROTATE:	begin
    															rom_data[upper_left] <= rom_data[upper_right];
				    											rom_data[upper_right] <= rom_data[under_right];
				    											rom_data[under_left] <= rom_data[upper_left];
				    											rom_data[under_right] <= rom_data[under_left];
    														end
    							CLOCKWISE_ROTATE:			begin
    															rom_data[upper_left] <= rom_data[under_left];
				    											rom_data[upper_right] <= rom_data[upper_left];
				    											rom_data[under_left] <= rom_data[under_right];
				    											rom_data[under_right] <= rom_data[upper_right];
    														end
				    			MIRROR_X:					begin
		    													rom_data[upper_left] <= rom_data[under_left];
				    											rom_data[upper_right] <= rom_data[under_right];
				    											rom_data[under_left] <= rom_data[upper_left];
				    											rom_data[under_right] <= rom_data[upper_right];
				    										end
				    			MIRROR_Y:					begin
		    													rom_data[upper_left] <= rom_data[upper_right];
				    											rom_data[upper_right] <= rom_data[upper_left];
				    											rom_data[under_left] <= rom_data[under_right];
				    											rom_data[under_right] <= rom_data[under_left];
				    										end
    						endcase
    					end
    		default:	begin
    						for (i = 0; i < 64; i = i + 1) begin
					        	rom_data[i] <= rom_data[i];
					        end
    					end
    	endcase
    end
end
//////////////////////////////////////////////////////////////

//////////////////////////////cmd_value///////////////////////
always @(posedge clk or posedge reset) begin
    if(reset) begin
        cmd_value <= 4'd0;
    end else begin
    	case (state)
    		CMD:     cmd_value <= (cmd_valid) ? cmd : cmd_value;
    		default: cmd_value <= cmd_value;
    	endcase
    end
end
//////////////////////////////////////////////////////////////

////////////////////////compare///////////////////////////////
always @(posedge clk or posedge reset) begin
    if(reset) begin
        compare <= 8'd0;
    end else begin
    	case (state)
    		PROCESS:	begin
    						case (cmd_value)
    							MAX:	begin
    										case (cnt) 
    											6'd0: compare <= rom_data[index[0]];
    											6'd1, 6'd2, 6'd3: compare <= (compare < rom_data[index[cnt]]) ? rom_data[index[cnt]] : compare;
    											default: compare <= compare;
    										endcase
    									end
    							MIN:	begin
    										case (cnt) 
    											6'd0: compare <= rom_data[index[0]];
    											6'd1, 6'd2, 6'd3: compare <= (compare > rom_data[index[cnt]]) ? rom_data[index[cnt]] : compare;
    											default: compare <= compare;
    										endcase
    									end
    						endcase
    					end
    		default:	compare <= 8'd0;
    	endcase
    end
end
//////////////////////////////////////////////////////////////

///////////////////////////point//////////////////////////////
always @(posedge clk or posedge reset) begin
    if(reset) begin
        point[0] <= 8'd4;
        point[1] <= 8'd4;
    end else begin
    	case (state)
    		PROCESS:	begin
    						case (cmd_value)
    							SHIFT_RIGHT:	point[0] <= (cnt == 6'd0) ? (point[0] != 8'd7) ? point[0] + 8'd1 : point[0] : point[0];
    							SHIFT_LEFT:		point[0] <= (cnt == 6'd0) ? (point[0] != 8'd1) ? point[0] - 8'd1 : point[0] : point[0];
    							SHIFT_DOWN:		point[1] <= (cnt == 6'd0) ? (point[1] != 8'd7) ? point[1] + 8'd1 : point[1] : point[1];
    							SHIFT_UP:		point[1] <= (cnt == 6'd0) ? (point[1] != 8'd1) ? point[1] - 8'd1 : point[1] : point[1];
    							default:		begin
													point[0] <= point[0];
													point[1] <= point[1];
											 	end
    						endcase
    					end
    		default:	begin
							point[0] <= point[0];
							point[1] <= point[1];
    					end
    	endcase
    end
end
//////////////////////////////////////////////////////////////

///////////////////////////////busy///////////////////////////
always @(posedge clk or posedge reset) begin
    if(reset) begin
        busy <= 1'b1;
    end else begin
        case (state)
        	CMD:	 begin
        				 case (cnt)
        					6'd0: busy <= 1'b0;
        					default: busy <= 1'b1;
        				 endcase
        			 end
        	default: busy <= 1'b1;
        endcase
    end
end
//////////////////////////////////////////////////////////////

/*output reg IRAM_valid;
output reg [7:0] IRAM_D;
output reg [5:0] IRAM_A;*/
//////////////////////////////IRAM_VALID//////////////////////
always @(posedge clk or posedge reset) begin
    if(reset) begin
        IRAM_valid <= 1'b0;
    end else begin
    	case (state)
    		TRANSMIT: IRAM_valid <= 1'b1;
    		default:  IRAM_valid <= 1'b0;
    	endcase
    end
end
///////////////////////////////////////////////////////////////

//////////////////////////////IRAM/////////////////////////////
always @(posedge clk or posedge reset) begin
    if(reset) begin
        IRAM_D <= 8'd0;
        IRAM_A <= 6'd63;
    end else begin
    	case (state)
    		TRANSMIT:	begin
    						IRAM_D <= rom_data[cnt];
    						IRAM_A <= IRAM_A + 6'd1;
    					end
    		default:	begin
    						IRAM_D <= 8'd0;
    						IRAM_A <= 6'd63;
    					end
    	endcase
    end 
end
////////////////////////////////////////////////////////////////

////////////////////////////done////////////////////////////////
always @(posedge clk or posedge reset) begin
    if(reset) begin
		done <= 1'b0;        
    end else begin
    	case (state)
    		DONE:	 done <= 1'b1;
    		default: done <= 1'b0;
    	endcase
    end
end
////////////////////////////////////////////////////////////////

endmodule

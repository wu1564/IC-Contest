`timescale 1ns/10ps
module GPSDC_
(
	clk, 
	reset_n, 
	DEN, 
	LON_IN, 
	LAT_IN, 
	COS_ADDR, 
	COS_DATA, 
	ASIN_ADDR, 
	ASIN_DATA, 
	Valid, 
	a, 
	D
);

input clk;
input reset_n;
input DEN;
input signed [23:0] LON_IN;
input signed [23:0] LAT_IN;
input [95:0] COS_DATA;
input [127:0] ASIN_DATA;

output reg [6:0] COS_ADDR;
output reg [5:0] ASIN_ADDR;
output reg Valid;
output reg signed [39:0] D;
output reg signed [63:0] a;

wire signed [24:0] R;
wire signed [15:0] rad;
assign R = 25'd12756274;
assign rad = 16'h0477;

reg signed [23:0] LATA, LATB, LONA, LONB;
wire signed [23:0] minus_LONA, minus_LATA;

reg [3:0] state_inter;
localparam Idle = 0, cosin_table = 1, inter_cosine = 2, divide = 3, mid = 4, asin_table = 5, inter_asine = 6, divide_asine = 7, distance = 8;

reg signed [63:0] x0, x1, y0, y1, divisor;
wire signed [63:0] minus_x0, minus_y0, minus_divisor;
reg signed [64:0] cosineA, cosineB;
reg signed [127:0] adda, addb;
reg signed [127:0] dividend;
wire signed [127:0] inter_add;
reg signed [127:0] multiplea, multipleb;
wire signed [255:0] inter_multiplier;

reg signed [127:0] asine_temp;

reg First;

reg [3:0] cnt1;
reg [6:0] cnt2;

assign inter_add = adda + addb;
assign inter_multiplier = multiplea * multipleb;
assign minus_x0 = $signed(~x0 + 1'b1);
assign minus_y0 = $signed(~y0 + 1'b1);
assign minus_divisor = $signed(~divisor + 1'b1);
assign minus_LONA = $signed(~LONA + 1'b1);
assign minus_LATA = $signed(~LATA + 1'b1);

always@(posedge clk or negedge reset_n) begin
	if(~reset_n) begin
		LATA<=0; LONA<=0;
		LATB<=0; LONB<=0;
		x0<=0; x1<=0;
		y0<=0; y1<=0;
		COS_ADDR<=0;
		adda<=0;
		addb<=0;
		cnt1<=0;
		multiplea<=0;
		multipleb<=0;
		cnt2<=0;
		cosineA<=0;
		cosineB<=0;
		divisor<=0;
		dividend<=0;
		a<=0;
		ASIN_ADDR<=0;
		asine_temp<=0;
		D<=0;
	end
	else begin
		case(state_inter)	
			Idle:
			begin
				if(DEN) begin
					LATA<=LATB; LONA<=LONB;
					LATB<=LAT_IN; LONB<=LON_IN;
				end
			end
			
			cosin_table:
			begin
				if($signed({{8{LATB[23]}}, LATB, {16{1'b0}}}) > $signed(COS_DATA[95:48])) begin
					x0<=$signed({{16{COS_DATA[95]}}, COS_DATA[95:48]});
					y0<=$signed({{16{COS_DATA[47]}}, COS_DATA[47:0]});
					COS_ADDR<=COS_ADDR+1;
				end
				else if($signed({{8{LATB[23]}}, LATB, {16{1'b0}}}) < $signed(COS_DATA[95:48])) begin
					x1<=$signed({{16{COS_DATA[95]}}, COS_DATA[95:48]});
					y1<=$signed({{16{COS_DATA[47]}}, COS_DATA[47:0]});
					COS_ADDR<=0;
				end
				else begin
					cosineA<=cosineB;
					cosineB<=$signed({1'b0, COS_DATA[31:0], {32{1'b0}}});
					COS_ADDR<=0;
				end
			end
			
			inter_cosine:
			begin
				case(cnt1)
					0:begin
						adda<=$signed({{80{LATB[23]}}, {8{LATB[23]}}, LATB, {16{1'b0}}});
						addb<=$signed({{64{minus_x0[63]}}, minus_x0});
						cnt1<=1;
					end
					
					1:begin
						multiplea<=inter_add;
						adda<=$signed({{64{y1[63]}}, y1});
						addb<=$signed({{64{minus_y0[63]}}, minus_y0});
						cnt1<=2;
					end
					
					2:begin
						multipleb<=inter_add;
						adda<=$signed({{64{x1[63]}}, x1});
						addb<=$signed({{64{minus_x0[63]}}, minus_x0});
						cnt1<=3;
					end
					
					3:begin
						multiplea<=$signed({{64{y0[63]}}, y0});
						multipleb<=inter_add;
						adda<=$signed(inter_multiplier[127:0]);
						cnt1<=4;
					end
					
					4:begin
						addb<=$signed(inter_multiplier[127:0]);
						cnt1<=5;
					end
					
					5:begin
						dividend<=inter_add;
						adda<=$signed({{64{x1[63]}}, x1});
						addb<=$signed({{64{minus_x0[63]}}, minus_x0});
						cnt1<=6;
					end
					
					default:
					begin
						divisor<=$signed(inter_add[63:0]);
						cnt1<=0;
					end
				endcase
			end
			
			divide:
			begin
				if(cnt2 == 64)
					cnt2<=0;
				else 
					cnt2<=cnt2+1;
				
				if(cnt2 == 0) begin
					cosineA<=cosineB;
				end
				
				addb<=$signed({{32{minus_divisor[63]}}, minus_divisor, {32{1'b0}}});
				
				if($signed(dividend) >= $signed({divisor, {32{1'b0}}})) begin	// dividend -> 128   divisor -> 64
					cosineB<=(cosineB<<1) | 65'd1;								// cosineB -> 64 + signed bit
					dividend<=$signed({inter_add[126:0], 1'b0});
					adda<=$signed({inter_add[126:0], 1'b0});
				end
				else begin
					cosineB<=cosineB<<1;
					dividend<=dividend<<1;
					adda<=dividend<<1;
				end
			end
			
			mid:
			begin
				if(cnt1==0) begin
					adda<=$signed({{104{LONB[23]}}, LONB});
					addb<=$signed({{104{minus_LONA[23]}}, minus_LONA});
					cnt1<=1;
				end
				else if(cnt1==1) begin
					multiplea<=inter_add;
					multipleb<=$signed({{112{rad[15]}}, rad});
					adda<=$signed({{104{LATB[23]}}, LATB});
					addb<=$signed({{104{minus_LATA[23]}}, minus_LATA});
					cnt1<=2;
				end
				else if(cnt1==2) begin
					multiplea<=$signed(inter_multiplier[128:1] + (inter_multiplier[127] & inter_multiplier[0]));
					multipleb<=$signed(inter_multiplier[128:1] + (inter_multiplier[127] & inter_multiplier[0]));
					cnt1<=3;
				end
				else if(cnt1==3) begin
					multiplea<=$signed(inter_multiplier[127:0]);
					multipleb<=cosineB;
					cnt1<=4;
				end
				else if(cnt1==4) begin
					multiplea<=$signed(inter_multiplier[127:0]);
					multipleb<=cosineA;
					cnt1<=5;
				end
				else if(cnt1==5) begin
					addb<=$signed(inter_multiplier[255:128]);
					multiplea<=inter_add;
					multipleb<=$signed({{112{rad[15]}}, rad});
					cnt1<=6;
				end
				else if(cnt1==6) begin
					multiplea<=$signed(inter_multiplier[128:1] + (inter_multiplier[127] & inter_multiplier[0]));
					multipleb<=$signed(inter_multiplier[128:1] + (inter_multiplier[127] & inter_multiplier[0]));
					cnt1<=7;
				end
				else if(cnt1==7) begin
					adda<=$signed(inter_multiplier[127:0]);
					cnt1<=8;
				end
				else begin
					a<=$signed(inter_add[63:0]);
					cnt1<=0;
				end
			end
			
			asin_table:
			begin
				if(a > $signed(ASIN_DATA[127:64])) begin
					x0<=$signed(ASIN_DATA[127:64]);
					y0<=$signed(ASIN_DATA[63:0]);
					ASIN_ADDR<=ASIN_ADDR+1;
				end
				else if(a < $signed(ASIN_DATA[127:64])) begin
					x1<=$signed(ASIN_DATA[127:64]);
					y1<=$signed(ASIN_DATA[63:0]);
					ASIN_ADDR<=0;
				end
				else begin
					asine_temp<=$signed({ASIN_DATA[63:0], {64{1'b0}}});
					ASIN_ADDR<=0;
				end
			end
			
			inter_asine:
			begin
				if(cnt1 == 0) begin
					adda<=$signed({{64{a[63]}}, a});
					addb<=$signed({{64{minus_x0[63]}}, minus_x0});
					cnt1<=1;
				end
				else if(cnt1 == 1) begin
					multiplea<=inter_add;
					adda<=$signed({{64{y1[63]}}, y1});
					addb<=$signed({{64{minus_y0[63]}}, minus_y0});
					cnt1<=2;
				end
				else if(cnt1 == 2) begin
					multipleb<=inter_add;
					adda<=$signed({{64{x1[63]}}, x1});
					addb<=$signed({{64{minus_x0[63]}}, minus_x0});
					cnt1<=3;
				end
				else if(cnt1 == 3) begin
					multiplea<=$signed({{64{y0[63]}}, y0});
					multipleb<=inter_add;
					adda<=$signed(inter_multiplier[127:0]);
					cnt1<=4;
				end
				else if(cnt1 == 4) begin
					addb<=$signed(inter_multiplier[127:0]);
					cnt1<=5;
				end
				else if(cnt1 == 5) begin
					dividend<=inter_add;
					adda<=$signed({{64{x1[63]}}, x1});
					addb<=$signed({{64{minus_x0[63]}}, minus_x0});
					cnt1<=6;
				end
				else begin
					divisor<=$signed(inter_add[63:0]);
					cnt1<=0;
				end
			end
			
			divide_asine:
			begin
				if(cnt2 == 127)
					cnt2<=0;
				else 
					cnt2<=cnt2+1;
				
				addb<=$signed({minus_divisor, {64{1'b0}}});
				
				if($signed(dividend) >= $signed({divisor, {64{1'b0}}})) begin		// dividend 128 bit  / divisor 64+signed extension
					asine_temp<=(asine_temp<<1) | 128'd1;
					dividend<=$signed({inter_add[126:0], 1'b0});
					adda<=$signed({inter_add[126:0], 1'b0});
				end
				else begin
					asine_temp<=asine_temp<<1;
					dividend<=dividend<<1;
					adda<=dividend<<1;
				end
			end
			
			distance:
			begin
				if(cnt1==0) begin
					multiplea<=asine_temp;
					multipleb<={{103{R[24]}}, R};
					cnt1<=1;
				end
				else begin
					D<=$signed(inter_multiplier[134:95]);
					cnt1<=0;
				end
			end
				
		endcase
	end
end

always@(posedge clk or negedge reset_n) begin
	if(~reset_n) begin
		Valid<=0;
	end
	else begin
		case(state_inter)
			distance:
			begin
				if(cnt1==0) begin
					Valid<=0;
				end
				else begin
					Valid<=1;
				end
			end
			
			default:
			begin
				Valid<=0;
			end
		endcase
	end
end

always@(posedge clk or negedge reset_n) begin
	if(~reset_n) begin
		state_inter<=Idle;
		First<=1;
	end
	else begin
		case(state_inter)
			Idle:
			begin
				if(DEN) begin
					state_inter<=cosin_table;
				end
			end
			
			cosin_table:
			begin
				if($signed({{8{LATB[23]}}, LATB, {16{1'b0}}}) > $signed(COS_DATA[95:48])) begin
					state_inter<=cosin_table;
				end
				else if($signed({{8{LATB[23]}}, LATB, {16{1'b0}}}) < $signed(COS_DATA[95:48])) begin
					state_inter<=inter_cosine;
				end
				else begin
					First<=0;
					if(First)
						state_inter<=Idle;
					else
						state_inter<=mid;
				end
			end
			
			inter_cosine:
			begin
				if(cnt1 == 6) begin
					state_inter<=divide;
				end
				else begin
					state_inter<=inter_cosine;
				end
			end
			
			divide:
			begin
				if(cnt2 == 64) begin
					First<=0;
					if(First)
						state_inter<=Idle;
					else
						state_inter<=mid;
				end
				else begin
					state_inter<=divide;
				end
			end
			
			mid:
			begin
				if(cnt1==8) begin
					state_inter<=asin_table;
				end
				else begin
					state_inter<=mid;
				end
			end
			
			asin_table:
			begin
				if(a > $signed(ASIN_DATA[127:64])) begin
					state_inter<=asin_table;
				end
				else if(a < $signed(ASIN_DATA[127:64])) begin
					state_inter<=inter_asine;
				end
				else begin
					state_inter<=distance;
				end
			end
			
			inter_asine:
			begin
				if(cnt1 == 6) begin
					state_inter<=divide_asine;
				end
				else begin
					state_inter<=inter_asine;
				end
			end
			
			divide_asine:
			begin
				if(cnt2 == 127) begin
					state_inter<=distance;
				end
				else begin
					state_inter<=divide_asine;
				end
			end
		
			distance:
			begin
				if(cnt1==0) begin
					state_inter<=distance;
				end
				else begin
					state_inter<=Idle;
				end
			end
		endcase
	end
end





endmodule

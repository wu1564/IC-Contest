module DT(
	input 			clk, 
	input			reset,
	output	reg		done ,
	output	reg		sti_rd ,
	output	reg 	[9:0]	sti_addr ,
	input		[15:0]	sti_di,
	output	reg		res_wr ,
	output	reg		res_rd ,
	output	reg 	[13:0]	res_addr ,
	output	reg 	[7:0]	res_do,
	input		[7:0]	res_di,
	output			fw_finish
	);

localparam ReadSti = 3'd0;
localparam WriteSti2Res = 3'd1;
localparam ReadRes_For = 3'd2;
localparam WriteRes_For = 3'd3;
localparam ReadRes_Bak = 3'd4;
localparam WriteRes_Bak = 3'd5;
localparam Stop = 3'd6;

reg[2:0]		PState;
reg[2:0]		NState;
reg[6:0]		cnt;
reg[7:0]		pre_result;
reg			jump_flag;
reg			comp_flag;

integer		i;
//=============================================================================
// 
//=============================================================================
always@(posedge clk or negedge reset) begin
	if(reset == 1'b0) begin
		PState <= ReadSti;	
	end
	else begin
		PState <= NState;
	end
end

always@(*) begin
	case(PState)
		ReadSti:			begin
								NState = WriteSti2Res;
							end
		WriteSti2Res:	begin
								if(cnt == 7'd15 || (cnt == 7'd14 && res_addr[6:0] == 7'd125)) begin
									if(sti_addr == 10'd1015) begin
										NState = ReadRes_For;
									end
									else begin
										NState = ReadSti;
									end
								end
								else begin
									NState = WriteSti2Res;
								end
							end
		ReadRes_For:	begin
								if(jump_flag == 1'b1 && res_addr == 14'd129 && res_di == 8'd0) begin
									NState = ReadRes_Bak;
								end
								else if(cnt == 7'd4) begin
									NState = WriteRes_For;
								end
								else begin
									NState = ReadRes_For;
								end
							end
		WriteRes_For:	begin
								if(res_addr == 14'd16253) begin
									NState = ReadRes_Bak;
								end
								else begin
									NState = ReadRes_For;
								end
							end
		ReadRes_Bak:	begin
								if(jump_flag == 1'b1 && res_addr == 14'd129 && res_di == 8'd0) begin
									NState = Stop;
								end
								else if(cnt == 7'd4) begin
									NState = WriteRes_Bak;
								end
								else begin
									NState = ReadRes_Bak;
								end
							end
		WriteRes_Bak:	begin
								if(res_addr == 14'd258) begin
									NState = Stop;
								end
								else begin
									NState = ReadRes_Bak;
								end
							end
		Stop:				begin
								NState = Stop;
							end
		default:			begin
								NState = ReadSti;
							end
	endcase
end
//=============================================================================
// cnt
//=============================================================================
always@(posedge clk or negedge reset) begin
	if(reset == 1'b0) begin
		cnt <= 7'd0;
	end
	else begin
		case(PState)
			ReadSti:			begin
									cnt <= 7'd0;
								end
			WriteSti2Res:	begin
									if(res_addr[6:0] == 7'd126) begin
										cnt <= cnt + 2'd2;
									end
									else begin
										cnt <= cnt + 1'b1;
									end
								end
			ReadRes_For:	begin
									if(cnt == 7'd15) begin
										cnt <= 7'd1;
									end
									else if(cnt == 7'd1 && res_di == 8'd0) begin // central value = 0
										cnt <= 7'd1;
									end
									else if(res_addr == 14'd16 && res_di == 8'd0) begin
										cnt <= 7'd0;
									end
									else if(res_addr == 14'd129 && jump_flag == 1'b1) begin
										cnt <= 7'd1;
									end
									else begin
										cnt <= cnt + 1'b1;
									end
								end
			ReadRes_Bak:	begin
									if(cnt == 7'd1 && res_di == 8'd0) begin
										cnt <= 7'd1;
									end
									else begin
										cnt <= cnt + 1'b1;
									end
								end
			WriteRes_Bak:	begin
									if(comp_flag == 1'b0) begin
										cnt <= 7'd1;
									end
									else begin
										cnt <= 7'd0;
									end
								end
			default:			begin
									cnt <= 7'd0;
								end
		endcase
	end
end
//=============================================================================
// jump_flag
//=============================================================================
always@(posedge clk or negedge reset) begin
	if(reset == 1'b0) begin
		jump_flag <= 1'b0;
	end
	else begin
		case(PState)
			ReadRes_For:	begin
									if(cnt == 7'd1) begin
										jump_flag <= 1'b1;
									end
								end
			ReadRes_Bak:	begin
									if(cnt == 7'd1) begin
										jump_flag <= 1'b1;
									end
								end
			default:			begin
									jump_flag <= 1'b0;
								end
		endcase
	end
end
//=============================================================================
// sti_addr
//=============================================================================
always@(posedge clk or negedge reset) begin
	if(reset == 1'b0) begin
		sti_addr <= 10'd7;
	end
	else begin
		case(PState)
			ReadSti:			begin
									sti_addr <= sti_addr + 1'b1;
								end
			default:			begin
									sti_addr <= sti_addr;
								end
		endcase
	end
end
//=============================================================================
// sti_rd
//=============================================================================
always@(posedge clk or negedge reset) begin
	if(reset == 1'b0) begin
		sti_rd <= 1'b0;
	end
	else begin
		case(PState)
			ReadSti:			begin
									sti_rd <= 1'b1;
								end
			default:			begin
									sti_rd <= 1'b0;
								end
		endcase
	end
end
//=============================================================================
// comp_flag
//=============================================================================
always@(posedge clk or negedge reset) begin
	if(reset == 1'b0) begin
		comp_flag <= 1'b0;
	end
	else begin
		case(PState)
			ReadRes_Bak:	begin
									if(cnt == 7'd1 && res_di > (res_do + 1'b1)) begin
										comp_flag <= 1'b1;
									end
									else if(cnt > 7'd1 && res_do > (res_di + 1'b1)) begin
										comp_flag <= 1'b1;
									end
								end
			default:			begin
									comp_flag <= 1'b0;
								end
		endcase
	end
end
//=============================================================================
// res_do
//=============================================================================
always@(posedge clk or negedge reset) begin
	if(reset == 1'b0) begin
		res_do <= 8'd0;
	end
	else begin
		case(PState)
			WriteSti2Res:	begin
									if(res_addr[6:0] == 7'd126) begin
										res_do <= {7'd0, sti_di[4'd14 - cnt]};
									end
									else begin
										res_do <= {7'd0, sti_di[4'd15 - cnt]};
									end										
								end
			ReadRes_For:	begin
									if(cnt == 7'd1 && res_di == 8'd0) begin
										res_do <= 8'd0;
									end
									else if(cnt == 7'd2 || (cnt > 7'd2 && res_do > res_di)) begin
										res_do <= res_di;
									end
								end
			WriteRes_For:	begin
									res_do <= (res_do < pre_result) ? (res_do + 1'b1) : (pre_result + 1'b1);
								end
			ReadRes_Bak:	begin
									if(cnt == 7'd1 && res_di == 8'd0) begin
										res_do <= 8'd0;
									end
									else if(cnt == 7'd1 && res_di != 8'd0) begin
										res_do <= res_di;										// central value
									end
									else if(cnt > 7'd1 && res_do > (res_di + 1'b1)) begin
										res_do <= res_di + 1'b1;
									end
								end
			WriteRes_Bak:	begin
									res_do <= (res_do < (pre_result + 1'b1)) ? res_do : (pre_result + 1'b1);
								end
			default:			begin
									res_do <= res_do;
								end
		endcase
	end
end
//=============================================================================
// pre_result
//=============================================================================
always@(posedge clk or negedge reset) begin
	if(reset == 1'b0) begin
		pre_result <= 8'd0;
	end
	else begin
		case(PState)
			ReadRes_For:	begin
									if(cnt == 7'd1) begin
										pre_result <= res_do;
									end
								end
			ReadRes_Bak:	begin
									if(cnt == 7'd1) begin
										pre_result <= res_do;
									end
								end
			default:			begin
									pre_result <= 8'd0;
								end
		endcase
	end
end
//=============================================================================
// res_addr
//=============================================================================
always@(posedge clk or negedge reset) begin
	if(reset == 1'b0) begin
		res_addr <= 14'd126;
	end
	else begin
		case(PState)
			WriteSti2Res:	begin
									if(res_addr[6:0] == 7'd126) begin
										res_addr <= res_addr + 2'd3;
									end
									else begin
										res_addr <= res_addr + 1'b1;
									end
								end
			ReadRes_For:	begin
									if(res_addr == 14'd16254) begin
										res_addr <= 14'd129;
									end
									else if(res_addr == 14'd129 && jump_flag == 1'b1) begin
										res_addr <= 14'd16254;
									end
									else if(cnt == 7'd1 && res_di == 8'd0) begin // central value = 0
										res_addr <= res_addr + 1'b1;
									end
									else begin
										case(cnt)
											7'd0:	res_addr <= res_addr + 1'b1;
											7'd1:	res_addr <= res_addr - 14'd129;
											7'd2:	res_addr <= res_addr + 1'b1;
											7'd3:	res_addr <= res_addr + 1'b1;
											7'd4:	res_addr <= res_addr + 14'd127;
											default: res_addr <= res_addr;
										endcase
									end
								end
			ReadRes_Bak:	begin
									if(cnt == 7'd1 && res_di == 8'd0) begin
										res_addr <= res_addr - 1'b1;
									end
									else begin
										case(cnt)
											7'd0:	res_addr <= res_addr - 1'b1;
											7'd1:	res_addr <= res_addr + 14'd127;
											7'd2:	res_addr <= res_addr + 1'b1;
											7'd3:	res_addr <= res_addr + 1'b1;
											default: res_addr <= res_addr;
										endcase
									end
								end
			WriteRes_Bak:	begin
									if(comp_flag == 1'b1) begin
										res_addr <= res_addr - 14'd129;
									end
									else begin
										res_addr <= res_addr - 14'd130;
									end
								end
			default:			begin
									res_addr <= res_addr;
								end
		endcase
	end
end  
//=============================================================================
// res_wr
//=============================================================================
always@(posedge clk or negedge reset) begin
	if(reset == 1'b0) begin
		res_wr <= 1'b0;
	end
	else begin
		case(PState)
			WriteSti2Res:	begin
									res_wr <= 1'b1;
								end
			WriteRes_For:	begin
									res_wr <= 1'b1;
								end
			WriteRes_Bak:	begin
									if(comp_flag == 1'b1) begin
										res_wr <= 1'b1;
									end
									else begin
										res_wr <= 1'b0;
									end
								end
			default:			begin
									res_wr <= 1'b0;
								end
		endcase
	end
end  
//=============================================================================
// res_rd
//=============================================================================
always@(posedge clk or negedge reset) begin
	if(reset == 1'b0) begin
		res_rd <= 1'b0;
	end
	else begin
		case(PState)
			ReadRes_For:	begin
									res_rd <= 1'b1;
								end
			ReadRes_Bak:	begin
									res_rd <= 1'b1;
								end
			WriteRes_Bak:	begin
									if(comp_flag == 1'b0) begin
										res_rd <= 1'b1;
									end
									else begin
										res_rd <= 1'b0;
									end
								end
			default:			begin
									res_rd <= 1'b0;
								end
		endcase
	end
end  
//=============================================================================
// done
//=============================================================================
always@(posedge clk or negedge reset) begin
	if(reset == 1'b0) begin
		done <= 1'b0;
	end
	else begin
		case(PState)
			Stop:				begin
									done <= 1'b1;
								end
			default:			begin
									done <= 1'b0;
								end
		endcase
	end
end

assign fw_finish = (PState > WriteRes_For) ? 1'b1 : 1'b0;

endmodule

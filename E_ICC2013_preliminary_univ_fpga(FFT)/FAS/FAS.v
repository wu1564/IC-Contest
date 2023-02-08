`timescale 1ns/10ps
module FAS(
       clk, 
       rst, 
       data_valid, 
       data, 
       fft_d0,fft_d1,fft_d2,fft_d3,fft_d4,fft_d5,fft_d6,fft_d7,
       fft_d8,fft_d9,fft_d10,fft_d11,fft_d12,fft_d13,fft_d14,fft_d15,
       fft_valid,
       done,
       freq
);

//--------------------------------------------------------------------
// Parameter Define
//--------------------------------------------------------------------
// Memory Macro
localparam DATA_WIDTH 		 = 32;
localparam BUFFER_DEPTH 	 = 160;
localparam BUFFER_ADDR_WIDTH = 4;
// State Machine Macro
localparam IDLE 	  = 0;
localparam STAGE1     = 1;
localparam STAGE2     = 2;
localparam STAGE3     = 3;
localparam STAGE4     = 4;
localparam FFT_OUTPUT = 5;
localparam NORM 	  = 6;	
localparam ANALYSIS   = 7;

//--------------------------------------------------------------------
// Input & Output Define
//--------------------------------------------------------------------
input	clk;
input	rst;
input	data_valid;
input  signed [15:0] data;
output reg [31:0] fft_d0,fft_d1,fft_d2,fft_d3,fft_d4,fft_d5,fft_d6,fft_d7, 
              fft_d8,fft_d9,fft_d10,fft_d11,fft_d12,fft_d13,fft_d14,fft_d15;
output reg fft_valid;
output done;                      
output [3:0] freq;

//--------------------------------------------------------------------
// Reg & Wire Define
//--------------------------------------------------------------------
integer i;
// buffer state signal
wire full;
wire empty;
wire pop_control_in;
wire buffer_finish;
wire [DATA_WIDTH-1:0] data0, data1, data2, data3, data4, data5, data6, data7, data8, data9, data10, data11, data12, data13, data14, data15;
wire [DATA_WIDTH-1:0] fft_out_a[0:7], fft_out_b[0:7];
reg pop_control;
// state machine
reg [2:0] state, next_state; 
// flags
wire norm_process_done;
wire fft_pe_valid;
reg  fft_start_flag;
// multiplier
wire [DATA_WIDTH-1:0]   multi_out[0:15];
reg  [DATA_WIDTH/2-1:0] multi_in[0:15];
// fft
reg  [DATA_WIDTH-1:0]   fft_in1_sel[0:7];
reg  [DATA_WIDTH-1:0]   fft_in2_sel[0:7];
reg  [DATA_WIDTH-1:0]   fft_res_a[0:7], fft_res_b[0:7];
reg  [DATA_WIDTH-1:0]   const_real[0:7], const_imag[0:7];
// counter
reg  [1:0] cnt;
reg  [DATA_WIDTH/2-1:0] temp[0:15];
// analysis
wire analysis_done;
wire [DATA_WIDTH * 16-1:0] fft_res;
reg  analysis_start;

//--------------------------------------------------------------------
// Module
//--------------------------------------------------------------------
Memory #(
	.BUFFER_ADDR_WIDTH(BUFFER_ADDR_WIDTH),
	.BUFFER_DEPTH(BUFFER_DEPTH),
    .DATA_WIDTH(DATA_WIDTH)
)mem(
	// Input Signal
    .clk(clk),
    .rst(rst),
    // Control Signal
    .pop_control(pop_control),
    // Input data
    .data_valid(data_valid),
    .data({data,16'd0}),
    // Output Signal
    .buffer_finish(buffer_finish),
    .full(full),
    .empty(empty),
	.buffer_out_0(data0),   .buffer_out_1(data1),   .buffer_out_2(data2),   .buffer_out_3(data3),
    .buffer_out_4(data4),   .buffer_out_5(data5),   .buffer_out_6(data6),   .buffer_out_7(data7),
    .buffer_out_8(data8),   .buffer_out_9(data9),   .buffer_out_10(data10), .buffer_out_11(data11), 
    .buffer_out_12(data12), .buffer_out_13(data13), .buffer_out_14(data14), .buffer_out_15(data15)
);

Analysis #(
	.DATA_WIDTH(DATA_WIDTH)
) analysisCircuit(
	.clk(clk),
	.rst(rst),
	.analysis_start(analysis_start),
	.analysis_done(analysis_done),
	.highest(freq),
	.fft_res_in(fft_res)
);

genvar fftNum;
generate
	for(fftNum = 0; fftNum < 8; fftNum = fftNum + 1) begin: fft
		FFT_PE u_fft(
			.clk(clk), 
			.rst(rst), 			 
			.a(fft_in1_sel[fftNum]), 		
			.b(fft_in2_sel[fftNum]),	    
			.const_real(const_real[fftNum]),			 
			.const_imag(const_imag[fftNum]),
			.ab_valid(fft_start_flag), 
			.fft_a(fft_out_a[fftNum]), 
			.fft_b(fft_out_b[fftNum]),
			.fft_pe_valid(fft_pe_valid)
		);
	end
endgenerate

genvar multNum;
generate
	for(multNum = 0; multNum < 16; multNum = multNum + 1) begin : multiplier
		Multiplier #(
			.DATA_WIDTH(DATA_WIDTH)
		)mult(
			.a(multi_in[multNum]),
			.b(multi_in[multNum]),
			.result(multi_out[multNum])
		);
	end
endgenerate

//--------------------------------------------------------------------
// State Machine
//--------------------------------------------------------------------
always @(posedge clk or posedge rst) begin
	if(rst) state <= IDLE;
	else begin
		state <= next_state;
	end 
end

always @(*) begin
	case (state)
		IDLE:		next_state = (buffer_finish) ? STAGE1 : IDLE;
		FFT_OUTPUT: next_state = NORM;
		NORM:		next_state = (norm_process_done) ? ANALYSIS : NORM;
		ANALYSIS:	next_state = (done) ? IDLE : ANALYSIS;
		default:	next_state = (fft_pe_valid) ? state + 1 : state;
	endcase
end

//--------------------------------------------------------------------
// Memory Control Signal
//--------------------------------------------------------------------
//wire pop_control_in;
assign pop_control_in = pop_control;

// reg pop_control;
always @(posedge clk or posedge rst) begin
	if(rst) begin
		pop_control <= 1'b0;
	end else if(done) begin
		pop_control <= 1'b1;
	end else begin
		pop_control <= 1'b0;
	end
end

//--------------------------------------------------------------------
// FFT Control Signal
//--------------------------------------------------------------------
//reg  [DATA_WIDTH-1:0] fft_res_a, fft_res_b;
always @(posedge clk or posedge rst) begin
	if(rst) begin
		for(i = 0; i < 8; i = i + 1) begin
			fft_res_a[i] <= 0;
			fft_res_b[i] <= 0;
		end
	end else if(fft_pe_valid) begin
		for(i = 0; i < 8; i = i + 1) begin
			fft_res_a[i] <= fft_out_a[i];
			fft_res_b[i] <= fft_out_b[i];
		end
	end
end

//reg [DATA_WIDTH-1:0] fft_in1_sel_0~fft_in1_sel_7;
always @(*) begin
	case(state)
		STAGE1:		begin
						fft_in1_sel[0] = data0;
						fft_in1_sel[1] = data1;
						fft_in1_sel[2] = data2;
						fft_in1_sel[3] = data3;
						fft_in1_sel[4] = data4;
						fft_in1_sel[5] = data5;
						fft_in1_sel[6] = data6;
						fft_in1_sel[7] = data7;
					end 
		STAGE2: 	begin
						fft_in1_sel[0] = fft_res_a[0];
						fft_in1_sel[1] = fft_res_a[1];
						fft_in1_sel[2] = fft_res_a[2];
						fft_in1_sel[3] = fft_res_a[3];
						fft_in1_sel[4] = fft_res_b[0];
						fft_in1_sel[5] = fft_res_b[1];
						fft_in1_sel[6] = fft_res_b[2];
						fft_in1_sel[7] = fft_res_b[3];
					end
		STAGE3:		begin
						fft_in1_sel[0] = fft_res_a[0];
						fft_in1_sel[1] = fft_res_a[1];
						fft_in1_sel[2] = fft_res_b[0];
						fft_in1_sel[3] = fft_res_b[1];
						fft_in1_sel[4] = fft_res_a[4];
						fft_in1_sel[5] = fft_res_a[5];
						fft_in1_sel[6] = fft_res_b[4];
						fft_in1_sel[7] = fft_res_b[5];
					end
		STAGE4:		begin
						fft_in1_sel[0] = fft_res_a[0];
						fft_in1_sel[1] = fft_res_b[0];
						fft_in1_sel[2] = fft_res_a[2];
						fft_in1_sel[3] = fft_res_b[2];
						fft_in1_sel[4] = fft_res_a[4];
						fft_in1_sel[5] = fft_res_b[4];
						fft_in1_sel[6] = fft_res_a[6];
						fft_in1_sel[7] = fft_res_b[6];
					end
		default:	begin
						for(i = 0; i < 8; i = i + 1) begin
							fft_in1_sel[i] = {DATA_WIDTH{1'b0}};
						end
					end
	endcase
end

//reg [DATA_WIDTH-1:0] fft_in2_sel_0~fft_in2_sel_7;
always @(*) begin
	case(state)
		STAGE1:		begin
						fft_in2_sel[0] = data8;
						fft_in2_sel[1] = data9;
						fft_in2_sel[2] = data10;
						fft_in2_sel[3] = data11;
						fft_in2_sel[4] = data12;
						fft_in2_sel[5] = data13;
						fft_in2_sel[6] = data14;
						fft_in2_sel[7] = data15;
					end 
		STAGE2: 	begin
						fft_in2_sel[0] = fft_res_a[4];
						fft_in2_sel[1] = fft_res_a[5];
						fft_in2_sel[2] = fft_res_a[6];
						fft_in2_sel[3] = fft_res_a[7];
						fft_in2_sel[4] = fft_res_b[4];
						fft_in2_sel[5] = fft_res_b[5];
						fft_in2_sel[6] = fft_res_b[6];
						fft_in2_sel[7] = fft_res_b[7];			
					end
		STAGE3:		begin
						fft_in2_sel[0] = fft_res_a[2];
						fft_in2_sel[1] = fft_res_a[3];
						fft_in2_sel[2] = fft_res_b[2];
						fft_in2_sel[3] = fft_res_b[3];
						fft_in2_sel[4] = fft_res_a[6];
						fft_in2_sel[5] = fft_res_a[7];
						fft_in2_sel[6] = fft_res_b[6];
						fft_in2_sel[7] = fft_res_b[7];					
					end
		STAGE4:		begin
						fft_in2_sel[0] = fft_res_a[1];
						fft_in2_sel[1] = fft_res_b[1];
						fft_in2_sel[2] = fft_res_a[3];
						fft_in2_sel[3] = fft_res_b[3];
						fft_in2_sel[4] = fft_res_a[5];
						fft_in2_sel[5] = fft_res_b[5];
						fft_in2_sel[6] = fft_res_a[7];
						fft_in2_sel[7] = fft_res_b[7];
					end
		default:	begin
						for(i = 0; i < 8; i = i + 1) begin
							fft_in2_sel[i] = {DATA_WIDTH{1'b0}};
						end
					end
	endcase
end

//reg signed [31:0] const_real;
always @(*) begin
	case (state)
		STAGE1:		begin
						const_real[0] = 32'h00010000;
						const_real[1] = 32'h0000EC83;
						const_real[2] = 32'h0000B504;
						const_real[3] = 32'h000061F7;
						const_real[4] = 32'h00000000;
						const_real[5] = 32'hFFFF9E09;
						const_real[6] = 32'hFFFF4AFC;
						const_real[7] = 32'hFFFF137D;
					end
		STAGE2:		begin
						const_real[0] = 32'h00010000;
						const_real[1] = 32'h0000B504;
						const_real[2] = 32'h00000000;
						const_real[3] = 32'hFFFF4AFC;
						const_real[4] = 32'h00010000;
						const_real[5] = 32'h0000B504;
						const_real[6] = 32'h00000000;
						const_real[7] = 32'hFFFF4AFC;
					end
		STAGE3:		begin
						const_real[0] = 32'h00010000;
						const_real[1] = 32'h00000000;
						const_real[2] = 32'h00010000;
						const_real[3] = 32'h00000000;
						const_real[4] = 32'h00010000;
						const_real[5] = 32'h00000000;
						const_real[6] = 32'h00010000;
						const_real[7] = 32'h00000000;
					end
		STAGE4:		begin
						for(i = 0; i < 8; i = i + 1) begin
							const_real[i] = 32'h00010000;
						end			
					end				
		default:	begin
						for(i = 0; i < 8; i = i + 1) begin
							const_real[i] = 32'd0;
						end
					end
	endcase
end

//reg signed [31:0] const_imag;
always @(*) begin
	case (state)
		STAGE1:		begin
						const_imag[0] = 32'h00000000;
						const_imag[1] = 32'hFFFF9E09;
						const_imag[2] = 32'hFFFF4AFC;
						const_imag[3] = 32'hFFFF137D;
						const_imag[4] = 32'hFFFF0000;
						const_imag[5] = 32'hFFFF137D;
						const_imag[6] = 32'hFFFF4AFC;
						const_imag[7] = 32'hFFFF9E09;
					end
		STAGE2:		begin
						const_imag[0] = 32'h00000000;
						const_imag[1] = 32'hFFFF4AFC;
						const_imag[2] = 32'hFFFF0000;
						const_imag[3] = 32'hFFFF4AFC;
						const_imag[4] = 32'h00000000;
						const_imag[5] = 32'hFFFF4AFC;
						const_imag[6] = 32'hFFFF0000;
						const_imag[7] = 32'hFFFF4AFC;
					end
		STAGE3:		begin
						const_imag[0] = 32'h00000000;
						const_imag[1] = 32'hFFFF0000;
						const_imag[2] = 32'h00000000;
						const_imag[3] = 32'hFFFF0000;
						const_imag[4] = 32'h00000000;
						const_imag[5] = 32'hFFFF0000;
						const_imag[6] = 32'h00000000;
						const_imag[7] = 32'hFFFF0000;			
					end
		default:	begin
						for(i = 0; i < 8; i = i + 1) begin
							const_imag[i] = 32'd0;
						end
					end					
	endcase
end

//reg fft_start_flag;
always @(posedge clk or posedge rst) begin
	if(rst) begin
		fft_start_flag <= 1'b0;
	end else begin
		case (state)
			IDLE,
			FFT_OUTPUT,
			ANALYSIS:	fft_start_flag <= 1'b0;
			default:	fft_start_flag <= (cnt == 2'd0) ? 1'b1 : 1'b0;
		endcase
	end
end

//wire norm_process_done;
assign norm_process_done = (cnt == 2'd1) ? 1'b1 : 1'b0;

//reg [1:0] cnt
always @(posedge clk or posedge rst) begin
	if(rst) begin
		cnt <= 2'd0;
	end else begin
		case (state) 
			IDLE,
			FFT_OUTPUT:	cnt <= 2'd0;
			NORM:		cnt <= (norm_process_done) ? 2'd0 : cnt + 2'd1;
			ANALYSIS:	cnt <= 2'd1;
			default:	cnt <= (fft_pe_valid) ? 2'd0 : 2'd1;
		endcase
	end
end

//wire [DATA_WIDTH * 16-1:0] fft_res;
assign fft_res = {fft_d15, fft_d14, fft_d13, fft_d12, fft_d11, fft_d10, fft_d9, fft_d8, fft_d7, fft_d6, fft_d5, fft_d4, fft_d3, fft_d2, fft_d1, fft_d0};

//--------------------------------------------------------------------
// Norm Process Signal
//--------------------------------------------------------------------
//reg  [DATA_WIDTH/2-1:0] temp[0:15];
always @(posedge clk or posedge rst) begin
	if(rst) begin
		for (i = 0; i < 16; i = i + 1) begin
			temp[i] <= 16'd0;
		end
	end else begin
		temp[0] <= fft_d0[15:0];
		temp[1] <= fft_d1[15:0];
		temp[2] <= fft_d2[15:0];
		temp[3] <= fft_d3[15:0];
		temp[4] <= fft_d4[15:0];
		temp[5] <= fft_d5[15:0];
		temp[6] <= fft_d6[15:0];
		temp[7] <= fft_d7[15:0];
		temp[8] <= fft_d8[15:0];
		temp[9] <= fft_d9[15:0];
		temp[10] <= fft_d10[15:0];
		temp[11] <= fft_d11[15:0];
		temp[12] <= fft_d12[15:0];
		temp[13] <= fft_d13[15:0];
		temp[14] <= fft_d14[15:0];
		temp[15] <= fft_d15[15:0];
	end
end

// reg  [DATA_WIDTH/2-1:0] multi_in_1[0:15];
always @(*) begin
	if(state == NORM && cnt == 2'd0) begin
		multi_in[0]  = fft_d0[31:16];
		multi_in[1]  = fft_d1[31:16];
		multi_in[2]  = fft_d2[31:16];
		multi_in[3]  = fft_d3[31:16];
		multi_in[4]  = fft_d4[31:16];
		multi_in[5]  = fft_d5[31:16];
		multi_in[6]  = fft_d6[31:16];
		multi_in[7]  = fft_d7[31:16];
		multi_in[8]  = fft_d8[31:16];
		multi_in[9]  = fft_d9[31:16];
		multi_in[10] = fft_d10[31:16];
		multi_in[11] = fft_d11[31:16];
		multi_in[12] = fft_d12[31:16];
		multi_in[13] = fft_d13[31:16];
		multi_in[14] = fft_d14[31:16];
		multi_in[15] = fft_d15[31:16];
	end else begin
		for(i = 0; i < 16; i = i + 1) begin
			multi_in[i] = temp[i];
		end
	end
end


//--------------------------------------------------------------------
// Analysis Circuit
//--------------------------------------------------------------------
// reg  analysis_start;
always @(posedge clk or posedge rst) begin
	if(rst) begin
		analysis_start <= 1'b0;
	end else if(state == ANALYSIS && cnt == 2'd0) begin
		analysis_start <= 1'b1;
	end else begin
		analysis_start <= 1'b0;
	end
end

//--------------------------------------------------------------------
// Output Signal
//--------------------------------------------------------------------
// output [31:0] fft_d0,fft_d1,fft_d2,fft_d3,fft_d4,fft_d5,fft_d6,fft_d7, 
//               fft_d8,fft_d9,fft_d10,fft_d11,fft_d12,fft_d13,fft_d14,fft_d15;
always @(posedge clk or posedge rst) begin
	if(rst) begin
		fft_d0  <= 32'd0; fft_d1  <= 32'd0; fft_d2  <= 32'd0; fft_d3  <= 32'd0; fft_d4  <= 32'd0; fft_d5  <= 32'd0;
		fft_d6  <= 32'd0; fft_d7  <= 32'd0; fft_d8  <= 32'd0; fft_d9  <= 32'd0; fft_d10 <= 32'd0; fft_d11 <= 32'd0;
		fft_d12 <= 32'd0; fft_d13 <= 32'd0; fft_d14 <= 32'd0; fft_d15 <= 32'd0;
	end else begin
		case (state)
			FFT_OUTPUT:	begin
							fft_d0  <= fft_res_a[0];
							fft_d1  <= fft_res_a[4];
							fft_d2  <= fft_res_a[2];
							fft_d3  <= fft_res_a[6];
							fft_d4  <= fft_res_a[1];
							fft_d5  <= fft_res_a[5];
							fft_d6  <= fft_res_a[3];
							fft_d7  <= fft_res_a[7];
							fft_d8  <= fft_res_b[0];
							fft_d9  <= fft_res_b[4];
							fft_d10 <= fft_res_b[2];
							fft_d11 <= fft_res_b[6];
							fft_d12 <= fft_res_b[1];
							fft_d13 <= fft_res_b[5];
							fft_d14 <= fft_res_b[3];
							fft_d15 <= fft_res_b[7];
						end
			NORM:		begin
							if(cnt == 2'd0) begin
								fft_d0  <= multi_out[0];
								fft_d1  <= multi_out[1];
								fft_d2  <= multi_out[2];
								fft_d3  <= multi_out[3];
								fft_d4  <= multi_out[4];
								fft_d5  <= multi_out[5];
								fft_d6  <= multi_out[6];
								fft_d7  <= multi_out[7];
								fft_d8  <= multi_out[8];
								fft_d9  <= multi_out[9];
								fft_d10 <= multi_out[10];
								fft_d11 <= multi_out[11];
								fft_d12 <= multi_out[12];
								fft_d13 <= multi_out[13];
								fft_d14 <= multi_out[14];
								fft_d15 <= multi_out[15];
							end else begin
								fft_d0  <= fft_d0 + multi_out[0];
								fft_d1  <= fft_d1 + multi_out[1];
								fft_d2  <= fft_d2 + multi_out[2];
								fft_d3  <= fft_d3 + multi_out[3];
								fft_d4  <= fft_d4 + multi_out[4];
								fft_d5  <= fft_d5 + multi_out[5];
								fft_d6  <= fft_d6 + multi_out[6];
								fft_d7  <= fft_d7 + multi_out[7];
								fft_d8  <= fft_d8 + multi_out[8];
								fft_d9  <= fft_d9 + multi_out[9];
								fft_d10 <= fft_d10 + multi_out[10];
								fft_d11 <= fft_d11 + multi_out[11];
								fft_d12 <= fft_d12 + multi_out[12];
								fft_d13 <= fft_d13 + multi_out[13];
								fft_d14 <= fft_d14 + multi_out[14];
								fft_d15 <= fft_d15 + multi_out[15];
							end
						end
			default:	begin
							fft_d0  <= fft_d0;
							fft_d1  <= fft_d1;
							fft_d2  <= fft_d2;
							fft_d3  <= fft_d3;
							fft_d4  <= fft_d4;
							fft_d5  <= fft_d5;
							fft_d6  <= fft_d6;
							fft_d7  <= fft_d7;
							fft_d8  <= fft_d8;
							fft_d9  <= fft_d9;
							fft_d10 <= fft_d10;
							fft_d11 <= fft_d11;
							fft_d12 <= fft_d12;
							fft_d13 <= fft_d13;
							fft_d14 <= fft_d14;
							fft_d15 <= fft_d15;
						end
		endcase
	end
end

// output fft_valid;
always @(posedge clk or posedge rst) begin
	if(rst) begin
		fft_valid <= 1'b0;
	end else if(state == FFT_OUTPUT) begin
		fft_valid <= 1'b1;
	end else begin
		fft_valid <= 1'b0;
	end
end

// output done;      
assign done = analysis_done;

// output [3:0] freq;

//--------------------------------------------------------------------
// FOR DEBUG
//--------------------------------------------------------------------
initial begin
	@(posedge clk);
	forever begin
		#10;
		if(fft_pe_valid) begin
			/*$display("0 : %x\n1 : %x\n2 : %x\n3 :  %x\n4 :  %x\n5 :  %x\n6 :  %x\n7 :  %x\n8 : %x\n9 : %x\n10 :  %x\n11 :  %x\n12 :  %x\n13 :  %x\n14 :  %x\n15 :  %x\n\n\n ",
					  fft_out_a[0],
					  fft_out_a[1],
					  fft_out_a[2],
					  fft_out_a[3],
					  fft_out_a[4],
					  fft_out_a[5],
					  fft_out_a[6],
					  fft_out_a[7],
					  fft_out_b[0],
					  fft_out_b[1],
					  fft_out_b[2],
					  fft_out_b[3],
					  fft_out_b[4],
					  fft_out_b[5],
					  fft_out_b[6],
					  fft_out_b[7]);*/
		end	
	end
end

endmodule

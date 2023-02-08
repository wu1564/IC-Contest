module FFT_PE#(
	parameter BUFFER_DEPTH = 8
)(
	clk, 
	rst, 			 
	a, 		
	b,	    
	power,			 
	ab_valid, 
	fft_a, 
	fft_b,
	fft_pe_valid
);

//----------------------------------------------------------
// Parameter Define
//----------------------------------------------------------
localparam IDLE 	    = 0;
localparam FIRST_STEP   = 1;
localparam SECOND_STEP  = 2;

//----------------------------------------------------------
// Input & Output Define
//----------------------------------------------------------
input  clk, rst; 		 
input  [2:0] power;
input  ab_valid;		
input  signed [31:0] a, b;
output reg fft_pe_valid;
output reg [31:0] fft_a, fft_b;

//-----------------------------------------------------------
// Regs & Wires
//-----------------------------------------------------------
wire signed [15:0] alu_res_0, alu_res_1;
wire signed [31:0] mul_real, mul_imag;
reg  [1:0]  state, next_state;
reg  signed [15:0] alu_in_0, alu_in_1;
reg  signed [31:0] const_real, const_imag;
reg  signed [31:0] buffer_a, buffer_b;

//-----------------------------------------------------------
// Module
//-----------------------------------------------------------
Alu #(
	.DATA_WIDTH(16)
)a0(
	.a(alu_in_0),
	.b(alu_in_1),
	.control(1'b1),
	.result(alu_res_0)
);

Alu #(
	.DATA_WIDTH(16)
)a1(
	.a(alu_in_0),
	.b(alu_in_1),
	.control(1'b0),
	.result(alu_res_1)
);

//-----------------------------------------------------------
// Finite State Machine
//-----------------------------------------------------------
//reg [1:0] state;
always @(posedge clk or posedge rst) begin
	if(rst) state <= IDLE;
	else state <= next_state;
end

//reg [1:0] next_state;
always @(*) begin
	case (state)
		IDLE:		 next_state = (ab_valid) ? FIRST_STEP : IDLE;
		FIRST_STEP:	 next_state = SECOND_STEP;
		default: 	 next_state = IDLE;
	endcase
end

//-----------------------------------------------------------
// Flags
//-----------------------------------------------------------
//reg signed [31:0] const_real;
always @(*) begin
	case (power)
		3'd0:	const_real = 32'h00010000;
		3'd1:	const_real = 32'h0000EC83;
		3'd2:	const_real = 32'h0000B504;
		3'd3:	const_real = 32'h000061F7;
		3'd4:	const_real = 32'h00000000;
		3'd5:	const_real = 32'hFFFF9E09;
		3'd6:	const_real = 32'hFFFF4AFC;
		3'd7:	const_real = 32'hFFFF137D;
	endcase
end

//reg signed [31:0] const_imag;
always @(*) begin
	case (power)
		3'd0:	const_imag = 32'h00000000;
		3'd1:	const_imag = 32'hFFFF9E09;
		3'd2:	const_imag = 32'hFFFF4AFC;
		3'd3:	const_imag = 32'hFFFF137D;
		3'd4:	const_imag = 32'hFFFF0000;
		3'd5:	const_imag = 32'hFFFF137D;
		3'd6:	const_imag = 32'hFFFF4AFC;
		3'd7:	const_imag = 32'hFFFF9E09;
	endcase
end

//wire [15:0] alu_in_0, alu_in_1;
always @(*) begin
	case(state)
		FIRST_STEP:		begin
							alu_in_0 = buffer_a[31:16];
							alu_in_1 = buffer_b[31:16];
						end
		SECOND_STEP: 	begin
							alu_in_0 = buffer_a[15:0];
							alu_in_1 = buffer_b[15:0];
						end
		default:		begin
							alu_in_0 = 16'd0; 
							alu_in_1 = 16'd0;
						end
	endcase
end

//wire signed [31:0] mul_real, mul_imag;
assign mul_real = {{16{alu_res_1[15]}}, alu_res_1} * const_real;
assign mul_imag = {{16{alu_res_1[15]}}, alu_res_1} * const_imag;

//reg  signed [31:0] buffer_a;
always @(posedge clk or posedge rst) begin
    if(rst) begin
        buffer_a <= 32'd0;
    end else if(ab_valid) begin
        buffer_a <= a;
    end
end

//reg  signed [31:0] buffer_b;
always @(posedge clk or posedge rst) begin
    if(rst) begin
        buffer_b <= 32'd0;
    end else if(ab_valid) begin
        buffer_b <= b;
    end
end

//-----------------------------------------------------------
// Output Signals
//-----------------------------------------------------------
//output reg [31:0] fft_a;
always @(posedge clk or posedge rst) begin
	if(rst) begin
		fft_a <= 32'd0;
	end else begin
		case(state)
			IDLE:			fft_a <= 32'd0;
			FIRST_STEP:		fft_a[31:16] <= alu_res_0;			// real    part
			SECOND_STEP:	fft_a[15:0]  <= alu_res_0;			// complex part
			default: 		fft_a <= fft_a;
		endcase
	end
end

//output reg [31:0] fft_b;
always @(posedge clk or posedge rst) begin
	if(rst) begin
		fft_b <= 32'd0;
	end else begin
		case (state)
			IDLE:			fft_b <= 32'd0;
			FIRST_STEP:		begin
								fft_b[31:16] <= mul_real[16+:16]; 					// real    part
								fft_b[15:0]  <= ~mul_imag[16+:16] + 16'd1;			// complex part
							end 
			SECOND_STEP:	begin
								fft_b[31:16] <= fft_b[31:16] + mul_imag[16+:16]; 	// real    part
								fft_b[15:0]  <= fft_b[15:0] + mul_real[16+:16]; 	// complex part
							end
			default: 		fft_b <= fft_b;
		endcase
	end
end

//output reg fft_pe_valid;
always @(posedge clk or posedge rst) begin
	if(rst) begin
		fft_pe_valid <= 1'b0;
	end else begin
		case (state)
			SECOND_STEP:	fft_pe_valid <= 1'b1;
			default:		fft_pe_valid <= 1'b0;
		endcase
	end
end

endmodule

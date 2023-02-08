module FFT_PE (
	clk, 
	rst, 			 
	a, 		
	b,	    
	const_real,			 
	const_imag,
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
input  ab_valid;		
input  signed [31:0] a, b;
input  signed [31:0] const_real, const_imag;
output reg fft_pe_valid;
output reg [31:0] fft_a;
output [31:0] fft_b;

//-----------------------------------------------------------
// Regs & Wires
//-----------------------------------------------------------
wire signed [15:0] alu_res_0, alu_res_1;
wire signed [31:0] mul_real, mul_imag;
reg  [1:0]  state, next_state;
reg  signed [15:0] alu_in_0, alu_in_1;
reg  signed [31:0] buffer_a, buffer_b;
reg  signed [31:0] fft_b_real, fft_b_imag;

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

//reg  signed [31:0] fft_a_real, fft_a_imag, fft_b_real, fft_b_imag;
always @(posedge clk or posedge rst) begin
	if(rst) begin
		fft_b_real <= 32'd0;
		fft_b_imag <= 32'd0;
	end else begin
		case(state)
			IDLE:			begin
								fft_b_real <= 32'd0;
								fft_b_imag <= 32'd0;	
							end
			FIRST_STEP:		begin
								fft_b_real <= mul_real; 
								fft_b_imag <= mul_imag;
							end
			SECOND_STEP:	begin
								fft_b_real <= fft_b_real + ~mul_imag + 32'd1;
								fft_b_imag <= fft_b_imag + mul_real;
							end
			default: 		begin
								fft_b_real <= fft_b_real;
								fft_b_imag <= fft_b_imag;
							end
		endcase
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
assign fft_b = {fft_b_real[16+:16], fft_b_imag[16+:16]};

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

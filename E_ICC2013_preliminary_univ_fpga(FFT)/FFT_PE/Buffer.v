module Buffer #(
    parameter BUFFER_DEPTH = 16,
    parameter DATA_WIDTH   = 32
)(
    // Input Signal
    clk,
    rst,
    data_valid,
    data,
    // Output Signal
    buffer_finish,
    buffer_out
);

//---------------------------------------------------------------
// Input & Output Declaration
//---------------------------------------------------------------
input  clk;
input  rst;
input  data_valid;
input  [DATA_WIDTH-1:0] data;
output reg buffer_finish;
output reg [DATA_WIDTH * BUFFER_DEPTH-1:0] buffer_out;

//---------------------------------------------------------------
// Regs & Wires Declaration
//---------------------------------------------------------------
integer i, var;
wire receive_done;
reg  [3:0] counter;
reg  [DATA_WIDTH-1:0] buffer [0:BUFFER_DEPTH-2];

//---------------------------------------------------------------
// Flags & Counter
//---------------------------------------------------------------
//wire receive_done;
assign receive_done = (counter == BUFFER_DEPTH-1) ? 1'b1 : 1'b0;

//reg [16-1:0] buffer [0:14];
always @(posedge clk or posedge rst) begin
    if(rst) begin
        for(i = 0; i < BUFFER_DEPTH-1; i = i + 1) begin
            buffer[i] <= {DATA_WIDTH{1'b0}};
        end
    end else if(data_valid && counter < BUFFER_DEPTH) begin
        buffer[counter] <= data;
    end
end

//reg [3:0] counter;
always @(posedge clk or posedge rst) begin
    if(rst) counter <= 4'd0;
    else if(data_valid) begin
        counter <= (receive_done) ? 4'd0 : counter + 4'd1;
    end
end

//---------------------------------------------------------------
// Output Signal
//---------------------------------------------------------------
//reg  [16-1:0] buffer [0:BUFFER_DEPTH-1];
always @(posedge clk or posedge rst) begin
    if(rst) begin
        buffer_out <= {DATA_WIDTH * BUFFER_DEPTH{1'b0}};
    end else if(receive_done) begin
        for(var = 0; var < BUFFER_DEPTH-1; var = var + 1) begin
            buffer_out[var * DATA_WIDTH +: DATA_WIDTH] <= buffer[var];
        end
        buffer_out[DATA_WIDTH * (BUFFER_DEPTH-1) +: DATA_WIDTH] <= data;
    end
end

//output wire buffer_finish;
always @(posedge clk or posedge rst) begin
    if(rst) begin
        buffer_finish <= 1'b0;
    end else if(receive_done) begin
        buffer_finish <= 1'b1;
    end else begin
        buffer_finish <= 1'b0;
    end
end

endmodule

module Memory #(
    parameter BUFFER_ADDR_WIDTH = 4,
    parameter BUFFER_DEPTH = 16,
    parameter DATA_WIDTH   = 32
)(
    // Input Signal
    clk,
    rst,
    // Control Signal
    pop_control,
    // Input data
    data_valid,
    data,
    // Output Signal
    buffer_finish,
    buffer_out_0,  buffer_out_1,  buffer_out_2,  buffer_out_3,
    buffer_out_4,  buffer_out_5,  buffer_out_6,  buffer_out_7,
    buffer_out_8,  buffer_out_9,  buffer_out_10, buffer_out_11, 
    buffer_out_12, buffer_out_13, buffer_out_14, buffer_out_15,
    full,
    empty
);

//---------------------------------------------------------------
// Parameter Define
//---------------------------------------------------------------
localparam POP_SIZE = 2**BUFFER_ADDR_WIDTH;

//---------------------------------------------------------------
// Input & Output Declaration
//---------------------------------------------------------------
input  clk;
input  rst;
input  pop_control;
input  data_valid;
input  [DATA_WIDTH-1:0] data;
output reg buffer_finish;
output reg full;
output empty;
output [DATA_WIDTH-1:0] buffer_out_0,  buffer_out_1,  buffer_out_2,  buffer_out_3, buffer_out_4,  buffer_out_5,  buffer_out_6,  buffer_out_7, buffer_out_8,  buffer_out_9,  buffer_out_10, buffer_out_11, buffer_out_12, buffer_out_13, buffer_out_14, buffer_out_15;

//---------------------------------------------------------------
// Regs & Wires Declaration
//---------------------------------------------------------------
integer i, var;
wire pop_out;
wire receive_done;
reg  [log2(BUFFER_DEPTH)-1:0] counter, pop_cnt;
reg  [DATA_WIDTH-1:0] buffer [0:BUFFER_DEPTH-1];

//---------------------------------------------------------------
// Flags & Counter
//---------------------------------------------------------------
//wire pop_out;
assign pop_out = (pop_cnt == 0) ? 1'b1 : 1'b0;

//wire receive_done;
assign receive_done = (counter == BUFFER_DEPTH-1) ? 1'b1 : 1'b0;

//reg  [DATA_WIDTH-1:0] buffer [0:BUFFER_DEPTH-1];
always @(posedge clk or posedge rst) begin
    if(rst) begin
        for(i = 0; i < BUFFER_DEPTH; i = i + 1) begin
            buffer[i] <= {DATA_WIDTH{1'b0}};
        end
    end else if(pop_control) begin
        for(i = 0; i < BUFFER_DEPTH - POP_SIZE; i = i + 1) begin
            buffer[i] <= buffer[i+POP_SIZE];
        end
    end else if(data_valid && ~full) begin
        buffer[counter] <= data;
    end
end

//reg [3:0] counter;
always @(posedge clk or posedge rst) begin
    if(rst) begin
        counter <= 0;
    end else begin
        case(1'b1)
            data_valid: counter <= (counter == BUFFER_DEPTH) ? counter : counter + 1;
            pop_out:    counter <= 0;
            default:    counter <= counter;
        endcase
    end
end

//reg  [log2(BUFFER_DEPTH)-1:0] pop_cnt;
always @(posedge clk or posedge rst) begin
    if(rst) begin
        pop_cnt <= 0;
    end else begin
        case(1'b1)
            pop_control:    pop_cnt <= pop_cnt - POP_SIZE;
            receive_done:   pop_cnt <= BUFFER_DEPTH;
            default:        pop_cnt <= pop_cnt;
        endcase
    end
end

//---------------------------------------------------------------
// Output Signal
//---------------------------------------------------------------
//output [DATA_WIDTH-1:0] buffer_out_0 ~ buffer_out_15;
assign buffer_out_0 = buffer[0];
assign buffer_out_1 = buffer[1];
assign buffer_out_2 = buffer[2];
assign buffer_out_3 = buffer[3];
assign buffer_out_4 = buffer[4];
assign buffer_out_5 = buffer[5];
assign buffer_out_6 = buffer[6];
assign buffer_out_7 = buffer[7];
assign buffer_out_8 = buffer[8];
assign buffer_out_9 = buffer[9];
assign buffer_out_10 = buffer[10];
assign buffer_out_11 = buffer[11];
assign buffer_out_12 = buffer[12];
assign buffer_out_13 = buffer[13];
assign buffer_out_14 = buffer[14];
assign buffer_out_15 = buffer[15];

//output reg buffer_finish;
always @(posedge clk or posedge rst) begin
    if(rst) begin
        buffer_finish <= 1'b0;
    end else if(receive_done || pop_control) begin
        buffer_finish <= 1'b1;
    end else begin
        buffer_finish <= 1'b0;
    end
end

//output reg full
always @(posedge clk or posedge rst) begin
    if(rst) begin
        full <= 1'b0;
    end else if(receive_done || counter >= BUFFER_DEPTH) begin
        full <= 1'b1;
    end
end

//output empty;
assign empty = (counter == 0) ? 1'b1 : 1'b0;

//---------------------------------------------------------------
// Function (log2)
//---------------------------------------------------------------
function integer log2;
input [31:0] value;
    for (log2=0; value>0; log2=log2+1)
        value = value>>1;
endfunction

endmodule

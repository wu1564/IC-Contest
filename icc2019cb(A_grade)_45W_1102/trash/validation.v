`timescale 1ns/1ps

`define CYCLE 10

module validation;

reg  clk;
reg  reset_n;
reg  [3:0] cnt;
reg  signed [127:0] rad;                           // 16 bit fixed
reg  signed [127:0] cos_a, cos_b;                  // 64 bit fixed all float 
reg  signed [127:0] lon_a, lon_b, lat_a, lat_b;    // 16 bit fixed
wire [127:0] adder;
wire [255:0] mult_out;
reg  [127:0] add_in0, add_in1, mult_in0, mult_in1;

reg signed [127:0] temp, temp2;

initial begin
    clk = 0;
    forever #(`CYCLE/2) clk = ~clk;
end

initial begin
    reset_n = 1;
    lon_a = {80'd0,48'h0079002c0000};       // 32 fixed
    lon_b = {80'd0,48'h0079002d0000};
    lat_a = {80'd0,48'h0018c8db0000};
    lat_b = {80'd0,48'h0018c8dd0000};
    cos_a = {64'd0,64'hf0a4e3f12f0e1b3d};   // 64 fixed
    cos_b = {64'd0,64'hf0a435481bf84f2c};
    rad   = {96'd0,16'h0477,16'd0};         // 32 fixed
    #(`CYCLE) reset_n = 0;
    #(`CYCLE) reset_n = 1;  
    #(`CYCLE * 100);
    $finish;
end

assign adder = add_in0 + add_in1;
assign mult_out = $signed(mult_in0) * $signed(mult_in1);

always @(*) begin
    add_in0 = 0;
    add_in1 = 0;
    mult_in0 = 0;
    mult_in1 = 0;
    case(cnt) 
        0: begin
            add_in0 = lon_a;
            add_in1 = ~lon_b + 128'd1;
        end
        1: begin
            mult_in0 = temp; // (lonA - lonB) * rad     
            mult_in1 = rad; 
        end
        2: begin
            mult_in0 = temp; // sin^2((lonA - lonB) * rad / 2)
            mult_in1 = temp;
        end
        3: begin
            mult_in0 = temp;
            mult_in1 = cos_b; // cosB * sin^2((lonA - lonB) * rad / 2)  64 fixed * 64bit fixed
        end
        4: begin
            mult_in0 = temp;
            mult_in1 = cos_a; // cosA * cosB * sin^2((lonA - lonB) * rad / 2)  64 fixed * 64bit fixed
        end
        5: begin
            add_in0 = lat_a;  // latA - latB
            add_in1 = ~lat_b + 128'd1;
        end
        6: begin
            mult_in0 = temp2; // (latA - latB) * rad 16 * 16
            mult_in1 = rad;
        end
        7: begin
            mult_in0 = temp2; // sin^2((latA - latB) * rad / 2) 64 * 64
            mult_in1 = temp2;
        end
        8: begin
            add_in0 = temp;
            add_in1 = temp2;
        end
        default: begin
            add_in0 = 0;
            add_in1 = 0;
            mult_in0 = 0;
            mult_in1 = 0;
        end
    endcase 
end

always @(posedge clk or negedge reset_n) begin
    if(!reset_n) begin
        temp <= 128'd0;
        temp2 <= 128'd0;
    end else begin
        case(cnt) 
            0: temp <= adder;               // lonA - lonB
            1: temp <= mult_out[1+:128];    // ((lonA - lonB) * rad) / 2          64 fixed
            2: temp <= mult_out[64+:128];   // sin^2((lonA - lonB) * rad / 2)     64 + 64 -> 64 bit fixed
            3: temp <= mult_out[64+:128];   // fixed 128 bit >> to 64 bits        64 bit fixed
            4: temp <= mult_out[64+:128];   // fixed 128 bit >> to 64 bits        64 bit fixed
            5: temp2 <= adder;              // latA - latB
            6: temp2 <= mult_out[1+:128];   // ((latA - latB) * rad) / 2          64 bit fixed
            7: temp2 <= mult_out[64+:128];  // sin^2((latA - latB) * rad / 2)     64 + 64 -> 64 bit fixed
            8: temp <= adder;               // 64 bit fixed
            default: begin
                temp <= temp;
                temp2 <= temp2;
            end
        endcase
    end
end

always @(posedge clk or negedge reset_n) begin
    if(!reset_n) begin
        cnt <= 4'd0;
    end else begin
        cnt <= (cnt == 4'd8) ? 4'd0 : cnt + 4'd1;
    end
end

endmodule

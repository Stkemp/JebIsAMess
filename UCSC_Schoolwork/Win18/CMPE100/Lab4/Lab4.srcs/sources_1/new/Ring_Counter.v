`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/31/2018 02:01:21 PM
// Design Name: 
// Module Name: Ring_Counter
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Ring_Counter(
    input advance,
    input clk,
    output [3:0] out
    );
    
    FDRE #(.INIT(1'b1) ) ff1(.C(clk), .R(1'b0), .CE(advance), .D(out[3]), .Q(out[0]));
    FDRE #(.INIT(1'b0) ) ff2(.C(clk), .R(1'b0), .CE(advance), .D(out[0]), .Q(out[1]));
    FDRE #(.INIT(1'b0) ) ff3(.C(clk), .R(1'b0), .CE(advance), .D(out[1]), .Q(out[2]));
    FDRE #(.INIT(1'b0) ) ff4(.C(clk), .R(1'b0), .CE(advance), .D(out[2]), .Q(out[3]));
    
endmodule

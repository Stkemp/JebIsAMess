`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/12/2018 03:14:18 PM
// Design Name: 
// Module Name: LFSR
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


module LFSR(
    input clk,
    input run,
    output [7:0] rnd
    );
    
    FDRE #(.INIT(1'b1)) FF0 (.C(clk), .CE(run), .D(rnd[0]^rnd[5]^rnd[6]^rnd[7]), .Q(rnd[0]));
    FDRE #(.INIT(1'b0)) FF7_1[7:1] (.C({7{clk}}), .CE({7{run}}), .D(rnd[6:0]), .Q(rnd[7:1]));
    
endmodule

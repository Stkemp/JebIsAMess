`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/06/2018 02:59:54 PM
// Design Name: 
// Module Name: GHPgen
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


module GHPgen(
    input [3:0] prevgate,
    input [3:0] plusminus,
    output [3:0] thisgate
    );
    
    wire is15, is14, is1, is0;
    wire [3:0] sum;
    
    Adder MyAdder(.a(prevgate), .b(plusminus), .cin(1'b0), .s(sum));
    
    assign is15 = &(~(prevgate^4'b1111));
    assign is14 = &(~(prevgate^4'b1110));
    assign is1 = &(~(prevgate^4'b0001));
    assign is0 = &(~(prevgate^4'b0000));
    
    m4_1x4 MyMux(.in0(sum), .in1(4'b0010), .in2(4'b1101), .in3(4'b0000), .e(1'b1), .sel({is15|is14, is1|is0}), .o(thisgate));
    
endmodule

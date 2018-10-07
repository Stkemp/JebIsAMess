`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/06/2018 04:35:25 PM
// Design Name: 
// Module Name: m2_1x16
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


module m2_1x16(
    input [15:0] in0,
    input [15:0] in1,
    input sel,
    output [15:0] o
    );
    
    assign o = in0&~{16{sel}} | in1&{16{sel}};
    
endmodule

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/23/2018 02:53:01 PM
// Design Name: 
// Module Name: ANDFullAdder
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


module ANDFullAdder(
    input q,
    input m,
    input p,
    input cin,
    output cout,
    output s
    );
    
    wire [7:0] v0, v1;
    assign v0 = {1'b1, q, q, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0};
    assign v1 = {q, ~q, ~q, q, 1'b0, 1'b1, 1'b1, 1'b0};
    
    m8_1e coutmux (v0, {m, p, cin}, 1'b1, cout);
    m8_1e smux (v1, {m, p, cin}, 1'b1, s);
    
endmodule

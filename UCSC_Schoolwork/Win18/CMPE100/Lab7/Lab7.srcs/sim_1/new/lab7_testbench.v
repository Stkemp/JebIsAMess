`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/06/2018 09:07:37 PM
// Design Name: 
// Module Name: lab7_testbench
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


module lab7_testbench();

reg clkin, btnL, btnR, btnU, btnD, btnC;
reg [15:0] sw;
wire Vsync, Hsync, dp;
wire [3:0] an, vgaRed, vgaGreen, vgaBlue;
wire [6:0] seg;
wire [15:0] led;

Top UUT (clkin, btnR, btnL, btnU, btnD, btnC, sw, Vsync, Hsync, vgaRed, vgaGreen, vgaBlue, seg, an, dp, led);

parameter PERIOD = 10;
    parameter real DUTY_CYCLE = 0.5;
    parameter OFFSET = 2;

    initial    // Clock process for clkin
    begin
        #OFFSET
                  clkin = 1'b1;
        forever
        begin
            #(PERIOD-(PERIOD*DUTY_CYCLE)) clkin = ~clkin;
        end
        end
        
   initial
   begin
   
   btnR = 0;
   btnL = 0;
   btnU = 0;
   btnD = 0;
   btnC = 0;
   sw = 16'b0;
   #1000;
   btnU = 1;
   #50;
   btnU = 0;
   
   end
endmodule

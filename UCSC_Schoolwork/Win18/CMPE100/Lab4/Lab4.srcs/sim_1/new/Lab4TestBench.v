`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/04/2018 07:13:00 PM
// Design Name: 
// Module Name: Lab4TestBench
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


module Lab4TestBench();

reg clkin, btnR, btnU, btnD, btnC, btnL;
reg [15:0] sw;
wire [6:0] seg;
wire [3:0] an;
wire [15:0] led;

Top UUT (clkin, btnR, btnU, btnD, btnC, btnL, sw, seg, dp, an, led);

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
         // add your stimuli here
         // to set signal foo to value 0 use
         // foo = 1'b0;
         // to set signal foo to value 1 use
         // foo = 1'b1;
         //always advance time my multiples of 100ns
         // to advance time by 100ns use the following line
btnR = 0;
btnU = 0;
btnD = 0;
btnC = 0;
btnL = 0;
sw = 16'b0000000000000000;
#1200;
btnU = 1'b1;
#100;
btnU = 1'b0;
#100;
btnU = 1'b1;
#100;
btnU = 1'b0;
#100;
btnU = 1'b1;
#100;
btnU = 1'b0;
#100;
btnU = 1'b1;
#100;
btnD = 1'b1;
btnU = 1'b0;
#100;
btnD = 1'b0;
#100;
btnD = 1'b1;
#100;
btnD = 1'b0;
btnC = 1'b1;
#200;
sw = 16'b1111111111110000;
btnL = 1'b1;
btnC = 0;
#100;
sw = 16'b1111111111110000;
#100;
btnL = 1'b0;
#1000;
btnD = 1'b1;
#1000;
btnD = 1'b0;
#100;
btnC = 1'b1;
        
        
        end
endmodule

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/13/2018 02:42:15 PM
// Design Name: 
// Module Name: Lab5_Testbench
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


module Lab5_Testbench( );

reg clkin, btnR, btnD, btnU;
reg [15:0] sw;
wire [15:0] led;
wire [3:0] an;
wire [6:0] seg;

Top UUT (clkin, btnR, btnD, btnU, sw, led, an, seg);

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
btnD = 0;
btnU = 0;
sw = 16'b0001000000000000;
#2000;
#100;
btnD = 1;
#50;
btnD = 0;
btnU = 1;
#10000;
btnU = 0;
    end
            
endmodule

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/21/2018 03:36:55 PM
// Design Name: 
// Module Name: lab6_Testbench
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


module lab6_Testbench( );

reg clkin, btnL, btnR, btnU;
wire led15, led9;
wire [3:0] an;
wire [6:0] seg;

Top UUT (clkin, btnL, btnR, btnU, led15, led9, an, seg);

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
btnL = 0;
btnU = 0;

#1200;

// no crossing
btnR = 1;
#50;
btnR = 0;
#50;
// left crossing
btnR = 1;
#50;
btnL = 1;
#50;
btnR = 0;
#50;
btnL = 0;
#200;
// right crossing
btnR = 1; // L&R pressed same time.
btnL = 1;
#50;
btnL = 0;
#50;
btnR = 0;
#200;
// L&R released at same time
btnR = 1;
btnL = 1;
#50
btnR = 0;
btnL = 0;
#200;

end

endmodule

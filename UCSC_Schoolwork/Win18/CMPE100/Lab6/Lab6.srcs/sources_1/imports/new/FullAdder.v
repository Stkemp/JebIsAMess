`timescale 1ns / 1ps


module FullAdder(
    input a,
    input b,
    input cin,
    output s,
    output cout
    );
    wire f,e;
    
    assign f = a ^ b;
    assign e = a & b;
    assign s = f ^ cin;
    assign cout = (f & cin) | e;
    
endmodule
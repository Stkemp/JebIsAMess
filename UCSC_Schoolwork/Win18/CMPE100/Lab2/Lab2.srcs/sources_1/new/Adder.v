`timescale 1ns / 1ps

module Adder(
    input a0,
    input b0,
    input a1,
    input b1,
    input a2,
    input b2,
    input cin,
    output s0,
    output s1,
    output s2,
    output s3
    );
    wire c0, c1;
    
    FullAdder add1 (.a(a0), .b(b0), .cin(cin), .s(s0), .cout(c0));
    FullAdder add2 (.a(a1), .b(b1), .cin(c0), .s(s1), .cout(c1));
    FullAdder add3 (.a(a2), .b(b2), .cin(c1), .s(s2), .cout(s3));
    
endmodule

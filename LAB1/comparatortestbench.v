`timescale 1ns/1ns
`include "comparator.v"

module tb();

  reg a,b; 
  wire greater, equal, lower; 

  comparator dut(
    .A(a),
    .B(b),
    .Y1(greater),
    .Y2(equal),
    .Y3(lower)
  );

  initial begin
    $dumpfile("tb.vcd");
    $dumpvars(0, tb);

    a = 0; b = 0; //A = 0, B = 0
    #10; //delay

    a = 0; b = 1; //A = 0, B = 1
    #10; //delay

    a = 1; b = 0; //A = 1, B = 0
    #10; //delay

    a = 1; b = 1; //A = 1, B = 1
    #10; //delay

    $display("Test is completed...");
  end

endmodule

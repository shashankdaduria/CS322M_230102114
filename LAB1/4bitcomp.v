module 4bitcomp(
  input [3:0] A;
  input [3:0] B;
  output C;
); //module instantiation
 
  C = (A==B) ? 1 : 0; //assign 1 to C when equal(A and B)

endmodule //end of module

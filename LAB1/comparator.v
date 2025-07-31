module compartor(
  input A;
  input B;
  output Y1;
  output Y2;
  output Y3;
); 

  Y1 = A & ~B; // when A is 1 and B is 0, i.e., A > B
  Y2 = A ~^ B; // one if both A and B are same
  Y3 = ~A & B; // when A is 0 and B is 1, i.e., A < B

endmodule 

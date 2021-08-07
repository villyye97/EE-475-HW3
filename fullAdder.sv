`timescale 1ns/10ps

module fullAdder(A, B, cin, sum, cout,sub);
	input logic A, B, cin, sub;
	output logic sum, cout;
	
	logic xor1,and1,and2,tmpB;
	logic [1:0] fB;
	assign fB[0] = B;
	not #0.05 n2(fB[1], B);
	mux_2to1 suboradd(.out(tmpB), .din(fB), .sel(sub));
	
	xor #0.05 x1(xor1,A,tmpB);
	xor #0.05 x2(sum,xor1,cin);
	and #0.05 a1(and1,xor1,cin);
	and #0.05 a2(and2, A,tmpB);
	or #0.05 o1(cout,and1,and2);
	
endmodule 

module fullAdder_testbench();
	logic A, B, cin, sum, cout, sub;
	
	fullAdder dut (A, B, cin, sum, cout, sub);
	
	initial begin
	
	sub=0;	A = 0; B = 0; cin =0; #10;
								  cin =1; #10;
						 B = 1; cin =0; #10;
								  cin =1; #10;
		      A = 1; B = 0; cin =0; #10;
								  cin =1; #10;
				       B = 1; cin =0; #10;
								  cin =1; #10;
	sub=1;	A = 0; B = 0; cin =0; #10;
								  cin =1; #10;
						 B = 1; cin =0; #10;
								  cin =1; #10;
		      A = 1; B = 0; cin =0; #10;
								  cin =1; #10;
				       B = 1; cin =0; #10;
								  cin =1; #10;
	   $stop;
	end
endmodule 
			
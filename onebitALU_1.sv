`timescale 1ns/10ps
module onebitALU_1(a, b, cin,cout, out,sel);
	input logic a,b,cin;
	input logic [2:0] sel;
	output logic cout,out;
	
	logic ab_and, ab_nand,ab_or,ab_nor;
	
	and a1 (ab_and,a,b);
	//function1:and
	
	not n1 (ab_nand, ab_and);
	//function2: nand
	
	or o1(ab_or,a,b);
	//function3: or
	
	not n2 (ab_nor,ab_or);
	//function4: nor
	
	
	mux8_1 m1(out, {1'b0,1'b0,1'b0,ab_and,ab_nand,ab_or,ab_nor,1'b0},sel);
	
	endmodule 
	
	
	
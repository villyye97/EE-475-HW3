`timescale 1ns/10ps
module bitAlu(A, B, cntrl, cin, cout, out);
	input logic A, B;
	input logic [2:0] cntrl;
	input logic cin;
	output logic cout;
	output logic out;
	
	//logic addsubout, andout, orout, xorout, passB; //tmp var for add/sub module to pass into mux
	logic [5:0] tmps;
	
	fullAdder fa(.A(A), .B(B), .cin(cin), .sum(tmps[1]), .cout(cout), .sub(cntrl[0]));
	and #0.05 a(tmps[3], A, B); 
	or #0.05 b(tmps[4], A, B);
	xor #0.05 c(tmps[5], A, B);
	assign tmps[0] = B;
	assign tmps[2] = tmps[1];
	//{xorout, andout, addsubout, addsubout, orout, passB}
	mux_6to1 d(.out(out), .din(tmps), .sel(cntrl));

endmodule 

module bitAlu_testbench;
   logic A, B;
	logic [2:0] cntrl;
	logic cin;
	logic cout;
	logic out;

   parameter delay = 10;

   integer i;
   initial begin
		A = 1'b1; B = 1'b1; cin = 0; cntrl = 3'b000; #(delay);//passb cout=x, out=0;
		A = 1'b1; B = 1'b0; cin = 1; cntrl = 3'b000; #(delay);//passb cout=x, out=0;
		
		A = 1'b1; B = 1'b1; cin = 0; cntrl = 3'b010; #(delay);//add cout=1, out=0;
		A = 1'b0; B = 1'b1; cin = 0; cntrl = 3'b010; #(delay);//add cout=0, out=1;
		A = 1'b1; B = 1'b1; cin = 1; cntrl = 3'b010; #(delay);//add cout=1, out=1;
		
		A = 1'b1; B = 1'b1; cin = 0; cntrl = 3'b011; #(delay);//sub cout=0, out=1;
		A = 1'b0; B = 1'b1; cin = 0; cntrl = 3'b011; #(delay);//sub cout=0, out=0;
		A = 1'b1; B = 1'b0; cin = 1; cntrl = 3'b011; #(delay);//sub cout=1, out=0;
		
		A = 1'b1; B = 1'b1; cin = 1; cntrl = 3'b100; #(delay);//and cout=x, out=1;
		A = 1'b1; B = 1'b0; cin = 0; cntrl = 3'b100; #(delay);//and cout=x, out=0;
		A = 1'b0; B = 1'b0; cin = 0; cntrl = 3'b100; #(delay);//and cout=x, out=0;

		A = 1'b1; B = 1'b1; cin = 1; cntrl = 3'b101; #(delay);//or cout=x, out=1;
		A = 1'b0; B = 1'b1; cin = 0; cntrl = 3'b101; #(delay);//or cout=x, out=1;
		A = 1'b0; B = 1'b0; cin = 0; cntrl = 3'b101; #(delay);//or cout=x, out=0;
		
		A = 1'b1; B = 1'b1; cin = 1; cntrl = 3'b110; #(delay);//xor cout=x, out=0;
		A = 1'b0; B = 1'b1; cin = 0; cntrl = 3'b110; #(delay);//xor cout=x, out=1;
		A = 1'b0; B = 1'b0; cin = 0; cntrl = 3'b110; #(delay);//xor cout=x, out=0;
   end

   bitAlu dut (.A, .B, .cntrl, .cin, .cout, .out);
endmodule

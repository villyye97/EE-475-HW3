`timescale 1ns/10ps
// sel = 1 get in[1] 
//sel = 0 get in[0] 
module mux2_1(in, out, sel);
	output logic out;
	input logic sel;
	input [1:0] in;
	
	logic isel, a,b;
	
	not #0.05 n1(isel, sel);
	and #0.05 a1(a, in[1],sel);
	and #0.05 a2(b, in[0], isel);
	or  #0.05 o1(out, a, b);
	
endmodule
	
	
module mux4_1 (in, out, sel);
	output logic out;
	input logic [3:0] in;
	input [1:0] sel;
		
	logic [1:0] temp;
	
	mux2_1 m1(in[3:2], temp[1], sel[0]);
	mux2_1 m2(in[1:0], temp[0], sel[0]);
	mux2_1 m3(temp,out, sel[1]);
	
endmodule 

module mux8_1(in,out,sel);
	input logic [7:0] in;
	input logic [2:0] sel;
	output logic out;
	
	logic [1:0] temp;
	
	mux4_1 m1(in[7:4], temp[1], sel[1:0]);
	mux4_1 m2(in[3:0], temp[0], sel[1:0]);
	mux2_1 m3(temp,out,sel[2]);
	
endmodule
	

module mux16_1(in, out, sel);

	input logic [15:0] in;
	input logic [3:0] sel;
	output logic out; 
	
	logic [3:0] temp;
	
	mux4_1 m1(in[15:12],temp[3],sel[1:0]);
	mux4_1 m2(in[11:8], temp[2], sel[1:0]);
	mux4_1 m3(in[7:4], temp[1], sel[1:0]);
	mux4_1 m4(in[3:0], temp[0], sel[1:0]);
	mux4_1 m21(temp,out, sel[3:2]);
	
endmodule 
	
module mux32_1(in, out, sel);
	input logic [31:0] in;
	input logic [4:0] sel;
	output logic out;
	
	logic [1:0] temp;
	
	mux16_1 m1(in[31:16], temp[1], sel[3:0]);
	mux16_1 m2(in[15:0], temp[0], sel[3:0]);
	mux2_1 m21(temp, out, sel[4]);
	
endmodule 

module mux32x64_64(in,out,sel);
	input logic [63:0]in[31:0];
	input logic [4:0] sel;
	output logic [63:0] out;
	
	logic [31:0]temp[63:0];
	
	always_comb begin
		for (int i = 0; i < 64; i++) begin
			for(int j = 0; j< 32; j++) begin
				temp[i][j] = in[j][i];
			end
		end
	end
	
	genvar k;
	generate 
		for(k = 0; k < 64; k++) begin : eachrow
			mux32_1 MUX(temp[k],out[k],sel);
		end
	endgenerate
endmodule
		
module mux2_1_x #(parameter WIDTH = 64)(in0,in1,out,sel);
	input logic [WIDTH-1:0] in0,in1;
	input logic sel;
	output logic [WIDTH-1:0] out;
	
	genvar k; 
	generate 
		for (k = 0; k<WIDTH; k++) begin :eachmux
		 mux2_1 MUX({in0[k],in1[k]},out[k],sel);
		end 
	endgenerate 
endmodule 

module mux4_1_x #(parameter WIDTH = 64)(in0,in1,in2,out,sel);
	input logic [WIDTH-1:0] in0,in1,in2;
	input logic sel;
	output logic [WIDTH-1:0] out;
	
	genvar k; 
	generate 
		for (k = 0; k<WIDTH; k++) begin :eachmux
		 mux4_1 MUX({in0[k],in1[k],in2[k],1'b0},out[k],sel);
		end 
	endgenerate 
endmodule 

module mux3_1_x #(parameter WIDTH = 64)(in0,in1,in2,out,sel);
	input logic [WIDTH-1:0] in0,in1,in2;
	input logic [1:0] sel;
	output logic [WIDTH-1:0] out;
	
	genvar i; 
	generate 
		for (i = 0; i<WIDTH; i++) begin :eachmux
			mux_3to1 MUX(.out(out[i]),.din({in2[i],in1[i],in0[i]}),.sel(sel));
		end 
	endgenerate 
endmodule 

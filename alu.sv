`timescale 1ns/10ps

module alu(A, B, cntrl, result, negative, zero, overflow, carry_out); 
	input logic [63:0] A, B;
	input logic [2:0] cntrl;
	output logic zero, overflow, carry_out, negative;
	output logic [63:0] result;
	
	logic [64:1] tmp_carry;
	logic [63:0] tmp_Alu;
	
	bitAlu startbit(.A(A[0]), .B(B[0]), .cntrl(cntrl), .cin(cntrl[0]), 
						.cout(tmp_carry[1]), .out(tmp_Alu[0]));
							
	genvar i;
	generate 
		for (i = 1; i < 64; i++) begin : eachbitalu
			bitAlu alu(.A(A[i]), 
							.B(B[i]), 
							.cntrl(cntrl), 
							.cin(tmp_carry[i]), 
							.cout(tmp_carry[i+1]),
							.out(tmp_Alu[i])
						 );			
		end
	endgenerate 
	
	assign negative = result[63];
	assign carry_out = tmp_carry[64];
	
	xor #0.05 ovflw(overflow, tmp_carry[64], tmp_carry[63]);
	zeroFlag zf(.out(zero), .alu(tmp_Alu));
	assign result = tmp_Alu;
endmodule



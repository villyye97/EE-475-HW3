`timescale 1ns/10ps

module zeroFlag (out, alu);
	input logic [63:0] alu;
	output logic out;
	
	logic [62:0] tmp;
	
	or #0.05 (tmp[0], alu[0], alu[1]);
	
	genvar i;
	generate 
		for (i = 0; i < 62; i++) begin : eachor
			or #0.05 (tmp[i+1],tmp[i], alu[i+2]);
		end
	endgenerate
	
	not #0.05 n1(out, tmp[62]);
	
endmodule

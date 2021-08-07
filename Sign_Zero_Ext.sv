/*
	Sign/zero extends any binary number to 64'bit binary number
	sel = 1 sign extend
	sel = 0 zero extend 
	from single_cycle_CPU instantiate by Sign_Zero_Ext #(.Din_Lngth = _) ext1(...);
*/ 
`timescale 1ns/10ps

module Sign_Zero_Ext #(parameter Din_Lngth = 16) (Din, Sel, Dout);
	input logic [Din_Lngth-1:0] Din;
	input logic Sel;
	
	output logic [63:0] Dout;
	
	logic [1:0] Sgn_extBit; 
	assign Sgn_extBit[1] = Din[Din_Lngth-1]; //sign
	assign Sgn_extBit[0] = 1'b0; // zero
	logic extBit;
	
	//First fill out the not extended part
	genvar i;
	generate 
		for (i = 0; i < Din_Lngth; i++) begin : eachBit
			assign Dout[i] = Din[i];
		end
	endgenerate 
	
	//See if zero extend or sign extend
	mux_2to1 zse(.out(extBit), .din(Sgn_extBit), .sel(Sel));
	
	//fill out the emtpy bits to extent to 64 bits
	genvar j;
	generate 
		for (j = Din_Lngth; j < 64; j++) begin : eachbit
			assign Dout[j] = extBit;
		end
	endgenerate

endmodule

module Sign_Zero_Ext_testbench ();
	logic [15:0] Din;
	logic Sel;
	logic [63:0] Dout;
	
	Sign_Zero_Ext dut (Din, Sel, Dout);
	
	integer i;
	initial begin
		Din <= 16'b1010111101011111; Sel <= 1'b1; #10;
		
		Din <= 16'b1010111101011111; Sel <= 1'b0; #10;
		
		$Stop; 
	end

endmodule 
/* 
Takes in instruction OP code from instruction memory and determines
the control signals. 0-9 in binary represents the 10 instructions in order
*/
`timescale 1ns/10ps

module CtrlSgnl (instruction, OPOut);
	input logic [31:0] instruction;
	output logic [3:0] OPOut;
	
	logic [10:0] OpCode; 
	
	assign OpCode = instruction[31:21];
	
	always_comb begin
		casex(OpCode) 
			// ADDI Instruction
			11'b1001000100x : OPOut = 4'b0000;
			
			// ADDS Instruction
			11'b10101011000 : OPOut = 4'b0001;
			
			// B. LT Instruction 
			11'b01010100xxx : OPOut = 4'b0010;
			
			// B Instruction
			11'b000101xxxxx : OPOut = 4'b0011;
			
			// BL Instruction
			11'b100101xxxxx : OPOut = 4'b0100;
			
			// BR Instruction
			11'b11010110000 : OPOut = 4'b0101;
			
			// CBZ Instruction 
			11'b10110100xxx : OPOut = 4'b0110;
			
			// LDUR Instruction
			11'b11111000010 : OPOut = 4'b0111;
			
			// STUR Instruction
			11'b11111000000 : OPOut = 4'b1000;
			
			// SUBS Instruction 
			11'b11101011000 : OPOut = 4'b1001; 
			
			default : OPOut = 4'bXXXX;
		endcase
	end

endmodule

module CtrlSgnl_testbench();
	logic [31:0] instruction;
	logic [3:0] OPOut;
	
	CtrlSgnl dut (instruction, OPOut);
	
	initial begin
		instruction <= 32'b10010001000000000000000000000000; #10
		instruction <= 32'b10101011000000000000000000000000; #10
		instruction <= 32'b01010100000000000000000000000000; #10
		instruction <= 32'b00010100000000000000000000000000; #10
		instruction <= 32'b10010100000000000000000000000000; #10
		instruction <= 32'b11010110000000000000000000000000; #10
		instruction <= 32'b10110100000000000000000000000000; #10
		instruction <= 32'b11111000010000000000000000000000; #10
		instruction <= 32'b11111000000000000000000000000000; #10
		instruction <= 32'b11101011000000000000000000000000; #10
		
		
		$Stop; 
	end

endmodule
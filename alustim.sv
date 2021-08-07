// Test bench for ALU
`timescale 1ns/10ps

// Meaning of signals in and out of the ALU:

// Flags:
// negative: whether the result output is negative if interpreted as 2's comp.
// zero: whether the result output was a 64-bit zero.
// overflow: on an add or subtract, whether the computation overflowed if the inputs are interpreted as 2's comp.
// carry_out: on an add or subtract, whether the computation produced a carry-out.

// cntrl			Operation						Notes:
// 000:			result = B						value of overflow and carry_out unimportant
// 010:			result = A + B
// 011:			result = A - B
// 100:			result = bitwise A & B		value of overflow and carry_out unimportant
// 101:			result = bitwise A | B		value of overflow and carry_out unimportant
// 110:			result = bitwise A XOR B	value of overflow and carry_out unimportant

module alustim();

	parameter delay = 10000000;

	logic		[63:0]	A, B;
	logic		[2:0]		cntrl;
	logic		[63:0]	result;
	logic					negative, zero, overflow, carry_out ;

	parameter ALU_PASS_B=3'b000, ALU_ADD=3'b010, ALU_SUBTRACT=3'b011, ALU_AND=3'b100, ALU_OR=3'b101, ALU_XOR=3'b110;
	

	alu dut (.A, .B, .cntrl, .result, .negative, .zero, .overflow, .carry_out);

	// Force %t's to print in a nice format.
	initial $timeformat(-9, 2, " ns", 10);

	integer i;
	logic [63:0] test_val;
	initial begin
		//////////////////////////////////////////////////////Pass B/////////////////////////////////////////////////////////////////
		
		$display("%t testing PASS_A operations", $time);
		cntrl = ALU_PASS_B;
		for (i=0; i<10; i++) begin
			A = $random(); B = $random();
			#(delay);
			assert(result == B && negative == B[63] && zero == (B == '0));
		end
		//////////////////////////////////////////////////////////Add/////////////////////////////////////////////////////////////////////////
		// testing general cases
		$display("%t testing addition", $time);
		cntrl = ALU_ADD;
			A = 1; B = 1;
			#(delay);
			assert(result == 2 && overflow == 0 && negative == 0 && zero == 0 && carry_out == 0);
			A = 10; B = 10; 
			#(delay);
			assert (result == 20 && overflow == 0 && negative == 0 && zero == 0 && carry_out ==0);
			#(delay);
			A = 100; B = -200;
			#(delay);
			assert (result == -100 && overflow == 0 && negative == 1 && zero == 0 && carry_out == 1);
			assert(result == -100);
			assert(overflow == 0);
			assert(negative == 1);
			assert(zero == 0);
			assert(carry_out == 0);
			A = -1000; B = 1000;
			#(delay);
			$display("result: %b,%b,%b,%b,%b", result,overflow,negative,zero,carry_out);
			#(delay);
			assert (result == 64'd0 && overflow == 0 && negative == 0 && zero == 1 && carry_out == 1 );

			A = 64'h7FFFFFFFFFFFFFFF; B = 64'h0000000000000002;
			#(delay);
			assert (result == 64'h8000000000000001 && overflow == 1 && negative == 1 && zero == 0 && carry_out == 0);
			A = 64'hFFFFFFFFFFFFFFFF; B = 64'hFFFFFFFFFFFFFFFF;
			#(delay);
			assert (result == 64'hFFFFFFFFFFFFFFFE && overflow == 0 && negative == 1 && zero == 0 && carry_out == 1);
		// test a overflow case inidivually
		// test a carry_out = 1 case inidivually
		// test a negative case individually
		// test a zero case individually
		
		/////////////////////////////////////////////////////////////SUB///////////////////////////////////////////////////////////////////////////////
		//Carryout is wrong
		$display ("%t testing SUB", $time);
		cntrl = ALU_SUBTRACT;
		
			A = 64'hFFFFFFFFFFFFFFFF; B = 64'h1111111111111111;
			#(delay);
			assert (result == 64'heeeeeeeeeeeeeeee && carry_out == 0 && overflow == 0 && negative == 1 && zero == 0); //problem with carryout, rest is fine
		 
			A = 64'h7FFFFFFFFFFFFFFF; B = 64'hFFFFFFFFFFFFFFFE;
			#(delay)
			assert (result == 64'h8000000000000001 && carry_out == 0 && overflow == 1 && negative == 1 && zero == 0);
			
			A = 100; B = 200;
			#(delay);
			assert (result == 64'hffffffffffffff9c && carry_out == 0 && overflow == 0 && negative == 1 && zero ==0);
			
			A = 64'hFFFFFFFFFFFFFFFF; B = 64'hFFFFFFFFFFFFFFFF;
			#(delay);
			assert (result == 64'h0 && carry_out == 1 && overflow == 0 && negative == 0 && zero ==1);
		/////////////////////////////////////////////////////////////AND/////////////////////////////////////////////////////////////////////////////////
		// ONLY NEED TO TEST RESULT AND NEGATIVE AND ZERO
		$display ("%t testing AND", $time);
		cntrl = ALU_AND;
		B = $random(); A = $random();
		#(delay);
		assert(negative == A[63]&B[63]);
		B = 0; A = 64'hFFFFFFFFFFFFFFFF;
		#(delay);
		assert(zero == 1);
		// NEED TO TEST RESULT AND ZERO FLAGS
		
		//////////////////////////////////////////////////////////////OR/////////////////////////////////////////////////////////////////////////
		// ONLY NEED TO TEST RESULT AND NEGATIVE AND ZERO
		$display ("%t testing OR", $time);
		cntrl = ALU_OR;
		for (i= 0; i < 10; i++) begin
			B = $random(); A = $random();
			#(delay);
			assert(negative == A[63]|B[63]);
		end 
		A = 0; B = 0;
		#(delay);
		assert(zero == 1);
		// NEED TO TEST RESULT AND ZERO FLAGS
		
		//////////////////////////////////////////////////////////////XOR/////////////////////////////////////////////////////////////////////////
		// ONLY NEED TO TEST RESULT AND NEGATIVE AND ZERO
		$display ("%t testing XOR", $time);
		cntrl = ALU_XOR;
		for (i= 0; i < 10; i++) begin
			B = $random(); A = $random();
			#(delay);
			assert(negative == A[63]^B[63]);
		end 
		A = 64'hFFFFFFFFFFFFFFFF; B = 64'hFFFFFFFFFFFFFFFF;
		#(delay);
		assert(zero == 1);
		// NEED TO TEST RESULT AND ZERO FLAGS
		
	end
endmodule

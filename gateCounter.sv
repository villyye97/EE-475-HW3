module gateCounter (LEDR, CLOCK_50, SW);

input logic SW;
input logic CLOCK_50;
output logic [3:0] LEDR;
logic [31:0] clk;


//clock_divider clock (CLOCK_50, clk);
//parameter which_clock = 20; 


gateCounterMachine gate(LEDR[3:0], CLOCK_50, SW);


endmodule

// D flip-flop act as a memory block
module DFlipFlop(q, qBar, D, clk, rst);
	
	input D, clk, rst;
	output q, qBar;
	reg q;
	not n1 (qBar, q);
	always@ (negedge rst or posedge clk)
		begin
			if(!rst)
				q = 0;
			else
				q = D;
		end

endmodule

// main counter instantantiate 4 instant of DFF and connect them together
// to create a ripple up counter
module gateCounterMachine (output [3:0] out, input clk, reset);

	wire a, b, c, d;
	
	
	
	DFlipFlop d1 (.q(out [0]), .qBar(a), .D(a), .clk(clk), .rst(reset));
	DFlipFlop d2 (.q(out [1]), .qBar(b), .D(b), .clk(a), .rst(reset));	
	DFlipFlop d3 (.q(out [2]), .qBar(c), .D(c), .clk(b), .rst(reset));
	DFlipFlop d4 (.q(out [3]), .qBar(d), .D(d), .clk(c), .rst(reset));

endmodule

// Divded the main clock down to a lower speed 
//module clock_divider(clk, divided_clock);
//
//input logic clk;
//output logic [31:0] divided_clock;
//
//initial 
//	
//	divided_clock <= 0;
//
//always_ff @(posedge clk)
//
//	divided_clock <= divided_clock + 'b1;
//
//endmodule 


module gateCounter_testbench;
	logic  [3:0]    LEDR;
	logic  SW;
	logic  clk;

	gateCounter dut (LEDR, clk, SW);
	
	parameter CLOCK_PERIOD = 100;   
		initial begin    
			clk <= 0;    
			forever #(CLOCK_PERIOD/2) clk <= ~clk;   
		end  
	
	initial begin 
		SW <= 0; @(posedge clk);
		@(posedge clk);
		@(posedge clk);
		@(posedge clk);
		@(posedge clk);
		@(posedge clk);
		@(posedge clk);
		SW <= 1; @(posedge clk);
		SW <= 0; @(posedge clk);
		@(posedge clk);
		@(posedge clk);
		@(posedge clk);
		@(posedge clk);
		@(posedge clk);
		@(posedge clk);
		@(posedge clk);
		@(posedge clk);
		@(posedge clk);
		@(posedge clk);
		@(posedge clk);
		@(posedge clk);
		@(posedge clk);
		@(posedge clk);
		@(posedge clk);
		@(posedge clk);
		
		
		

	
	$stop(); 
	end
	
endmodule 


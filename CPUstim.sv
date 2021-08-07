`timescale 1ns/10ps

module CPUstim ();
	logic reset; 
	logic clk;
	
	Single_Cycle_CPU test (.*);
	
	parameter CLOCK_PERIOD = 100;
	initial begin 
		clk <= 0;
		forever #(CLOCK_PERIOD/2) clk <= ~clk;
	end 
	integer i ;
	initial begin 
		@(posedge clk);
		reset <= 1;
		@(posedge clk);
		reset <= 0;
		for (i = 0; i <1000;i++)begin 
		@(posedge clk);
		
		end 
		@(posedge clk);
		$stop;
	end 
	
endmodule 
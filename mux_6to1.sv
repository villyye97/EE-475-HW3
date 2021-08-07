`timescale 1ns/10ps

module mux_6to1(out, din, sel);
    input logic [2:0] sel;
    input logic [5:0] din;
    output logic out;

    logic [1:0] tmp;

    mux_3to1 m0 (.out(tmp[0]), .din(din[2:0]), .sel(sel[1:0]));
    mux_3to1n m1 (.out(tmp[1]), .din(din[5:3]), .sel(sel[1:0]));

    mux_2to1 mf (.out, .din(tmp), .sel(sel[2]));
endmodule

module mux_6to1_testbench;
    logic [2:0] sel; 
    logic [5:0] din;
    logic out;

    parameter delay = 10;

    integer i;

    initial begin
        din=6'b111111; sel=3'b000; #(delay);
		  din=6'b111110; sel=3'b000; #(delay);
		  din=6'b001101; sel=3'b000; #(delay);

		  din=6'b111111; sel=3'b010; #(delay);
		  din=6'b111101; sel=3'b010; #(delay);
		  din=6'b010111; sel=3'b010; #(delay);
		  
		  din=6'b111111; sel=3'b011; #(delay);
		  din=6'b111011; sel=3'b011; #(delay);
		  din=6'b001101; sel=3'b011; #(delay);
		  
		  din=6'b111111; sel=3'b100; #(delay);
		  din=6'b110111; sel=3'b100; #(delay);
		  din=6'b011101; sel=3'b100; #(delay);
		 
		  din=6'b111111; sel=3'b101; #(delay);
		  din=6'b101111; sel=3'b101; #(delay);
		  din=6'b011011; sel=3'b101; #(delay);
		  
		  din=6'b111111; sel=3'b110; #(delay);
		  din=6'b011111; sel=3'b110; #(delay);
		  din=6'b100101; sel=3'b110; #(delay);	
		  
	
    end

    mux_6to1 dut (.out, .din, .sel);
endmodule

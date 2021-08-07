`timescale 1ns/10ps

module mux_3to1n(out, din, sel);
    input logic [1:0] sel;
    input logic [2:0] din;
    output logic out;

    logic [1:0] tmp;

    mux_2to1 m0 (.out(tmp[0]), .din(din[1:0]), .sel(sel[0]));
	 assign tmp[1] = din[2];
	 
    mux_2to1 mf (.out, .din(tmp), .sel(sel[1]));
endmodule

module mux_3to1n_testbench;
    logic [1:0] sel; 
    logic [2:0] din;
    logic out;

    parameter delay = 10;

    integer i;
    initial begin
		  
		  din=3'b111; sel=00; #(delay);
		  din=3'b110; sel=00; #(delay);
		  din=3'b011; sel=00; #(delay);
		  
		  din=3'b111; sel=01; #(delay);
		  din=3'b101; sel=01; #(delay);
		  din=3'b011; sel=01; #(delay);
		  
		  din=3'b111; sel=10; #(delay);
		  din=3'b011; sel=10; #(delay);
		  din=3'b101; sel=10; #(delay);
    end

    mux_3to1n dut (.out, .din, .sel);
endmodule
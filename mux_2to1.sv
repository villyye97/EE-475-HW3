// if sel == 1 then out = din[1] else out = din[0]
`timescale 1ns/10ps
module mux_2to1 (out, din, sel);
    input logic sel;
    input logic [1:0] din;
    output logic out;

    logic notSel, tmp0, tmp1;

    nand #0.05 n1 (tmp0, din[1], sel);
    nand #0.05 n2 (notSel, sel, sel);
    nand #0.05 n3 (tmp1, din[0], notSel);
    nand #0.05 n4 (out, tmp0, tmp1);
endmodule

module mux_2to1_testbench;
    logic [1:0] din;
	logic sel, out;

    parameter delay = 10;

    integer i;
    initial begin
        for (i = 0; i < 8; i++) begin
            {sel, din[1], din[0]} = i;
            #delay;
        end
    end

    mux_2to1 dut (.out, .din, .sel);
endmodule

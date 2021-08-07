/*
	PC Path takes in previous PC and updates the PC by outputing PCNew. 
	How much PC incr by depends on control signals and imm addresses.
*/
`timescale 1ns/10ps

module PCPath (PCAddr, unCondBr, Br_Taken, Db, Imm19, Imm26, PCNew, PC4,clk,reset,PC);
	input logic clk, reset;
	input logic [63:0] PCAddr, Db;
	input logic unCondBr;
	input logic [1:0] Br_Taken;
	input logic [18:0] Imm19;
	input logic [25:0] Imm26;
	
	output logic [63:0] PCNew, PC4, PC; 
	
	// temp variabels for address processing and path
	logic [63:0] extendedImm19, extendedImm26;
	logic [63:0] shftExtImm19, shftExtImm26, shftExtImm;
	logic [63:0] tmpPCNew, tmpPCNewAdd4, tmpPCNew2;
	
	//somewhere to put the output of the alu flags that we don't need
	logic [3:0] xflag, Xflag;
	
	//Connecting wire of PC. splitting the wire
	//logic [63:0] PC;
	//assign PC = PC;
	
	//SignExtend(Imm26<<2)
	Sign_Zero_Ext #(26) ext1(.Din(Imm26), .Sel(1'b1), .Dout(extendedImm26));
	shifter shft1(.value(extendedImm26), .direction(1'b0), .distance(6'b000010), 
					  .result(shftExtImm26));
	//SignExtend(Imm19<<2)
	Sign_Zero_Ext #(19) ext2(.Din(Imm19), .Sel(1'b1), .Dout(extendedImm19));
	shifter shft2(.value(extendedImm19), .direction(1'b0), .distance(6'b000010), 
					  .result(shftExtImm19));
	
	/* decide what to pass through depending unCondBr control signal
		unCondBr = 0 -> choose imm26 
		unCondBr = 1 -> choose imm19
	*/
	mux2_1_x #(64) m2_64(.in1(shftExtImm19), .in0(shftExtImm26), .out(shftExtImm),
						.sel(unCondBr));
	
	//PC = PC + SignExtend(Imm<<2) 
	alu alu1(.A(PC), .B(shftExtImm), .cntrl(3'b010), .result(PCNew), .negative(xflag[0]),
		 .zero(xflag[1]), .overflow(xflag[2]), .carry_out(xflag[3]));
	
	//PC = PC + 4 
	alu alu2(.A(PC), .B(64'd4), .cntrl(3'b010), .result(PC4), .negative(Xflag[0]),
		 .zero(Xflag[1]), .overflow(Xflag[2]), .carry_out(Xflag[3]));
	
	// wire out PC +4 for BR instruction 	

	
	/* control signal with Br_Taken decide whether we want pc+4, pc+SignExtend(Imm<<2) or 
		Db from regfile from instruction BR Rd
		Br_Taken = 00 or 01 -> PC = Db
		Br_Taken = 10       -> PC = PC + 4
		Br_Taken = 11       -> PC = PC + sign/zeroExtend(imm<<2)
	*/
	mux3_1_x #(64) m3_64(.in0(Db), .in1(PC4), .in2(Db), .out(PCNew), 
						.sel(Br_Taken));

	REG2 PCreg (PCAddr,PC,clk,1'b1,reset);
	/*always_ff@(posedge clk) begin 
		if (reset) 
		PC <= 64'b0;
		else 
		PC <= PCNew;
	end*/
endmodule

/*`timescale 1ns/10ps
module PCPath_testbench();
	logic [63:0] PC, Db;
	logic unCondBr;
	logic [1:0] Br_Taken;
	logic [18:0] Imm19;
	logic [25:0] Imm26;
	
	logic [63:0] PCNew;

	PCPath dut (PC, unCondBr, Br_Taken, Db, Imm19, Imm26, PCNew);
	
	integer i;
	initial begin
		PC<=64'hF; Db<=64'd1; unCondBr<=1; Br_Taken<=2'b11; Imm19<=19'hFF9999; Imm26<=26'hFF999999999;#10
																															 #10
																															 #10
																															 #10
		
		
		
		$stop; 
	end
endmodule
*/
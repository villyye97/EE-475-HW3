
`timescale 1ns/10ps
module Single_Cycle_CPU(reset,clk);

	input logic  reset;
	input logic    clk;
	
	logic [63:0]dataA,dataB,WriteData,ALUOut,PC,PCNew,PC4,Db,PCAddr;
	logic [31:0] instr;    //instruction code used for the CPU
	logic [3:0] OPID,flags,FlagReg;			//instruction ID decoded from control signal 
	logic Reg2Loc,ALUSrc,RegWrite,MemWrite,UncondBr,ConstSel,FlagEn,Reg3Loc; //muxes used in the CPU
	logic [1:0] MemToReg,Br_Taken;
	logic [18:0] Imm19;
	logic [25:0] Imm26;
	logic [8:0] Imm9;
	logic [11:0] Imm12;
	logic [4:0] Rm,Rd,Rn;
	logic [2:0] ALUOP;
	
	logic  zero,negative,overflow,carry_out;

	
	instructmem i1(PC,instr,clk);
	
	CtrlSgnl control1(instr, OPID);
	
	//REG2 PCreg(PCNew, PC , clk, 1'b1,reset);
	
	PCPath pc1(.unCondBr(UncondBr),.*);
	
	datapath dp1(clk,Reg2Loc,ALUSrc,MemToReg, RegWrite,MemWrite, ConstSel,Reg3Loc,
	ALUOP,Imm9,Imm12,Imm19,Imm26,Rn,Rd,Rm,flags,PC4,readEn);
	
	OPdecode op1(OPID, instr,flags,Imm9,Imm12,Imm19,Imm26,Rn,Rd,Rm,Reg2Loc,ALUSrc,
	MemToReg,RegWrite,MemWrite,Br_Taken,UncondBr,ConstSel,FlagEn,Reg3Loc,ALUOP,readEn);


	REG #(4) FLG(flags,FlagReg,clk,FlagEn);
	
	mux2_1_x br (.in0(PCNew),.in1(PC4),.out(PCAddr),.sel(Br_Taken));
	
	
	endmodule 


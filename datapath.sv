
`timescale 1ns/10ps

module datapath (clk,Reg2Loc,ALUSrc,MemToReg, RegWrite,MemWrite, ConstSel,Reg3Loc,ALUOP,
Imm9,Imm12,Imm19,Imm26,Rn,Rd,Rm,flags,PC4,readEn);
	input logic clk;
	input logic Reg2Loc,ALUSrc,RegWrite,MemWrite, ConstSel,Reg3Loc,readEns;
	
	input logic [1:0] MemToReg;
	input logic [63:0] PC4;
	input logic [2:0] ALUOP;
	input logic [11:0]Imm12;
	input logic [25:0]Imm26;
	input logic [18:0]Imm19;
	input logic [8:0] Imm9;
	input logic [4:0] Rn, Rd,Rm;
	
	output logic [3:0] flags;//negative,zero,overflow,carry_out
	
	logic [63:0]  dataA, dataB,WriteData,dataB1,ALUOut, read_data,constant;
	logic [4:0] tempR;
	logic [63:0] imm12;
	logic [63:0] imm9;
	
	
	Sign_Zero_Ext  #(12) cons1(Imm12,1'b1,imm12);
	Sign_Zero_Ext #(9) cons2(Imm9,1'b1,imm9);
	
	
	regfile regA(dataA, dataB,WriteData,Rn,tempR, Rd,RegWrite,clk);
	
	alu AluA(dataA, dataB1, ALUOP, ALUOut, flags[3], flags[2], flags[1], flags[0]); 
	
	datamem MEM(ALUOut,MemWrite,readEn,dataB,clk,4'b1000,read_data);
	
	mux2_1_x #(5) regtoloc(Rm,Rd,tempR,Reg2Loc);
	mux2_1_x alusource(constant,dataB,dataB1,ALUSrc);
	mux3_1_x memorytoreg (ALUOut,read_data,PC4,WriteData,MemToReg);
	//mux4_1_x memorytoreg (1,2,3,WriteData,MemToReg);

	mux2_1_x constsel(imm12,imm9,constant,ConstSel);
	
	
endmodule 

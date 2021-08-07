
`timescale 1ns/10ps

module OPdecode(OPID, instr,flags,Imm9,Imm12,Imm19,Imm26,Rn,Rd,Rm,Reg2Loc,ALUSrc,
	MemtoReg,RegWrite,MemWrite,Br_Taken,UncondBr,ConstSel,FlagEn,Reg3Loc,ALUOP,readEn);
	input logic [3:0] OPID;
	input logic [31:0] instr;
	input logic [3:0] flags;
	
	output logic [8:0] Imm9;
	output logic [11:0]Imm12;	
	output logic [18:0]Imm19;
	output logic [25:0]Imm26;

	output logic [4:0] Rn, Rd, Rm;
	output logic Reg2Loc,ALUSrc,RegWrite,MemWrite,UncondBr,ConstSel,FlagEn,Reg3Loc,readEn;
	output logic [1:0] MemtoReg, Br_Taken;
	output logic [2:0] ALUOP;
	
	
	assign enable = 1'b1;
	assign dis = 1'b0;
	
	xor x1 (flag1, flags[3],flags[2]);
	
	
	always_comb begin 
		if(OPID == 4'b0000) begin //ADDI
			Imm12 = inst r [21:10]; //register decode
			Rn = instr [9:5];
			Rd = instr [4:0];
			//mux decode
			Reg2Loc = dis;
			ALUSrc = enable;
			MemtoReg = 2'b00;
			RegWrite = enable;
			MemWrite = dis;
			Br_Taken = 2'b00;
			UncondBr = dis;
			ALUOP = 3'b010;
			ConstSel = enable;
			FlagEn = dis;
			Reg3Loc = dis;
			readEn= dis;
		end 
		else if (OPID == 4'b0001)begin //ADDS
			Rm = instr [20:16];			//Register decode
			Rn = instr [9:5];
			Rd = instr [4:0];
			//mux decode
			Reg2Loc = enable;
			ALUSrc = dis;
			MemtoReg = 2'b00;
			RegWrite = enable;
			MemWrite = dis;
			Br_Taken = 2'b00;
			UncondBr = dis;
			ALUOP = 3'b010;
			ConstSel = dis;
			FlagEn = enable;
			Reg3Loc = dis; 
			readEn= dis;

		end
		else if (OPID == 4'b0011) begin //B IMM26
			Imm26 = instr[25:0];			  //register decode 
			//Mux decode 
			Reg2Loc = dis;
			ALUSrc = dis;
			MemtoReg = 2'b00;
			RegWrite = dis;
			MemWrite = dis;
			Br_Taken = 2'b01;
			UncondBr = enable;
			ALUOP = 3'b000;
			ConstSel = dis;
			FlagEn = dis;
			Reg3Loc = dis;
			readEn= dis;

		end
		else if (OPID == 4'b0010) begin //B.LT Imm19
			Imm19 = instr[23:5];			//register decode
			//mux decode
			Reg2Loc = dis;
			ALUSrc = dis;
			MemtoReg = 2'b00;
			RegWrite = dis;
			MemWrite = dis;
			Br_Taken = {1'b0,flag1};
			UncondBr = 2'b01;
			ALUOP = 3'b000;
			ConstSel = dis;
			FlagEn = dis;
			Reg3Loc = dis;
			readEn= dis;

		end 
		else if (OPID == 4'b0100) begin //BL Imm26
			Imm26 = instr[25:0];			
			Reg2Loc = dis;
			ALUSrc = dis;
			MemtoReg = 2'b10;
			RegWrite = enable;
			MemWrite = dis;
			Br_Taken = enable;
			UncondBr = 2'b01;
			ALUOP = 3'b000;
			ConstSel = dis;
			FlagEn = dis;
			Reg3Loc = enable;
			readEn= dis;

		end 
		else if (OPID == 4'b0101) begin // BR Rd
			//mux decode
			Reg2Loc = dis;				
			ALUSrc = dis;
			MemtoReg = 2'b00;
			RegWrite = dis;
			MemWrite = dis;
			Br_Taken = 2'b10;
			UncondBr = dis;
			ALUOP = 3'b000;
			ConstSel = dis;
			FlagEn = dis;
			Reg3Loc = dis;
			readEn= dis;

			
		end 
		else if (OPID == 4'b0110) begin //CBZ Rd, Imm19
			Imm19 = instr[23:5];				//register decode
			//mux decode
			Reg2Loc = dis;
			ALUSrc = dis;
			MemtoReg = 2'b00;
			RegWrite = dis;
			MemWrite = dis;
			Br_Taken = {1'b0,flags[2]};
			UncondBr = dis;
			ALUOP = 3'b000;
			ConstSel = dis;
			FlagEn = dis;
			Reg3Loc = dis;
			readEn= dis;

		end 
		else if (OPID == 4'b0111) begin //LDUR Rd
			Imm9 = instr[20:12];				//register decode
			Rn = instr[9:5];
			Rd = instr[5:0];
			//mux decode
			Reg2Loc = dis;
			ALUSrc = enable;
			MemtoReg = 2'b01;
			RegWrite = enable;
			MemWrite = dis;
			Br_Taken = 2'b00;
			UncondBr = dis;
			ALUOP = 3'b010;
			ConstSel = dis;
			FlagEn = dis;
			Reg3Loc = dis;
			readEn= enable;

		end 
		else if (OPID == 4'b1000) begin //STUR Rd
			Imm9 = instr[20:12];			//register decode
			Rn = instr[9:5];
			Rd = instr[5:0];
			//mux decode
			Reg2Loc = dis;
			ALUSrc = enable;
			MemtoReg = 2'b00;
			RegWrite = dis;
			MemWrite = enable;
			Br_Taken = 2'b00;
			UncondBr = dis;
			ALUOP = 3'b010;
			ConstSel = dis;
			FlagEn = dis;
			Reg3Loc = dis;
			readEn= dis;

		end
		else if (OPID == 4'b1001) begin //SUBS Rd
			Rm = instr [20:16];				//register decode
			Rn = instr [9:5];
			Rd = instr [4:0];
			//mux decode
			Reg2Loc = enable;
			ALUSrc = dis;
			MemtoReg = 2'b00;
			RegWrite = enable;
			MemWrite = dis;
			Br_Taken = 2'b00;
			UncondBr = dis;
			ALUOP = 3'b011;
			ConstSel = dis;
			FlagEn = enable;
			Reg3Loc = dis;			
			readEn= dis;
			end 
		else begin 
			Rm = 0;
			Rn = 0;
			Rd = 0;
			Imm9 = 0;
			Imm12 = 0;
			Imm19 = 0;
			Imm26 = 0;
			Reg2Loc = dis;
			ALUSrc = dis;
			MemtoReg = 2'b00;
			RegWrite = dis;
			MemWrite = dis;
			Br_Taken = 2'b00;
			UncondBr = dis;
			ALUOP = 3'b000;
			ConstSel = dis;
			FlagEn = dis;
			Reg3Loc = dis;
			readEn= dis;

		end 
	end 
endmodule 
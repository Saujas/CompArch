module controller(state, opcode, PC_write, PC_write_cond, IorD, Mem_Read, Mem_Write, IR_Write, Mem_To_Reg, PC_Source, ALU_Op, ALU_srcA, ALU_srcB, Reg_Write, Reg_Dst, next_state);
	input [3:0] state;
	input [5:0] opcode;
	output [3:0] next_state;
	output PC_write, PC_write_cond, IorD, Mem_Read, Mem_Write, IR_Write, Mem_To_Reg, Reg_Dst, Reg_Write, ALU_srcA;
	output [1:0] PC_Source, ALU_Op, ALU_srcB;
	wire jmp, rf, beq, lw, sw;
	
	assign PC_write = (~state[3] & ~state[2] & ~state[1] & ~state[0]) | (state[3] & ~state[2] & ~state[1] & state[0]);
	assign PC_write_cond = (state[3] & ~state[2] & ~state[1] & ~state[0]);
	assign IorD = (~state[3] & ~state[2] & state[1] & state[0]) | (~state[3] & state[2] & ~state[1] & state[0]);
	assign Mem_Read = (~state[3] & ~state[2] & ~state[1] & ~state[0]) | (~state[3] & ~state[2] & state[1] & state[0]);
	assign Mem_Write = (~state[3] & state[2] & ~state[1] & state[0]);
	assign IR_Write = (~state[3] & ~state[2] & ~state[1] & ~state[0]);
	assign Mem_To_Reg = (~state[3] & state[2] & ~state[1] & ~state[0]);
	assign PC_Source[0] = (state[3] & ~state[2] & ~state[1] & ~state[0]);
	assign PC_Source[1] = (state[3] & ~state[2] & ~state[1] & state[0]);
	assign ALU_Op[0] = (state[3] & ~state[2] & ~state[1] & ~state[0]);
	assign ALU_Op[1] = (~state[3] & state[2] & state[1] & ~state[0]);
	assign ALU_srcB[0] = (~state[3] & ~state[2] & ~state[1] & ~state[0]) | (~state[3] & ~state[2] & ~state[1] & state[0]);
	assign ALU_srcB[1] = (~state[3] & ~state[2] & ~state[1] & state[0]) | (~state[3] & ~state[2] & state[1] & ~state[0]);
	assign ALU_srcA = (~state[3] & ~state[2] & state[1] & ~state[0]) | (~state[3] & state[2] & state[1] & ~state[0]) | (state[3] & ~state[2] & ~state[1] & ~state[0]);
	assign Reg_Write = (~state[3] & state[2] & ~state[1] & ~state[0]) | (~state[3] & state[2] & state[1] & state[0]);
	assign Reg_Dst = (~state[3] & state[2] & state[1] & state[0]);
	
	//assign next_state = 4'b0000;
	assign jmp = (~opcode[5] & ~opcode[4] & ~opcode[3] & ~opcode[2] & opcode[1] & ~opcode[0]);
	assign rf = (~opcode[5] & ~opcode[4] & ~opcode[3] & ~opcode[2] & ~opcode[1] & ~opcode[0]);
	assign beq = (~opcode[5] & ~opcode[4] & ~opcode[3] & opcode[2] & ~opcode[1] & ~opcode[0]);
	assign lw = (opcode[5] & ~opcode[4] & ~opcode[3] & ~opcode[2] & opcode[1] & opcode[0]);
	assign sw = (opcode[5] & ~opcode[4] & opcode[3] & ~opcode[2] & opcode[1] & opcode[0]);
	
	assign next_state[0] = (~state[3] & ~state[2] & ~state[1] & ~state[0]) | ((~state[3] & ~state[2] & ~state[1] & state[0])&jmp) | ((~state[3] & ~state[2] & state[1] & ~state[0])&lw) | ((~state[3] & ~state[2] & state[1] & ~state[0])&sw) | ((~state[3] & state[2] & state[1] & ~state[0])&rf);
	assign next_state[1] = ((~state[3] & ~state[2] & ~state[1] & state[0])&rf) | ((~state[3] & ~state[2] & ~state[1] & state[0])&(lw|sw)) | ((~state[3] & ~state[2] & state[1] & ~state[0])&lw) | ((~state[3] & state[2] & state[1] & ~state[0])&rf);
	assign next_state[2] = ((~state[3] & ~state[2] & ~state[1] & state[0])&rf) | ((~state[3] & ~state[2] & state[1] & ~state[0])&sw) | ((~state[3] & ~state[2] & state[1] & state[0])&lw) | ((~state[3] & state[2] & state[1] & ~state[0])&rf);
	assign next_state[3] = ((~state[3] & ~state[2] & ~state[1] & state[0])&(jmp|beq));
	
endmodule

module test;
	reg [3:0] state;
	reg [5:0] opcode;
	wire [3:0] next_state;
	wire PC_write, PC_write_cond, IorD, Mem_Read, Mem_Write, IR_Write, Mem_To_Reg, Reg_Dst, Reg_Write, ALU_srcA;
	wire [1:0] PC_Source, ALU_Op, ALU_srcB;
	
	controller c(state, opcode, PC_write, PC_write_cond, IorD, Mem_Read, Mem_Write, IR_Write, Mem_To_Reg, PC_Source, ALU_Op, ALU_srcA, ALU_srcB, Reg_Write, Reg_Dst, next_state);
	initial
		begin
			$monitor(,$time, " state=%b, next_state=%b, opcode=%b, PC_write=%b PC_write_cond=%b, IorD=%b, Mem_Read=%b, Mem_Write=%b IR_Write=%b, Mem_To_Reg=%b, PC_Source=%b, ALU_Op=%b ALU_srcA=%b, ALU_srcB=%b, Reg_Write=%b, Reg_Dst=%b", state, next_state, opcode, PC_write, PC_write_cond, IorD, Mem_Read, Mem_Write, IR_Write, Mem_To_Reg, PC_Source, ALU_Op, ALU_srcA, ALU_srcB, Reg_Write, Reg_Dst);
			#0 state = 4'b0000;
			#0 opcode = 6'b100011;
			#5 state = next_state;
			#5 state = next_state;
			#5 state = next_state;
			#5 state = next_state;
			#10 $finish;
		end
		
endmodule
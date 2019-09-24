module dff_sync(q, d, clock, reset);

	input d, reset, clock;
	output q;
	reg q;

	always @ (posedge clock)
		begin
			if(!reset) q <= 1'b0;
			else q <= d;
		end

endmodule


module reg_32bit(q,d,clk,reset);
	input [31:0] d;
	input clk, reset;
	output [31:0] q;
	genvar j;
	
	generate for (j=0; j<32;j=j+1) begin: mux_loop

		dff_sync d1(q[j], d[j], clk, reset);

	end
	endgenerate
endmodule

/*
module tb32reg;
	reg [31:0] d;
	reg clk,reset;
	wire [31:0] q;
	
	reg_32bit R(q,d,clk,reset);
	always @(clk)
		#5 clk<=~clk;
		initial
			begin
				$monitor( $time, " d=%b, clk=%b, reset=%b, q=%b", d, clk, reset, q);
				clk= 1'b1;
				reset=1'b0;//reset the register
				#5 reset=1'b1;
				#5 d=32'hAFAFAFAF;
				#5 d=32'hFAFAFAFA;
				#10 d=32'hAFAFAFAF;
				#5 d=32'hFAFAFAFA;
				#50 $finish;
			end
endmodule
*/


module mux4_1(regData,q1,q2,q3,q4,reg_no);
	input q1, q2, q3, q4;
	input [1:0] reg_no;
	output regData;
	wire sel1, sel2, not_sel1, not_sel2, n1, n2, n3, n4, a1, a2, a3, a4, o1, o2;
	assign sel1 = reg_no[1];
	assign sel2 = reg_no[0];
	not (not_sel1, sel1);
	not (not_sel2, sel2);
	and (n1, not_sel1, not_sel2);
	and (n2, not_sel1, sel2);
	and (n3, sel1, not_sel2);
	and (n4, sel1, sel2);
	and (a1, n1, q1);
	and (a2, n2, q2);
	and (a3, n3, q3);
	and (a4, n4, q4);
	or (o1, a1, a2);
	or (o2, a3, a4);
	or (regData, o1, o2);
endmodule



module bit_32_mux4_1 (regData,q1,q2,q3,q4,reg_no);
	input [31:0] q1;
	input [31:0] q2;
	input [31:0] q3;
	input [31:0] q4;
	output [31:0] regData;
	input [1:0] reg_no;
	genvar j;
	
	generate for (j=0; j<32;j=j+1) begin: mux_loop

		mux4_1 m1(regData[j], q1[j], q2[j], q3[j], q4[j], reg_no);

	end
	endgenerate
endmodule

/*
module test;
	reg [31:0] q1;
	reg [31:0] q2;
	reg [31:0] q3;
	reg [31:0] q4;
	wire [31:0] out;
	reg [1:0] reg_no;
	
	bit_32_mux4_1 R(out,q1,q2,q3,q4,reg_no);
	
	initial
		begin
			$monitor (,$time, " q1=%b, q2=%b, q3=%b q4=%b, reg_no=%b, out=%b", q1, q2, q3, q4, reg_no, out);
			#0 q1=32'hFFFFFFFF;
			#0 q2=32'h00000000;
			#0 q3=32'h0F0F0F0F;
			#0 q4=32'hF0F0F0F0;
			#10 reg_no = 2'b00;
			#10 reg_no = 2'b01;
			#10 reg_no = 2'b10;
			#10 reg_no = 2'b11;
			#100 $finish;
		end
endmodule
*/


module decoder2_4 (register,reg_no);
	input [1:0] reg_no;
	output [3:0] register;
	wire n1, n2, r1, r2;
	assign r1 = reg_no[0];
	assign r2 = reg_no[1];
	not (n1, r1);
	not (n2, r2);
	and (register[0], n1, n2);
	and (register[1], r1, n2);
	and (register[2], n1, r2);
	and (register[3], r1, r2);
	
endmodule

/*
module testbench;
	wire [3:0] register;
	reg [1:0] reg_no;
	
	decoder2_4 d1 (register, reg_no);
	
	initial
		begin
			$monitor (,$time, " reg_no=%b, register=%b", reg_no, register);
			#0 reg_no = 2'b00;
			#10 reg_no = 2'b01;
			#10 reg_no = 2'b10;
			#10 reg_no = 2'b11;
			#10 $finish;
		end
endmodule
*/


module RegFile(clk,reset,ReadReg1,ReadReg2,WriteData,WriteReg,RegWrite,ReadData1,ReadData2);
	input clk, reset, RegWrite;
	input [1:0] ReadReg1;
	input [1:0] ReadReg2;
	input [31:0] WriteData;
	output [31:0] ReadData1;
	output [31:0] ReadData2;
	input [1:0] WriteReg;
	
	wire a1;
	wire [3:0] o1;
	wire [3:0] register;
	
	wire [3:0] CLK;
	genvar j;
	
	and (a1, clk, RegWrite);
	decoder2_4 d1(register, WriteReg);
	
	generate for (j=0; j<4;j=j+1) begin: mux_loop

		and (CLK[j], a1, register[j]);

	end
	endgenerate
	
	
	wire [31:0] r1;
	wire [31:0] r2;
	wire [31:0] r3;
	wire [31:0] r4;
	wire [31:0] d0;
	/*
	assign d0 = 32'h00000000;
	
	reg_32bit rr1(r1, d0, 1, reset);
	reg_32bit rr2(r2, d0, 1, reset);
	reg_32bit rr3(r3, d0, 1, reset);
	reg_32bit rr4(r4, d0, 1, reset);
	*/
	reg_32bit rr1(r1, WriteData, CLK[0], reset);
	reg_32bit rr2(r2, WriteData, CLK[1], reset);
	reg_32bit rr3(r3, WriteData, CLK[2], reset);
	reg_32bit rr4(r4, WriteData, CLK[3], reset);
	
	bit_32_mux4_1 m1(ReadData1,r1,r2,r3,r4,ReadReg1);
	bit_32_mux4_1 m2(ReadData2,r1,r2,r3,r4,ReadReg2);
	
endmodule



module tbRegFile;
	reg clk, reset, RegWrite;
	reg [1:0] ReadReg1, ReadReg2, WriteReg;
	reg [31:0] WriteData;
	wire [31:0] ReadData1, ReadData2;
	
	RegFile rf(clk,reset,ReadReg1,ReadReg2,WriteData,WriteReg,RegWrite,ReadData1,ReadData2);
	
	initial
		begin
			$monitor($time, ": Reset = %b, RegWrite = %b, ReadReg1 = %b, ReadReg2 = %b, WriteRegNo = %b, WriteData = %b, ReadData1 = %b, ReadData2 = %b.", reset, RegWrite, ReadReg1, ReadReg2, WriteReg, WriteData, ReadData1, ReadData2);
			#0 clk = 1'b1;
			#0 reset = 1'b1;
			#0 ReadReg1 = 2'b00;
			#0 ReadReg2 = 2'b01;
			#10 RegWrite = 1'b1;  WriteData = 32'hF0F0F0F0; WriteReg = 2'b00;
			#10 RegWrite = 1'b1;  WriteData = 32'h00000000; WriteReg = 2'b01;
			#10 RegWrite = 1'b1;  WriteData = 32'h0F0F0F0F; WriteReg = 2'b10;
			#10 RegWrite = 1'b1;  WriteData = 32'hFFFFFFFF; WriteReg = 2'b11;
			#10 RegWrite = 1'b0;
			#10 ReadReg1 = 2'b00; ReadReg2 = 2'b01;
			#10 ReadReg1 = 2'b10; ReadReg2 = 2'b11;
			#10 $finish;
		end
endmodule
module mux_2_to_1(out, sel, in1, in2);
	input in1,in2,sel;
	output out;
	wire not_sel,a1,a2;
	not (not_sel,sel);
	and (a1,sel,in2);
	and (a2,not_sel,in1);
	or(out,a1,a2);
endmodule

module bit32_2to1mux(out,sel,in1,in2);
	input [31:0] in1,in2;
	output [31:0] out;
	input sel;
	genvar j;

	generate for (j=0; j<32;j=j+1) begin: mux_loop

		mux_2_to_1 m1(out[j],sel,in1[j],in2[j]);

	end
	endgenerate
endmodule


module mux_3_to_1(out, sel1, sel2, in1, in2, in3);
	input in1,in2,in3,sel1,sel2;
	output out;
	wire not_sel1, not_sel2,n1,n2,n3,a1,a2,a3,o1;
	not (not_sel1, sel1);
	not (not_sel2, sel2);
	and (n1, not_sel1, not_sel2);
	and (n2, not_sel1, sel2);
	and (n3, sel1, not_sel2);
	and (a1, n1, in1);
	and (a2, n2, in2);
	and (a3, n3, in3);
	or (o1, a1, a2);
	or (out, o1, a3);
endmodule


module bit32_3to1mux(out,sel1,sel2,in1,in2,in3);
	input [31:0] in1,in2,in3;
	output [31:0] out;
	input sel1, sel2;
	genvar j;

	generate for (j=0; j<32;j=j+1) begin: mux_loop

		mux_3_to_1 m1(out[j],sel1, sel2,in1[j],in2[j],in3[j]);

	end
	endgenerate
endmodule


/*
module tb_8bit2to1mux;
	reg [31:0] INP1, INP2, INP3;
	reg SEL1, SEL2;
	wire [31:0] out;
	bit32_3to1mux M1(out,SEL1,SEL2,INP1,INP2,INP3);
	initial
	begin
	$monitor (,$time, " inp1=%b, inp2=%b, inp3=%b s1=%b, s2=%b, out=%b", INP1, INP2, INP3, SEL1, SEL2, out);
	#0 INP1=32'b10101010101010101010101010101010;
	#0 INP2=32'b01010101010101010101010101010101;
	#0 INP3=32'b11111111111111111111111111111111;
	#0 SEL1=1'b0;
	#0 SEL2=1'b0;
	#100 SEL1=1'b0;
	#0 SEL2=1'b1;
	#200 SEL1=1'b1;
	#0 SEL2=1'b0;
	#300 SEL1=1'b1;
	#0 SEL2=1'b1;
	#1000 $finish;
	end
endmodule

*/


module bit32AND (out,in1,in2);
	input [31:0] in1,in2;
	output [31:0] out;
	assign {out}=in1 &in2;
endmodule


module bit32OR (out,in1,in2);
	input [31:0] in1,in2;
	output [31:0] out;
	assign {out}=in1 | in2;
endmodule

/*
module tb32bitand;
	reg [31:0] IN1,IN2;
	wire [31:0] OUT;
	bit32OR a1 (OUT,IN1,IN2);
	initial
	begin
		$monitor ($time, " inp1=%b, inp2=%b, out=%b", IN1, IN2, OUT);
		#0 IN1=32'hA5_A5_A5_A5;
		#0 IN2=32'h5A_5A_5A_5A;
		#400 $finish;
	end
endmodule
*/


module FA (Cout, Sum,In1,In2,Cin);
	input In1,In2;
	input Cin;
	output Cout;
	output Sum;
	assign {Cout,Sum}=In1+In2+Cin;
endmodule


module FA_32 (cout, sum, in1, in2, cin);
	input [31:0] in1, in2;
	output [31:0] sum;
	wire [32:0] c;
	output cout;
	input cin;
	assign c[0] = cin;
	genvar j;
	generate for (j=0; j<32;j=j+1) begin: mux_loop

		FA m1(c[j+1],sum[j],in1[j],in2[j],c[j]);

	end
	endgenerate
	assign cout = c[32];
endmodule


/*
module tbFA;
	reg [31:0] IN1,IN2;
	wire [31:0] OUT;
	wire cout;
	wire cin;
	assign cin = 0;
	FA_32 a1 (cout,OUT,IN1,IN2, cin);
	initial
	begin
		$monitor ($time, " inp1=%b, inp2=%b, cin=%b, sum=%b, cout=%b", IN1, IN2, cin, OUT, cout);
		#0 IN1=32'h00_00_00_01;
		#0 IN2=32'h7F_FF_FF_FF;
		#400 $finish;
	end
endmodule
*/

module invert(a,b,x);
	input [31:0] a;
	output [31:0] b;
	input x;
	genvar j;
	generate for (j=0; j<32; j=j+1) begin: loop
		xor (b[j], a[j], x);
	end
	endgenerate
endmodule

module ALU(a,b,binv, cin, op, re, cout);
	input [31:0] a;
	input [31:0] b;
	wire [31:0] c;
	input cin;
	input binv;
	input [1:0] op;
	wire [31:0] and_out;
	wire [31:0] or_out;
	wire [31:0] ar_out;
	output cout;
	output [31:0] re;
	invert m(b, c, binv);
	bit32AND a1(and_out, a, b);
	bit32OR o1(or_out, a, b);
	FA_32 f1(cout, ar_out, a, c, cin);
	
	bit32_3to1mux m1(re,op[1],op[0],and_out,or_out,ar_out);
endmodule
	
	
	
	


module tbALU;
reg Binvert, Carryin;
reg [1:0] Operation;
reg [31:0] a,b;
wire [31:0] Result;
wire CarryOut;
ALU a1 (a,b,Binvert,Carryin,Operation,Result,CarryOut);
initial
begin
$monitor($time, " inp1=%b, inp2=%b, cin=%b, op=%b, sum=%b, cout=%b", a, b, Carryin, Operation, Result, CarryOut);
a=32'ha5a5a5a5;
b=32'h5a5a5a5a;
Operation=2'b00;
Binvert=1'b0;
Carryin=1'b0; //must perform AND resulting in zero
#100 Operation=2'b01; //OR
#100 Operation=2'b10; //ADD
#100 Binvert=1'b1;//SUB
#200 $finish;
end
endmodule


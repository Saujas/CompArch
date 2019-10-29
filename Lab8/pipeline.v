module encoder(func, enc);
	input[7:0] func;
	output[2:0] enc;
	reg[2:0] enc;
	
	always @(func)
	begin
		if(func[0])
			enc = 3'b000;
		else if(func[1])
			enc = 3'b001;
		else if(func[2])
			enc = 3'b010;
		else if(func[3])
			enc = 3'b011;
		else if(func[4])
			enc = 3'b100;
		else if(func[5])
			enc = 3'b101;
		else if(func[6])
			enc = 3'b110;
		else if(func[7])
			enc = 3'b111;
	end
endmodule
	
/*
module test;
	reg [7:0] func;
	wire [2:0] enc;
	encoder e(func, enc);
	initial
		begin
			$monitor(,$time, "func=%b, enc=%b", func, enc);
			#0 func = 8'h01;
			#5 func = 8'h02;
			#5 func = 8'h04;
			#5 func = 8'h08;
			#5 func = 8'h10;
			#5 func = 8'h20;
			#5 func = 8'h40;
			#5 func = 8'h80;
			#10 $finish;
		end
endmodule
*/

module ALU(out, opcode, A, B, c);
	output[3:0] out;
	input[2:0] opcode;
	input[3:0] A;
	input[3:0] B;
	output c;
	assign {c, out} = (opcode==3'b000)? A+B:
					  (opcode==3'b001)? A-B:
					  (opcode==3'b010)? A^B:
					  (opcode==3'b011)? A|B:
					  (opcode==3'b100)? A&B:
					  (opcode==3'b101)? A~|B:
					  (opcode==3'b110)? A~&B:A~^B;
	
endmodule

/*
module test1;
	wire[3:0] out;
	reg[2:0] opcode;
	reg[3:0] A;
	reg[3:0] B;
	wire c;
	ALU a(out, opcode, A, B, c);
	initial
		begin
			$monitor(,$time, " A=%b, B=%b, opcode=%b, out=%b, c=%b", A, B, opcode, out, c);
			#0 opcode = 3'b000;
			#0 A = 4'b1001;
			#0 B = 4'b0100;
			#5 opcode = 3'b001;
			#5 opcode = 3'b010;
			#5 opcode = 3'b011;
			#5 opcode = 3'b100;
			#5 opcode = 3'b101;
			#5 opcode = 3'b110;
			#5 opcode = 3'b111;
			#10 $finish;
		end
endmodule
*/


module parity(num, out);
	input[3:0] num;
	output out;
	assign out = ~^num;
endmodule


/*
module test2;
	wire out;
	reg[3:0] num;
	parity p(num, out);
	initial
		begin
			$monitor(,$time, " num=%b, out=%b", num, out);
			#0 num = 4'b0000;
			#5 num = 4'b0001;
			#5 num = 4'b0011;
			#5 num = 4'b0111;
			#5 num = 4'b1111;
			#10 $finish;
		end
endmodule
*/


module pipeline1(clock, opcode, A, B, A_out, B_out, ctrl);
	input clock;
	input [2:0] opcode;
	output[2:0] ctrl;
	reg[2:0] ctrl;
	input [3:0] A;
	input [3:0] B;
	output [3:0] A_out;
	reg[3:0] A_out;
	output [3:0] B_out;
	reg[3:0] B_out;
	
	always @(posedge clock)
		begin
			A_out<=A;
			B_out<=B;
			ctrl<=opcode;
		end
		
endmodule
	
/*	
module test3;
	reg clock;
	reg [2:0] opcode;
	wire[2:0] ctrl;
	reg [3:0] A;
	reg [3:0] B;
	wire [3:0] A_out;
	wire [3:0] B_out;
	
	pipeline1 p(clock, opcode, A, B, A_out, B_out, ctrl);
	
	initial
		begin
			$monitor(,$time, " clock=%b, A=%b, B=%b, A_out=%b, B_out=%b, opcode=%b, ctrl=%b", clock, A, B, A_out, B_out, opcode, ctrl);
			#0 clock = 1'b0;
			#1 opcode = 3'b001;
			#1 clock = 1'b1;
			#1 A = 4'b0001;
			#1 B = 4'b0011;
			#5 clock = 1'b0;
			#5 A = 4'b0111;
			#5 B = 4'b1111;
			#5 clock = 1'b1;
			#10 $finish;
		end
endmodule
*/

	
module pipeline2(clock, num, out);
	input clock;
	input[3:0] num;
	output[3:0] out;
	reg[3:0] out;
	
	always @(posedge clock)
		begin
			out<=num;
		end
endmodule
	
module test4;
	reg clock;
	reg[3:0] num;
	wire[3:0] out;
	
	pipeline2 p(clock, num, out);
	
	initial
		begin
			$monitor(,$time, " clock=%b, num=%b, out=%b", clock,num,out);
			#0 clock = 1'b0;
			#1 num = 3'b001;
			#1 clock = 1'b1;
			#5 num = 4'b0111;
			#5 clock = 1'b0;
			#5 num = 4'b1111;
			#5 clock = 1'b1;
			#10 $finish;
		end
endmodule
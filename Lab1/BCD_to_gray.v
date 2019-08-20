module BCD_to_gray_gate(a,b);
	input [3:0]a;
	output [3:0]b;
	assign b[3] = a[3];
	xor x1(b[2], a[3], a[2]);
	xor x2(b[1], a[2], a[1]);
	xor x3(b[0], a[1], a[0]);
endmodule

module BCD_to_gray_df(a,b);
	input [3:0]a;
	output [3:0]b;
	assign b[3] = a[3];
	assign b[2] = a[3] ^ a[2];
	assign b[1] = a[2] ^ a[1];
	assign b[0] = a[1] ^ a[0];
endmodule

module testbench;
	reg [3:0]a1;
	wire [3:0]f1;
	reg [3:0]a2;
	wire [3:0]f2;
	BCD_to_gray_gate t1(a1,f1);
	BCD_to_gray_df t2(a2,f2);
	
	initial
		begin
			$monitor (,$time, " a=%4b, f=%4b", a1, f1);
			#0 a1=4'b0000; //4'b0000 is assigning 4 bit binary value to a
				repeat(15)
			#1 a1 = a1 + 4'b0001;  // repeat with increment of 0001

			$monitor (,$time, " a=%4b, f=%4b", a2, f2);
			#0 a2=4'b0000; //4'b0000 is assigning 4 bit binary value to a
				repeat(15)
			#1 a2 = a2 + 4'b0001;  // repeat with increment of 0001
			#1000 $finish;
		end
	endmodule
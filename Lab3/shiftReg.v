module shiftReg(en, in, clk, q);

	parameter n = 4;
	input en;
	input in;
	input clk;
	output [n-1:0] q;
	reg [n-1:0] q;
	
	initial
		q=4'd10;
		always @(posedge clk)
			begin
				if (en)
				q={in,q[n-1:1]};
			end
	
endmodule


module test;
	parameter n= 4;
	reg EN,in,CLK;
	wire [n-1:0] Q;
	//reg [n-1:0] Q;
	
	shiftReg r1(EN,in,CLK,Q);
	initial
		begin
			CLK=0;
		end
	always
		#2 CLK=~CLK;
	initial
		$monitor($time,"EN=%b in= %b Q=%b\n",EN,in,Q);
		initial
			begin
				in=0;EN=0;
				#4 in=1;EN=1;
				#4 in=1;EN=0;
				#4 in=0;EN=1;
				#5 $finish;
			end
			
	initial
		begin
			$dumpfile("filename.vcd");
			$dumpvars;
		end
endmodule

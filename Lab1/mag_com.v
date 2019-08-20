module mag_com_bm (a,b,f);
	input [3:0] a;
	input [3:0] b;
	output [1:0] f;
	reg [1:0] f;
	
	always @(a or b)
	begin
		if(a<b)
			begin
				assign f[0] = 1;
				assign f[1] = 0;
			end
		else if(a>b)
			begin
				assign f[0] = 0;
				assign f[1] = 1;
			end
		else
			begin
				assign f[0] = 0;
				assign f[1] = 0;
			end
	end
endmodule

module testbench;
	reg [3:0] a;
	reg [3:0] b;
	wire [1:0] f;
	
	mag_com_bm m1(a, b, f);
	
	initial
		begin
			$monitor (,$time, " a=%4b, b=%4b, f=%4b", a, b, f);
			#0 a=4'b1000;
			#2 b=4'b0010;
				repeat(15)
			#1 b = b + 4'b0001;
			#100 $finish;
		end
	endmodule
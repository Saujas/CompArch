module DECODER(d0,d1,d2,d3,d4,d5,d6,d7,x,y,z);
	
	input x,y,z;
	output d0,d1,d2,d3,d4,d5,d6,d7;
	wire x0,y0,z0;
	
	not n1(x0,x);
	not n2(y0,y);
	not n3(z0,z);
	
	and a0(d0,x0,y0,z0);
	and a1(d1,x0,y0,z);
	and a2(d2,x0,y,z0);
	and a3(d3,x0,y,z);
	and a4(d4,x,y0,z0);
	and a5(d5,x,y0,z);
	and a6(d6,x,y,z0);
	and a7(d7,x,y,z);
	
endmodule


module FADDER(s,c,x,y,z);

	input x,y,z;
	wire d0,d1,d2,d3,d4,d5,d6,d7;
	output s,c;
	
	DECODER dec(d0,d1,d2,d3,d4,d5,d6,d7,x,y,z);
	assign  s = d1 | d2 | d4 | d7,
			c = d3 | d5 | d6 | d7;
	 
endmodule


module Full8Adder(s,cout,x,y,cin);
	input [7:0] x;
	input [7:0] y;
	input cin;
	output [7:0] s;
	wire [6:0] c;
	
	FADDER f0(s[0], c[0], x[0], y[0], cin);
	FADDER f1(s[1], c[1], x[1], y[1], c[0]);
	FADDER f2(s[2], c[2], x[2], y[2], c[1]);
	FADDER f3(s[3], c[3], x[3], y[3], c[2]);
	FADDER f4(s[4], c[4], x[4], y[4], c[3]);
	FADDER f5(s[5], c[5], x[5], y[5], c[4]);
	FADDER f6(s[6], c[6], x[6], y[6], c[5]);
	FADDER f7(s[7], cout, x[7], y[7], c[6]);
	
endmodule
	


module testbench;

	reg x,y,z;
	wire s,c;
	FADDER fl(s,c,x,y,z);
	
	initial
		$monitor(,$time," x=%b,y=%b,z=%b,s=%b,c=%b",x,y,z,s,c);
		
	initial
		begin
			#0 x=1'b0;y=1'b0;z=1'b0;
			#4 x=1'b1;y=1'b0;z=1'b0;
			#4 x=1'b0;y=1'b1;z=1'b0;
			#4 x=1'b1;y=1'b1;z=1'b0;
			#4 x=1'b0;y=1'b0;z=1'b1;
			#4 x=1'b1;y=1'b0;z=1'b1;
			#4 x=1'b0;y=1'b1;z=1'b1;
			#4 x=1'b1;y=1'b1;z=1'b1;
		end
		
endmodule
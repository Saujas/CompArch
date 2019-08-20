module mux2tol_gate(a, b, s, f);
	input a, b, s;
	output f;
	wire c, d, e;
	not n1(e, s);
	and a1(c, a, s);
	and a2(d, b, e);
	or o1(f, c, d);
endmodule

module mux2tol_df(a, b, s, f);
	input a,b,s;
	output f;
	assign f = s? a:b;
endmodule


module testbench;
	reg a1,b1,s1,a2,b2,s2,a3,b3,s3;
	wire f1,f2,f3;
	
	mux2tol_gate mux_gate (a1, b1, s1, f1);
	mux2tol_df mux_df (a2, b2, s2, f2); //each call needs a different instant name
	mux2tol_gate mux_gate1 (a3, b3, s3, f3);
	
	initial  //There should be only one initial block in a module
		begin
			$monitor (,$time, " a=%b, b=%b, sssss=%b, f=%b", a1, b1, s1, f1);
			#0 a1=1'b0; //monitor outputs to screen
			#2 s1=1'b1; //one bit of value 1 assigned to a
			#5 s1=1'b0;
			#10 a1=1'b1;b1=1'b0;
			#15 s1=1'b1;
			#20 s1=1'b0;

			$monitor (,$time, " a=%b, b=%b, sss=%b, f=%b", a2, b2, s2, f2);
			#0 a2=1'b0;
			#2 s2=1'b1;
			#5 s2=1'b0;
			#10 a2=1'b1;b2=1'b0;
			#15 s2=1'b1;
			#20 s2=1'b0;

			$monitor (,$time, " a=%b, b=%b, ssssssss=%b, f=%b", a3, b3, s3, f3);
			#0 a3=1'b0;
			#2 s3=1'b1;
			#5 s3=1'b0;
			#10 a3=1'b1;b3=1'b0;
			#15 s3=1'b1;
			#20 s3=1'b0;
			#300 $finish;
		end
	endmodule

// NOTES

// Set PATH=%PATH%;C:\iverilog\bin;
	
// #0 a = 4'b0000;
//	repeat(9)  repeats following statement 9 times
// #10 a =  a + 4'b0001

// Use assign to copy value from one register to the other
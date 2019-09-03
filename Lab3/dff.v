module dff_sync(d, clear, clock, q);

	input d, clear, clock;
	output q;
	reg q;

	always @ (posedge clock)
		begin
			if(!clear) q <= 1'b0;
			else q <= d;
		end

endmodule


module dff_async(d, clear, clock, q);

	input d, clear, clock;
	output q;
	reg q;

	always @ (negedge clear or posedge clock)
		begin
			if(!clear) q <= 1'b0;
			else q <= d;
		end
		
endmodule


module testing;

	reg d, clk, rst;
	wire q;
	
	dff_async ds(d, rst, clk, q); //dff sync ds(d, rst, clk, q);
	
	always @ (posedge clk)
		begin
			$display("d=%b, clk=%b, rst=%b, q=%b\n", d, clk, rst, q);
		end
		
	initial begin
		//forever begin		
			clk=0;
			#3
			clk=1;
			#3
			clk=0;
			#3
			clk=1;
			#3
			clk=0;
			#3
			clk=1;
			#3
			clk=0;
		//end
	end
	
	initial begin
		d=0; rst=1;
		#4
		d=1; rst=0;
		#5
		d=1; rst=1;
		#3
		d=1; rst=0;
		#5
		d=1; rst=1;
	end
	
	initial
		begin
			$dumpfile("filename.vcd");
			$dumpvars;
		end
		
endmodule
			
			
			
			
			
			
			
			
			
			
			
			
			
// horizontal_counter.sv
// Purpose: Counts the horizontal 'pixels' for vga


module horizontal_counter 
	#( countMax = 799 ) 
	( input logic clk, reset,
     output logic en_vcounter,
	  output logic [15:0] hcounter
	);

	always_ff@(posedge clk) begin
		if (reset)begin 
			hcounter <= 0;
			en_vcounter <= 0;
		end
		else if (hcounter < countMax) begin // counts until 800 - vga standards
			hcounter <= hcounter + 1;
			en_vcounter <= 0;
		end
		
		else begin
			hcounter <= 0;
			en_vcounter <= 1;
		end
	end
	
endmodule

// vertical_counter.sv
// Purpose: Counts the vertical 'pixels' for vga

module vertical_counter 
	#( countMax = 524 )
	( input logic clk, reset,
     input logic en_vcounter,
	  output logic [15:0] vcounter
	);

	always_ff@(posedge clk) begin
		if (reset)
			vcounter <= 0;
		else if (en_vcounter == 1) begin
			if (vcounter < countMax) // counts until 525 - vga standards
				vcounter <= vcounter + 1;
				
			else
				vcounter <= 0;
		end
	end
	
endmodule

// horizontal_counter.sv
// Purpose: Counts the horizontal 'pixels' for vga
import vgapkg::*;

module horizontal_counter 
	#( countMax = 799 ) 
	( input logic clk,
     output logic en_vcounter,
	  output logic [15:0] hcounter = 0
	);

	always_ff@(posedge clk) begin
		if (hcounter < countMax) begin // counts until 800 - vga standards
			hcounter <= hcounter + 1;
			en_vcounter <= 0;
		end
		
		else begin
			hcounter <= 0;
			en_vcounter <= 1;
		end
	end
	
endmodule

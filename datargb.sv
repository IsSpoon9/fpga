//datargb.sv
//Purpose: turns the data into rgb signals
import vgapkg::*;

module datargb (
//	input logic clk,
//	input logic Data,
//	output logic [11:0] readData,
	input vgaIndex n_xpixel, n_ypixel,
	output vgaColour outputRGB
	);
	
	
	always_comb begin
		if(n_xpixel == 200 || n_xpixel == 300 || 
			n_ypixel == 200 || n_ypixel == 300)
			outputRGB <= 3'b010; 
		else
			outputRGB <= 3'b000;
			
		// Add more here to display more
	end
	
endmodule
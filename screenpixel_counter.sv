//screenpixel_counter.sv
// Purpose: Calculates the visible pixels for vga
import vgapkg::* ;

module screenpixel_counter(
	input logic clk,
	input vgaIndex hcount, vcount,
	input logic visible,
	output vgaIndex xpixel, ypixel
	);
	
	always_ff@(posedge clk) begin
		if (visible) begin
			ypixel <= vcount - (vgaV_back + vgaV_front);
			xpixel <= hcount - (vgaH_back + vgaH_front);
		end
		else begin
			ypixel <= '0;
			xpixel <= '0;
		end
	end
	
endmodule
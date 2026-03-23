//vgacontroller.sv
// Purpose: Controls the gpio ports based on input, sends current pixel being edited
import vgapkg::*;

module vgacontroller
  ( input logic clk,
	 input logic [2:0] inputRGB,
	 output logic [15:0] n_xpixel, n_ypixel,
    output logic [13:0] gpio
	 ) ;
	
	// Count the pixels
	logic [15:0] hcount, vcount;
	logic en_vcount;
	
	// Horizontal Count
	horizontal_counter
	hcounter(
		.clk(clk),
		.en_vcounter(en_vcount),
		.hcounter(hcount)
	);
	
	// Vertical Count
	vertical_counter
	vcounter(
		.clk(clk),
		.en_vcounter(en_vcount),
		.vcounter(vcount)
	);
	
	// Count Pixels
	assign n_xpixel = (hcount >= 143) ? (hcount - 143) : '0;
   assign n_ypixel = (vcount >= 35) ? (vcount - 35) : '0;
	
	// Set the sync pulses
	logic hsync, vsync;
	assign hsync = (hcount < 96) ? 1'b1 : 0;
	assign vsync = (vcount < 2) ? 1'b1 : 0;
	
	// Is the count ready for colour input
	logic visible;
	assign visible = (hcount < (784) && hcount > (143) 
						&& vcount < (515) && vcount > (35));	 
	
	// Assign colour
	logic[3:0] r, g, b; //VGA Red, Green, Blue
	assign r = visible ? {4{inputRGB[0]}} : '0;
	assign g = visible ? {4{inputRGB[1]}} : '0;
	assign b = visible ? {4{inputRGB[2]}} : '0;
	
	// Assign to GPIO
	assign gpio[0]  = hsync;
	assign gpio[1]  = vsync;
	assign gpio[5:2]  = r;
	assign gpio[9:6]  = g;
	assign gpio[13:10] = b;
		 
endmodule                                                         

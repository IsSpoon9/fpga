//vgacontroller.sv
// By: Ethan Siemens
// Purpose: Controls the gpio ports based on input, sends current pixel being edited

module vgacontroller
  ( input logic clk, reset,
	 input logic [2:0] inputRGB,
	 output logic [9:0] xpixel, ypixel,
    output logic [13:0] gpio,
	 output  logic vsync, hsync
	 ) ;
	
	// Logic
	logic [15:0] hcount, vcount;
	logic en_vcount;
	logic visible;
	logic[3:0] r, g, b; //VGA Red, Green, Blue
	
	// Count the pixels
	// Horizontal Count
	horizontal_counter
	hcounter(
		.clk(clk),
		.reset(reset),
		.en_vcounter(en_vcount),
		.hcounter(hcount)
	);
	
	// Vertical Count
	vertical_counter
	vcounter(
		.clk(clk),
		.reset(reset),
		.en_vcounter(en_vcount),
		.vcounter(vcount)
	);
	
	// Count Pixels
	assign xpixel = (hcount > 143) ? (hcount - 143) : '0;
   assign ypixel = (vcount > 35) ? (vcount - 35) : '0;
	
	// Set the sync pulses
	assign hsync = (hcount < 96) ? 1'b1 : 0;
	assign vsync = (vcount < 2) ? 1'b1 : 0;
	
	// Is the count ready for colour input
	assign visible = (hcount < (784) && hcount > (143) 
						&& vcount < (515) && vcount > (35));	 
	
	// Assign colour
	assign r = visible ? {4{inputRGB[2]}} : '0;
	assign g = visible ? {4{inputRGB[1]}} : '0;
	assign b = visible ? {4{inputRGB[0]}} : '0;
	
	// Assign to GPIO
	assign gpio[0]  = hsync;
	assign gpio[1]  = vsync;
	assign gpio[5:2]  = r;
	assign gpio[9:6]  = g;
	assign gpio[13:10] = b;
		 
endmodule                                                         

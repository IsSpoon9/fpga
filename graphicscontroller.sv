// graphicscontroller.sv
// Purpose: Turns oscillscope data into vga display
import vgapkg::*;

module graphicscontroller 
	( input logic clk,
//	  input logic data,
	  output logic [13:0] gpio
	  );
	
	// Clock divide for vga
	logic clkvga;
	clkdiv #(.fin(50_000_000), .fout(25_000_000)) 
	c0(
		.clkin(clk), 
		.clkout(clkvga)
	);
	
	// Connection wires
	logic [2:0] rgb;
	logic [15:0] xpixel, ypixel;
	
	// Convert data to rgb
	datargb 
	rgb0(
		//.clk(clkvga),
		.n_xpixel(xpixel),
		.n_ypixel(ypixel),
		.outputRGB(rgb)
	);
	
	// Convert rgb to gpio output
	vgacontroller 
	vga_c0(
		.clk(clkvga),
		.inputRGB(rgb),
		.n_xpixel(xpixel),
		.n_ypixel(ypixel),
		.gpio(gpio)
	);
	
endmodule
	  
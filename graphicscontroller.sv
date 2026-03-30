// graphicscontroller.sv
// Purpose: Turns oscillscope data into vga display

module graphicscontroller 
	( input logic clk, reset,
	  input logic [11:0] data,
	  input logic [7:0] trigger_index,
	  output logic [7:0] read_adr,
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
		.data(data),
		.read_adr(read_adr),
		.trigger_index(trigger_index),
		.xpixel(xpixel),
		.ypixel(ypixel),
		.outputRGB(rgb)
	);
	
	// Convert rgb to gpio output
	vgacontroller 
	vga_c0(
		.clk(clkvga),
		.reset(reset),
		.inputRGB(rgb),
		.xpixel(xpixel),
		.ypixel(ypixel),
		.gpio(gpio)
	);
	
endmodule
	  
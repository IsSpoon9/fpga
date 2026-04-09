// fpga-oscilliscope.sv

module oscilliscope_top (
		input logic clk50, s1, s2, // clk, Reset, Trigger
		//Encoders
		input  logic enc1a, enc1b,// Encoder #1 (trigger level)
		input  logic enc2a, enc2b, // Encoder #2 (timebase) 
		//VGA
		output logic [15:0] GPIO_0,
		input logic [1:0] KEY,
		// ADC
		input  logic ADC_SDO,
		output logic ADC_CONVST, ADC_SDI, ADC_SCK 
	) ;
	 
	localparam SYS_CLK = 50_000_000;
	
	localparam DATA_WIDTH = 12; 
	localparam ADDR_WIDTH = 8;
	
	
	// Logic Values  ----------------------------------------------
	
	// Buttons
	logic reset, trigger; 
	
	// ADC
	logic [DATA_WIDTH-1:0] adc_data;
	
	// Input_Control
	logic [DATA_WIDTH-1:0] trig_level;
	logic [1:0] trig_mode;
	logic [DATA_WIDTH-1:0] timebase_sel; // Can change
	logic [1:0] scale_level;
	
	// Trigger
	logic trigger_fire;
	
	// Timebase Module //Can Change
	logic sample_tick;
	
	// Circular Buffer
	logic [DATA_WIDTH-1:0] buffer_data;
	logic [ADDR_WIDTH-1:0] read_addr;
	
	// Waveform Renderer
	logic [2:0] rgb;
	logic [9:0] xpixel, ypixel;
	logic rendering;
	
	
	// CLOCKS & COUNTERS ----------------------------------------------
	
	// Encoder Clock -> 1kHz
	logic clk1; 
	clkdiv 
	c_1k(
		.clkin(clk50), 
		.clkout(clk1)
	);
	
	// VGA Clock
	logic clkvga;
	clkdiv #(.fin(SYS_CLK), .fout(25_000_000)) 
	c_vga(
		.clkin(clk50), 
		.clkout(clkvga)
	);
	
	// Write address counter
	logic [ADDR_WIDTH-1:0] write_addr, write_addr_sync;
	always_ff @(posedge clk50) begin
		if (reset)
			write_addr <= 0;

		else if (trigger_fire)
			write_addr <= 0;

		else if (sample_tick)
			write_addr <= write_addr + 1;
	end
	
	always_ff @(posedge clkvga)
		write_addr_sync <= write_addr;
	
	// INPUTS ----------------------------------------------
	
	// Button Inversions
	assign reset = !s1;
	assign trigger = !s2;

	// ADC
	ltc2308 
	ltc2308_0 (
		.clk(clk50),
      .reset(reset),
      .sdo(ADC_SDO),
      .convst(ADC_CONVST),
      .sdi(ADC_SDI),
      .sck(ADC_SCK),
		.sample_out(adc_data),
		.adc_ready()
	);
	
	// Rotary Logic
	input_control #(.DATA_WIDTH(DATA_WIDTH), .ADDR_WIDTH(ADDR_WIDTH)) 
	input_0(
		.clk(clk1),
		.reset(reset),
		.trigger(trigger),
		.enc1a(enc1a), .enc1b(enc1b),// Encoder #1 (trigger level)
		.enc2a(enc2a),	.enc2b(enc2b), // Encoder #2 (timebase) 
		.scale(KEY[1]),
		.trig_level(trig_level),
		.trig_mode(trig_mode),
		.timebase_sel(timebase_sel),
		.scale_level(scale_level)
	);
	
	// Computation ------------------------------------------

	// Trigger
	trigger #(.DATA_WIDTH(DATA_WIDTH), .ADDR_WIDTH(ADDR_WIDTH)) 
	trig_0(
		.clk(clk50),
		.reset(reset),
		.data_in(adc_data),
		.trig_level(trig_level),
		.trig_mode(trig_mode),
		.trigger_edge(trigger_fire)
	);
	
	// Timebase module
	timebase
	time_0(
		.clk(clk50),
		.reset(reset),
		.timebase_sel(timebase_sel),
		.sample_tick(sample_tick)
	);
	
	
	// Stored values ----------------------------------------------------
	// if all else fails
//	circularBuffer #(.DATA_WIDTH(DATA_WIDTH), .ADDR_WIDTH(ADDR_WIDTH)) 
//	cb_0 (
//		.clkin(clk50),
//		.clkout(clkvga),
//		.reset(reset),
//		//Write Logic
//		.write_en(sample_tick),
//		.write_addr(write_addr),
//		.data_in(adc_data),
//		
//		//Read Logic
//		.read_en(rendering),
//		.read_addr(read_addr),
//		.data_out(buffer_data)
//	);

	// Altera Config -> Dual Port RAM
	dual_port_ram
	dp_0 (
		.data(adc_data),
		.rdaddress(read_addr),
		.rdclock(clkvga),
		.wraddress(write_addr_sync),
		.wrclock(clk50),
		.wren(sample_tick),
		.q(buffer_data)
		
	);
	
	// Display ----------------------------------------------------
	
	// Renders the Waveform
	waveform_renderer 
	wve0(
		// Essential
		.clk(clkvga),
		.xpixel(xpixel),
		.ypixel(ypixel),
		.data_in(buffer_data),
		.write_addr(write_addr_sync),
		.outputRGB(rgb),
		.read_addr(read_addr),
		// Non Essential
		.trig_level(trig_level),
		.trig_mode(trig_mode),
		.time_scale(timebase_sel),
		.scale_level(scale_level)
	);
	
	// Controls VGA Port - does the actual displaying
	vgacontroller 
	vga0(
		.clk(clkvga),
		.reset(reset),
		.inputRGB(rgb),
		.vsync(vsync), // Hide?
		.hsync(hsync), // Hide?
		.xpixel(xpixel),
		.ypixel(ypixel),
		.gpio(GPIO_0)
	);
	
endmodule                                                         



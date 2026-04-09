// waveform_renderer.sv
// By: Ethan Siemens

module waveform_renderer 
#( DATA_WIDTH = 12, ADDR_WIDTH = 8 )
(  // Essentials
	input logic clk, // VGA Clock
   input logic [9:0] xpixel, // Where is X pixel
	input logic [9:0] ypixel, // Where is y pixel
	input logic [DATA_WIDTH-1:0] data_in,
	input logic [ADDR_WIDTH-1:0] write_addr,
	output logic [2:0] outputRGB,
	output logic [ADDR_WIDTH-1:0] read_addr,
	
	// Extras
	input logic [DATA_WIDTH-1:0] trig_level,
	input logic [1:0] trig_mode,
	input logic [DATA_WIDTH-1:0] time_scale,
	input logic [1:0] scale_level
   
);
	 
	// Params ----------------------------------------------------

	// For Screen
	localparam X_LEFT  = 192; // 256 pixels wide (Time Axis)
	localparam X_RIGHT = 448; 
	localparam Y_TOP   = 140; 
	localparam Y_BOT   = 340; // 200 pixels tall (Voltage Axis)

	// For Scaling
	localparam VIN_MAX = 4024;
	localparam VIN_MIN = 0;
	function logic [9:0] scale (logic [DATA_WIDTH-1:0] data);
	   logic [20:0] temp;
		temp = (data - VIN_MIN)*scale_level;
		temp = temp *(Y_BOT - Y_TOP);
		temp = temp / (VIN_MAX - VIN_MIN);
		scale = Y_BOT - temp;
	endfunction

	// Other
	typedef enum {RISING = 0, FALLING = 1, LEVEL = 2, ALWAYS = 3} state_trig ;
	
	// Logic
	// Point of no return ----------------------------------------------------
	logic [DATA_WIDTH-1:0] sample;
	logic [9:0] scaled_volt, scaled_trig;
	logic [ADDR_WIDTH-1:0] base_sync;

	// sync data
	always_ff @(posedge clk) begin
		 sample <= data_in;
		 
		 if (xpixel == 0 && ypixel == 0) // start of frame
			base_sync <= write_addr;
			
	end

	always_comb begin
		
		// Default values -> For Comb Logic
		outputRGB = 3'b000;
		read_addr   = '0;
		scaled_volt = '0;
		scaled_trig = scale(trig_level);
	

		// Only compute inside scope region
		if (xpixel >= X_LEFT && xpixel < X_RIGHT) begin
			read_addr = base_sync - (X_RIGHT - xpixel);
			scaled_volt = scale(sample);
		end

		// ---------------- Draw Border
		if ((xpixel == X_LEFT || xpixel == X_RIGHT) &&
			(ypixel >= Y_TOP && ypixel <= Y_BOT))
			outputRGB = 3'b111;

		else if ((ypixel == Y_TOP || ypixel == Y_BOT) &&
			(xpixel >= X_LEFT && xpixel <= X_RIGHT))
			outputRGB = 3'b111;

		// ---------------- Trigger Line
		if ((xpixel >= (X_LEFT - 20) && xpixel < X_LEFT) &&
			(ypixel == scaled_trig || ypixel == scaled_trig - 1)) begin
			
			case (trig_mode)
				RISING: outputRGB = 3'b010;  // Rising (Green)
				FALLING: outputRGB = 3'b100; // Falling (Red)
				LEVEL: outputRGB = 3'b110;   // Level (Yellow)
				default: outputRGB = 3'b001; // Free run (Blue)
			endcase
		end

		// ---------------- Waveform
		if ((xpixel > X_LEFT && xpixel < X_RIGHT && ypixel > Y_TOP && ypixel < Y_BOT) &&
			(ypixel == scaled_volt || ypixel == scaled_volt - 1))
			outputRGB = 3'b010; // waveform line -> Green
	end
 
endmodule
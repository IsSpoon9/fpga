// input_control.sv
// Tanvir Kaur - 02-28-26
// This modules enable the user interface

// idea:
// trig levels are different states that will go from one state to another
// the system will be in rising egde trigger mode by default
// on pressing boosterpack switch the system will go to falling edge mode
// one of the rotary encoder will be used to adjust the trigger level for level triggered mode
// second rotary encoder will be used to adjust the timebase, the number of samples displayed
// second boosterpack switch will reset both the trigger and timebase 

module input_control 
#( DATA_WIDTH = 12, ADDR_WIDTH = 8 )
(  input logic clk, // 1kHz Clock
	input logic reset, // Reset Button
	input logic trigger, // Trigger Button
   input logic enc1a, enc1b,// Encoder #1 (trigger level)
   input logic enc2a, enc2b, // Encoder #2 (timebase) 

   // Outputs to oscilloscope
	output logic [DATA_WIDTH-1:0] trig_level, // Trigger Level
   output logic [1:0] trig_mode, // Trigger Mode
   output logic [DATA_WIDTH-1:0] timebase_sel // Timebase
);

	// PARAMETERS TO BE CHANGED
	localparam DEFAULT_LEVEL    = 12'd0;    
	localparam DEFAULT_TIMEBASE = 12'd0;    
	localparam DEFAULT_MODE     = 2'b0;     

	localparam MAX_TRIGGER = 12'd4000;
	localparam MIN_TRIGGER = 12'd0;
	localparam TRIG_SCALE = 12'd10;

	localparam MAX_TIME = 12'd32;
	localparam MIN_TIME = 12'd0;
	localparam TIME_SCALE = 12'd1;

	// Encoder Detection
	logic level_up, level_dn;
	logic time_up, time_dn;

	// Trigger Level Encoder
	rotary_encoder 
	level_enc (
		.clk(clk),
		.reset(reset),
		.enca(enc1a),
		.encb(enc1b),
		.down(level_dn),
		.up(level_up)
	);   

	// Time Scaling Encoder
	rotary_encoder 
	time_enc (
		.clk(clk),
		.reset(reset),
		.enca(enc2a),
		.encb(enc2b),
		.down(time_dn),
		.up(time_up)
	);	

	
	// Button Debounce
	logic trigger_p; //Trigger Button Pressed
	button
	trigger_button (
		.clk(clk),
		.reset(reset),
		.button(trigger),
		.pressed(trigger_p)
	);

	// Registers
	always_ff @(posedge clk) begin
	
		// Reset back to defaults
		if (reset) begin
			trig_mode <= DEFAULT_MODE;
			trig_level <= DEFAULT_LEVEL;
			timebase_sel   <= DEFAULT_TIMEBASE;
		end 

		else begin
		
		// Run through trigger modes
		if (trigger_p)
			trig_mode <= trig_mode + 1'b1;

		// Adjust trigger level
		if(level_up)
			trig_level <= (trig_level < MAX_TRIGGER) ? trig_level + TRIG_SCALE : trig_level;
		else if (level_dn)
			trig_level <= (trig_level > MIN_TRIGGER) ? trig_level - TRIG_SCALE : trig_level;

		// Adjust timebase
		if(time_up)
			timebase_sel <= (timebase_sel < MAX_TIME) ? timebase_sel + TIME_SCALE : timebase_sel;
		else if (time_dn)
			timebase_sel <= (timebase_sel > MIN_TIME) ? timebase_sel - TIME_SCALE : timebase_sel;
		end
	end

endmodule
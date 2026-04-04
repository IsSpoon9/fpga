// trigger.sv
// Tanvir Kaur - Feb 28, 2026

// This module will detect rising, falling, or level trigger events by comparing the current
// ADC sample to the previous sample and the user‑selected trigger level.
// This module is controlled by the control.sv 

module trigger 
#( DATA_WIDTH = 12, ADDR_WIDTH = 8 )
(
	input logic clk, // System Clock
	input logic reset, // Reset
	input logic [DATA_WIDTH-1:0] data_in,   // Incoming Data
	input logic [DATA_WIDTH-1:0] trig_level,// User Decided Trigger Level
	input logic [1:0]  trig_mode, // User Decided Trigger Mode
	output logic trigger_edge // Did the Trigger Fire?
);

	typedef enum {RISING = 0, FALLING = 1, LEVEL = 2, ALWAYS = 3} state_trig ;

	logic [DATA_WIDTH-1:0] prev_data;
	logic condition_met;
	logic trigger_fire;

	always_ff @(posedge clk) begin
		
		// Reset the previous data
		if (reset)
			prev_data <= '0; 

		// No Reset
		else begin

		// Store Data
		prev_data <= data_in;

		// Testing Modes
		case (trig_mode)
			RISING:    condition_met <= (data_in >= trig_level && prev_data < trig_level);  // Rising Edge
			FALLING:   condition_met <= (data_in <= trig_level && prev_data > trig_level);  // Falling Edge
			LEVEL:     condition_met <= (data_in == trig_level && prev_data == trig_level); // Level
			default:   condition_met <= 1; 															  // Always fire trigger
		endcase

		// Set trigger level
		trigger_fire <= condition_met ? 1 : 0;

		end
	end
	
	// Get the edge of trigger
	logic trigger_prev;

	always_ff @(posedge clk) begin
		 trigger_prev <= trigger_fire;
	end

	assign trigger_edge = trigger_fire & ~trigger_prev;
	
	
endmodule
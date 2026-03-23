// trigger.sv
// Tanvir Kaur - Feb 28, 2026

// This module will detect rising, falling, or level trigger events by comparing the current
// ADC sample to the previous sample and the user‑selected trigger level.
// This module is controlled by the control.sv 

module trigger (
    input  logic        clk,
    input  logic [11:0] sample_in,   // sample coming from fifo
    input  logic [11:0] trig_level,  // would be connected to the count value
    input  logic [1:0]  trig_mode,   // 00=rising, 01=falling, 10=level, 11=nothing
    input  logic        enable,
    output logic        trigger_fire  // goes to the VGA renderer
);

	    logic [11:0] prev_sample;
		 logic condition_true;   // indicates if any trigger event has happened or not
	
		 // stores previous sample
		 always_ff @(posedge clk) begin
			  prev_sample <= sample_in;
		 end
	
		 // trigger condition logic
		 always_comb begin
			  case (trig_mode)
					2'b00: condition_true = (prev_sample < trig_level) && (sample_in >= trig_level); // rising
					2'b01: condition_true = (prev_sample > trig_level) && (sample_in <= trig_level); // falling
					2'b10: condition_true = (sample_in == trig_level);                               // level
					default: condition_true = 1'b0;                                                  // off
			  endcase
		 end
	
		 // trigger pulse
		 always_ff @(posedge clk) begin
			  if (!enable)
					trigger_fire <= 1'b0;
			  else
					trigger_fire <= condition_true;  // this trigger_fire will tell the VGA waveform renderer to start drawing
					                                // at the index indicated by the circular buffer 
		 end
	
endmodule


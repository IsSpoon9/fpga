// timebase.sv

module timebase 
(   input  logic clk,             // system clock
    input  logic reset,             // reset
    input  logic [11:0] timebase_sel,  // User Input
    output logic sample_tick       // pulse to move capture/read pointer
);

	logic [32:0] counter;
   logic [32:0] divider;

	// Assign divisions based on User input
	assign divider = (1 << timebase_sel);
	
	always_ff @(posedge clk) begin
		
		// Reset counts
		if(reset) begin
			counter <= '0;
			sample_tick <= 0;
		end
		
		// Count for pulse
		else begin
			
			// Reset if count too high 
			if(counter >= divider -1) begin
				counter <= '0;
				sample_tick <= 1;
			end
			
			// Just keep countin
			else begin
				counter <= counter + 1'd1;
				sample_tick <= 0;
			end
		end
	end

endmodule
// button.sv
// debounce button

module button (
	input logic clk, reset, button,
	output logic pressed
	);
	
	logic button_prev;
	
	always_ff @(posedge clk) begin
		
		if(reset) begin
			button_prev <= 0;
			pressed <= 0;
		end
		else begin
			button_prev <= button;
			if(button && !button_prev) // rising edge of button
				pressed <= 1;
			else
				pressed <= 0;
		end
	
	end
	
	
endmodule
	
	
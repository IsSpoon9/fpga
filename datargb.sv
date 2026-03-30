//datargb.sv
//Purpose: turns the data into rgb signals

module datargb (
   input logic [11:0] data,
	output logic [7:0] read_adr, 
	input logic [7:0] trigger_index,
	input logic [15:0] xpixel, ypixel,
	output logic [2:0] outputRGB
	);

	
	logic [7:0] data_height;
		
	always_comb begin
	   outputRGB  = 3'b000;
		read_adr   = 0;
		data_height = 0;
		
		if(xpixel >= 145 && xpixel <= 400 ) begin
			read_adr = trigger_index + (xpixel[7:0] - 8'd145);
			data_height = (data*200/4095 + 200);
			
			if (ypixel == data_height || ypixel == data_height + 1)
				outputRGB = 3'b001; 
			
			else if(ypixel >= 200 && ypixel <= 400)
				outputRGB = 3'b101; 
		end
		
		// Add more here to display more
	end
	
endmodule
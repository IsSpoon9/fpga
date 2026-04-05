// circularBuffer.sv
// Purpose: Stores Values for the oscilliscope
// Ethan Siemens 03-31-26

module circularBuffer
#( DATA_WIDTH = 12, ADDR_WIDTH = 8 )
(	input logic clkin, // System Clock
	input logic clkout, // Vga Clock
	input logic reset, // Reset Button

	input logic write_en, // When to write
	input logic [ADDR_WIDTH-1:0] write_addr, // Where to write
	input logic [ADDR_WIDTH-1:0] read_addr, // Where to read

	input logic [DATA_WIDTH-1:0] data_in, // Sample in
	output logic [DATA_WIDTH-1:0] data_out // Sample out
);
	
	// BEHOLD, THE OSCILLISCOPE STORAGE
	logic [DATA_WIDTH-1:0] mem[0:2**ADDR_WIDTH-1]; 

	always_ff @(posedge clkin) begin
		
		// Reset Storage
		if(reset) begin 
			for (int i = 0; i < 2**ADDR_WIDTH; i++)
				mem[i] <= 0;
		end
		
		// Write Values
		else if (write_en) 
			mem[write_addr] <= data_in;
			
	end
	
	always_ff @(posedge clkout)
		data_out <= mem[read_addr];
	  
endmodule
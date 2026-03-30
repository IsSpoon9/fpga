// circularBuffer.sv
// Ethan Siemens 2026-3-1

module circularBuffer
   ( input logic clk, reset,  // 80 MHz (12.5ns) clock and reset
     input logic [11:0] data_in, 
     input logic write_en,
	  input logic [7:0] read_adr,
	  
	  output logic [11:0] data_out,
	  output logic [7:0] write_ptr
     ) ;
	  
	
	logic [11:0] mem[255:0];
		
	always_ff @(posedge clk) begin
		if(reset) begin
			write_ptr <= 0;
			for (int i = 0; i < 256; i++)
				mem[i] <= 0;
		end
		
		else if(write_en) begin
			mem[write_ptr] <= data_in;
			write_ptr <= write_ptr + 1;
		end
	end
	
	assign data_out = mem[read_adr];
	  
	  
endmodule
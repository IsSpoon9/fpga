// circularBuffer.sv
// Ethan Siemens 2026-3-1

module circularBuffer
   ( input logic clk, reset,  // 80 MHz (12.5ns) clock and reset
	
     input logic [15:0] data_in, 
     input logic write_en,
	  
	  input logic [7:0] read_adr,
	  output logic [15:0] data_out
     ) ;
	  
	logic [7:0] write_ptr;
	logic [15:0] mem[255:0];
		
	always_ff @(posedge clk) begin
		if(reset)
			write_ptr <= 0;
		
		if(write_en) begin
			mem[write_ptr] <= data_in;
			write_ptr <= write_ptr + 1'b1;
		end
	end
	
	assign data_out = mem[read_adr];
	  
	  
endmodule
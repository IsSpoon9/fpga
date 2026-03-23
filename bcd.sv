//bcd.sv
//Tanvir Kaur
// This is a single digit BCD Counter

module bcd
 ( input logic clk,
   input logic reset_n,
	input logic up, down,
	output logic [3:0] n,
	output logic carry, borrow
 );
 
  // Internal signals
  logic [3:0] next_n;
 
  // Carry when 9 -> 0, incrementing
  assign carry = up && (n == 4'd9);
  
  // Borrow when 0 -> 9, decrementing
  assign borrow = down && (n == 4'd0);
  
  // Single digit counter 
  // always_ff @(posedge clk)
  assign next_n = up ? ((n == 4'd9) ? 4'd0 : ( n + 4'd1)):
              down ? ((n == 4'd0) ? 4'd9 : ( n - 4'd1)):
				  n;
				  
  // For Register with reset
    always_ff @(posedge clk) 
	   n <= !reset_n ? 4'd0 : next_n;
		 //phase <= !reset_n ? 17'd0 : phase + {counter, 16'd0};
		
endmodule 
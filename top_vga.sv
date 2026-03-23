// top_vga.sv
import vgapkg::* ;

module top_vga 
  ( input logic clk50,
    output logic [13:0] GPIO_0
	 ) ;
   
	graphicscontroller graphics0 (
		.clk(clk50),
		//.data('0),
		.gpio(GPIO_0)
	);
	
endmodule                                                         

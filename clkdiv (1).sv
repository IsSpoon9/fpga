module clkdiv
  #( fin = 50_000_000, fout = 1000 )
   ( input logic clkin, 
     output logic clkout );

   localparam divider = fin / fout / 2 - 1 ;
   
   logic [$clog2(divider):0] count ;

   always_ff @(posedge clkin) 
     count <= !count ? $bits(count)'(divider) : count - 1'b1 ;

   always_ff @(posedge clkin) 
     clkout <= count ? clkout : ~clkout ;
   
endmodule


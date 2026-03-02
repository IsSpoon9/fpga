// ltc2308.sv - LTC 2308 ADC interface
// Ed Casas 2026-2-1

// FIXME: add your name and date here
// Ethan Siemens
// 2026, Feb 06

// Interface from LTC 2308 500 kHz (2us) 8-channel ADC to Avalon MM
// bus.  Configures the ADC as single-ended unipolar which is how it's
// connected on the DE0-Nano-SoC FPGA board.

// This interface reads sequentially from channels between 'firstch'
// and 'lastch' which are configured by writing a 6-bit value in
// format ({lastch,firstch}). The sample values read from the ADC are
// read as 16-bit values with the channel number in the upper nybble.
// If no data available, the value 16'h8000 is read. Samples are taken
// continuously at 2us per sample.

module ltc2308
   ( input logic clk, reset,    // 80 MHz (12.5ns) clock and reset
     input logic sdo,           // serial data from ADC

     output logic convst, sck, sdi, // ADC control

     output logic [31:0] readdata, // Avalon MM data bus
     input logic [31:0] writedata,
     input logic read, write
     ) ;

   // ADC states and state duration counter
   
   typedef enum { start, convert, transfer, acquire } state_t ;
   
   state_t state, state_next ;

   logic [6:0] count, count_next ;

`define set_next(s,c) begin state_next=(s); count_next=$bits(count)'(c)-1'b1; end

   always_comb begin

      if ( reset )
         `set_next ( start, 2 )
      else if ( count )
         `set_next ( state, count )
      else 
         case(state)
            start: `set_next ( convert, 126 ) 
            convert: `set_next ( transfer, 24 ) 
            transfer: `set_next ( acquire, 8 ) 
            acquire: `set_next ( start, 2 )
         endcase
   end
   
   always_ff @(posedge clk) begin
      state <= state_next ;
      count <= count_next ;
   end

   // ADC control signals

   always_ff @(posedge clk) begin 
      convst <= state_next == start ;
      sck <= state_next == transfer && !count_next[0] ;
   end

   // The first/last ADC input multiplexer channels, channel sent to
   // ADC (incremented at end of conversion), configured channel is
   // saved in 'prevch'

   logic [2:0] firstch, lastch, ch, prevch ;

   // Increment the ADC input channel, starting at 'firstch' and
   // wrapping around when it reaches 'lastch'.

   always_ff @(posedge clk) begin
      if ( reset ) begin
         ch <= firstch ;
         prevch <= firstch ;
      end else if ( state == convert && !count_next ) begin
         ch <= ch == lastch ? firstch : ch + 1'b1 ;
         prevch <= ch ;
      end
   end

   // ADC configuration on SDI

   logic [11:0] adccfg ;
   assign adccfg = { 1'b1, ch[0], ch[2:1], 2'b10, 6'b0 }  ;

   always_ff @(posedge clk)
      sdi <= state_next == transfer ? adccfg[count_next >> 1] : '0 ;

   // ADC data on SDO

   logic [11:0] sample ;
   always_ff @(posedge clk)
      sample <= state == transfer && !sck ? { sample[10:0], sdo } : sample ;

   // A CPU write over the Avalon MM bus sets the first and last
   // channels to be sampled.

   always_ff @(posedge clk)
      if ( write )
         { lastch, firstch } <= 6'b101000;

   // Register the read signal to detect the first clock of a CPU read
   // cycle.
   
   logic prevread ;
   always_ff @(posedge clk) 
      prevread <= read ;

   // At end of data transfer from the ADC, the 12-bit sample value is
   // transferred to the FIFO along with the channel number in the
   // upper 4 bits.  This channel number is the one configured at the
   // start of the previous transfer.

   // FIFO between ADC and CPU. Channel number and sample value is
   // written to FIFO at end of transfer state if not full.  Data is
   // read from FIFO to readdata on first clock of read cycle if not
   // empty.  Reads of empty FIFO read as 16'h8000.
   
	logic [15:0] buffer_out;
	logic [7:0] read_addr;
   
   circularBuffer circularBuffer0 
      (.clock(clk),
		 .reset(reset)
       .data_in( { prevch, sample } ), 
		 .write_en((state == transfer && state_next == acquire) ),
		 .read_adr(read_addr),
       .data_out(buffer_out)) ;

	always_ff @(posedge clk) read_addr
		<= read ? address : read_addr;
	assign readdata = buffer_out;

endmodule
     

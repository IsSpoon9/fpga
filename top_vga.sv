// top_vga.sv

module top_vga 
  ( input logic clk50, s1, s2, //Clk and Reset
  
	 //VGA
    output logic [13:0] GPIO_0,

    input  logic enc1a, enc1b,// Encoder #1 (trigger level)
    input  logic enc2a, enc2b, // Encoder #2 (timebase) 
	 
    // ADC
    input  logic ADC_SDO,
    output logic ADC_CONVST, ADC_SDI, ADC_SCK
	 
    ) ;
	
	// Setup Reset Pin
	logic reset;
	assign reset = !s1;
	
	// Rotary Encoders
   logic enc_level_up, enc_level_down;
   logic enc_time_up, enc_time_down;
	
	rotary_encoder level_enc (
      .clk50(clk50),
      .reset_n(!reset),
      .enc_a(enc1a),
      .enc_b(enc1b),
      .up_pulse(enc_level_up),
		.down_pulse(enc_level_down)
	);   
   rotary_encoder time_enc (
		.clk50(clk50),
      .reset_n(!reset),
      .enc_a(enc2a),
      .enc_b(enc2b),
      .up_pulse(enc_time_up),
      .down_pulse(enc_time_down)
   );	
	
	// Encoder Controller
	logic [11:0] trig_level, timebase;
   logic [1:0]  trig_mode;
	
   control_registers u0 (
		.clk(clk50),
      .reset(reset),                 // active-high reset inside module
      .trigger_mode(!s2),                     // mode button
      .enc_level_up(enc_level_up),
      .enc_level_down(enc_level_down),
      .enc_time_up(enc_time_up),
      .enc_time_down(enc_time_down),
      .trig_level(trig_level),
      .trig_mode(trig_mode),
      .timebase(timebase)
    );
	

	// ADC
	logic [11:0] adc_sample;
	logic write_en;   
	
	ltc2308 ltc2308_0 (
		.clk(clk50),
      .reset(reset),
      .sdo(ADC_SDO),
      .convst(ADC_CONVST),
      .sdi(ADC_SDI),
      .sck(ADC_SCK),
		.sample(adc_sample),
	   .write_en(write_en)
	  );
	
	


	// Stored values
	logic [11:0] buffer_sample;
	logic [7:0] read_addr, write_adr;
	
	circularBuffer cb (
		 .clk(clk50),
		 .reset(reset),
		 .data_in(adc_sample),
		 .write_en(write_en),
		 .read_adr(read_addr),
		 .data_out(buffer_sample),
		 .write_ptr(write_adr)
	);
	
	// Trigger Control
	logic [7:0] trigger_index;
   trigger trig0 (
		.clk(clk50),
		.reset(reset),
      .sample_in(buffer_sample),
      .trig_level(trig_level),
      .trig_mode(trig_mode),
		.write_adr(write_adr),
      .trigger_index(trigger_index)
    );
	
	// Controls Screen
	graphicscontroller graphics0 (
		.clk(clk50),
		.reset(reset),
		.trigger_index(trigger_index),
		.read_adr(read_addr),
		.data(buffer_sample),
		.gpio(GPIO_0)
	);
	
endmodule                                                         



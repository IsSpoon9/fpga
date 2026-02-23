
module fpga (
	clk50_clk,
	leds_export,
	ltc2308_0_adc0_sck,
	ltc2308_0_adc0_sdo,
	ltc2308_0_adc0_sdi,
	ltc2308_0_adc0_convst,
	reset_n_reset_n);	

	input		clk50_clk;
	output	[7:0]	leds_export;
	output		ltc2308_0_adc0_sck;
	input		ltc2308_0_adc0_sdo;
	output		ltc2308_0_adc0_sdi;
	output		ltc2308_0_adc0_convst;
	input		reset_n_reset_n;
endmodule

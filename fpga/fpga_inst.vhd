	component fpga is
		port (
			clk50_clk             : in  std_logic                    := 'X'; -- clk
			leds_export           : out std_logic_vector(7 downto 0);        -- export
			ltc2308_0_adc0_sck    : out std_logic;                           -- sck
			ltc2308_0_adc0_sdo    : in  std_logic                    := 'X'; -- sdo
			ltc2308_0_adc0_sdi    : out std_logic;                           -- sdi
			ltc2308_0_adc0_convst : out std_logic;                           -- convst
			reset_n_reset_n       : in  std_logic                    := 'X'  -- reset_n
		);
	end component fpga;

	u0 : component fpga
		port map (
			clk50_clk             => CONNECTED_TO_clk50_clk,             --          clk50.clk
			leds_export           => CONNECTED_TO_leds_export,           --           leds.export
			ltc2308_0_adc0_sck    => CONNECTED_TO_ltc2308_0_adc0_sck,    -- ltc2308_0_adc0.sck
			ltc2308_0_adc0_sdo    => CONNECTED_TO_ltc2308_0_adc0_sdo,    --               .sdo
			ltc2308_0_adc0_sdi    => CONNECTED_TO_ltc2308_0_adc0_sdi,    --               .sdi
			ltc2308_0_adc0_convst => CONNECTED_TO_ltc2308_0_adc0_convst, --               .convst
			reset_n_reset_n       => CONNECTED_TO_reset_n_reset_n        --        reset_n.reset_n
		);


// control.sv
// Tanvir Kaur - Feb 28, 2026
// This modules enable the user interface

// idea:
// trig levels are different states that will go from one state to another
// the system will be in rising egde trigger mode by default
// on pressing boosterpack switch the system will go to falling edge mode
// one of the rotary encoder will be used to adjust the trigger level for level triggered mode
// second rotary encoder will be used to adjust the timebase, the number of samples displayed
// second boosterpack switch will reset both the trigger and timebase 

module control_registers (
    input  logic        clk,
    input  logic        reset,

    // UI inputs 
    input  logic trigger_mode,       // cycle trigger mode to falling
    input  logic enc_level_up,
    input  logic enc_level_down,
    input  logic enc_time_up,
    input  logic enc_time_down,

    // Outputs to oscilloscope pipeline
    output logic [11:0] trig_level,
    output logic [1:0]  trig_mode,
    output logic [11:0] timebase,
    output logic enable

    // LED output for debugging
   // output logic [7:0]  leds
);

    // Default values needs to be changed later on
    localparam [11:0] DEFAULT_LEVEL    = 12'd2;    
    localparam [11:0] DEFAULT_TIMEBASE = 12'd2;    
    localparam [1:0]  DEFAULT_MODE     = 2'b00;      

    // Registers
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            trig_level <= DEFAULT_LEVEL;
            trig_mode  <= DEFAULT_MODE;
            timebase   <= DEFAULT_TIMEBASE;
            enable     <= 1'b1;
        end 
		  
		  else begin

            // Cycle trigger mode (00 to 01 to 10 to 11 to 00)
            if (trigger_mode)
                trig_mode <= trig_mode + 1'b1;

            // Adjust trigger level
            if (enc_level_up)
                trig_level <= trig_level + 1;
            if (enc_level_down)
                trig_level <= trig_level - 1;

            // Adjust timebase
            if (enc_time_up)
                timebase <= timebase + 1;
            if (enc_time_down)
                timebase <= timebase - 1;
        end
  end

    // LED 
    // [7] = enable
    // [6:4] = trigger mode (one-hot)
    // [3:0] = upper bits of trigger level
   // always_comb begin
     //   leds[7]   = enable;
       // leds[6:4] = (trig_mode == 2'b00) ? 3'b001 :   // rising
         //           (trig_mode == 2'b01) ? 3'b010 :   // falling
           //         (trig_mode == 2'b10) ? 3'b100 :   // level
             //                              3'b000;    // off
       // leds[3:0] = trig_level[11:8];
   // end

endmodule
// trigger.sv
// Tanvir Kaur - Feb 28, 2026

// This module will detect rising, falling, or level trigger events by comparing the current
// ADC sample to the previous sample and the user‑selected trigger level.
// This module is controlled by the control.sv 

module trigger (
    input  logic        clk,
    input  logic        reset,
    input  logic [11:0] sample_in,
    input  logic [11:0] trig_level,
    input  logic [1:0]  trig_mode,
    input  logic [7:0]  write_adr,

    output logic [7:0]  trigger_index
);

    logic [11:0] prev_sample;
    logic condition_true;

    // store previous sample
    always_ff @(posedge clk or posedge reset) begin
        if (reset)
            prev_sample <= 0;
        else
            prev_sample <= sample_in;
    end

    // trigger condition
    always_comb begin
        case (trig_mode)
            2'b00: condition_true = (sample_in >= trig_level);
            2'b01: condition_true = (sample_in <= trig_level);
            2'b10: condition_true = (sample_in == trig_level);
            default: condition_true = 1'b0;
        endcase
    end

  always_ff @(posedge clk or posedge reset) begin
    if (reset)
        trigger_index <= 0;
    else begin
        if (condition_true) begin
            trigger_index <= write_adr;
        end
    end
end

endmodule

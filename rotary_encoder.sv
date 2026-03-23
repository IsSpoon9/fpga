module rotary_encoder (
    input  logic clk50,        
    input  logic reset_n,
    input  logic enc_a,
    input  logic enc_b,

    output logic up_pulse,
    output logic down_pulse
);

    // Clock divider for the rotary encoder and LED Mux
    logic clk;
    clkdiv clk1 ( clk50 , clk);

    logic [3:0] state;
    logic up, enable;

    always_ff @(posedge clk or negedge reset_n) begin
        if (!reset_n)
            state <= 4'b0000;
        else
            state <= {state[1:0], enc_a, enc_b};
    end

    always_ff @(posedge clk or negedge reset_n) begin
        if (!reset_n)
            up <= 1'b0;
        else
            up <= (state == 4'b1101) ||
                  (state == 4'b0100) ||
                  (state == 4'b0010) ||
                  (state == 4'b1011);
    end

    always_ff @(posedge clk or negedge reset_n) begin
        if (!reset_n)
            enable <= 1'b0;
        else
            enable <= (state == 4'b1101) ||
                      (state == 4'b0100) ||
                      (state == 4'b0010) ||
                      (state == 4'b1011) ||
                      (state == 4'b1110) ||
                      (state == 4'b1000) ||
                      (state == 4'b0001) ||
                      (state == 4'b0111);
    end

    assign up_pulse   =  up & enable;
    assign down_pulse = !up & enable;

endmodule
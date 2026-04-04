module rotary_encoder (
		input logic clk, reset, // Clock
		input logic enca, encb, // Encoder nodes
		output logic up, down // Direction
	);
	
    logic [3:0] state;
    logic upD, enable;

    always_ff @(posedge clk) begin
        if (reset)
            state <= 4'b0000;
        else
            state <= {state[1:0], enca, encb};
    end

    always_ff @(posedge clk) begin
        if (reset)
            upD <= 1'b0;
        else
            upD <= (state == 4'b1101) ||
                  (state == 4'b0100) ||
                  (state == 4'b0010) ||
                  (state == 4'b1011);
    end

    always_ff @(posedge clk) begin
        if (reset)
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

    assign up   =  upD & enable;
    assign down = !upD & enable;

	
endmodule
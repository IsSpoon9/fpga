module datargb (
    input  logic [11:0]  data,           // ADC 0-4095
    input  logic [7:0]   trigger_index,
    input  logic [7:0]   timebase,
    input  logic [15:0]  xpixel, ypixel,
    output logic [7:0]   read_adr, 
    output logic [2:0]   outputRGB
);

    // New Rotated Boundaries (A tall, thin box)
    localparam X_LEFT  = 220;
    localparam X_RIGHT = 420; // 200 pixels wide (Voltage Axis)
    localparam Y_TOP   = 112; 
    localparam Y_BOT   = 368; // 256 pixels tall (Time Axis)
	 localparam SCALE = 21;
    
    logic [7:0] y_offset;
    logic [7:0] scaled_volt;

	 
	 // Remember to Rotate Screen
    always_comb begin
		  // Set variables to zero for comb to work
        outputRGB = 3'b000;
		  scaled_volt = '0;
        
        y_offset = (ypixel >= Y_TOP) ? (ypixel[7:0] - 8'd112) : 8'd0;
        read_adr = trigger_index + (y_offset * timebase);

        // DRAWING
		  // Borders
        if ((ypixel == Y_TOP || ypixel == Y_BOT) && (xpixel >= X_LEFT && xpixel <= X_RIGHT))
            outputRGB = 3'b111;
        else if ((xpixel == X_LEFT || xpixel == X_RIGHT) && (ypixel >= Y_TOP && ypixel <= Y_BOT))
            outputRGB = 3'b111;
				
        //Scope
        else if (ypixel > Y_TOP && ypixel < Y_BOT && xpixel > X_LEFT && xpixel < X_RIGHT) begin
            
            // Voltage
            scaled_volt = data[11:0] / SCALE; 
            if (xpixel == (X_LEFT + scaled_volt) || xpixel == (X_LEFT + scaled_volt + 1)) begin
                outputRGB = 3'b001;
            end
        end
    end
endmodule
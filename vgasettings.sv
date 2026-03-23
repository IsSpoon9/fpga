// settings.sv
// Purpose: Customizable values for the VGA display

// ------------------------------------------------------------------ Standard Settings



// ------------------------------------------------------------------ VGA Settings
package vgapkg;
    // --------------------------------- Adjustable Parameters
    localparam int vgaDisplay_freq = 60;

    // Horizontal Timing
    localparam int vgaH_vis   = 640;
    localparam int vgaH_front = 16;
    localparam int vgaH_sync  = 96;
    localparam int vgaH_back  = 48;
    
    // Vertical Timing
    localparam int vgaV_vis   = 480;
    localparam int vgaV_front = 10;
    localparam int vgaV_sync  = 2;
    localparam int vgaV_back  = 33;
    
    // System Types
    typedef logic [15:0] vgaIndex;
    
    // --------------------------------- Colours
    // Fixed: Changed bit width to 3 to match vgaColour typedef [2:0]
    typedef logic [2:0] vgaColour;
    
    localparam vgaColour vgaBLK = 3'b000; // black
    localparam vgaColour vgaBLU = 3'b001; // blue
    localparam vgaColour vgaGRN = 3'b010; // green
    localparam vgaColour vgaCYN = 3'b011; // cyan
    localparam vgaColour vgaRED = 3'b100; // red
    localparam vgaColour vgaPRP = 3'b101; // purple
    localparam vgaColour vgaYLW = 3'b110; // yellow
    localparam vgaColour vgaWHT = 3'b111; // white
    
    // --------------------------------- Auto-Adjusted Parameters
    localparam int vgaH_total = vgaH_vis + vgaH_sync + vgaH_back + vgaH_front;
    localparam int vgaV_total = vgaV_vis + vgaV_sync + vgaV_back + vgaV_front;
    
    // Calculated Pixel Clock (for 640x480 @ 60Hz, this results in ~25.17 MHz)
    localparam int clkVGA = vgaH_total * vgaV_total * vgaDisplay_freq;

endpackage

// ------------------------------------------------------------------ GUI Settings
package dispPKG;
	
endpackage
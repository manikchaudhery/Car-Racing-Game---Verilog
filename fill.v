module fill
	(
		CLOCK_50,						//	On Board 50 MHz
		// Your inputs and outputs here
		KEY,
		SW,
		HEX0, HEX1,
		PS2_CLK,
		PS2_DAT,
		// The ports below are for the VGA output.  Do not change.
		VGA_CLK,   						//	VGA Clock
		VGA_HS,							//	VGA H_SYNC
		VGA_VS,							//	VGA V_SYNC
		VGA_BLANK_N,						//	VGA BLANK
		VGA_SYNC_N,						//	VGA SYNC
		VGA_R,   						//	VGA Red[9:0]
		VGA_G,	 						//	VGA Green[9:0]
		VGA_B 
  						//	VGA Blue[9:0]
	);

	input			CLOCK_50;				//	50 MHz
	input	 [3:0] KEY;
	input  [9:0] SW;
	output [0:6] HEX0, HEX1;
	// Declare your inputs and outputs here
	// Do not change the following outputs
	output			VGA_CLK;   				//	VGA Clock
	output			VGA_HS;					//	VGA H_SYNC
	output			VGA_VS;					//	VGA V_SYNC
	output			VGA_BLANK_N;				//	VGA BLANK
	output			VGA_SYNC_N;				//	VGA SYNC
	output	[7:0]	VGA_R;   				//	VGA Red[9:0]
	output	[7:0]	VGA_G;	 				//	VGA Green[9:0]
	output	[7:0]	VGA_B;   				//	VGA Blue[9:0]
	
	wire resetn;
	assign resetn = KEY[3];
	
	inout				PS2_CLK;
	inout				PS2_DAT;
	wire 				signalStraight, signalRight, signalLeft;
	
	// Create the colour, x, y and writeEn wires that are inputs to the controller.

	wire [5:0] colour;
	wire [8:0] x;
	wire [7:0] y;
	wire writeEn;
	wire[7:0] secondsPassed;

	// Create an Instance of a VGA controller - there can be only one!
	// Define the number of colours as well as the initial background
	// image file (.MIF) for the controller.
	vga_adapter VGA(
			.resetn(resetn),
			.clock(CLOCK_50),
			.colour(colour),
			.x(x),
			.y(y),
			.plot(writeEn),
			/* Signals for the DAC to drive the monitor. */
			.VGA_R(VGA_R),
			.VGA_G(VGA_G),
			.VGA_B(VGA_B),
			.VGA_HS(VGA_HS),
			.VGA_VS(VGA_VS),
			.VGA_BLANK(VGA_BLANK_N),
			.VGA_SYNC(VGA_SYNC_N),
			.VGA_CLK(VGA_CLK));
		defparam VGA.RESOLUTION = "320x240";
		defparam VGA.MONOCHROME = "FALSE";
		defparam VGA.BITS_PER_COLOUR_CHANNEL = 2;
		defparam VGA.BACKGROUND_IMAGE = "track.mif";
			
		projectTop P0(
			.Clock(CLOCK_50),
			.Resetn(resetn),
			.simReset(1'b0),
			.Start(SW[9]),
			.moveForward(signalStraight),
			.moveRight(signalRight),
			.moveLeft(signalLeft),
			.xOut(x),
			.yOut(y),
			.secondsPassed(secondsPassed),
			.colourOut(colour),
			.plotOut(writeEn));
		
		PS2_Call ps2call(
			// Inputs
			CLOCK_50,
			SW[9],

			// Bidirectionals
			PS2_CLK,
			PS2_DAT,
	
			// Outputs
			signalStraight, signalRight, signalLeft);
	
		hex7seg hex0(.c(secondsPassed[3:0]), .led(HEX0));
		hex7seg hex1(.c(secondsPassed[7:4]), .led(HEX1));
	
endmodule





//module fill
//	(
//		CLOCK_50,						//	On Board 50 MHz
//		// Your inputs and outputs here
//		KEY,
//		SW,
//		HEX0, HEX1,
//		// The ports below are for the VGA output.  Do not change.
//		VGA_CLK,   						//	VGA Clock
//		VGA_HS,							//	VGA H_SYNC
//		VGA_VS,							//	VGA V_SYNC
//		VGA_BLANK_N,						//	VGA BLANK
//		VGA_SYNC_N,						//	VGA SYNC
//		VGA_R,   						//	VGA Red[9:0]
//		VGA_G,	 						//	VGA Green[9:0]
//		VGA_B,   						//	VGA Blue[9:0]
//		PS2_CLK,
//		PS2_DAT
//	);
//
//	input			CLOCK_50;				//	50 MHz
//	input	 [3:0] KEY;
//	input  [9:0] SW;
//	output [0:6] HEX0, HEX1;
//	// Declare your inputs and outputs here
//	// Do not change the following outputs
//	output			VGA_CLK;   				//	VGA Clock
//	output			VGA_HS;					//	VGA H_SYNC
//	output			VGA_VS;					//	VGA V_SYNC
//	output			VGA_BLANK_N;				//	VGA BLANK
//	output			VGA_SYNC_N;				//	VGA SYNC
//	output	[7:0]	VGA_R;   				//	VGA Red[9:0]
//	output	[7:0]	VGA_G;	 				//	VGA Green[9:0]
//	output	[7:0]	VGA_B;   				//	VGA Blue[9:0]
//	
//	wire resetn;
//	assign resetn = KEY[3];
//	
//	// Create the colour, x, y and writeEn wires that are inputs to the controller.
//
//	wire [5:0] colour;
//	wire [8:0] x;
//	wire [7:0] y;
//	wire writeEn;
//	wire[7:0] secondsPassed;
//	
//	reg moveForward;
//	reg moveLeft;
//	reg moveRight;
//
//	// Create an Instance of a VGA controller - there can be only one!
//	// Define the number of colours as well as the initial background
//	// image file (.MIF) for the controller.
//	vga_adapter VGA(
//			.resetn(resetn),
//			.clock(CLOCK_50),
//			.colour(colour),
//			.x(x),
//			.y(y),
//			.plot(writeEn),
//			/* Signals for the DAC to drive the monitor. */
//			.VGA_R(VGA_R),
//			.VGA_G(VGA_G),
//			.VGA_B(VGA_B),
//			.VGA_HS(VGA_HS),
//			.VGA_VS(VGA_VS),
//			.VGA_BLANK(VGA_BLANK_N),
//			.VGA_SYNC(VGA_SYNC_N),
//			.VGA_CLK(VGA_CLK));
//		defparam VGA.RESOLUTION = "320x240";
//		defparam VGA.MONOCHROME = "FALSE";
//		defparam VGA.BITS_PER_COLOUR_CHANNEL = 2;
//		defparam VGA.BACKGROUND_IMAGE = "track.mif";
//			
//		projectTop P0(
//			.Clock(CLOCK_50),
//			.Resetn(resetn),
//			.simReset(1'b0),
//			.Start(SW[9]),
//			.moveForward(moveForward),
//			.moveRight(moveRight),
//			.moveLeft(moveLeft),
//			.xOut(x),
//			.yOut(y),
//			.secondsPassed(secondsPassed),
//			.colourOut(colour),
//			.plotOut(writeEn));
//						
//		hex7seg hex0(.c(secondsPassed[3:0]), .led(HEX0));
//		hex7seg hex1(.c(secondsPassed[7:4]), .led(HEX1));
//		
//		//PS2 COntroller module
//		wire		[7:0]	ps2_key_data;
//	   wire				ps2_key_pressed;
//		
//	 // Bidirectionals
//	// need these for inout 
//	inout				PS2_CLK;
//	inout				PS2_DAT;
//		
//	PS2_Controller PS2 (
//		// Inputs
//		.CLOCK_50			(CLOCK_50),
//		.reset				(!resetn),
//
//		// Bidirectionals
//		.PS2_CLK			(PS2_CLK),
//		.PS2_DAT			(PS2_DAT),
//
//		// Outputs
//		.received_data		(ps2_key_data),
//		.received_data_en	(ps2_key_pressed)
//	);
//	
//	always @(posedge CLOCK_50) begin
//	
//	//if key was pressed
//	//deciding the moving state inside this if statement
//		if(ps2_key_pressed == 1'b1) begin
//
//		//check E075 or only 75
//			if(ps2_key_data == 7'hE075)begin
//			moveForward <= 1'b1;
//			moveLeft <= 1'b0;
//			moveRight <= 1'b0;
//			end
//
//			if(ps2_key_data == 7'hE06B)begin
//			moveForward <= 1'b0;
//			moveLeft <= 1'b1;
//			moveRight <= 1'b0;
//			end
//
//			if(ps2_key_data == 7'hE074)begin
//			moveForward <= 1'b0;
//			moveLeft <= 1'b0;
//			moveRight <= 1'b1;
//			end
//		end
//		else begin
//			moveForward <= 1'b0;
//			moveLeft <= 1'b0;
//			moveRight <= 1'b0;
//		end
//	
//	end
//		
//endmodule
		

		
		

//module fill
//	(
//		CLOCK_50,						//	On Board 50 MHz
//		// Your inputs and outputs here
//		KEY,
//		SW,
//		HEX0, HEX1,
//		// The ports below are for the VGA output.  Do not change.
//		VGA_CLK,   						//	VGA Clock
//		VGA_HS,							//	VGA H_SYNC
//		VGA_VS,							//	VGA V_SYNC
//		VGA_BLANK_N,						//	VGA BLANK
//		VGA_SYNC_N,						//	VGA SYNC
//		VGA_R,   						//	VGA Red[9:0]
//		VGA_G,	 						//	VGA Green[9:0]
//		VGA_B   						//	VGA Blue[9:0]
//	);
//
//	input			CLOCK_50;				//	50 MHz
//	input	 [3:0] KEY;
//	input  [9:0] SW;
//	output [0:6] HEX0, HEX1;
//	// Declare your inputs and outputs here
//	// Do not change the following outputs
//	output			VGA_CLK;   				//	VGA Clock
//	output			VGA_HS;					//	VGA H_SYNC
//	output			VGA_VS;					//	VGA V_SYNC
//	output			VGA_BLANK_N;				//	VGA BLANK
//	output			VGA_SYNC_N;				//	VGA SYNC
//	output	[7:0]	VGA_R;   				//	VGA Red[9:0]
//	output	[7:0]	VGA_G;	 				//	VGA Green[9:0]
//	output	[7:0]	VGA_B;   				//	VGA Blue[9:0]
//	
//	wire resetn;
//	assign resetn = KEY[3];
//	
//	// Create the colour, x, y and writeEn wires that are inputs to the controller.
//
//	wire [5:0] colour;
//	wire [8:0] x;
//	wire [7:0] y;
//	wire writeEn;
//	wire[7:0] secondsPassed;
//
//	// Create an Instance of a VGA controller - there can be only one!
//	// Define the number of colours as well as the initial background
//	// image file (.MIF) for the controller.
//	vga_adapter VGA(
//			.resetn(resetn),
//			.clock(CLOCK_50),
//			.colour(colour),
//			.x(x),
//			.y(y),
//			.plot(writeEn),
//			/* Signals for the DAC to drive the monitor. */
//			.VGA_R(VGA_R),
//			.VGA_G(VGA_G),
//			.VGA_B(VGA_B),
//			.VGA_HS(VGA_HS),
//			.VGA_VS(VGA_VS),
//			.VGA_BLANK(VGA_BLANK_N),
//			.VGA_SYNC(VGA_SYNC_N),
//			.VGA_CLK(VGA_CLK));
//		defparam VGA.RESOLUTION = "320x240";
//		defparam VGA.MONOCHROME = "FALSE";
//		defparam VGA.BITS_PER_COLOUR_CHANNEL = 2;
//		defparam VGA.BACKGROUND_IMAGE = "track.mif";
//			
//		projectTop P0(
//			.Clock(CLOCK_50),
//			.Resetn(resetn),
//			.simReset(1'b0),
//			.Start(SW[9]),
//			.moveForward(~KEY[1]),
//			.moveRight(~KEY[0]),
//			.moveLeft(~KEY[2]),
//			.xOut(x),
//			.yOut(y),
//			.secondsPassed(secondsPassed),
//			.colourOut(colour),
//			.plotOut(writeEn));
//						
//		hex7seg hex0(.c(secondsPassed[3:0]), .led(HEX0));
//		hex7seg hex1(.c(secondsPassed[7:4]), .led(HEX1));
//	
//endmodule
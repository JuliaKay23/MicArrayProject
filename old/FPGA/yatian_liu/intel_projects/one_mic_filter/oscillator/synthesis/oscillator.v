// oscillator.v

// Generated using ACDS version 19.1 670

`timescale 1 ps / 1 ps
module oscillator (
		output wire  clkout, // clkout.clk
		input  wire  oscena  // oscena.oscena
	);

	altera_int_osc int_osc_0 (
		.oscena (oscena), // oscena.oscena
		.clkout (clkout)  // clkout.clk
	);

endmodule

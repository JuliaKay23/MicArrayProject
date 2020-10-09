module tse_tutorial(
	// Clock
	input         CLOCK_50,
	
	// KEY
	input  [0: 0] KEY,
	
	// Ethernet 0
	output        ENET0_MDC,
	inout         ENET0_MDIO,
	output        ENET0_RESET_N,
	output        ENET0_GTX_CLK,
	input         ENET0_RX_CLK,
	input  [3: 0] ENET0_RX_DATA,
	input         ENET0_RX_DV,
	output [3: 0] ENET0_TX_DATA,
	output        ENET0_TX_EN
);

//TO-DO
// 1. What is byteenable? what is write? what is chipselect?
// 2. Instatiate a RAM with n number words, begin with n=2 or use n registers
// 3. Change size of RAM in qsys to be equal to size n
// 4. Send all of RAM in qsys over ethernet

	// MODIFIED
	wire [3:0] byteenable = 4'b1111;
	wire chipselect = 1'b1;
	wire write = 1'b1;
	wire clken = 1'b1;
	reg [9:0] address;
	reg [31:0] data;
	reg [23:0] count;
	
	initial begin
		address = 10'd0;
		data = 32'd0;
		count = 24'd0;
	end
	// END MODIFIED
	

	wire sys_clk, clk_125, clk_25, clk_2p5, tx_clk;
	wire core_reset_n;
	wire mdc, mdio_in, mdio_oen, mdio_out;
	wire eth_mode, ena_10;

	assign mdio_in   = ENET0_MDIO;
	assign ENET0_MDC  = mdc;
	assign ENET0_MDIO = mdio_oen ? 1'bz : mdio_out;
	
	assign ENET0_RESET_N = core_reset_n;
	
	my_pll my_pll_inst (
		.refclk   (CLOCK_50),   //  refclk.clk
		.rst      (~KEY[0]),      //   reset.reset
		.outclk_0 (sys_clk), // outclk0.clk
		.outclk_1 (clk_125), // outclk1.clk
		.outclk_2 (clk_25), // outclk2.clk
		.outclk_3 (clk_2p5), // outclk3.clk
		.locked   (core_reset_n)    //  locked.export
	);
	 
	
	assign tx_clk = eth_mode ? clk_125 :       // GbE Mode   = 125MHz clock
	                ena_10   ? clk_2p5 :       // 10Mb Mode  = 2.5MHz clock
	                           clk_25;         // 100Mb Mode = 25 MHz clock
	
	my_ddio_out ddio_out_inst(
		.datain_h(1'b1),
		.datain_l(1'b0),
		.outclock(tx_clk),
		.dataout(ENET0_GTX_CLK)
	);
	
	// MODIFIED
	always @(posedge CLOCK_50) begin
		if (count <= 24'h4C4B40) begin
			data <= data + 1;
			count <= 24'd0;
		end
		else count <= count + 1;
	end
	// END MODIFIED 
	
    nios_system system_inst (
        .clk_clk                                   (sys_clk),           //                                   clk.clk
        .reset_reset_n                             (core_reset_n),      //                                 reset.reset_n
        .tse_pcs_mac_tx_clock_connection_clk 		(tx_clk), 				// eth_tse_0_pcs_mac_tx_clock_connection.clk
        .tse_pcs_mac_rx_clock_connection_clk 		(ENET0_RX_CLK), 		// eth_tse_0_pcs_mac_rx_clock_connection.clk
        .tse_mac_mdio_connection_mdc               (mdc),             	//               tse_mac_mdio_connection.mdc
        .tse_mac_mdio_connection_mdio_in           (mdio_in),           //                                      .mdio_in
        .tse_mac_mdio_connection_mdio_out          (mdio_out),          //                                      .mdio_out
        .tse_mac_mdio_connection_mdio_oen          (mdio_oen),          //                                      .mdio_oen
        .tse_mac_rgmii_connection_rgmii_in         (ENET0_RX_DATA),     //              tse_mac_rgmii_connection.rgmii_in
        .tse_mac_rgmii_connection_rgmii_out        (ENET0_TX_DATA),     //                                      .rgmii_out
        .tse_mac_rgmii_connection_rx_control       (ENET0_RX_DV),       //                                      .rx_control
        .tse_mac_rgmii_connection_tx_control       (ENET0_TX_EN),       //                                      .tx_control

        .tse_mac_status_connection_eth_mode        (eth_mode),        	//                                      .eth_mode
        .tse_mac_status_connection_ena_10          (ena_10),          	//                                      .ena_10	  
		  // MODIFIED
		  .ram_block_s2_address                (address),                //                    ram_block_s2.address
        .ram_block_s2_chipselect             (chipselect),             //                                .chipselect
        .ram_block_s2_clken                  (clken),                  //                                .clken
        .ram_block_s2_write                  (write),                  //                                .write
        .ram_block_s2_writedata              (data),              //                                .writedata
        .ram_block_s2_byteenable             (byteenable)              //                                .byteenable
			// END MODIFIED
	);	
	 
	 

endmodule 
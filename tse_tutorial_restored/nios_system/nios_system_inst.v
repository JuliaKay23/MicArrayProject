	nios_system u0 (
		.clk_clk                             (<connected-to-clk_clk>),                             //                             clk.clk
		.ram_block_s2_address                (<connected-to-ram_block_s2_address>),                //                    ram_block_s2.address
		.ram_block_s2_chipselect             (<connected-to-ram_block_s2_chipselect>),             //                                .chipselect
		.ram_block_s2_clken                  (<connected-to-ram_block_s2_clken>),                  //                                .clken
		.ram_block_s2_write                  (<connected-to-ram_block_s2_write>),                  //                                .write
		.ram_block_s2_readdata               (<connected-to-ram_block_s2_readdata>),               //                                .readdata
		.ram_block_s2_writedata              (<connected-to-ram_block_s2_writedata>),              //                                .writedata
		.ram_block_s2_byteenable             (<connected-to-ram_block_s2_byteenable>),             //                                .byteenable
		.reset_reset_n                       (<connected-to-reset_reset_n>),                       //                           reset.reset_n
		.tse_mac_mdio_connection_mdc         (<connected-to-tse_mac_mdio_connection_mdc>),         //         tse_mac_mdio_connection.mdc
		.tse_mac_mdio_connection_mdio_in     (<connected-to-tse_mac_mdio_connection_mdio_in>),     //                                .mdio_in
		.tse_mac_mdio_connection_mdio_out    (<connected-to-tse_mac_mdio_connection_mdio_out>),    //                                .mdio_out
		.tse_mac_mdio_connection_mdio_oen    (<connected-to-tse_mac_mdio_connection_mdio_oen>),    //                                .mdio_oen
		.tse_mac_rgmii_connection_rgmii_in   (<connected-to-tse_mac_rgmii_connection_rgmii_in>),   //        tse_mac_rgmii_connection.rgmii_in
		.tse_mac_rgmii_connection_rgmii_out  (<connected-to-tse_mac_rgmii_connection_rgmii_out>),  //                                .rgmii_out
		.tse_mac_rgmii_connection_rx_control (<connected-to-tse_mac_rgmii_connection_rx_control>), //                                .rx_control
		.tse_mac_rgmii_connection_tx_control (<connected-to-tse_mac_rgmii_connection_tx_control>), //                                .tx_control
		.tse_mac_status_connection_set_10    (<connected-to-tse_mac_status_connection_set_10>),    //       tse_mac_status_connection.set_10
		.tse_mac_status_connection_set_1000  (<connected-to-tse_mac_status_connection_set_1000>),  //                                .set_1000
		.tse_mac_status_connection_eth_mode  (<connected-to-tse_mac_status_connection_eth_mode>),  //                                .eth_mode
		.tse_mac_status_connection_ena_10    (<connected-to-tse_mac_status_connection_ena_10>),    //                                .ena_10
		.tse_pcs_mac_rx_clock_connection_clk (<connected-to-tse_pcs_mac_rx_clock_connection_clk>), // tse_pcs_mac_rx_clock_connection.clk
		.tse_pcs_mac_tx_clock_connection_clk (<connected-to-tse_pcs_mac_tx_clock_connection_clk>)  // tse_pcs_mac_tx_clock_connection.clk
	);


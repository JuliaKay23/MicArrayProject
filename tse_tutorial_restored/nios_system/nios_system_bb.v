
module nios_system (
	clk_clk,
	ram_block_s2_address,
	ram_block_s2_chipselect,
	ram_block_s2_clken,
	ram_block_s2_write,
	ram_block_s2_readdata,
	ram_block_s2_writedata,
	ram_block_s2_byteenable,
	reset_reset_n,
	tse_mac_mdio_connection_mdc,
	tse_mac_mdio_connection_mdio_in,
	tse_mac_mdio_connection_mdio_out,
	tse_mac_mdio_connection_mdio_oen,
	tse_mac_rgmii_connection_rgmii_in,
	tse_mac_rgmii_connection_rgmii_out,
	tse_mac_rgmii_connection_rx_control,
	tse_mac_rgmii_connection_tx_control,
	tse_mac_status_connection_set_10,
	tse_mac_status_connection_set_1000,
	tse_mac_status_connection_eth_mode,
	tse_mac_status_connection_ena_10,
	tse_pcs_mac_rx_clock_connection_clk,
	tse_pcs_mac_tx_clock_connection_clk);	

	input		clk_clk;
	input	[9:0]	ram_block_s2_address;
	input		ram_block_s2_chipselect;
	input		ram_block_s2_clken;
	input		ram_block_s2_write;
	output	[31:0]	ram_block_s2_readdata;
	input	[31:0]	ram_block_s2_writedata;
	input	[3:0]	ram_block_s2_byteenable;
	input		reset_reset_n;
	output		tse_mac_mdio_connection_mdc;
	input		tse_mac_mdio_connection_mdio_in;
	output		tse_mac_mdio_connection_mdio_out;
	output		tse_mac_mdio_connection_mdio_oen;
	input	[3:0]	tse_mac_rgmii_connection_rgmii_in;
	output	[3:0]	tse_mac_rgmii_connection_rgmii_out;
	input		tse_mac_rgmii_connection_rx_control;
	output		tse_mac_rgmii_connection_tx_control;
	input		tse_mac_status_connection_set_10;
	input		tse_mac_status_connection_set_1000;
	output		tse_mac_status_connection_eth_mode;
	output		tse_mac_status_connection_ena_10;
	input		tse_pcs_mac_rx_clock_connection_clk;
	input		tse_pcs_mac_tx_clock_connection_clk;
endmodule

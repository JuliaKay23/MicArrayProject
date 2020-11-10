---------------------------------------------------------------------------------------------------
--  Project          : Enclustra UDP/IP/ETH Core
--  File description : Instantiation wrapper for RGMII / Altera Cyclone V
--  File name        : en_udp_ip_eth_rgmii_alt_c5.vhd
--  Author           : Marc Oberholzer
---------------------------------------------------------------------------------------------------
--  Copyright (c) 2012/2013 by Enclustra GmbH, Switzerland
--  All rights reserved.
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- libraries
---------------------------------------------------------------------------------------------------

library ieee;
	use ieee.std_logic_1164.all;

library altera_mf;
	use altera_mf.altera_mf_components.all;

library lib_en_udp_ip_eth_rgmii_alt_c5_eval;

---------------------------------------------------------------------------------------------------
-- entity
---------------------------------------------------------------------------------------------------

entity en_udp_ip_eth_rgmii_alt_c5 is

	-----------------------------------------------------------------------------------------------
	-- generics
	-----------------------------------------------------------------------------------------------

	generic (
		UdpPortCount_g		: positive					:= 1;
		MaxPayloadSize_g	: positive					:= 2000;
		RxBufferCount_g		: natural					:= 2;
		EnableRawEth_g		: boolean					:= false;
		RawEthRxBufferCnt_g	: natural					:= 2;
		RawEthTxBufferCnt_g	: natural					:= 2;
		RawEthPayloadSize_g	: positive					:= 2000;
		TimeoutWidth_g		: positive					:= 12;
		RoundRobin_g		: boolean					:= true;
		ArpReply_g			: boolean					:= true;
		UseStreamingMode_g	: boolean					:= false;
		UdpRxHdrMask_g		: std_logic_vector (0 to 3)	:= "0000";
		UdpTxHdrMask_g		: std_logic_vector (0 to 1)	:= "00";
		IpRxHdrMask_g		: std_logic_vector (0 to 9)	:= "0000000000";
		IpTxHdrMask_g		: std_logic_vector (0 to 6)	:= "0000000";
		EthRxHdrMask_g		: std_logic_vector (0 to 2)	:= "000";
		EthTxHdrMask_g		: std_logic_vector (0 to 2)	:= "000"
	);

	-----------------------------------------------------------------------------------------------
	-- ports
	-----------------------------------------------------------------------------------------------

	port (

		-------------------------------------------------------------------------------------------
		-- user clock and reset ports
		-------------------------------------------------------------------------------------------

		Clk					: in	std_logic;
		Rst					: in	std_logic;
		
		-------------------------------------------------------------------------------------------
		-- user transmit data interface ports
		-------------------------------------------------------------------------------------------

		Tx_Data				: in	std_logic_vector (UdpPortCount_g*8-1 downto 0);
		Tx_Vld				: in	std_logic_vector (UdpPortCount_g-1 downto 0);
		Tx_Lst				: in	std_logic_vector (UdpPortCount_g-1 downto 0);
		Tx_Rdy				: out	std_logic_vector (UdpPortCount_g-1 downto 0);
		Tx_Err				: in	std_logic_vector (UdpPortCount_g-1 downto 0);
		Tx_Snd				: in	std_logic_vector (UdpPortCount_g-1 downto 0);
		
		-------------------------------------------------------------------------------------------
		-- user receive data interface ports
		-------------------------------------------------------------------------------------------

		Rx_Data				: out	std_logic_vector (UdpPortCount_g*8-1 downto 0);
		Rx_Vld				: out	std_logic_vector (UdpPortCount_g-1 downto 0);
		Rx_Rdy				: in	std_logic_vector (UdpPortCount_g-1 downto 0);
		Rx_Lst				: out	std_logic_vector (UdpPortCount_g-1 downto 0);
		Rx_Err				: out	std_logic_vector (UdpPortCount_g-1 downto 0);

		-------------------------------------------------------------------------------------------
		-- Raw Ethernet transmit interface
		-------------------------------------------------------------------------------------------
		
		EthTx_Data			: in	std_logic_vector (7 downto 0);
		EthTx_Vld			: in	std_logic;
		EthTx_Rdy			: out	std_logic;
		EthTx_Lst			: in	std_logic;
		EthTx_Err			: in	std_logic;
		
		-------------------------------------------------------------------------------------------
		-- Raw Ethernet receive interface
		-------------------------------------------------------------------------------------------
		
		EthRx_Data			: out	std_logic_vector (7 downto 0);
		EthRx_Vld			: out	std_logic;
		EthRx_Rdy			: in	std_logic;
		EthRx_Lst			: out	std_logic;
		EthRx_Err			: out	std_logic;
		
		-------------------------------------------------------------------------------------------
		-- user header interface ports
		-------------------------------------------------------------------------------------------

		Hdr_UdpTxSrc		: in	std_logic_vector (UdpPortCount_g*16-1 downto 0);
		Hdr_UdpTxDst		: in	std_logic_vector (UdpPortCount_g*16-1 downto 0);
		Hdr_UdpRxPort		: in	std_logic_vector (UdpPortCount_g*16-1 downto 0);
		Hdr_UdpRxPortMask	: in	std_logic_vector (UdpPortCount_g*16-1 downto 0);
		Hdr_IpSrc			: in	std_logic_vector (31 downto 0);  -- own IP
		Hdr_IpDst			: in	std_logic_vector (UdpPortCount_g*32-1 downto 0);
		Hdr_IpDscp			: in	std_logic_vector (7  downto 0);
		Hdr_IpId			: in	std_logic_vector (15 downto 0);
		Hdr_IpFlags			: in	std_logic_vector (2  downto 0);
		Hdr_IpTtl			: in	std_logic_vector (7  downto 0);
		Hdr_MacSrc			: in	std_logic_vector (47 downto 0);  -- own MAC
		Hdr_MacDst			: in	std_logic_vector (UdpPortCount_g*48-1 downto 0);
		Hdr_RawEthMac		: in	std_logic_vector (47 downto 0); -- MAC addr for raw Ethernet
		
		-------------------------------------------------------------------------------------------
		-- user configuration interface ports
		-------------------------------------------------------------------------------------------

		Cfg_TxEn			: in	std_logic;
		Cfg_RxEn			: in	std_logic;
		Cfg_CheckRawEthMac	: in	std_logic;
		Cfg_CheckMac		: in	std_logic;
		Cfg_CheckIp			: in	std_logic;
		Cfg_CheckUdp		: in	std_logic;
		Cfg_MTU				: in	std_logic_vector (UdpPortCount_g*14-1 downto 0);
		Cfg_Timeout			: in	std_logic_vector (TimeoutWidth_g-1 downto 0);
		
		-------------------------------------------------------------------------------------------
		-- rgmii ports
		-------------------------------------------------------------------------------------------

		Rgmii_RxClk			: in	std_logic;
		Rgmii_RxD			: in	std_logic_vector (3 downto 0);
		Rgmii_RxCtl			: in	std_logic;
		Rgmii_TxClk			: out	std_logic;
		Rgmii_TxD			: out	std_logic_vector (3 downto 0);
		Rgmii_TxCtl			: out	std_logic;

		-------------------------------------------------------------------------------------------
		-- version interface port
		-------------------------------------------------------------------------------------------

		Version				: out	std_logic_vector (31 downto 0)
	);
end;

---------------------------------------------------------------------------------------------------
-- architecture
---------------------------------------------------------------------------------------------------

architecture struct of en_udp_ip_eth_rgmii_alt_c5 is

	-----------------------------------------------------------------------------------------------
	-- internal signals
	-----------------------------------------------------------------------------------------------

	signal RstRxChain			: std_logic_vector (2 downto 0);
	signal Rst_Rx				: std_logic;
	signal Rgmii_RxD_Reg		: std_logic_vector (7 downto 0);
	signal Rgmii_RxCtl_Reg		: std_logic_vector (1 downto 0);
	signal Rgmii_TxClk_Next		: std_logic_vector (1 downto 0);
	signal Rgmii_TxD_Next		: std_logic_vector (7 downto 0);
	signal Rgmii_TxCtl_Next		: std_logic_vector (1 downto 0);

begin
	
	-----------------------------------------------------------------------------------------------
	-- reset synchronization
	-----------------------------------------------------------------------------------------------

	process (Rgmii_RxClk, Rst)
	begin
		if Rst = '1' then
			RstRxChain <= (others => '0');
		elsif rising_edge (Rgmii_RxClk) then
			RstRxChain <= '1' & RstRxChain (RstRxChain'left downto 1);
		end if;
	end process;
	Rst_Rx <= not RstRxChain (0);

	-----------------------------------------------------------------------------------------------
	-- ddr inputs
	-----------------------------------------------------------------------------------------------

	-- rgmii data input interface
	g_rgmii_rxd : for i in 0 to 3 generate
		i_rxd : altddio_in
			generic map (
				intended_device_family	=> "CYCLONE IV E",
				invert_input_clocks		=> "ON",
				lpm_hint				=> "UNUSED",
				lpm_type				=> "ALTDDIO_IN",
				power_up_high			=> "OFF",
				width					=> 1
			)
			port map (
				aclr			=> '0',
				datain(0)		=> Rgmii_RxD(i),
				inclock			=> Rgmii_RxClk,
				dataout_h(0)	=> Rgmii_RxD_Reg(i+4),
				dataout_l(0)	=> Rgmii_RxD_Reg(i)
			);
	end generate g_rgmii_rxd;
	
	-- rgmii control input interface
	i_xyz : altddio_in
		generic map (
			intended_device_family	=> "CYCLONE IV E",
			invert_input_clocks		=> "ON",
			lpm_hint				=> "UNUSED",
			lpm_type				=> "ALTDDIO_IN",
			power_up_high			=> "OFF",
			width					=> 1
		)
		port map (
			aclr			=> '0',
			datain(0)		=> Rgmii_RxCtl,
			inclock			=> Rgmii_RxClk,
			dataout_h(0)	=> Rgmii_RxCtl_Reg(1),
			dataout_l(0)	=> Rgmii_RxCtl_Reg(0)
		);
	
	-----------------------------------------------------------------------------------------------
	-- ddr outputs
	-----------------------------------------------------------------------------------------------
	
	-- rgmii data output interface
	g_rgmii_txd : for i in 0 to 3 generate
		i_txd : altddio_out
			generic map (
				extend_oe_disable		=> "OFF",
				intended_device_family	=> "CYCLONE IV E",
				invert_output			=> "OFF",
				lpm_hint				=> "UNUSED",
				lpm_type				=> "ALTDDIO_OUT",
				oe_reg					=> "UNREGISTERED",
				power_up_high			=> "OFF",
				width					=> 1
			)
			port map (
				aclr		=> '0',
				datain_h(0)	=> Rgmii_TxD_Next(i),
				datain_l(0)	=> Rgmii_TxD_Next(i+4),
				outclock	=> Clk,
				dataout(0)	=> Rgmii_TxD(i)
			);
	end generate g_rgmii_txd;

	-- rgmii control output interface
	i_rgmii_txctl : altddio_out
		generic map (
			extend_oe_disable		=> "OFF",
			intended_device_family	=> "CYCLONE IV E",
			invert_output			=> "OFF",
			lpm_hint				=> "UNUSED",
			lpm_type				=> "ALTDDIO_OUT",
			oe_reg					=> "UNREGISTERED",
			power_up_high			=> "OFF",
			width					=> 1
		)
		port map (
			aclr		=> '0',
			datain_h(0)	=> Rgmii_TxCtl_Next(0),
			datain_l(0)	=> Rgmii_TxCtl_Next(1),
			outclock	=> Clk,
			dataout(0)	=> Rgmii_TxCtl
		);

	-- rgmii clock output interface
	i_rgmii_txd : altddio_out
		generic map (
			extend_oe_disable		=> "OFF",
			intended_device_family	=> "CYCLONE IV E",
			invert_output			=> "OFF",
			lpm_hint				=> "UNUSED",
			lpm_type				=> "ALTDDIO_OUT",
			oe_reg					=> "UNREGISTERED",
			power_up_high			=> "OFF",
			width					=> 1
		)
		port map (
			aclr		=> '0',
			datain_h(0)	=> Rgmii_TxClk_Next(0), 
			datain_l(0)	=> Rgmii_TxClk_Next(1), 
			outclock	=> Clk,
			dataout(0)	=> Rgmii_TxClk
		);

	-----------------------------------------------------------------------------------------------
	-- udp/ip/eth core instance
	-----------------------------------------------------------------------------------------------

	i_core : entity lib_en_udp_ip_eth_rgmii_alt_c5_eval.en_udp_ip_eth_rgmii

		-------------------------------------------------------------------------------------------
		-- generics
		-------------------------------------------------------------------------------------------
		
		generic map (
			UdpPortCount_g		=> UdpPortCount_g,
			MaxPayloadSize_g	=> MaxPayloadSize_g,
			RxBufferCount_g		=> RxBufferCount_g,
			EnableRawEth_g		=> EnableRawEth_g,
			RawEthRxBufferCnt_g	=> RawEthRxBufferCnt_g,
			RawEthTxBufferCnt_g	=> RawEthTxBufferCnt_g,
			RawEthPayloadSize_g	=> RawEthPayloadSize_g,
			TimeoutWidth_g		=> TimeoutWidth_g,
			RoundRobin_g		=> RoundRobin_g,
			ArpReply_g			=> ArpReply_g,
			UseStreamingMode_g	=> UseStreamingMode_g,
			UdpRxHdrMask_g		=> UdpRxHdrMask_g,
			UdpTxHdrMask_g		=> UdpTxHdrMask_g,
			IpRxHdrMask_g		=> IpRxHdrMask_g,
			IpTxHdrMask_g		=> IpTxHdrMask_g,
			EthRxHdrMask_g		=> EthRxHdrMask_g,
			EthTxHdrMask_g		=> EthTxHdrMask_g
		)
		-------------------------------------------------------------------------------------------
		-- ports
		-------------------------------------------------------------------------------------------
		
		port map (

			---------------------------------------------------------------------------------------
			-- user clock and reset ports
			---------------------------------------------------------------------------------------
			
			Clk					=> Clk,
			Rst					=> Rst,

			---------------------------------------------------------------------------------------
			-- rgmii rx clock and synchronous reset ports
			---------------------------------------------------------------------------------------

			Clk_Rx				=> Rgmii_RxClk,
			Rst_Rx				=> Rst_Rx,

			---------------------------------------------------------------------------------------
			-- user transmit data interface ports
			---------------------------------------------------------------------------------------

			Tx_Data				=> Tx_Data,
			Tx_Vld				=> Tx_Vld,
			Tx_Lst				=> Tx_Lst,
			Tx_Rdy				=> Tx_Rdy,
			Tx_Err				=> Tx_Err,
			Tx_Snd				=> Tx_Snd,

			---------------------------------------------------------------------------------------
			-- user receive data interface ports
			---------------------------------------------------------------------------------------

			Rx_Data				=> Rx_Data,
			Rx_Vld				=> Rx_Vld,
			Rx_Rdy				=> Rx_Rdy,
			Rx_Lst				=> Rx_Lst,
			Rx_Err				=> Rx_Err,

			---------------------------------------------------------------------------------------
			-- Raw Ethernet transmit interface
			---------------------------------------------------------------------------------------
			
			EthTx_Data			=> EthTx_Data,
			EthTx_Vld			=> EthTx_Vld,
			EthTx_Rdy			=> EthTx_Rdy,
			EthTx_Lst			=> EthTx_Lst,
			EthTx_Err			=> EthTx_Err,

			---------------------------------------------------------------------------------------
			-- Raw Ethernet receive interface
			---------------------------------------------------------------------------------------
			
			EthRx_Data			=> EthRx_Data,
			EthRx_Vld			=> EthRx_Vld,
			EthRx_Rdy			=> EthRx_Rdy,
			EthRx_Lst			=> EthRx_Lst,
			EthRx_Err			=> EthRx_Err,

			---------------------------------------------------------------------------------------
			-- user header interface ports
			---------------------------------------------------------------------------------------
			
			Hdr_UdpTxSrc		=> Hdr_UdpTxSrc,
			Hdr_UdpTxDst		=> Hdr_UdpTxDst,
			Hdr_UdpRxPort		=> Hdr_UdpRxPort,
			Hdr_UdpRxPortMask	=> Hdr_UdpRxPortMask,
			Hdr_IpSrc			=> Hdr_IpSrc,
			Hdr_IpDst			=> Hdr_IpDst,
			Hdr_IpDscp			=> Hdr_IpDscp,
			Hdr_IpId			=> Hdr_IpId,
			Hdr_IpFlags			=> Hdr_IpFlags,
			Hdr_IpTtl			=> Hdr_IpTtl,
			Hdr_MacSrc			=> Hdr_MacSrc,
			Hdr_MacDst			=> Hdr_MacDst,
			Hdr_RawEthMac		=> Hdr_RawEthMac,

			---------------------------------------------------------------------------------------
			-- user configuration interface ports
			---------------------------------------------------------------------------------------

			Cfg_TxEn			=> Cfg_TxEn,
			Cfg_RxEn			=> Cfg_RxEn,
			Cfg_CheckRawEthMac	=> Cfg_CheckRawEthMac,
			Cfg_CheckMac		=> Cfg_CheckMac,
			Cfg_CheckIp			=> Cfg_CheckIp,
			Cfg_CheckUdp		=> Cfg_CheckUdp,
			Cfg_MTU				=> Cfg_MTU,
			Cfg_Timeout			=> Cfg_Timeout,

			---------------------------------------------------------------------------------------
			-- rgmii ports
			---------------------------------------------------------------------------------------

			Rgmii_RxClk			=> Rgmii_RxClk,
			Rgmii_RxD_Reg		=> Rgmii_RxD_Reg,
			Rgmii_RxCtl_Reg		=> Rgmii_RxCtl_Reg,
			Rgmii_TxClk_Next	=> Rgmii_TxClk_Next,
			Rgmii_TxD_Next		=> Rgmii_TxD_Next,
			Rgmii_TxCtl_Next	=> Rgmii_TxCtl_Next,

			---------------------------------------------------------------------------------------
			-- debug and version interface ports
			---------------------------------------------------------------------------------------
			
			Debug				=> open,
			Version				=> Version
			
		);
end;

---------------------------------------------------------------------------------------------------
-- eof
---------------------------------------------------------------------------------------------------
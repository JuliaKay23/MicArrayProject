---------------------------------------------------------------------------------------------------
--  Project          : Enclustra UDP/IP/ETH Core
--  File description : Instantiation wrapper for RGMII / Xilinx 7 Series
--  File name        : en_udp_ip_eth_rgmii_alt_c5_qsys.vhd
--  Author           : Christoph Glattfelder
---------------------------------------------------------------------------------------------------
--  Copyright (c) 2016 by Enclustra GmbH, Switzerland
--  All rights reserved.
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- libraries
---------------------------------------------------------------------------------------------------

library ieee;
	use ieee.std_logic_1164.all;

library altera_mf;
	use altera_mf.altera_mf_components.all;

library lib_en_udp_ip_eth_rgmii_alt_c5_eval_qsys;

---------------------------------------------------------------------------------------------------
-- entity
---------------------------------------------------------------------------------------------------

entity en_udp_ip_eth_rgmii_alt_c5_eval_qsys is

	-----------------------------------------------------------------------------------------------
	-- generics
	-----------------------------------------------------------------------------------------------

	generic (
		UdpPortCount_g		: positive		:= 1;
		MaxPayloadSize_g	: positive		:= 2000;
		RxBufferCount_g		: natural		:= 2;

		RoundRobin_g		: boolean		:= true;
		ArpReply_g			: boolean		:= true;
		UseStreamingMode_g	: boolean		:= false;
		TimeoutWidth_g		: positive		:= 12;

		EnableRawEth_g		: boolean		:= false;
		MapRawEthToRb_g		: boolean		:= true;
		RawEthRxBufferCnt_g	: natural		:= 2;
		RawEthTxBufferCnt_g	: natural		:= 2;
		RawEthPayloadSize_g	: positive		:= 2000;
			
		HdrUdpRxSrcPort_g	: boolean		:= false;
		HdrUdpRxDestPort_g	: boolean		:= false;
		HdrUdpRxLength_g	: boolean		:= false;
		HdrUdpRxChkSum_g	: boolean		:= false;
		HdrUdpTxSrcPort_g	: boolean		:= false;
		HdrUdpTxDestPort_g	: boolean		:= false;
		
		HdrIpRxVersion_g	: boolean		:= false;
		HdrIpRxEcnDcsp_g	: boolean		:= false;
		HdrIpRxLength_g		: boolean		:= false;
		HdrIpRxId_g			: boolean		:= false;
		HdrIpRxFragOffset_g	: boolean		:= false;
		HdrIpRxTtl_g		: boolean		:= false;
		HdrIpRxProtocol_g	: boolean		:= false;
		HdrIpRxChkSum_g		: boolean		:= false;
		HdrIpRxSrcAddr_g	: boolean		:= false;
		HdrIpRxDestAddr_g	: boolean		:= false;
		
		HdrIpTxEcnDcsp_g	: boolean		:= false;
		HdrIpTxId_g			: boolean		:= false;
		HdrIpTxFragOffset_g	: boolean		:= false;
		HdrIpTxTtl_g		: boolean		:= false;
		HdrIpTxProtocol_g	: boolean		:= false;
		HdrIpTxSrcAddr_g	: boolean		:= false;
		HdrIpTxDestAddr_g	: boolean		:= false;
		
		HdrEthRxDestMac_g	: boolean		:= false;
		HdrEthRxSrcMac_g	: boolean		:= false;
		HdrEthRxEthType_g	: boolean		:= false;
		
		HdrEthTxDestMac_g	: boolean		:= false;
		HdrEthTxSrcMac_g	: boolean		:= false;
		HdrEthTxEthType_g	: boolean		:= false
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

		Tx0_TDATA			: in	std_logic_vector (7 downto 0) := (others => '0');
		Tx0_TVALID			: in	std_logic := '0';
		Tx0_TLAST			: in	std_logic := '0';
		Tx0_TREADY			: out	std_logic;
		Tx0_TUSER			: in	std_logic_vector (1 downto 0) := (others => '0'); -- 0:Error, 1:Send

		Tx1_TDATA			: in	std_logic_vector (7 downto 0) := (others => '0');
		Tx1_TVALID			: in	std_logic := '0';
		Tx1_TLAST			: in	std_logic := '0';
		Tx1_TREADY			: out	std_logic;
		Tx1_TUSER			: in	std_logic_vector (1 downto 0) := (others => '0'); -- 0:Error, 1:Send

		Tx2_TDATA			: in	std_logic_vector (7 downto 0) := (others => '0');
		Tx2_TVALID			: in	std_logic := '0';
		Tx2_TLAST			: in	std_logic := '0';
		Tx2_TREADY			: out	std_logic;
		Tx2_TUSER			: in	std_logic_vector (1 downto 0) := (others => '0'); -- 0:Error, 1:Send

		Tx3_TDATA			: in	std_logic_vector (7 downto 0) := (others => '0');
		Tx3_TVALID			: in	std_logic := '0';
		Tx3_TLAST			: in	std_logic := '0';
		Tx3_TREADY			: out	std_logic;
		Tx3_TUSER			: in	std_logic_vector (1 downto 0) := (others => '0'); -- 0:Error, 1:Send

		Tx4_TDATA			: in	std_logic_vector (7 downto 0) := (others => '0');
		Tx4_TVALID			: in	std_logic := '0';
		Tx4_TLAST			: in	std_logic := '0';
		Tx4_TREADY			: out	std_logic;
		Tx4_TUSER			: in	std_logic_vector (1 downto 0) := (others => '0'); -- 0:Error, 1:Send

		Tx5_TDATA			: in	std_logic_vector (7 downto 0) := (others => '0');
		Tx5_TVALID			: in	std_logic := '0';
		Tx5_TLAST			: in	std_logic := '0';
		Tx5_TREADY			: out	std_logic;
		Tx5_TUSER			: in	std_logic_vector (1 downto 0) := (others => '0'); -- 0:Error, 1:Send

		Tx6_TDATA			: in	std_logic_vector (7 downto 0) := (others => '0');
		Tx6_TVALID			: in	std_logic := '0';
		Tx6_TLAST			: in	std_logic := '0';
		Tx6_TREADY			: out	std_logic;
		Tx6_TUSER			: in	std_logic_vector (1 downto 0) := (others => '0'); -- 0:Error, 1:Send

		Tx7_TDATA			: in	std_logic_vector (7 downto 0) := (others => '0');
		Tx7_TVALID			: in	std_logic := '0';
		Tx7_TLAST			: in	std_logic := '0';
		Tx7_TREADY			: out	std_logic;
		Tx7_TUSER			: in	std_logic_vector (1 downto 0) := (others => '0'); -- 0:Error, 1:Send
		
		-------------------------------------------------------------------------------------------
		-- user receive data interface ports
		-------------------------------------------------------------------------------------------

		Rx0_TDATA			: out	std_logic_vector (7 downto 0);
		Rx0_TVALID			: out	std_logic;
		Rx0_TREADY			: in	std_logic := '0';
		Rx0_TLAST			: out	std_logic;
		Rx0_TUSER			: out	std_logic; -- Error

		Rx1_TDATA			: out	std_logic_vector (7 downto 0);
		Rx1_TVALID			: out	std_logic;
		Rx1_TREADY			: in	std_logic := '0';
		Rx1_TLAST			: out	std_logic;
		Rx1_TUSER			: out	std_logic; -- Error

		Rx2_TDATA			: out	std_logic_vector (7 downto 0);
		Rx2_TVALID			: out	std_logic;
		Rx2_TREADY			: in	std_logic := '0';
		Rx2_TLAST			: out	std_logic;
		Rx2_TUSER			: out	std_logic; -- Error

		Rx3_TDATA			: out	std_logic_vector (7 downto 0);
		Rx3_TVALID			: out	std_logic;
		Rx3_TREADY			: in	std_logic := '0';
		Rx3_TLAST			: out	std_logic;
		Rx3_TUSER			: out	std_logic; -- Error

		Rx4_TDATA			: out	std_logic_vector (7 downto 0);
		Rx4_TVALID			: out	std_logic;
		Rx4_TREADY			: in	std_logic := '0';
		Rx4_TLAST			: out	std_logic;
		Rx4_TUSER			: out	std_logic; -- Error

		Rx5_TDATA			: out	std_logic_vector (7 downto 0);
		Rx5_TVALID			: out	std_logic;
		Rx5_TREADY			: in	std_logic := '0';
		Rx5_TLAST			: out	std_logic;
		Rx5_TUSER			: out	std_logic; -- Error

		Rx6_TDATA			: out	std_logic_vector (7 downto 0);
		Rx6_TVALID			: out	std_logic;
		Rx6_TREADY			: in	std_logic := '0';
		Rx6_TLAST			: out	std_logic;
		Rx6_TUSER			: out	std_logic; -- Error

		Rx7_TDATA			: out	std_logic_vector (7 downto 0);
		Rx7_TVALID			: out	std_logic;
		Rx7_TREADY			: in	std_logic := '0';
		Rx7_TLAST			: out	std_logic;
		Rx7_TUSER			: out	std_logic; -- Error

		-------------------------------------------------------------------------------------------
		-- Raw Ethernet transmit interface
		-------------------------------------------------------------------------------------------
		
		EthTx_TDATA			: in	std_logic_vector (7 downto 0)  := (others => '0');
		EthTx_TVALID		: in	std_logic := '0';
		EthTx_TREADY		: out	std_logic;
		EthTx_TLAST			: in	std_logic := '0';
		EthTx_TUSER			: in	std_logic := '0'; -- Error
		
		-------------------------------------------------------------------------------------------
		-- Raw Ethernet receive interface
		-------------------------------------------------------------------------------------------
		
		EthRx_TDATA			: out	std_logic_vector (7 downto 0);
		EthRx_TVALID		: out	std_logic;
		EthRx_TREADY		: in	std_logic := '0';
		EthRx_TLAST			: out	std_logic;
		EthRx_TUSER			: out	std_logic; -- Error

		-------------------------------------------------------------------------------------------
		-- AXI4lite slave interface for register bank access
		-------------------------------------------------------------------------------------------

		S_AXI_ACLK    		: in  std_logic;
		S_AXI_ARESETN 		: in  std_logic;
		S_AXI_AWADDR  		: in  std_logic_vector(15 downto 0);
		S_AXI_AWVALID 		: in  std_logic;
		S_AXI_WDATA   		: in  std_logic_vector(31 downto 0);
		S_AXI_WSTRB   		: in  std_logic_vector(3 downto 0);
		S_AXI_WVALID  		: in  std_logic;
		S_AXI_BREADY  		: in  std_logic;
		S_AXI_ARADDR  		: in  std_logic_vector(15 downto 0);
		S_AXI_ARVALID 		: in  std_logic;
		S_AXI_RREADY  		: in  std_logic;
		S_AXI_ARREADY 		: out std_logic;
		S_AXI_RDATA   		: out std_logic_vector(31 downto 0);
		S_AXI_RRESP   		: out std_logic_vector(1 downto 0);
		S_AXI_RVALID  		: out std_logic;
		S_AXI_WREADY  		: out std_logic;
		S_AXI_BRESP   		: out std_logic_vector(1 downto 0);
		S_AXI_BVALID  		: out std_logic;
		S_AXI_AWREADY 		: out std_logic;
		S_AXI_ARPROT		: in std_logic_vector (2 downto 0);
		S_AXI_AWPROT		: in std_logic_vector (2 downto 0);
		
		IntTx				: out std_logic;
		IntRx				: out std_logic;
		
		-------------------------------------------------------------------------------------------
		-- rgmii ports
		-------------------------------------------------------------------------------------------

		Rgmii_RxClk			: in	std_logic;
		Rgmii_RxD			: in	std_logic_vector (3 downto 0);
		Rgmii_RxCtl			: in	std_logic;
		Rgmii_TxClk			: out	std_logic;
		Rgmii_TxD			: out	std_logic_vector (3 downto 0);
		Rgmii_TxCtl			: out	std_logic
		
	);
end;

---------------------------------------------------------------------------------------------------
-- architecture
---------------------------------------------------------------------------------------------------

architecture struct of en_udp_ip_eth_rgmii_alt_c5_eval_qsys is

	-----------------------------------------------------------------------------------------------
	-- functions
	-----------------------------------------------------------------------------------------------

	function toStdLogic (value : boolean) return std_logic is
	begin
		if value then
			return '1';
		else
			return '0';
		end if;
	end;

	-----------------------------------------------------------------------------------------------
	-- constants
	-----------------------------------------------------------------------------------------------

	constant MaxUdpPortCount_c	: natural := 8;

	-- create header masks
	constant UdpRxHdrMask_c		: std_logic_vector (0 to 3)	:= toStdLogic(HdrUdpRxSrcPort_g) &
															   toStdLogic(HdrUdpRxDestPort_g) &
															   toStdLogic(HdrUdpRxLength_g) &
															   toStdLogic(HdrUdpRxChkSum_g);
	constant UdpTxHdrMask_c		: std_logic_vector (0 to 1)	:= toStdLogic(HdrUdpTxSrcPort_g) &
															   toStdLogic(HdrUdpTxDestPort_g);
	constant IpRxHdrMask_c		: std_logic_vector (0 to 9)	:= toStdLogic(HdrIpRxVersion_g) &
															   toStdLogic(HdrIpRxEcnDcsp_g) &
															   toStdLogic(HdrIpRxLength_g) &
															   toStdLogic(HdrIpRxId_g) &
															   toStdLogic(HdrIpRxFragOffset_g) &
															   toStdLogic(HdrIpRxTtl_g) &
															   toStdLogic(HdrIpRxProtocol_g) &
															   toStdLogic(HdrIpRxChkSum_g) &
															   toStdLogic(HdrIpRxSrcAddr_g) &
															   toStdLogic(HdrIpRxDestAddr_g);
	constant IpTxHdrMask_c		: std_logic_vector (0 to 6)	:= toStdLogic(HdrIpTxEcnDcsp_g) &
															   toStdLogic(HdrIpTxId_g) &
															   toStdLogic(HdrIpTxFragOffset_g) &
															   toStdLogic(HdrIpTxTtl_g) &
															   toStdLogic(HdrIpTxProtocol_g) &
															   toStdLogic(HdrIpTxSrcAddr_g) &
															   toStdLogic(HdrIpTxDestAddr_g);
	constant EthRxHdrMask_c		: std_logic_vector (0 to 2)	:= toStdLogic(HdrEthRxDestMac_g) &
															   toStdLogic(HdrEthRxSrcMac_g) &
															   toStdLogic(HdrEthRxEthType_g);
	constant EthTxHdrMask_c		: std_logic_vector (0 to 2)	:= toStdLogic(HdrEthTxDestMac_g) &
															   toStdLogic(HdrEthTxSrcMac_g) &
															   toStdLogic(HdrEthTxEthType_g);


	-----------------------------------------------------------------------------------------------
	--  signals
	-----------------------------------------------------------------------------------------------

	-- reset
	signal Rst_Rx				: std_logic;
	signal RstRxChain			: std_logic_vector (2 downto 0);
	attribute keep : string;
	attribute keep of RstRxChain : signal is "true";		

	-- udp interfaces
	signal Tx_Data				: std_logic_vector (MaxUdpPortCount_c*8-1 downto 0);
	signal Tx_Vld				: std_logic_vector (MaxUdpPortCount_c-1 downto 0);
	signal Tx_Lst				: std_logic_vector (MaxUdpPortCount_c-1 downto 0);
	signal Tx_Rdy				: std_logic_vector (MaxUdpPortCount_c-1 downto 0);
	signal Tx_Err				: std_logic_vector (MaxUdpPortCount_c-1 downto 0);
	signal Tx_Snd				: std_logic_vector (MaxUdpPortCount_c-1 downto 0);

	signal Rx_Data				: std_logic_vector (MaxUdpPortCount_c*8-1 downto 0);
	signal Rx_Vld				: std_logic_vector (MaxUdpPortCount_c-1 downto 0);
	signal Rx_Rdy				: std_logic_vector (MaxUdpPortCount_c-1 downto 0);
	signal Rx_Lst				: std_logic_vector (MaxUdpPortCount_c-1 downto 0);
	signal Rx_Err				: std_logic_vector (MaxUdpPortCount_c-1 downto 0);

	-- rgmii	
	signal Rgmii_RxD_Reg		: std_logic_vector (7 downto 0);
	signal Rgmii_RxCtl_Reg		: std_logic_vector (1 downto 0);
	signal Rgmii_TxClk_Next		: std_logic_vector (1 downto 0);
	signal Rgmii_TxD_Next		: std_logic_vector (7 downto 0);
	signal Rgmii_TxCtl_Next		: std_logic_vector (1 downto 0);

	-- header interface
	signal Hdr_MacSrc			: std_logic_vector (47 downto 0);
	signal Hdr_MacDst			: std_logic_vector (UdpPortCount_g*48-1 downto 0);
	signal Hdr_IpSrc			: std_logic_vector (31 downto 0);
	signal Hdr_IpDst			: std_logic_vector (UdpPortCount_g*32-1 downto 0);
	signal Hdr_IpDscp			: std_logic_vector (7  downto 0);
	signal Hdr_IpId				: std_logic_vector (15 downto 0);
	signal Hdr_IpFlags			: std_logic_vector (2  downto 0);
	signal Hdr_IpTtl			: std_logic_vector (7  downto 0);
	signal Hdr_UdpTxSrc			: std_logic_vector (UdpPortCount_g*16-1 downto 0);
	signal Hdr_UdpTxDst			: std_logic_vector (UdpPortCount_g*16-1 downto 0);
	signal Hdr_UdpRxPort		: std_logic_vector (UdpPortCount_g*16-1 downto 0);
	signal Hdr_UdpRxPortMask	: std_logic_vector (UdpPortCount_g*16-1 downto 0);
	signal Hdr_RawEthMac		: std_logic_vector (47 downto 0); -- MAC addr for raw Ethernet

	-- configuration interface
	signal Cfg_TxEn				: std_logic;
	signal Cfg_RxEn				: std_logic;
	signal Cfg_CheckRawEthMac	: std_logic;
	signal Cfg_CheckMac			: std_logic;
	signal Cfg_CheckIp			: std_logic;
	signal Cfg_CheckUdp			: std_logic;
	signal Cfg_MTU				: std_logic_vector (UdpPortCount_g*14-1 downto 0);
	signal Cfg_Timeout			: std_logic_vector (TimeoutWidth_g-1 downto 0);

	-- raw ethernet port
	signal EthTx_Data			: std_logic_vector (7 downto 0);
	signal EthTx_Vld			: std_logic;
	signal EthTx_Rdy			: std_logic;
	signal EthTx_Lst			: std_logic;
	signal EthTx_Err			: std_logic;

	signal EthRx_Data			: std_logic_vector (7 downto 0);
	signal EthRx_Vld			: std_logic;
	signal EthRx_Rdy			: std_logic;
	signal EthRx_Lst			: std_logic;
	signal EthRx_Err			: std_logic;

	-- raw Ethernet from register bank
	signal EthTx_Data_Rb		: std_logic_vector (7 downto 0);
	signal EthTx_Vld_Rb			: std_logic;
	signal EthTx_Rdy_Rb			: std_logic;
	signal EthTx_Lst_Rb			: std_logic;
	signal EthTx_Err_Rb			: std_logic;

	signal EthRx_Data_Rb		: std_logic_vector (7 downto 0);
	signal EthRx_Vld_Rb			: std_logic;
	signal EthRx_Rdy_Rb			: std_logic;
	signal EthRx_Lst_Rb			: std_logic;
	signal EthRx_Err_Rb			: std_logic;

	signal Version				: std_logic_vector (31 downto 0);

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

	i_core : entity lib_en_udp_ip_eth_rgmii_alt_c5_eval_qsys.en_udp_ip_eth_rgmii

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
			UdpRxHdrMask_g		=> UdpRxHdrMask_c,
			UdpTxHdrMask_g		=> UdpTxHdrMask_c,
			IpRxHdrMask_g		=> IpRxHdrMask_c,
			IpTxHdrMask_g		=> IpTxHdrMask_c,
			EthRxHdrMask_g		=> EthRxHdrMask_c,
			EthTxHdrMask_g		=> EthTxHdrMask_c
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

			Tx_Data				=> Tx_Data(UdpPortCount_g*8-1 downto 0),
			Tx_Vld				=> Tx_Vld(UdpPortCount_g-1 downto 0),
			Tx_Lst				=> Tx_Lst(UdpPortCount_g-1 downto 0),
			Tx_Rdy				=> Tx_Rdy(UdpPortCount_g-1 downto 0),
			Tx_Err				=> Tx_Err(UdpPortCount_g-1 downto 0),
			Tx_Snd				=> Tx_Snd(UdpPortCount_g-1 downto 0),

			---------------------------------------------------------------------------------------
			-- user receive data interface ports
			---------------------------------------------------------------------------------------

			Rx_Data				=> Rx_Data(UdpPortCount_g*8-1 downto 0),
			Rx_Vld				=> Rx_Vld(UdpPortCount_g-1 downto 0),
			Rx_Rdy				=> Rx_Rdy(UdpPortCount_g-1 downto 0),
			Rx_Lst				=> Rx_Lst(UdpPortCount_g-1 downto 0),
			Rx_Err				=> Rx_Err(UdpPortCount_g-1 downto 0),

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
		
	-----------------------------------------------------------------------------------------------
	-- signal mapping
	-----------------------------------------------------------------------------------------------
	
	Tx_Data		<= Tx7_TDATA & Tx6_TDATA & Tx5_TDATA & Tx4_TDATA & Tx3_TDATA & Tx2_TDATA & Tx1_TDATA & Tx0_TDATA;
	Tx_Vld		<= Tx7_TVALID & Tx6_TVALID & Tx5_TVALID & Tx4_TVALID & Tx3_TVALID & Tx2_TVALID & Tx1_TVALID & Tx0_TVALID;
	Tx_Lst		<= Tx7_TLAST & Tx6_TLAST & Tx5_TLAST & Tx4_TLAST & Tx3_TLAST & Tx2_TLAST & Tx1_TLAST & Tx0_TLAST;
	Tx_Err		<= Tx7_TUSER(0) & Tx6_TUSER(0) & Tx5_TUSER(0) & Tx4_TUSER(0) & Tx3_TUSER(0) & Tx2_TUSER(0) & Tx1_TUSER(0) & Tx0_TUSER(0);
	Tx_Snd		<= Tx7_TUSER(1) & Tx6_TUSER(1) & Tx5_TUSER(1) & Tx4_TUSER(1) & Tx3_TUSER(1) & Tx2_TUSER(1) & Tx1_TUSER(1) & Tx0_TUSER(1);

	Tx0_TREADY	<= Tx_Rdy(0) when UdpPortCount_g > 0 else '0';
	Tx1_TREADY	<= Tx_Rdy(1) when UdpPortCount_g > 1 else '0';
	Tx2_TREADY	<= Tx_Rdy(2) when UdpPortCount_g > 2 else '0';
	Tx3_TREADY	<= Tx_Rdy(3) when UdpPortCount_g > 3 else '0';
	Tx4_TREADY	<= Tx_Rdy(4) when UdpPortCount_g > 4 else '0';
	Tx5_TREADY	<= Tx_Rdy(5) when UdpPortCount_g > 5 else '0';
	Tx6_TREADY	<= Tx_Rdy(6) when UdpPortCount_g > 6 else '0';
	Tx7_TREADY	<= Tx_Rdy(7) when UdpPortCount_g > 7 else '0';
	
	Rx0_TDATA	<= Rx_Data(7 downto 0) when UdpPortCount_g > 0 else X"00";
	Rx0_TVALID	<= Rx_Vld(0) when UdpPortCount_g > 0 else '0';
	Rx0_TLAST	<= Rx_Lst(0) when UdpPortCount_g > 0 else '0';
	Rx0_TUSER	<= Rx_Err(0) when UdpPortCount_g > 0 else '0';
	
	Rx1_TDATA	<= Rx_Data(15 downto 8) when UdpPortCount_g > 1 else X"00";
	Rx1_TVALID	<= Rx_Vld(1) when UdpPortCount_g > 1 else '0';
	Rx1_TLAST	<= Rx_Lst(1) when UdpPortCount_g > 1 else '0';
	Rx1_TUSER	<= Rx_Err(1) when UdpPortCount_g > 1 else '0';

	Rx2_TDATA	<= Rx_Data(23 downto 16) when UdpPortCount_g > 2 else X"00";
	Rx2_TVALID	<= Rx_Vld(2) when UdpPortCount_g > 2 else '0';
	Rx2_TLAST	<= Rx_Lst(2) when UdpPortCount_g > 2 else '0';
	Rx2_TUSER	<= Rx_Err(2) when UdpPortCount_g > 2 else '0';

	Rx3_TDATA	<= Rx_Data(31 downto 24) when UdpPortCount_g > 3 else X"00";
	Rx3_TVALID	<= Rx_Vld(3) when UdpPortCount_g > 3 else '0';
	Rx3_TLAST	<= Rx_Lst(3) when UdpPortCount_g > 3 else '0';
	Rx3_TUSER	<= Rx_Err(3) when UdpPortCount_g > 3 else '0';

	Rx4_TDATA	<= Rx_Data(39 downto 32) when UdpPortCount_g > 4 else X"00";
	Rx4_TVALID	<= Rx_Vld(4) when UdpPortCount_g > 4 else '0';
	Rx4_TLAST	<= Rx_Lst(4) when UdpPortCount_g > 4 else '0';
	Rx4_TUSER	<= Rx_Err(4) when UdpPortCount_g > 4 else '0';

	Rx5_TDATA	<= Rx_Data(47 downto 40) when UdpPortCount_g > 5 else X"00";
	Rx5_TVALID	<= Rx_Vld(5) when UdpPortCount_g > 5 else '0';
	Rx5_TLAST	<= Rx_Lst(5) when UdpPortCount_g > 5 else '0';
	Rx5_TUSER	<= Rx_Err(5) when UdpPortCount_g > 5 else '0';

	Rx6_TDATA	<= Rx_Data(55 downto 48) when UdpPortCount_g > 6 else X"00";
	Rx6_TVALID	<= Rx_Vld(6) when UdpPortCount_g > 6 else '0';
	Rx6_TLAST	<= Rx_Lst(6) when UdpPortCount_g > 6 else '0';
	Rx6_TUSER	<= Rx_Err(6) when UdpPortCount_g > 6 else '0';

	Rx7_TDATA	<= Rx_Data(63 downto 56) when UdpPortCount_g > 7 else X"00";
	Rx7_TVALID	<= Rx_Vld(7) when UdpPortCount_g > 7 else '0';
	Rx7_TLAST	<= Rx_Lst(7) when UdpPortCount_g > 7 else '0';
	Rx7_TUSER	<= Rx_Err(7) when UdpPortCount_g > 7 else '0';

	Rx_Rdy		<= Rx7_TREADY & Rx6_TREADY & Rx5_TREADY & Rx4_TREADY & Rx3_TREADY & Rx2_TREADY & Rx1_TREADY & Rx0_TREADY;
		
	-- map raw Ethernet port to AXI Stream or register bank
	EthTx_Data		<= EthTx_Data_rb when MapRawEthToRb_g else EthTx_TDATA;
	EthTx_Vld		<= EthTx_Vld_rb when MapRawEthToRb_g else EthTx_TVALID;
	EthTx_Lst		<= EthTx_Lst_rb when MapRawEthToRb_g else EthTx_TLAST;
	EthTx_Err		<= EthTx_Err_rb when MapRawEthToRb_g else EthTx_TUSER;
	EthTx_TREADY	<= '0' when MapRawEthToRb_g else EthTx_Rdy;
	EthTx_Rdy_rb	<= EthTx_Rdy when MapRawEthToRb_g else '0';

	EthRx_TDATA		<= EthRx_Data when not MapRawEthToRb_g else X"00";
	EthRx_TVALID	<= EthRx_Vld when not MapRawEthToRb_g else '0';
	EthRx_TLAST		<= EthRx_Lst when not MapRawEthToRb_g else '0';
	EthRx_TUSER		<= EthRx_Err when not MapRawEthToRb_g else '0';
	
	EthRx_Data_rb	<= EthRx_Data when MapRawEthToRb_g else X"00";
	EthRx_Vld_rb	<= EthRx_Vld when MapRawEthToRb_g else '0';
	EthRx_Lst_rb	<= EthRx_Lst when MapRawEthToRb_g else '0';
	EthRx_Err_rb	<= EthRx_Err when MapRawEthToRb_g else '0';
	EthRx_Rdy		<= EthRx_Rdy_rb when MapRawEthToRb_g else EthRx_TREADY;	
	
	-----------------------------------------------------------------------------------------------
	-- register bank
	-----------------------------------------------------------------------------------------------
	
	i_rb : entity lib_en_udp_ip_eth_rgmii_alt_c5_eval_qsys.en_udp_ip_eth_axi_rb
		generic map (
			C_S_AXI_ADDR_WIDTH	=> 16,
			UdpPortCount_g		=> UdpPortCount_g,
			TimeoutWidth_g		=> TimeoutWidth_g
		)
		port map (
			-- system clock and synchronous reset
			Clk					=> Clk,
			Rst					=> Rst,

			-- AXI4lite slave interface
			S_AXI_ACLK    		=> S_AXI_ACLK,
			S_AXI_ARESETN 		=> S_AXI_ARESETN,
			S_AXI_AWADDR  		=> S_AXI_AWADDR,
			S_AXI_AWVALID 		=> S_AXI_AWVALID,
			S_AXI_WDATA   		=> S_AXI_WDATA,
			S_AXI_WSTRB   		=> S_AXI_WSTRB,
			S_AXI_WVALID  		=> S_AXI_WVALID,
			S_AXI_BREADY  		=> S_AXI_BREADY,
			S_AXI_ARADDR  		=> S_AXI_ARADDR,
			S_AXI_ARVALID 		=> S_AXI_ARVALID,
			S_AXI_RREADY  		=> S_AXI_RREADY,
			S_AXI_ARREADY 		=> S_AXI_ARREADY,
			S_AXI_RDATA   		=> S_AXI_RDATA,
			S_AXI_RRESP   		=> S_AXI_RRESP,
			S_AXI_RVALID  		=> S_AXI_RVALID,
			S_AXI_WREADY  		=> S_AXI_WREADY,
			S_AXI_BRESP   		=> S_AXI_BRESP,
			S_AXI_BVALID  		=> S_AXI_BVALID,
			S_AXI_AWREADY 		=> S_AXI_AWREADY,

			IntTx				=> IntTx,
			IntRx				=> IntRx,

			-- header interface
			Hdr_MacSrc			=> Hdr_MacSrc,
			Hdr_MacDst			=> Hdr_MacDst,
			Hdr_IpSrc			=> Hdr_IpSrc,
			Hdr_IpDst			=> Hdr_IpDst,
			Hdr_IpDscp			=> Hdr_IpDscp,
			Hdr_IpId			=> Hdr_IpId,
			Hdr_IpFlags			=> Hdr_IpFlags,
			Hdr_IpTtl			=> Hdr_IpTtl,
			Hdr_UdpTxSrc		=> Hdr_UdpTxSrc,
			Hdr_UdpTxDst		=> Hdr_UdpTxDst,
			Hdr_UdpRxPort		=> Hdr_UdpRxPort,
			Hdr_UdpRxPortMask	=> Hdr_UdpRxPortMask,
			Hdr_RawEthMac		=> Hdr_RawEthMac,

			-- configuration interface
			Cfg_TxEn			=> Cfg_TxEn,
			Cfg_RxEn			=> Cfg_RxEn,
			Cfg_CheckRawEthMac	=> Cfg_CheckRawEthMac,
			Cfg_CheckMac		=> Cfg_CheckMac,
			Cfg_CheckIp			=> Cfg_CheckIp,
			Cfg_CheckUdp		=> Cfg_CheckUdp,
			Cfg_MTU				=> Cfg_MTU,
			Cfg_Timeout			=> Cfg_Timeout,

			-- raw Ethernet
			EthTx_Data			=> EthTx_Data_rb,
			EthTx_Vld			=> EthTx_Vld_rb,
			EthTx_Rdy			=> EthTx_Rdy_rb,
			EthTx_Lst			=> EthTx_Lst_rb,
			EthTx_Err			=> EthTx_Err_rb,

			EthRx_Data			=> EthRx_Data_rb,
			EthRx_Vld			=> EthRx_Vld_rb,
			EthRx_Rdy			=> EthRx_Rdy_rb,
			EthRx_Lst			=> EthRx_Lst_rb,
			EthRx_Err			=> EthRx_Err_rb,

			-- Version
			Version				=> Version
		);
	
end;

---------------------------------------------------------------------------------------------------
-- eof
---------------------------------------------------------------------------------------------------

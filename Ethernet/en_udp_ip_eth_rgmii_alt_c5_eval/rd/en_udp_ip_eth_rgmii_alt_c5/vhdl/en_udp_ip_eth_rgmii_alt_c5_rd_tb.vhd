---------------------------------------------------------------------------------------------------
--  Project          : Enclustra UDP/IP/ETH Core
--  File description : Test Bench for Reference Design for RGMII / Altera Cyclone V
--  File name        : en_udp_ip_eth_rgmii_alt_c5_rd_tb.vhd
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
	use ieee.numeric_std.all;

library en_udp_ip_eth_rgmii_alt_c5_eval_cl;
	use en_udp_ip_eth_rgmii_alt_c5_eval_cl.en_cl_base_pkg.all;

library lib_en_udp_ip_eth_rgmii_alt_c5_eval;

library work;
	use work.txt_util.all;
	
---------------------------------------------------------------------------------------------------
-- entity declaration
---------------------------------------------------------------------------------------------------

entity en_udp_ip_eth_rgmii_alt_c5_rd_tb is
end;

---------------------------------------------------------------------------------------------------
-- architecture implementation
---------------------------------------------------------------------------------------------------

architecture behavioral of en_udp_ip_eth_rgmii_alt_c5_rd_tb is

	-----------------------------------------------------------------------------------------------
	-- constants
	-----------------------------------------------------------------------------------------------

	-- core configuration
	constant UdpPortCount_c			: positive					:= 1;
	constant MaxPayloadSize_c		: positive					:= 2000;
	constant RxBufferCount_c		: natural					:= 2;
	constant EnableRawEth_c			: boolean					:= true;
	constant RawEthRxBufferCnt_c	: natural					:= 2;
	constant RawEthTxBufferCnt_c	: natural					:= 0;
	constant RawEthPayloadSize_c	: positive					:= 2048;
	constant TimeoutWidth_c			: positive					:= 12;
	constant RoundRobin_c			: boolean					:= true;
	constant ArpReply_c				: boolean					:= true;
	constant UseStreamingMode_c		: boolean					:= false;
	constant UdpRxHdrMask_c			: std_logic_vector (0 to 3)	:= "0000";
	constant UdpTxHdrMask_c			: std_logic_vector (0 to 1)	:= "00";
	constant IpRxHdrMask_c			: std_logic_vector (0 to 9)	:= "0000000000";
	constant IpTxHdrMask_c			: std_logic_vector (0 to 6)	:= "0000000";
	constant EthRxHdrMask_c			: std_logic_vector (0 to 2)	:= "000";
	constant EthTxHdrMask_c			: std_logic_vector (0 to 2)	:= "000";

	-- 125 mhz clock
	constant Clk125MHzStartTime_c	: time		:=   0.000 ns;
	constant Clk125MHzPhaseHigh_c	: time		:=   4.000 ns;
	constant Clk125MHzPhaseLow_c	: time		:=   4.000 ns;
	constant Clk125MHzStimAppTime_c	: time		:=   1.000 ns;
	constant Clk125MHzRespAcqTime_c	: time		:=   7.000 ns;

	-- udp test packet
	constant TestPacketData_c		: StdLogicArray8_t (0 to 7)
		:= (0 => X"D0", 1 => X"D1", 2 => X"D2", 3 => X"D3", 
			4 => X"D4", 5 => X"D5", 6 => X"D6", 7 => X"D7");
	constant TestPacketLength_c		: natural
		:= 8;

	-----------------------------------------------------------------------------------------------
	-- procedures
	-----------------------------------------------------------------------------------------------

	-- udp send
	procedure udp_tx (
				TxData			: in	StdLogicArray8_t (0 to 7)		;
				ByteCount		: in	natural							;
				StimAppTime		: in	time							;
		signal	Clk				: in	std_logic						;
		signal	Tx_Data			: out	std_logic_vector (7 downto 0)	;
		signal	Tx_Vld			: out	std_logic						;
		signal	Tx_Rdy			: in	std_logic						;
		signal	Tx_Lst			: out	std_logic						
	) is
	begin
	
		wait until rising_edge (Clk);
		wait for StimAppTime;
		for i in 0 to ByteCount-1 loop
			Tx_Data <= TxData (i);
			Tx_Vld <= '1';
			if i = ByteCount-1 then
				Tx_Lst <= '1';
			else
				Tx_Lst <= '0';
			end if;
			wait until rising_edge (Clk);
			wait for StimAppTime;
			while Tx_Rdy = '0' loop
				wait until rising_edge (Clk);
				wait for StimAppTime;
			end loop;
		end loop;
		Tx_Data <= (others => '0');
		Tx_Vld <= '0';
		Tx_Lst <= '0';
	
	end procedure udp_tx;
		
	-----------------------------------------------------------------------------------------------
	-- internal testbench signals
	-----------------------------------------------------------------------------------------------

	-- simulation control
	signal TbRunning 			: boolean 						:= false;
	signal ClkRunning			: boolean 						:= false;
	signal TestcaseNr 			: natural						:= 0;
	signal Cfg_BitRate			: std_logic_vector (1 downto 0)	:= "11";
	
	-----------------------------------------------------------------------------------------------
	-- dut signals
	-----------------------------------------------------------------------------------------------

	signal Clk2_5				: std_logic						:= '0';
	signal Clk25				: std_logic						:= '0';
	signal Clk125				: std_logic						:= '0';
	signal RstIn_N				: std_logic						:= '0';
	signal Led_N				: std_logic_vector (1 downto 0)	:= (others => '1');
	signal Eth_Rst_N			: std_logic						:= '1';

	-----------------------------------------------------------------------------------------------
	-- rgmii signals
	-----------------------------------------------------------------------------------------------

	signal PcRgmii_RxClk		: std_logic						:= '0';
	signal PcRgmii_RxD			: std_logic_vector (3 downto 0)	:= (others => '0');
	signal PcRgmii_RxCtl		: std_logic						:= '0';
	signal PcRgmii_TxClk		: std_logic						:= '0';
	signal PcRgmii_TxD			: std_logic_vector (3 downto 0)	:= (others => '0');
	signal PcRgmii_TxCtl		: std_logic						:= '0';

	signal DutRgmii_RxClk		: std_logic						:= '0';
	signal DutRgmii_RxD			: std_logic_vector (3 downto 0)	:= (others => '0');
	signal DutRgmii_RxCtl		: std_logic						:= '0';
	signal DutRgmii_TxClk		: std_logic						:= '0';
	signal DutRgmii_TxD			: std_logic_vector (3 downto 0)	:= (others => '0');
	signal DutRgmii_TxCtl		: std_logic						:= '0';

	-----------------------------------------------------------------------------------------------
	-- host pc emulator signals
	-----------------------------------------------------------------------------------------------

	-- reset
	signal Rst					: std_logic						:= '1';

	-- transmit interface
	signal Tx_Data				: std_logic_vector (7 downto 0)	:= (others => '0');
	signal Tx_Vld				: std_logic_vector (0 downto 0)	:= (others => '0');
	signal Tx_Rdy				: std_logic_vector (0 downto 0)	:= (others => '1');
	signal Tx_Lst				: std_logic_vector (0 downto 0)	:= (others => '0');
	signal Tx_Err				: std_logic_vector (0 downto 0)	:= (others => '0');
	signal Tx_Snd				: std_logic_vector (0 downto 0)	:= (others => '0');

	-- receive interface
	signal Rx_Data				: std_logic_vector (7 downto 0)	:= (others => '0');
	signal Rx_Vld				: std_logic_vector (0 downto 0)	:= (others => '0');
	signal Rx_Rdy				: std_logic_vector (0 downto 0)	:= (others => '1');
	signal Rx_Lst				: std_logic_vector (0 downto 0)	:= (others => '0');
	signal Rx_Err				: std_logic_vector (0 downto 0)	:= (others => '0');

	signal EthRx_Data			: std_logic_vector (7 downto 0);
	signal EthRx_Vld			: std_logic;
	signal EthRx_Lst			: std_logic;
	signal EthRx_Err			: std_logic;

	-- mdi
	signal PcMdi_TxD			: std_logic_vector (9 downto 0);
	signal PcMdi_TxVld			: std_logic;
	signal PcMdi_TxRdy			: std_logic;
	signal PcMdi_RxD			: std_logic_vector (9 downto 0);
	signal PcMdi_RxVld			: std_logic;
	signal PcMdi_RxRdy			: std_logic;

	-- header interface 
	signal Hdr_IpDst			: std_logic_vector (31 downto 0) := (others => '0');

	-- Frame counter
	signal UdpTxCnt				: integer := 0;
	signal RawEthTxCnt			: integer := 0;
	signal UdpRxCnt				: integer := 0;
	signal RawEthRxCnt			: integer := 0;

begin

	-----------------------------------------------------------------------------------------------
	-- host pc emulator udp core
	-----------------------------------------------------------------------------------------------

	Rst <= not RstIn_N;
	i_pc : entity lib_en_udp_ip_eth_rgmii_alt_c5_eval.en_udp_ip_eth_rgmii_alt_c5

		-------------------------------------------------------------------------------------------
		-- generics
		-------------------------------------------------------------------------------------------

		generic map (
			UdpPortCount_g		=> UdpPortCount_c,
			MaxPayloadSize_g	=> MaxPayloadSize_c,
			RxBufferCount_g		=> RxBufferCount_c,
			EnableRawEth_g		=> EnableRawEth_c,
			RawEthRxBufferCnt_g	=> RawEthRxBufferCnt_c,
			RawEthTxBufferCnt_g	=> RawEthTxBufferCnt_c,
			RawEthPayloadSize_g	=> RawEthPayloadSize_c,
			TimeoutWidth_g		=> TimeoutWidth_c,
			RoundRobin_g		=> RoundRobin_c,
			ArpReply_g			=> ArpReply_c,
			UseStreamingMode_g	=> UseStreamingMode_c,
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

			Clk					=> Clk125,
			Rst					=> Rst,

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

			-------------------------------------------------------------------------------------------
			-- Raw Ethernet transmit interface
			-------------------------------------------------------------------------------------------

			EthTx_Data			=> X"00",
			EthTx_Vld			=> '0',
			EthTx_Rdy			=> open,
			EthTx_Lst			=> '0',
			EthTx_Err			=> '0',

			-------------------------------------------------------------------------------------------
			-- Raw Ethernet receive interface
			-------------------------------------------------------------------------------------------

			EthRx_Data			=> EthRx_Data,
			EthRx_Vld			=> EthRx_Vld,
			EthRx_Rdy			=> '1',
			EthRx_Lst			=> EthRx_Lst,
			EthRx_Err			=> EthRx_Err,

			---------------------------------------------------------------------------------------
			-- user header interface ports
			---------------------------------------------------------------------------------------

			Hdr_UdpTxSrc		=> std_logic_vector (to_unsigned (50101,16)),
			Hdr_UdpTxDst		=> std_logic_vector (to_unsigned (50100,16)),
			Hdr_UdpRxPort		=> std_logic_vector (to_unsigned (50101,16)),
			Hdr_UdpRxPortMask	=> X"FFFF",
			Hdr_IpSrc			=> X"10_00_00_C8", -- 16.0.0.200
			Hdr_IpDst			=> Hdr_IpDst,
			Hdr_IpDscp			=> X"00",
			Hdr_IpId			=> X"0000",
			Hdr_IpFlags			=> "010",
			Hdr_IpTtl			=> X"FF",
			Hdr_MacSrc			=> X"01_23_45_67_89_AB",
			Hdr_MacDst			=> X"40_00_00_00_00_01",
			Hdr_RawEthMac		=> X"00_00_00_00_00_00",

			---------------------------------------------------------------------------------------
			-- user configuration interface ports
			---------------------------------------------------------------------------------------

			Cfg_TxEn			=> '1',
			Cfg_RxEn			=> '1',
			Cfg_CheckRawEthMac	=> '0',
			Cfg_CheckMac		=> '1',
			Cfg_CheckIp			=> '1',
			Cfg_CheckUdp		=> '1',
			Cfg_MTU				=> std_logic_vector (to_unsigned (0, 14)), -- not used because of packet mode
			Cfg_Timeout			=> std_logic_vector (to_unsigned (0, 12)), -- not used because of packet mode

			---------------------------------------------------------------------------------------
			-- RGMII ports
			---------------------------------------------------------------------------------------

			Rgmii_RxClk			=> PcRgmii_RxClk,
			Rgmii_RxD			=> PcRgmii_RxD,
			Rgmii_RxCtl			=> PcRgmii_RxCtl,
			Rgmii_TxClk			=> PcRgmii_TxClk,
			Rgmii_TxD			=> PcRgmii_TxD,
			Rgmii_TxCtl			=> PcRgmii_TxCtl

		);	

	-----------------------------------------------------------------------------------------------
	-- host pc emulator phy model
	-----------------------------------------------------------------------------------------------

	i_phy_pc : entity en_udp_ip_eth_rgmii_alt_c5_eval_cl.en_cl_rgmii_trispeed_phy_mdl
		port map (

			-- 125 MHz clock and synchronous reset interface
			Clk125		=> Clk125,
			Rst125		=> Rst,

			-- bit rate config (0: no clock, 1: 10 Mbit/s, 2: 100 Mbit/s, 3: 1000 Mbit/s)
			Cfg_BitRate	=> Cfg_BitRate,

			-- rgmii interface
			Rgmii_TxClk	=> PcRgmii_TxClk ,
			Rgmii_TxD	=> PcRgmii_TxD,
			Rgmii_TxCtl	=> PcRgmii_TxCtl,
			Rgmii_RxClk	=> PcRgmii_RxClk,
			Rgmii_RxD	=> PcRgmii_RxD,
			Rgmii_RxCtl	=> PcRgmii_RxCtl,

			-- media dependent interface emulation, synchronous to Clk125
			Mdi_TxD		=> PcMdi_TxD,
			Mdi_TxVld	=> PcMdi_TxVld,
			Mdi_TxRdy	=> PcMdi_TxRdy,
			Mdi_RxD		=> PcMdi_RxD,
			Mdi_RxVld	=> PcMdi_RxVld,
			Mdi_RxRdy	=> PcMdi_RxRdy
		);

	-----------------------------------------------------------------------------------------------
	-- device under test (dut) phy model
	-----------------------------------------------------------------------------------------------

	i_phy_dut : entity en_udp_ip_eth_rgmii_alt_c5_eval_cl.en_cl_rgmii_trispeed_phy_mdl
		port map (

			-- 125 MHz clock and synchronous reset interface
			Clk125		=> Clk125,
			Rst125		=> Rst,

			-- bit rate config (0: no clock, 1: 10 Mbit/s, 2: 100 Mbit/s, 3: 1000 Mbit/s)
			Cfg_BitRate	=> Cfg_BitRate,

			-- rgmii interface
			Rgmii_TxClk	=> DutRgmii_TxClk ,
			Rgmii_TxD	=> DutRgmii_TxD,
			Rgmii_TxCtl	=> DutRgmii_TxCtl,
			Rgmii_RxClk	=> DutRgmii_RxClk,
			Rgmii_RxD	=> DutRgmii_RxD,
			Rgmii_RxCtl	=> DutRgmii_RxCtl,

			-- media dependent interface emulation, synchronous to Clk125
			Mdi_TxD		=> PcMdi_RxD,
			Mdi_TxVld	=> PcMdi_RxVld,
			Mdi_TxRdy	=> PcMdi_RxRdy,
			Mdi_RxD		=> PcMdi_TxD,
			Mdi_RxVld	=> PcMdi_TxVld,
			Mdi_RxRdy	=> PcMdi_TxRdy
		);
		
	-----------------------------------------------------------------------------------------------
	-- device under test (dut)
	-----------------------------------------------------------------------------------------------

	i_dut : entity work.en_udp_ip_eth_rgmii_alt_c5_rd
	
		-------------------------------------------------------------------------------------------
		-- generics
		-------------------------------------------------------------------------------------------

		generic map (
			Simulation_g	=> true
		)

		-------------------------------------------------------------------------------------------
		-- ports
		-------------------------------------------------------------------------------------------

		port map (

			---------------------------------------------------------------------------------------
			-- clock input (125 MHz) 
			---------------------------------------------------------------------------------------

			Clk125			=> Clk125,

			---------------------------------------------------------------------------------------
			-- reset input (active-low)
			---------------------------------------------------------------------------------------
			
			RstIn_N			=> RstIn_N,

			---------------------------------------------------------------------------------------
			-- ethernet phy reset output (active-low)
			---------------------------------------------------------------------------------------

			Eth_Rst_N		=> Eth_Rst_N,

			---------------------------------------------------------------------------------------
			-- led outputs (active-low, led 0: traffic, led 1: continuously blinking)
			---------------------------------------------------------------------------------------
			
			Led_N			=> Led_N,

			---------------------------------------------------------------------------------------
			-- rgmii interface
			---------------------------------------------------------------------------------------

			Rgmii_RxClk			=> DutRgmii_RxClk,
			Rgmii_RxD			=> DutRgmii_RxD,
			Rgmii_RxCtl			=> DutRgmii_RxCtl,
			Rgmii_TxClk			=> DutRgmii_TxClk,
			Rgmii_TxD			=> DutRgmii_TxD,
			Rgmii_TxCtl			=> DutRgmii_TxCtl
		);
	

	
	-----------------------------------------------------------------------------------------------
	-- clock generation
	-----------------------------------------------------------------------------------------------

	clk_125_gen : process
	begin
		wait until TbRunning;
		wait for Clk125MHzStartTime_c;
		while TbRunning loop
			if ClkRunning then
				Clk125 <= '1';
				wait for Clk125MHzPhaseHigh_c;
				Clk125 <= '0';
				wait for Clk125MHzPhaseLow_c;
			else
				wait for Clk125MHzPhaseHigh_c;
				wait for Clk125MHzPhaseLow_c;
				Clk125 <= '0';
			end if;
	  	end loop;
	  	wait;
	end process clk_125_gen;

	-----------------------------------------------------------------------------------------------
	-- RX packet counter
	-----------------------------------------------------------------------------------------------

	process (Clk125)
	begin
		if rising_edge (Clk125) then
			if Rst = '1' then
				UdpRxCnt	<= 0;
				RawEthRxCnt	<= 0;
			else
				if (Rx_Vld(0) and Rx_Rdy(0) and Rx_Lst(0)) = '1' and Rx_Err(0) = '0' then
					UdpRxCnt <= UdpRxCnt + 1;
				end if;
				if (EthRx_Vld and EthRx_Lst) = '1' and EthRx_Err = '0' then
					RawEthRxCnt <= RawEthRxCnt + 1;
				end if;
			end if;
		end if;
	end process;

	-----------------------------------------------------------------------------------------------
	-- stimuli application
	-----------------------------------------------------------------------------------------------

	stim_app : process
	
		-------------------------------------------------------------------------------------------
		-- variables
		-------------------------------------------------------------------------------------------
		
		variable ErrorCount_v	: natural	:= 0;
	
	begin

		-------------------------------------------------------------------------------------------
		-- start simulation
		-------------------------------------------------------------------------------------------

		TestcaseNr <= 0;

		-- start simulation;
		TbRunning <= true;

		-- start clocks;
		ClkRunning <= true;

		-- wait
		wait for 50 ns;

		-- user message
		print("### NOTE: simulation started");

		-------------------------------------------------------------------------------------------
		-- reset phase
		-------------------------------------------------------------------------------------------

		-- remove external reset
		wait for 100 ns;
		RstIn_N <= '1';

		-- wait for pll to lock
		wait for 1 us;

		-------------------------------------------------------------------------------------------
		-- testcase 1: send test packet
		-------------------------------------------------------------------------------------------

		-- testcase number
		TestcaseNr <= 1;
		print("Testcase " & str(TestcaseNr) & ": sending udp frame @ 1G");

		-- send packet
		Hdr_IpDst	<= X"10_00_00_01"; -- 16.0.0.1
		udp_tx (
			TxData			=> TestPacketData_c,
			ByteCount		=> TestPacketLength_c,
			StimAppTime		=> Clk125MHzStimAppTime_c,
			Clk				=> Clk125,
			Tx_Data			=> Tx_Data,
			Tx_Vld			=> Tx_Vld (0),
			Tx_Rdy			=> Tx_Rdy (0),
			Tx_Lst			=> Tx_Lst (0));
		UdpTxCnt <= UdpTxCnt + 1;

		-- wait for reply
		wait for 5 us;
		if UdpRxCnt = UdpTxCnt and RawEthRxCnt = RawEthTxCnt then
			print("   OK");
		else
			print("   !ERROR!");
		end if;

		-------------------------------------------------------------------------------------------
		-- testcase 2: send test packet to RAW Ethernet
		-------------------------------------------------------------------------------------------

		-- testcase number
		TestcaseNr <= 2;
		print("Testcase " & str(TestcaseNr) & ": sending a frame to a different IP address. This will be looped back via the raw Ethernet port");

		-- send packet
		Hdr_IpDst	<= X"10_00_00_0A"; -- 16.0.0.10
		udp_tx (
			TxData			=> TestPacketData_c,
			ByteCount		=> TestPacketLength_c,
			StimAppTime		=> Clk125MHzStimAppTime_c,
			Clk				=> Clk125,
			Tx_Data			=> Tx_Data,
			Tx_Vld			=> Tx_Vld (0),
			Tx_Rdy			=> Tx_Rdy (0),
			Tx_Lst			=> Tx_Lst (0));
		RawEthTxCnt <= RawEthTxCnt + 1;

		-- wait for reply
		wait for 5 us;
		if UdpRxCnt = UdpTxCnt and RawEthRxCnt = RawEthTxCnt then
			print("   OK");
		else
			print("   !ERROR!");
		end if;

		-------------------------------------------------------------------------------------------
		-- testcase 3: change to 100 Mbit mode
		-------------------------------------------------------------------------------------------

		-- testcase number
		TestcaseNr <= 3;
		print("Testcase " & str(TestcaseNr) & ": sending udp frame @ 100M");

		
		-- change to 100 mbit mode
		wait until rising_edge (Clk125);
		wait for Clk125MHzStimAppTime_c;
		Cfg_BitRate <= "10";

		-- wait for mode change
		wait for 1 us;

		-- send packet
		Hdr_IpDst	<= X"10_00_00_01"; -- 16.0.0.1
		udp_tx (
			TxData			=> TestPacketData_c,
			ByteCount		=> TestPacketLength_c,
			StimAppTime		=> Clk125MHzStimAppTime_c,
			Clk				=> Clk125,
			Tx_Data			=> Tx_Data,
			Tx_Vld			=> Tx_Vld (0),
			Tx_Rdy			=> Tx_Rdy (0),
			Tx_Lst			=> Tx_Lst (0));
		UdpTxCnt <= UdpTxCnt + 1;

		-- wait for reply
		wait for 15 us;
		if UdpRxCnt = UdpTxCnt and RawEthRxCnt = RawEthTxCnt then
			print("   OK");
		else
			print("   !ERROR!");
		end if;

		-------------------------------------------------------------------------------------------
		-- testcase 4: change to 10 Mbit mode
		-------------------------------------------------------------------------------------------

		-- testcase number
		TestcaseNr <= 4;
		print("Testcase " & str(TestcaseNr) & ": sending udp frame @ 10M");

		
		-- change to 10 mbit mode
		wait until rising_edge (Clk125);
		wait for Clk125MHzStimAppTime_c;
		Cfg_BitRate <= "01";

		-- wait for mode change
		wait for 10 us;

		-- send packet
		udp_tx (
			TxData			=> TestPacketData_c,
			ByteCount		=> TestPacketLength_c,
			StimAppTime		=> Clk125MHzStimAppTime_c,
			Clk				=> Clk125,
			Tx_Data			=> Tx_Data,
			Tx_Vld			=> Tx_Vld (0),
			Tx_Rdy			=> Tx_Rdy (0),
			Tx_Lst			=> Tx_Lst (0));
		UdpTxCnt <= UdpTxCnt + 1;

		-- wait for reply
		wait for 115 us;
		if UdpRxCnt = UdpTxCnt and RawEthRxCnt = RawEthTxCnt then
			print("   OK");
		else
			print("   !ERROR!");
		end if;

		-------------------------------------------------------------------------------------------
		-- end simulation
		-------------------------------------------------------------------------------------------

		-- put device to reset
		RstIn_N <= '0';
		wait for 1 us;

		-- stop clocks
		ClkRunning <= false;

		-- stop tb
		TbRunning <= false;

		-- user message
		print("### NOTE: simulation finished");

		-------------------------------------------------------------------------------------------
		-- wait forever
		-------------------------------------------------------------------------------------------

		wait;

	end process stim_app;

end;

---------------------------------------------------------------------------------------------------
-- EOF
---------------------------------------------------------------------------------------------------

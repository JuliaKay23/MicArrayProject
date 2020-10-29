---------------------------------------------------------------------------------------------------
--  Project          : Enclustra UDP/IP/ETH Core
--  File description : Reference Design for RGMII / Altera Cyclone V
--  File name        : en_udp_ip_eth_rgmii_alt_c5_rd.vhd
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
	use ieee.std_logic_unsigned.all;

library lib_en_udp_ip_eth_rgmii_alt_c5_eval;

---------------------------------------------------------------------------------------------------
-- entity
---------------------------------------------------------------------------------------------------

entity en_udp_ip_eth_rgmii_alt_c5_rd is

	-----------------------------------------------------------------------------------------------
	-- generics
	-----------------------------------------------------------------------------------------------

	generic (
		Simulation_g	: boolean	:= false
	);

	-----------------------------------------------------------------------------------------------
	-- ports
	-----------------------------------------------------------------------------------------------

	port (

		-------------------------------------------------------------------------------------------
		-- clock input (100 MHz) 
		-------------------------------------------------------------------------------------------

		Clk125			: in	std_logic;
		
		-------------------------------------------------------------------------------------------
		-- reset input (active-low)
		-------------------------------------------------------------------------------------------

		RstIn_N			: in	std_logic;
		
		-------------------------------------------------------------------------------------------
		-- ethernet phy reset output (active-low)
		-------------------------------------------------------------------------------------------

		Eth_Rst_N		: out	std_logic;
		
		-------------------------------------------------------------------------------------------
		-- led outputs (active-low, led 0: traffic, led 1: continuously blinking)
		-------------------------------------------------------------------------------------------

		Led_N			: out	std_logic_vector (3 downto 0);
		
		-------------------------------------------------------------------------------------------
		-- mii interface
		-------------------------------------------------------------------------------------------

		Rgmii_RxClk		: in	std_logic;
		Rgmii_RxD		: in	std_logic_vector (3 downto 0);
		Rgmii_RxCtl		: in	std_logic;
		Rgmii_TxClk		: out	std_logic;
		Rgmii_TxD		: out	std_logic_vector (3 downto 0);
		Rgmii_TxCtl		: out	std_logic
	);
end;

---------------------------------------------------------------------------------------------------
-- architecture
---------------------------------------------------------------------------------------------------

architecture struct of en_udp_ip_eth_rgmii_alt_c5_rd is

	-----------------------------------------------------------------------------------------------
	-- types
	-----------------------------------------------------------------------------------------------
	type NaturalArray_t is array (natural range <>) of natural;
	type HdrRamArray_t is array (63 downto 0) of std_logic_vector (7 downto 0);

	-----------------------------------------------------------------------------------------------
	-- core configuration constants
	-----------------------------------------------------------------------------------------------

	-- Name					Type		Range		Description
	-----------------------------------------------------------------------------------------------
	-- ClkFreq_g			positive	>0			Frequency in Hz of the system clock (Clk). Not required by all versions of the core. 
	-- UdpPortCount_g		positive	>0			Number of UDP ports. Each port has an individual receive and transmit interface as well as a dedicated receive buffer. Access to the transmit path is arbitrated between the individual UDP ports. 
	-- MaxPayloadSize_g		positive	>0			Maximum UDP payload size in bytes. This value is used to determine the required buffer size. No packets with bigger payload can be processed. 
	-- RxBufferCount_g		Natural		0 or >= 2	Defines the number of UDP packet that can be stored in the receive buffer (per UDP port). Set to 0 to disable the internal RX buffer. 
	-- EnableRawEth_g		boolean		True/false	Enables the optional raw Ethernet port. 
	--  ... See user manual, section 2.1 - Interface Generics for the rest
	
	-- Name					Type							Range		
	-----------------------------------------------------------------------------------------------
	-- UdpRxHdrMask_g		std_logic_vector (0 to 3)		“0000”.. ”1111”		
	-- 		UDP receive header fields pass through enable mask
	-- Bit 0: Source UDP port number 
	-- Bit 1: Destination UDP port number 
	-- Bit 2: Length 
	-- Bit 3: UDP checksum 
	-- 
	-- UdpTxHdrMask_g		std_logic_vector (0 to 1)		“00”.. ”11”		
	-- 		UDP transmit header fields pass through enable mask
	-- Bit 0: Source UDP port number 
	-- Bit 1: Destination UDP port number

	constant UdpPortCount_c			: positive					:= 1;
	constant MaxPayloadSize_c		: positive					:= 8000;
	constant RxBufferCount_c		: natural					:= 4;
	constant EnableRawEth_c			: boolean					:= false;
	constant RawEthRxBufferCnt_c	: natural					:= 2;
	constant RawEthTxBufferCnt_c	: natural					:= 2;
	constant RawEthPayloadSize_c	: positive					:= 2048;
	constant TimeoutWidth_c			: positive					:= 12;
	constant RoundRobin_c			: boolean					:= true;
	constant ArpReply_c				: boolean					:= true;
	constant UseStreamingMode_c		: boolean					:= false;
	constant UdpRxHdrMask_c			: std_logic_vector (0 to 3)	:= "1100";
	constant UdpTxHdrMask_c			: std_logic_vector (0 to 1)	:= "11";
	constant IpRxHdrMask_c			: std_logic_vector (0 to 9)	:= "0000000011";
	constant IpTxHdrMask_c			: std_logic_vector (0 to 6)	:= "0000011";
	constant EthRxHdrMask_c			: std_logic_vector (0 to 2)	:= "110";
	constant EthTxHdrMask_c			: std_logic_vector (0 to 2)	:= "110";

	-----------------------------------------------------------------------------------------------
	-- functions
	-----------------------------------------------------------------------------------------------

	function toOnesCount (slv : std_logic_vector) return natural is
		variable count : natural;
	begin
		count := 0;
		for i in slv'range loop
			if slv (i) = '1' then
				count := count + 1;
			end if;
		end loop;
		return count;
	end;

	-----------------------------------------------------------------------------------------------
	-- internal constants
	-----------------------------------------------------------------------------------------------

	-- Constant UDP payload
	constant 	Tx_Data_c	: std_logic_vector(31 downto 0) 		:= X"DE_AD_BE_EF";
	constant 	NumTxBytes_c	: natural 							:= 4;

	-- ticks per second on clk125
	constant COUNTS_IN_1_SEC 	: std_logic_vector(0 to 27)		:=	 std_logic_vector(to_unsigned(125000000, 28));
	--	constant TxDataByteLength_c	: std_logic_vector(0 to 31)	:=	4;


	-----------------------------------------------------------------------------------------------
	-- signals
	-----------------------------------------------------------------------------------------------

	-- global reset
	signal Rst					: std_logic;
	signal RstChain			: std_logic_vector (7 downto 0);
	signal Rst_Clk125			: std_logic;

	-- UDP transmit interface
	signal Tx_Data				: std_logic_vector (UdpPortCount_c*8-1 downto 0);
	signal Tx_Vld				: std_logic_vector (UdpPortCount_c-1 downto 0);
	signal Tx_Rdy				: std_logic_vector (UdpPortCount_c-1 downto 0);
	signal Tx_Lst				: std_logic_vector (UdpPortCount_c-1 downto 0);
	signal TxSnd				: std_logic_vector (UdpPortCount_c-1 downto 0);

	-- UDP receive interface
	signal Rx_Data				: std_logic_vector (UdpPortCount_c*8-1 downto 0);
	signal Rx_Vld				: std_logic_vector (UdpPortCount_c-1 downto 0);
	signal Rx_Rdy				: std_logic_vector (UdpPortCount_c-1 downto 0);
	signal Rx_Lst				: std_logic_vector (UdpPortCount_c-1 downto 0);
	
	-- Raw Ethernet transmit interface
	signal EthTx_Data			: std_logic_vector (7 downto 0);
	signal EthTx_Vld			: std_logic;
	signal EthTx_Rdy			: std_logic;
	signal EthTx_Lst			: std_logic;

	-- Raw Ethernet receive interface
	signal EthRx_Data			: std_logic_vector (7 downto 0);
	signal EthRx_Vld			: std_logic;
	signal EthRx_Rdy			: std_logic;
	signal EthRx_Lst			: std_logic;

	-- Ian's second_delay
	-- signal counter				: std_logic_vector (7 downto 0);
	-- signal second_tick			: std_logic;

	-- UDP transmit state
	-- signal Tx_State			: std_logic;
	-- signal Tx_State_Next		: std_logic;
	-- signal Tx_Data_Next			: std_logic_vector(31 downto 0);

	-- Byte Counter for Tx
	-- signal ByteCountClr			: std_logic;
	-- signal ByteCountCen			: std_logic;
	-- signal ByteCount			: std_logic_vector (5 downto 0);
	
	-- basic version
	signal Cnt					: std_logic_vector (1 downto 0);
	signal led					: std_logic_vector (3 downto 0);
	
begin
	
	-----------------------------------------------------------------------------------------------
	-- global reset
	-----------------------------------------------------------------------------------------------

	-- asynchronous reset
	Rst <= not RstIn_N;
	
	-- synchronous reset
	process (Clk125, Rst)
	begin
		if Rst = '1' then
			RstChain <= (others => '0');
		elsif rising_edge (Clk125) then
			RstChain <= '1' & RstChain (RstChain'left downto 1);
		end if;
	end process;
	Rst_Clk125 <= not RstChain (0);
	
	-- ethernet phy reset output
	Eth_Rst_N <= not Rst_Clk125;
	
	-----------------------------------------------------------------------------------------------
	-- udp/ip/eth core instance
	-----------------------------------------------------------------------------------------------

	i_core : entity lib_en_udp_ip_eth_rgmii_alt_c5_eval.en_udp_ip_eth_rgmii_alt_c5

		-------------------------------------------------------------------------------------------
		-- generics
		-------------------------------------------------------------------------------------------

		generic map (
			UdpPortCount_g			=> UdpPortCount_c,
			MaxPayloadSize_g		=> MaxPayloadSize_c,
			RxBufferCount_g			=> RxBufferCount_c,
			EnableRawEth_g			=> EnableRawEth_c,
			RawEthRxBufferCnt_g		=> RawEthRxBufferCnt_c,
			RawEthTxBufferCnt_g		=> RawEthTxBufferCnt_c,
			RawEthPayloadSize_g		=> RawEthPayloadSize_c,
			TimeoutWidth_g			=> TimeoutWidth_c,
			RoundRobin_g			=> RoundRobin_c,
			ArpReply_g				=> ArpReply_c,
			UseStreamingMode_g		=> UseStreamingMode_c,
			UdpRxHdrMask_g			=> UdpRxHdrMask_c,
			UdpTxHdrMask_g			=> UdpTxHdrMask_c,
			IpRxHdrMask_g			=> IpRxHdrMask_c,
			IpTxHdrMask_g			=> IpTxHdrMask_c,
			EthRxHdrMask_g			=> EthRxHdrMask_c,
			EthTxHdrMask_g			=> EthTxHdrMask_c
		)

		-------------------------------------------------------------------------------------------
		-- ports
		-------------------------------------------------------------------------------------------

		port map (

			--! See User Manual Section 2.2 for details on each of the ports below

			---------------------------------------------------------------------------------------
			-- user clock and reset ports
			---------------------------------------------------------------------------------------

			Clk					=> Clk125,
			Rst					=> Rst_Clk125,

			---------------------------------------------------------------------------------------
			-- user transmit data interface ports -- User Manual Section 2.2.2
			---------------------------------------------------------------------------------------
			
			Tx_Data				=> Tx_Data,
			Tx_Vld				=> Tx_Vld,
			Tx_Lst				=> Tx_Lst,
			Tx_Rdy				=> Tx_Rdy,
			Tx_Err				=> (others => '0'),
			Tx_Snd				=> (others => '0'),

			---------------------------------------------------------------------------------------
			-- user receive data interface ports -- User Manual Section 2.2.3
			---------------------------------------------------------------------------------------
			
			Rx_Data				=> Rx_Data,
			Rx_Vld				=> Rx_Vld,
			Rx_Rdy				=> (others => '0'),
			Rx_Lst				=> Rx_Lst,
			Rx_Err				=> open,

			-------------------------------------------------------------------------------------------
			-- Raw Ethernet transmit interface -- User Manual Section 2.2.4
			-------------------------------------------------------------------------------------------

			EthTx_Data			=> EthTx_Data,
			EthTx_Vld			=> EthTx_Vld,
			EthTx_Rdy			=> EthTx_Rdy,
			EthTx_Lst			=> EthTx_Lst,
			EthTx_Err			=> '0',

			-------------------------------------------------------------------------------------------
			-- Raw Ethernet receive interface -- User Manual Section 2.2.5
			-------------------------------------------------------------------------------------------

			EthRx_Data			=> EthRx_Data,
			EthRx_Vld			=> EthRx_Vld,
			EthRx_Rdy			=> EthRx_Rdy,
			EthRx_Lst			=> EthRx_Lst,
			EthRx_Err			=> open,

			---------------------------------------------------------------------------------------
			-- user header interface ports -- User Manual Section 2.2.6
			---------------------------------------------------------------------------------------
			
			Hdr_UdpTxSrc		=> std_logic_vector (to_unsigned (50100,16)),
			Hdr_UdpTxDst		=> std_logic_vector (to_unsigned (50101,16)),
			Hdr_UdpRxPort		=> std_logic_vector (to_unsigned (50100,16)),
			Hdr_UdpRxPortMask	=> X"FFFF",
			Hdr_IpSrc			=> X"10_00_00_01", -- 16.0.0.1
			Hdr_IpDst			=> X"10_00_00_C8", -- 16.0.0.200 * try broadcast ip (look it up)
			-- Hdr_IpSrc			=> X"C0_A8_56_4D",  -- 192.168.86.77
			-- Hdr_IpDst			=> X"C0_A8_56_A7",  -- 192.168.86.167
			Hdr_IpDscp			=> X"00",
			Hdr_IpId				=> X"0000",
			Hdr_IpFlags			=> "010",
			Hdr_IpTtl			=> X"FF",
			Hdr_MacSrc			=> X"40_00_00_00_00_01",
			Hdr_MacDst			=> X"FF_FF_FF_FF_FF_FF", -- Broadcast MAC
			Hdr_RawEthMac		=> X"40_00_00_00_00_01",

			---------------------------------------------------------------------------------------
			-- user configuration interface ports -- User Manual Section 2.2.7
			---------------------------------------------------------------------------------------

			Cfg_TxEn					=> '1',
			Cfg_RxEn					=> '0',
			Cfg_CheckRawEthMac	=> '0',
			Cfg_CheckMac			=> '0',
			Cfg_CheckIp				=> '0',
			Cfg_CheckUdp			=> '1',
			Cfg_MTU					=> std_logic_vector (to_unsigned (0, 14)), -- not used because of packet mode
			Cfg_Timeout				=> std_logic_vector (to_unsigned (0, 12)), -- not used because of packet mode

			---------------------------------------------------------------------------------------
			-- MII ports -- User Manual Section 2.3.4
			---------------------------------------------------------------------------------------

			Rgmii_RxClk			=> Rgmii_RxClk,
			Rgmii_RxD			=> Rgmii_RxD,
			Rgmii_RxCtl			=> Rgmii_RxCtl,
			Rgmii_TxClk			=> Rgmii_TxClk,
			Rgmii_TxD			=> Rgmii_TxD,
			Rgmii_TxCtl			=> Rgmii_TxCtl,

			---------------------------------------------------------------------------------------
			-- version interface port
			---------------------------------------------------------------------------------------

			Version				=> open
		);
		
		
		-- Defaults for unused ports
--		Rx_Data	
--      Rx_Vld	
--      Rx_Rdy	
--	   Rx_Lst	
		
--		EthTx_Data	<= 0;
--		EthTx_Vld	<= '0';
--		EthRx_Rdy	<= '0';
--		EthTx_Lst	<= '0';
--		
--		EthRx_Data <=	0;
--		EthRx_Vld  <=	'0';
--		EthTx_Rdy  <=	'0';
--		EthRx_Lst  <=	'0';
		

	-- udp_tx_test : process( Tx_Rdy, second_tick, clk125 )
	-- begin
	-- 	if (rising_edge(Clk125)) then
	-- 		-- Defaults
	-- 		ByteCountCen 			<= '0';
	-- 		ByteCountClr 			<= '1';
	-- 		Tx_Vld(0)				<= '0';
	-- 		Tx_Lst(0)				<= '0';

	-- 		if (Tx_state = '1') then
	-- 			Tx_Vld (0) 		<= '1';
	-- 			ByteCountCen 	<= '1';
	-- 			ByteCountClr 	<= '0';

	-- 			case( ByteCount ) is
				
	-- 				when X"0" =>
	-- 					Tx_Data(7 downto 0) <= Tx_Data_c(7 downto 0);
	-- 				when X"1" =>
	-- 					Tx_Data(7 downto 0) <= Tx_Data_c(15 downto 7);
	-- 				when X"2" =>
	-- 					Tx_Data(7 downto 0) <= Tx_Data_c(23 downto 16);
	-- 				when X"3" =>
	-- 					-- NumTxBytes_c - 1
	-- 					Tx_Data(7 downto 0) <= Tx_Data_c(31 downto 24);
	-- 					Tx_Lst(0)			<= '1';
	-- 					ByteCountCen 		<= '0';
	-- 					ByteCountClr 		<= '1';
	-- 				when others =>
	-- 					Tx_Data(7 downto 0) <= X"AA";
	-- 					ByteCountCen 		<= '0';
	-- 					ByteCountClr 		<= '1';
	-- 			end case ;
	-- 		else
	-- 			-- wait for Tx_State = 1
	-- 			ByteCountCen <= '0';
	-- 			ByteCountClr <= '0';
	-- 		end if;
	-- 	end if;
	-- end process;
	
	
	
	
	
	
	
	
	Tx_Vld <= (others => '1');

	basic_tx : process( Clk125, Cnt )
	begin
		if Cnt < 3 then
			Tx_Data(7 downto 0)	<= X"B4";
			Tx_Lst				<= (others => '0');
		else
			Tx_Data(7 downto 0)	<= X"A3";
			Tx_Lst				<= (others => '1');
		end if;
	end process ; -- basic_tx
	
	
	process (Clk125, Rst)
	begin 
		if rising_edge(Clk125) then
			if Rst = '1' then
				Cnt <= (others => '0');
--				led <= "0000";
			elsif Cnt = 4-1 then
				Cnt <= (others => '0');
--				led <= "01";
			else
				Cnt <= Cnt + 1;
--				led <= "10";
			end if;
		end if;
	end process;
	
	with cnt select 
	led <= 	"1110" when "00",
				"1101" when "01",
				"1011" when "10",
				"0111" when "11",
				"1001" when others;
	
	Led_N <= led;
	

--	udp_tx_ctrl : process( clk125, Tx_Data_next )
--	begin
----		ByteCountCen 			 <= '0';
----		ByteCountClr 			 <= '1';
----		Tx_Vld(0)				 <= '0';
----		Tx_Lst(0)				 <= '0';
----		Tx_Data(7 downto 0) 	 <= Tx_Data_next(7 downto 0);
--		
--		if rising_edge (Clk125) then
--		-- Defaults
--		
--			if Tx_State = '1' then
--				-- Receiver ready
--				if (Tx_Rdy(0) = '1') then				
--					if to_integer( unsigned (ByteCount)) = (NumTxBytes_c - 1) then
--						Tx_Lst(0) 		<= '1';
--						ByteCountClr 	<= '1';
--						ByteCountCen 	<= '0';
--					else 
--						Tx_Lst(0) 		<= '0';
--						ByteCountClr 	<= '0';
--						ByteCountCen 	<= '1';
--					end if ;
--				else 
--					-- wait for TxRdy
--					Tx_Lst(0) 		<= '0';
--					ByteCountClr 	<= '1';
--					ByteCountCen 	<= '0';
--				end if;
--			else 
--			-- Wait for Tx_State
--				Tx_Lst(0) 		<= '0';
--				ByteCountClr 	<= '1';
--				ByteCountCen 	<= '0';
--			
--			end if ;
--		end if ;
--	end process ; -- udp_tx_ctrl
--	
--	Tx_Vld <= (others => '1');
--	
--	
--	process (clk125, ByteCount)
--	begin 
--		if rising_edge(clk125) then
--			Tx_State					 <= Tx_State_Next;
--			Tx_Data(7 downto 0) 	 <= Tx_Data_next(7 downto 0);
--			
--			if second_tick = '1' then
--				-- Begin payload transmit
--				Tx_State_Next	<= '1';
--				Tx_Data_Next	<= std_logic_vector(shift_right( unsigned( Tx_Data_Next), 8));
--			elsif to_integer( unsigned (ByteCount)) = NumTxBytes_c-1 then
--				Tx_State_Next	<= '0';
--				Tx_Data_Next	<= Tx_Data_c;
--			else 
--				Tx_State_Next	<= Tx_State;
--				Tx_Data_Next	<= std_logic_vector(shift_right( unsigned( Tx_Data_Next), 8));
--			end if;
--		end if;
--	end process;
--	
--	-- next_data : process( Clk125, second_tick )
--	-- begin
--		
--	-- end process ; -- next_data
--
--	
--
--	-----------------------------------------------------------------------------------------------
--	-- seconds timer -- Ian 
--	-- based on https://stackoverflow.com/questions/29948476/creating-a-real-time-delay-in-vhdl
--	-----------------------------------------------------------------------------------------------
--
--	second_delay : process (Clk125) is
--	begin
--		
--		if (rising_edge(Clk125)) then
--		
--			second_tick <= '0';
--			-- if (counter < COUNTS_IN_1_SEC-1) then
----			if (to_integer (unsigned (counter)) < 125000000-1) then
--			if (to_integer (unsigned (counter)) < 125000-1) then
--				counter <= counter + 1;
--				Led_N(0) <= not '1';
--				Led_N(1) <= not std_logic(counter(0));
--			else
--				second_tick <= '1';
--				Led_N(0) <= not '0';
--				Led_N(1) <= not '1';
--				counter  <= (others => '0');
--			end if;
--		end if;
--	end process second_delay;
--
--
--	-----------------------------------------------------------------------------------------------
--	-- udp loopback byte counter
--	-----------------------------------------------------------------------------------------------
--
--	process (Clk125)
--	begin
--		if rising_edge (Clk125) then
--			if Rst_Clk125 = '1' then
--				ByteCount <= (others => '0');
--			else
--				if ByteCountClr = '1' then
--					ByteCount <= (others => '0');
--				elsif ByteCountCen = '1' then
--					ByteCount <= std_logic_vector (unsigned (ByteCount) + 1);
--				end if;
--			end if;
--		end if;
--	end process;


end;	-- Architecture?
---------------------------------------------------------------------------------------------------
-- eof
---------------------------------------------------------------------------------------------------
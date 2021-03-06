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

		Led_N			: out	std_logic_vector (1 downto 0);
		
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

	type LbFsmState_t is (Idle_s, RxHdr_s, TxHdrFetch_s, TxHdr_s, Payload_s);
	type NaturalArray_t is array (natural range <>) of natural;
	type HdrRamArray_t is array (63 downto 0) of std_logic_vector (7 downto 0);

	-----------------------------------------------------------------------------------------------
	-- core configuration constants
	-----------------------------------------------------------------------------------------------

	constant UdpPortCount_c			: positive					:= 1;
	constant MaxPayloadSize_c		: positive					:= 8000;
	constant RxBufferCount_c		: natural					:= 4;
	constant EnableRawEth_c			: boolean					:= true;
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

	function toLedCtrWidth (Simulation : boolean) return natural is
	begin
		if Simulation then
			return 4;
		else
			return 24;
		end if;
	end;

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

	function toHdrAddrArray (ByteMask : std_logic_vector; ByteAddr : NaturalArray_t; ByteCount : natural) return NaturalArray_t is
		variable addrout : NaturalArray_t (0 to ByteCount-1) := (others => 0);
		variable j : natural := 0;
	begin
		for i in 0 to ByteMask'length-1 loop
			if ByteMask (i) = '1' then
				addrout (j) := ByteAddr (i);
				j := j+1;
			end if;
		end loop;
		return addrout;
	end;

	-----------------------------------------------------------------------------------------------
	-- internal constants
	-----------------------------------------------------------------------------------------------

	constant RxHdrByteMaskFull_c	: std_logic_vector (0 to 39)	:=
		EthRxHdrMask_c (0)	& EthRxHdrMask_c (0)&
		EthRxHdrMask_c (0)	& EthRxHdrMask_c (0)&
		EthRxHdrMask_c (0)	& EthRxHdrMask_c (0)&
		EthRxHdrMask_c (1)	& EthRxHdrMask_c (1)&
		EthRxHdrMask_c (1)	& EthRxHdrMask_c (1)&
		EthRxHdrMask_c (1)	& EthRxHdrMask_c (1)&
		EthRxHdrMask_c (2)	& EthRxHdrMask_c (2)&
		IpRxHdrMask_c (0)	& IpRxHdrMask_c (1)	&
		IpRxHdrMask_c (2)	& IpRxHdrMask_c (2)	&
		IpRxHdrMask_c (3)	& IpRxHdrMask_c (3)	&
		IpRxHdrMask_c (4)	& IpRxHdrMask_c (4)	&
		IpRxHdrMask_c (5)	& IpRxHdrMask_c (6)	&
		IpRxHdrMask_c (7)	& IpRxHdrMask_c (7)	&
		IpRxHdrMask_c (8)	& IpRxHdrMask_c (8)	&
		IpRxHdrMask_c (8)	& IpRxHdrMask_c (8)	&
		IpRxHdrMask_c (9)	& IpRxHdrMask_c (9)	&
		IpRxHdrMask_c (9)	& IpRxHdrMask_c (9)	&
		UdpRxHdrMask_c (0)	& UdpRxHdrMask_c (0)&
		UdpRxHdrMask_c (1)	& UdpRxHdrMask_c (1)&
		UdpRxHdrMask_c (2)	& UdpRxHdrMask_c (2);

	constant RxHdrByteAddrFull_c	: NaturalArray_t (0 to 39)		:=
		(	 0,  1,  2,  3,  4,  5,  6,  7,  8,  9,
			10, 11, 12, 13, 14, 15, 16, 17, 18, 19,
			20, 21, 22, 23, 24, 25, 26, 27, 28, 29,
			30, 31, 32, 33, 34, 35, 36, 37, 38, 39);
		
	constant RxHdrByteLength_c 		: natural						:=
		toOnesCount	(RxHdrByteMaskFull_c);	

	constant RxHdrByteAddr_c		: NaturalArray_t (0 to RxHdrByteLength_c-1)	:=
		toHdrAddrArray (RxHdrByteMaskFull_c, RxHdrByteAddrFull_c, RxHdrByteLength_c);

	constant TxHdrByteMaskFull_c	: std_logic_vector (0 to 32)	:=
		EthTxHdrMask_c (0)	& EthTxHdrMask_c (0)&
		EthTxHdrMask_c (0)	& EthTxHdrMask_c (0)&
		EthTxHdrMask_c (0)	& EthTxHdrMask_c (0)&
		EthTxHdrMask_c (1)	& EthTxHdrMask_c (1)&
		EthTxHdrMask_c (1)	& EthTxHdrMask_c (1)&
		EthTxHdrMask_c (1)	& EthTxHdrMask_c (1)&
		EthTxHdrMask_c (2)	& EthTxHdrMask_c (2)&
		IpTxHdrMask_c (0)	&
		IpTxHdrMask_c (1)	& IpTxHdrMask_c (1)	&
		IpTxHdrMask_c (2)	& IpTxHdrMask_c (2)	&
		IpTxHdrMask_c (3)	& IpTxHdrMask_c (4)	&
		IpTxHdrMask_c (5)	& IpTxHdrMask_c (5)	&
		IpTxHdrMask_c (5)	& IpTxHdrMask_c (5)	&
		IpTxHdrMask_c (6)	& IpTxHdrMask_c (6)	&
		IpTxHdrMask_c (6)	& IpTxHdrMask_c (6)	&
		UdpTxHdrMask_c (0)	& UdpTxHdrMask_c (0)&
		UdpTxHdrMask_c (1)	& UdpTxHdrMask_c (1);

	constant TxHdrByteAddrFull_c	: NaturalArray_t (0 to 32)		:=
		(	 6,  7,  8,  9, 10, 11,  0,  1,  2,  3,
			 4,  5, 12, 13, 15, 18, 19, 20, 21, 22,
			23, 30, 31, 32, 33, 26, 27, 28, 29, 36, 
			37, 34, 35);

	constant TxHdrByteLength_c 		: natural						:=
		toOnesCount	(TxHdrByteMaskFull_c);	

	constant TxHdrByteAddr_c		: NaturalArray_t (0 to TxHdrByteLength_c-1)	:=
		toHdrAddrArray (TxHdrByteMaskFull_c, TxHdrByteAddrFull_c, TxHdrByteLength_c);

	-----------------------------------------------------------------------------------------------
	-- signals
	-----------------------------------------------------------------------------------------------

	-- global reset
	signal Rst					: std_logic;
	signal RstChain				: std_logic_vector (7 downto 0);
	signal Rst_Clk125			: std_logic;

	-- transmit interface
	signal Tx_Data				: std_logic_vector (UdpPortCount_c*8-1 downto 0);
	signal Tx_Vld				: std_logic_vector (UdpPortCount_c-1 downto 0);
	signal Tx_Rdy				: std_logic_vector (UdpPortCount_c-1 downto 0);
	signal Tx_Lst				: std_logic_vector (UdpPortCount_c-1 downto 0);

	-- receive interface
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
	
	-- loopback
	signal LbFsmState			: LbFsmState_t;
	signal LbFsmState_Next		: LbFsmState_t;
	signal HdrRamAddr			: std_logic_vector (5 downto 0);
	signal HdrRamQ				: std_logic_vector (7 downto 0);
	signal HdrRamWen			: std_logic;
	signal HdrRamArray			: HdrRamArray_t := (others => (others => '0'));
	signal ByteCountClr			: std_logic;
	signal ByteCountCen			: std_logic;
	signal ByteCount			: std_logic_vector (5 downto 0);
	
	-- receive/transmit packet led
	signal PktDetected			: std_logic;
	signal RxTxPktLed			: std_logic;
	signal RxTxPktLedCtrQ		: std_logic_vector (toLedCtrWidth (Simulation_g)-1 downto 0);

	-- blinking led
	signal BlinkingLedCtrQ		: std_logic_vector (toLedCtrWidth (Simulation_g)+1 downto 0);
	
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
			Rst					=> Rst_Clk125,

			---------------------------------------------------------------------------------------
			-- user transmit data interface ports
			---------------------------------------------------------------------------------------
			
			Tx_Data				=> Tx_Data,
			Tx_Vld				=> Tx_Vld,
			Tx_Lst				=> Tx_Lst,
			Tx_Rdy				=> Tx_Rdy,
			Tx_Err				=> (others => '0'),
			Tx_Snd				=> (others => '0'),

			---------------------------------------------------------------------------------------
			-- user receive data interface ports
			---------------------------------------------------------------------------------------
			
			Rx_Data				=> Rx_Data,
			Rx_Vld				=> Rx_Vld,
			Rx_Rdy				=> Rx_Rdy,
			Rx_Lst				=> Rx_Lst,
			Rx_Err				=> open,

			-------------------------------------------------------------------------------------------
			-- Raw Ethernet transmit interface
			-------------------------------------------------------------------------------------------

			EthTx_Data			=> EthTx_Data,
			EthTx_Vld			=> EthTx_Vld,
			EthTx_Rdy			=> EthTx_Rdy,
			EthTx_Lst			=> EthTx_Lst,
			EthTx_Err			=> '0',

			-------------------------------------------------------------------------------------------
			-- Raw Ethernet receive interface
			-------------------------------------------------------------------------------------------

			EthRx_Data			=> EthRx_Data,
			EthRx_Vld			=> EthRx_Vld,
			EthRx_Rdy			=> EthRx_Rdy,
			EthRx_Lst			=> EthRx_Lst,
			EthRx_Err			=> open,

			---------------------------------------------------------------------------------------
			-- user header interface ports
			---------------------------------------------------------------------------------------
			
			Hdr_UdpTxSrc		=> std_logic_vector (to_unsigned (50100,16)),
			Hdr_UdpTxDst		=> std_logic_vector (to_unsigned (50101,16)),
			Hdr_UdpRxPort		=> std_logic_vector (to_unsigned (50100,16)),
			Hdr_UdpRxPortMask	=> X"FFFF",
			Hdr_IpSrc			=> X"10_00_00_01", -- 16.0.0.1
			Hdr_IpDst			=> X"10_00_00_C8", -- 16.0.0.200 * try broadcast ip (look it up)
--			Hdr_IpSrc			=> X"C0_A8_56_4D",  -- 192.168.86.77
--			Hdr_IpDst			=> X"C0_A8_56_A7",  -- 192.168.86.167
			Hdr_IpDscp			=> X"00",
			Hdr_IpId				=> X"0000",
			Hdr_IpFlags			=> "010",
			Hdr_IpTtl			=> X"FF",
			Hdr_MacSrc			=> X"40_00_00_00_00_01",
			Hdr_MacDst			=> X"FF_FF_FF_FF_FF_FF", -- Broadcast MAC
			Hdr_RawEthMac		=> X"40_00_00_00_00_01",

			---------------------------------------------------------------------------------------
			-- user configuration interface ports
			---------------------------------------------------------------------------------------

			Cfg_TxEn			=> '1',
			Cfg_RxEn			=> '1',
			Cfg_CheckRawEthMac	=> '1',
			Cfg_CheckMac		=> '1',
			Cfg_CheckIp			=> '1',
			Cfg_CheckUdp		=> '1',
			Cfg_MTU				=> std_logic_vector (to_unsigned (0, 14)), -- not used because of packet mode
			Cfg_Timeout			=> std_logic_vector (to_unsigned (0, 12)), -- not used because of packet mode

			---------------------------------------------------------------------------------------
			-- MII ports
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

		EthTx_Data			<= EthRx_Data;
		EthTx_Vld			<= EthRx_Vld;
		EthRx_Rdy			<= EthTx_Rdy;
		EthTx_Lst			<= EthRx_Lst;

	-----------------------------------------------------------------------------------------------
	-- udp loopback fsm
	-----------------------------------------------------------------------------------------------
	
	process (LbFsmState, Rx_Vld, Rx_Lst, Tx_Rdy, ByteCount, HdrRamQ, Rx_Data)
	begin
	
		-------------------------------------------------------------------------------------------
		-- default assignments
		-------------------------------------------------------------------------------------------
	
		LbFsmState_Next <= LbFsmState;
		Rx_Rdy (0) <= '0';
		HdrRamAddr <= (others => '0');
		HdrRamWen <= '0';
		Tx_Vld (0) <= '0';
		Tx_Lst (0) <= '0';
		Tx_Data <= HdrRamQ;
		ByteCountClr <= '0';
		ByteCountCen <= '0';
		
		-------------------------------------------------------------------------------------------
		-- conditional assignments
		-------------------------------------------------------------------------------------------
		
		case LbFsmState is 

			---------------------------------------------------------------------------------------
			when Idle_s =>
			---------------------------------------------------------------------------------------

				if Rx_Vld (0) = '1' then
					if RxHdrByteLength_c > 0 then
						LbFsmState_Next <= RxHdr_s;
					elsif TxHdrByteLength_c > 0 then
						LbFsmState_Next <= TxHdrFetch_s;
					else
						LbFsmState_Next <= Payload_s;
					end if;
				end if;

			---------------------------------------------------------------------------------------
			when RxHdr_s =>
			---------------------------------------------------------------------------------------
			
				Rx_Rdy (0) <= '1';
				if Rx_Vld (0) = '1' then
					if Rx_Lst (0) = '1' then
						ByteCountClr <= '1';
						LbFsmState_Next <= Idle_s;
					else
						HdrRamAddr <= std_logic_vector (to_unsigned (RxHdrByteAddr_c (to_integer (unsigned (ByteCount))),HdrRamAddr'length));
						HdrRamWen <= '1';
						if unsigned (ByteCount) = RxHdrByteLength_c-1 then
							ByteCountClr <= '1';
							if TxHdrByteLength_c > 0 then
								LbFsmState_Next <= TxHdrFetch_s;
							else
								LbFsmState_Next <= Payload_s;
							end if;
						else
							ByteCountCen <= '1';
						end if;
					end if;
				end if;				
			
			---------------------------------------------------------------------------------------
			when TxHdrFetch_s =>
			---------------------------------------------------------------------------------------
			
				HdrRamAddr <= std_logic_vector (to_unsigned (TxHdrByteAddr_c (to_integer (unsigned (ByteCount))),HdrRamAddr'length));
				LbFsmState_Next <= TxHdr_s;
			
			---------------------------------------------------------------------------------------
			when TxHdr_s =>
			---------------------------------------------------------------------------------------
			
				Tx_Vld (0) <= '1';
				HdrRamAddr <= std_logic_vector (to_unsigned (TxHdrByteAddr_c (to_integer (unsigned (ByteCount))),HdrRamAddr'length));
				if Tx_Rdy (0) = '1' then
					if unsigned (ByteCount) = TxHdrByteLength_c-1 then
						ByteCountClr <= '1';
						LbFsmState_Next <= Payload_s;
					else
						ByteCountCen <= '1';
						LbFsmState_Next <= TxHdrFetch_s;
					end if;
				end if;
			
			---------------------------------------------------------------------------------------
			when Payload_s =>
			---------------------------------------------------------------------------------------
			
				Tx_Vld (0) <= Rx_Vld (0);
				Rx_Rdy (0) <= Tx_Rdy (0);
				Tx_Lst (0) <= Rx_Lst (0);
				Tx_Data <= Rx_Data;
				if Rx_Vld (0) = '1' and Tx_Rdy (0) = '1' and Rx_Lst (0) = '1' then
					LbFsmState_Next <= Idle_s;
				end if;
			
			---------------------------------------------------------------------------------------
			when others =>
			---------------------------------------------------------------------------------------
			
				LbFsmState_Next <= Idle_s;

		end case;
		
	end process;
	
	process (Clk125)
	begin
		if rising_edge (Clk125) then
			if Rst_Clk125 = '1' then
				LbFsmState <= Idle_s;
			else
				LbFsmState <= LbFsmState_Next;
			end if;
		end if;
	end process;

	-----------------------------------------------------------------------------------------------
	-- udp loopback byte counter
	-----------------------------------------------------------------------------------------------

	process (Clk125)
	begin
		if rising_edge (Clk125) then
			if Rst_Clk125 = '1' then
				ByteCount <= (others => '0');
			else
				if ByteCountClr = '1' then
					ByteCount <= (others => '0');
				elsif ByteCountCen = '1' then
					ByteCount <= std_logic_vector (unsigned (ByteCount) + 1);
				end if;
			end if;
		end if;
	end process;

	-----------------------------------------------------------------------------------------------
	-- udp loopback header ram
	-----------------------------------------------------------------------------------------------

	process(Clk125)
	begin
		if rising_edge(Clk125) then
			HdrRamQ <= HdrRamArray (to_integer (unsigned (HdrRamAddr)));			
			if HdrRamWen = '1' then
				HdrRamArray (to_integer (unsigned (HdrRamAddr))) <= Rx_Data;
			end if;
		end if;
	end process;

	-----------------------------------------------------------------------------------------------
	-- udp packet receive / transmit led
	-----------------------------------------------------------------------------------------------
	
	-- packet detector
	PktDetected <= '1' when (Tx_Vld = "1" and Tx_Lst = "1" and Tx_Rdy = "1") else '0';
	
	-- ~1/8 second pulse
	process (Clk125)
	begin
		if rising_edge (Clk125) then
			if Rst_Clk125 = '1' then
				RxTxPktLedCtrQ <= (others => '0');
				RxTxPktLed <= '0';		
			else
				RxTxPktLed <= '0';
				if PktDetected = '1' then
					RxTxPktLedCtrQ <= (others => '0');
					RxTxPktLedCtrQ (0) <= '1';
					RxTxPktLed <= '1';
				elsif unsigned (RxTxPktLedCtrQ) > 0 then
					RxTxPktLedCtrQ <= std_logic_vector (unsigned (RxTxPktLedCtrQ) + 1);
					RxTxPktLed <= '1';
				end if;
			end if;
		end if;
	end process;
	
	-- output
	Led_N (0) <= not RxTxPktLed;

	-----------------------------------------------------------------------------------------------
	-- blinking led
	-----------------------------------------------------------------------------------------------
	
	-- ~1/4 second pulses
	process (Clk125)
	begin
		if rising_edge (Clk125) then
			if Rst_Clk125 = '1' then
				BlinkingLedCtrQ <= (others => '0');
			else
				BlinkingLedCtrQ <= std_logic_vector (unsigned (BlinkingLedCtrQ) + 1);
			end if;
		end if;
	end process;
	
	-- output
	Led_N (1) <= not BlinkingLedCtrQ (BlinkingLedCtrQ'left);
	
end;

---------------------------------------------------------------------------------------------------
-- eof
---------------------------------------------------------------------------------------------------
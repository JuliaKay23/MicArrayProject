-- (C) 2001-2019 Intel Corporation. All rights reserved.
-- Your use of Intel Corporation's design tools, logic functions and other 
-- software and tools, and its AMPP partner logic functions, and any output 
-- files from any of the foregoing (including device programming or simulation 
-- files), and any associated documentation or information are expressly subject 
-- to the terms and conditions of the Intel Program License Subscription 
-- Agreement, Intel FPGA IP License Agreement, or other applicable 
-- license agreement, including, without limitation, that your use is for the 
-- sole purpose of programming logic devices manufactured by Intel and sold by 
-- Intel or its authorized distributors.  Please refer to the applicable 
-- agreement for further details.


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


library work;
use work.auk_dspip_lib_pkg.all;
use work.auk_dspip_math_pkg.all;

library altera_mf;
use altera_mf.altera_mf_components.all;

entity auk_dspip_avalon_streaming_source is
  generic(
    WIDTH_g         : integer := 16;
    PACKET_SIZE_g   : integer := 4;
    HYPER_PIPELINE  : natural := 0;
    NUM_IN_STAGES   : natural := 1; -- only used when the design is seperated from the interface for hyper pipelining
    NUM_OUT_STAGES  : natural := 1; -- only used when the design is seperated from the interface for hyper pipelining
    NUM_STALL_W_STAGES : natural := 1 -- only used when the design is seperated from the interface for hyper pipelining
    );
  port(
    clk               : in  std_logic;
    reset_n           : in  std_logic;
    ----------------- DESIGN SIDE SIGNALS
    data              : in  std_logic_vector (WIDTH_g-1 downto 0);
    data_count        : in  std_logic_vector (log2_ceil_one(PACKET_SIZE_g)-1 downto 0) := (others => '0');
    source_valid_ctrl : in  std_logic;
    source_stall      : out std_logic;
    packet_error      : in  std_logic_vector (1 downto 0);
    ----------------- AVALON_STREAMING SIDE SIGNALS
    at_source_ready   : in  std_logic;            -- external circuit ready to accept output
    at_source_valid   : out std_logic;            -- output data valid
    at_source_data    : out std_logic_vector (WIDTH_g-1 downto 0);   -- output data
    at_source_channel : out std_logic_vector (log2_ceil_one(PACKET_SIZE_g)-1 downto 0);
    at_source_error   : out std_logic_vector (1 downto 0);
    at_source_sop     : out std_logic;
    at_source_eop     : out std_logic
    );
end auk_dspip_avalon_streaming_source;



architecture rtl of auk_dspip_avalon_streaming_source is

  -- single-clock FIFO from altera_mf library
  component scfifo
  generic (
           add_ram_output_register: string := "ON";
           allow_rwcycle_when_full: string := "OFF";
           almost_empty_value: natural := 0;
           almost_full_value: natural := 0;
           lpm_numwords: natural;
           lpm_showahead: string := "OFF";
           lpm_width: natural;
           lpm_widthu: natural := 1;
           overflow_checking: string := "ON";
           underflow_checking: string := "ON";
           use_eab: string := "ON";
           lpm_hint: string := "UNUSED";
           lpm_type: string := "scfifo"
           );
  port    (
           aclr: in std_logic := '0';
           almost_empty: out std_logic;
           almost_full: out std_logic;
           clock: in std_logic;
           data: in std_logic_vector(lpm_width-1 downto 0);
           empty: out std_logic;
           full: out std_logic;
           q : out std_logic_vector(lpm_width-1 downto 0);
           rdreq: in std_logic;
           sclr: in std_logic := '0';
           usedw: out std_logic_vector(lpm_widthu-1 downto 0);
           wrreq: in std_logic
           );
  end component;


  signal reset : std_logic;

  -- FIFO connection signals
  constant SOURCE_LPM_NUMWORDS : natural := NUM_IN_STAGES + NUM_OUT_STAGES + NUM_STALL_W_STAGES + 3 + 5 + 8; -- the last +8 is safeguard
  constant SOURCE_ALMOST_FULL : natural := 5 + 8; -- the last +8 is safeguard
  constant SOURCE_LPM_WIDTHU : natural := log2_ceil_one(SOURCE_LPM_NUMWORDS);
  constant FIFO_DATA_WIDTH : natural := WIDTH_g+data_count'length;
  signal source_fifo_data, source_fifo_q : std_logic_vector (FIFO_DATA_WIDTH-1 downto 0);
  signal source_fifo_empty, source_fifo_almost_full : std_logic;
  signal source_fifo_rdreq, source_fifo_wrreq : std_logic;
  signal source_fifo_usedw : std_logic_vector (SOURCE_LPM_WIDTHU-1 downto 0);

  -- other signals
  signal source_valid_s : std_logic;

begin


-- hard-wire the reset signal
reset <= not(reset_n);


-- connect the source FIFO
source_FIFO : scfifo
  generic map(
              almost_full_value        => SOURCE_ALMOST_FULL,
              lpm_numwords             => SOURCE_LPM_NUMWORDS,
              lpm_width                => FIFO_DATA_WIDTH,
              lpm_widthu               => SOURCE_LPM_WIDTHU,
              lpm_showahead            => "OFF",
              use_eab                  => "ON" 
             )
  port map(
           clock         => clk,
           data          => source_fifo_data,
           empty         => source_fifo_empty,
           full          => open,
           almost_full   => source_fifo_almost_full,
           almost_empty  => open,
           q             => source_fifo_q,
           rdreq         => source_fifo_rdreq,
           sclr          => reset,
           usedw         => source_fifo_usedw,
           wrreq         => source_fifo_wrreq
          );

-- input data to source fifo
source_fifo_data(WIDTH_g-1 downto 0)                          <= data;
source_fifo_data(FIFO_DATA_WIDTH-1 downto WIDTH_g)  <= data_count;
-- output data from source fifo
at_source_data      <= source_fifo_q(WIDTH_g-1 downto 0);
at_source_channel   <= source_fifo_q(FIFO_DATA_WIDTH-1 downto WIDTH_g);
-- source fifo status signals for internal control
source_stall <= source_fifo_almost_full;


-- fifo control signal
source_fifo_wrreq <= source_valid_ctrl;

fifo_rd_process : process (clk) is
begin
  if source_valid_s = '0' or at_source_ready = '1' then
    source_fifo_rdreq <= '1';
  else
    source_fifo_rdreq <= '0';
  end if;
end process;


source_valid_s_process : process (clk) is
begin
  if rising_edge(clk) then
    if reset = '1' then
      source_valid_s <= '0';
    else
      if source_fifo_rdreq = '1' and source_fifo_empty = '0' then
        source_valid_s <= '1';
      elsif source_fifo_rdreq = '1' and source_fifo_empty = '1' then
        source_valid_s <= '0';
      end if;
    end if;
  end if;
end process;
at_source_valid <= source_valid_s;



-- sop and eop process: DUMMY CONNECTION
process (source_fifo_q) is
begin
  if unsigned(source_fifo_q(FIFO_DATA_WIDTH-1 downto WIDTH_g)) = 0 then
    at_source_sop <= '1';
  else
    at_source_sop <= '0';
  end if;
  if unsigned(source_fifo_q(FIFO_DATA_WIDTH-1 downto WIDTH_g)) = PACKET_SIZE_g-1 then
    at_source_eop <= '1';
  else
    at_source_eop <= '0';
  end if;
end process;



-- error code: DUMMY CONNECTION
at_source_error <= packet_error;


end rtl;


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

entity auk_dspip_avalon_streaming_sink is
  generic(
    WIDTH_g                    : integer := 16;
    NUM_SINK_READY_CTRL_STAGES : natural := 1;
    NUM_STALL_W_STAGES         : natural := 1
    );
  port(
    clk             : in  std_logic;
    reset_n         : in  std_logic;
    ----------------- DESIGN SIDE SIGNALS
    data            : out std_logic_vector(WIDTH_g-1 downto 0);
    data_valid      : out std_logic;
    sink_ready_ctrl : in  std_logic;    --the controller will tell
                                        --the interface whether
                                        --new input can be accepted.
    sink_stall      : out std_logic;    --needs to stall the design
                                        --if no new data is coming
    packet_error    : out std_logic_vector (1 downto 0);  --this is for SOP and EOP check only.
                                        --when any of these doesn't behave as
                                        --expected, the error is flagged.
    send_sop        : out std_logic;    -- transmit SOP signal to the design.
                                        -- It only transmits the legal SOP.
    send_eop        : out std_logic;    -- transmit EOP signal to the design.
                                        -- It only transmits the legal EOP.    
    ----------------- ATLANTIC SIDE SIGNALS
    at_sink_ready   : out std_logic;    --it will be '1' whenever the
                                        --sink_ready_ctrl signal is high.
    at_sink_valid   : in  std_logic;
    at_sink_data    : in  std_logic_vector(WIDTH_g-1 downto 0);
    at_sink_sop     : in  std_logic := '0';
    at_sink_eop     : in  std_logic := '0';
    at_sink_error   : in  std_logic_vector(1 downto 0)  := "00" --it indicates
                                        --that there is an error in the packet.
    );
end auk_dspip_avalon_streaming_sink;



architecture rtl of auk_dspip_avalon_streaming_sink is

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
  constant SINK_LPM_NUMWORDS : natural := NUM_SINK_READY_CTRL_STAGES + NUM_STALL_W_STAGES + 5;
  constant SINK_ALMOST_EMPTY : natural := SINK_LPM_NUMWORDS - 5 + 1;
  constant SINK_LPM_WIDTHU : natural := log2_ceil_one(SINK_LPM_NUMWORDS);
  constant FIFO_DATA_WIDTH : natural := WIDTH_g + 2;
  signal sink_fifo_data, sink_fifo_q : std_logic_vector (FIFO_DATA_WIDTH-1 downto 0);
  signal sink_fifo_almost_empty, sink_fifo_full : std_logic;
  signal sink_fifo_rdreq, sink_fifo_wrreq : std_logic;
  signal sink_fifo_usedw : std_logic_vector (SINK_LPM_WIDTHU-1 downto 0);
  


begin


-- hard-wire the reset signal
reset <= not(reset_n);



-- connect the sink FIFO
sink_FIFO : scfifo
  generic map(
              almost_empty_value       => SINK_ALMOST_EMPTY,
              lpm_numwords             => SINK_LPM_NUMWORDS,
              lpm_width                => FIFO_DATA_WIDTH,
              lpm_widthu               => SINK_LPM_WIDTHU,
              lpm_showahead            => "OFF",
              use_eab                  => "ON"
             )
  port map(
           clock         => clk,
           data          => sink_fifo_data,
           empty         => open,
           full          => sink_fifo_full,
           almost_full   => open,
           almost_empty  => sink_fifo_almost_empty,
           q             => sink_fifo_q,
           rdreq         => sink_fifo_rdreq,
           sclr          => reset,
           usedw         => sink_fifo_usedw,
           wrreq         => sink_fifo_wrreq
          );
-- fifo control signals
sink_fifo_rdreq <= sink_ready_ctrl;
sink_fifo_wrreq <= at_sink_valid;
-- input data to the sink fifo
sink_fifo_data(WIDTH_g-1 downto 0) <= at_sink_data;
sink_fifo_data(WIDTH_g)            <= at_sink_eop;
sink_fifo_data(WIDTH_g+1)          <= at_sink_sop;
-- output data from the sink fifo
data     <= sink_fifo_q(WIDTH_g-1 downto 0);
send_eop <= sink_fifo_q(WIDTH_g);
send_sop <= sink_fifo_q(WIDTH_g+1);
-- sink fifo status signals for internal control
at_sink_ready <= not(sink_fifo_full);
sink_stall <= sink_fifo_almost_empty;



-- error code: DUMMY CONNECTION
packet_error <= at_sink_error;



-- data valid signal
process (clk)
begin
  if (rising_edge(clk)) then
    data_valid <= sink_fifo_rdreq;
  end if;
end process;
  
end rtl;


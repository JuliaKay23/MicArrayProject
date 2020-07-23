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


entity auk_dspip_avalon_streaming_controller is
  generic(
          HYPER_PIPELINE : natural := 1;
          NUM_IN_STAGES  : natural := 1;
          NUM_OUT_STAGES : natural := 1;
          NUM_SINK_READY_CTRL_STAGES : natural := 1;
          NUM_STALL_W_STAGES : natural := 1
         );
  port(
    clk                 : in  std_logic;
    clk_en              : in  std_logic;
    reset_n             : in  std_logic;
    ready               : in  std_logic;
    sink_packet_error   : in  std_logic_vector (1 downto 0);
    sink_stall          : in  std_logic;
    source_stall        : in  std_logic;
    valid               : in  std_logic;
    reset_design        : out std_logic;
    sink_ready_ctrl     : out std_logic;                       
    source_packet_error : out std_logic_vector (1 downto 0);
    source_valid_ctrl   : out std_logic;
    stall               : out std_logic
    );
end auk_dspip_avalon_streaming_controller;



architecture struct of auk_dspip_avalon_streaming_controller is


  component hyper_pipeline_interface is
    generic (
            PIPELINE_STAGES : natural := 3;
            SIGNAL_WIDTH : natural := 1
            );
    port (
          clk : IN STD_LOGIC;
          clken : IN STD_LOGIC;
          reset : IN STD_LOGIC;
          signal_w : IN STD_LOGIC_VECTOR (SIGNAL_WIDTH-1 DOWNTO 0);
          signal_pipelined : OUT STD_LOGIC_VECTOR (SIGNAL_WIDTH-1 DOWNTO 0)
         );
  end component;


  -- single-clock FIFO, small and light weight version
  component auk_dspip_avalon_streaming_small_fifo
  generic (
           almost_full_value : natural := 1;
           lpm_numwords : natural;
           lpm_width    : natural;
           lpm_widthu   : natural;
           showahead    : string := "OFF"
           );
  port    (
           clock: in std_logic;
           data: in std_logic_vector(lpm_width-1 downto 0);
           empty: out std_logic;
           full: out std_logic;
           almost_full : out std_logic;
           q : out std_logic_vector(lpm_width-1 downto 0);
           rdreq: in std_logic;
           sclr: in std_logic := '0';
           usedw: out std_logic_vector(lpm_widthu-1 downto 0);
           wrreq: in std_logic
           );
  end component;


  signal reset_sig : std_logic;
  signal stall_w, stall_w_pipelined_1, stall_w_pipelined_2, stall_reg, stall_reg_pipelined : std_logic;
  signal sink_ready_ctrl_w : std_logic;

  -- ready fifo connections
  constant READY_LPM_NUMWORDS               : natural := NUM_IN_STAGES + NUM_OUT_STAGES + 1 + NUM_SINK_READY_CTRL_STAGES;
  constant READY_LPM_WIDTHU                 : natural := log2_ceil_one(READY_LPM_NUMWORDS);
  signal ready_fifo_empty, ready_fifo_full  : std_logic;
  signal ready_fifo_rdreq, ready_fifo_wrreq : std_logic;
  signal ready_fifo_q                       : std_logic;
  signal ready_fifo_usedw                   : std_logic_vector (READY_LPM_WIDTHU-1 downto 0);


begin

  reset_sig <= not reset_n;

  -- control mechanism
  reset_design <= not reset_n;
  stall_w <= sink_stall or source_stall or not(clk_en);
  source_valid_ctrl <= valid and not(stall_reg_pipelined);
  source_packet_error <= sink_packet_error;

  stall_reg_process : process(clk)
  begin
    if rising_edge(clk) then
      if reset_sig = '1' then
        stall_reg <= '1';
      else
        stall_reg <= stall_w_pipelined_2;
      end if;
    end if;
  end process;

  stall <= stall_reg;


  -----------------------------------------------------------------------------
  -- Add hyper pipeline stages
  -----------------------------------------------------------------------------
  hyper_pipeline_gen : if (HYPER_PIPELINE = 1) generate
    stall_w_pipeline_1 : hyper_pipeline_interface
      generic map (
                   PIPELINE_STAGES => NUM_STALL_W_STAGES,
                   SIGNAL_WIDTH => 1
                  )
      port map (  
                clk => clk,
                clken => clk_en,
                reset => '0',
                signal_w(0) => stall_w,
                signal_pipelined(0) => stall_w_pipelined_1
               );
    stall_w_pipeline_2 : hyper_pipeline_interface
      generic map (
                   PIPELINE_STAGES => NUM_SINK_READY_CTRL_STAGES,
                   SIGNAL_WIDTH => 1
                  )
      port map (  
                clk => clk,
                clken => clk_en,
                reset => '0',
                signal_w(0) => stall_w_pipelined_1,
                signal_pipelined(0) => stall_w_pipelined_2
               );
    stall_reg_pipeline : hyper_pipeline_interface
      generic map (
                   PIPELINE_STAGES => NUM_IN_STAGES+NUM_OUT_STAGES,
                   SIGNAL_WIDTH => 1
                  )
      port map (  
                clk => clk,
                clken => clk_en,
                reset => reset_sig,
                signal_w(0) => stall_reg,
                signal_pipelined(0) => stall_reg_pipelined
               );
    sink_ready_ctrl_pipeline : hyper_pipeline_interface
      generic map (
                   PIPELINE_STAGES => NUM_SINK_READY_CTRL_STAGES,
                   SIGNAL_WIDTH => 1
                  )
      port map (  
                clk => clk,
                clken => clk_en,
                reset => reset_sig,
                signal_w(0) => sink_ready_ctrl_w,
                signal_pipelined(0) => sink_ready_ctrl
               );     
  end generate;
  no_pipeline_gen : if (HYPER_PIPELINE /= 1) generate
    stall_w_pipelined_1 <= stall_w;
    stall_w_pipelined_2 <= stall_w_pipelined_1;
    stall_reg_pipelined <= stall_reg;
    sink_ready_ctrl     <= sink_ready_ctrl_w;
  end generate;


  -----------------------------------------------------------------------------
  -- Record ready signals from the design: no ready signal should be ignored due to pipeline latency
  -----------------------------------------------------------------------------
  ready_FIFO : auk_dspip_avalon_streaming_small_fifo
  generic map(
              lpm_numwords             => READY_LPM_NUMWORDS,
              lpm_width                => 1,
              lpm_widthu               => READY_LPM_WIDTHU,
              showahead                => "ON"
             )
  port map(
           clock         => clk,
           data(0)       => ready,
           empty         => ready_fifo_empty,
           full          => ready_fifo_full,
           almost_full   => open,
           q(0)          => ready_fifo_q,
           rdreq         => ready_fifo_rdreq,
           sclr          => reset_sig,
           usedw         => ready_fifo_usedw,
           wrreq         => ready_fifo_wrreq
          );
  ready_fifo_wrreq <= (stall_w_pipelined_1 or not(ready_fifo_empty))   and   not(stall_reg_pipelined)   and   clk_en;
  ready_fifo_rdreq <= not(stall_w_pipelined_1) and not(ready_fifo_empty)                                and   clk_en;


  sink_ready_ctrl_process : process(stall_w_pipelined_1, ready, ready_fifo_q, ready_fifo_empty) -- finally connect the ready signal to sink_ready_ctrl
    begin
      if (stall_w_pipelined_1 = '0' and ready_fifo_empty = '0') then
        sink_ready_ctrl_w <= ready_fifo_q;
      elsif (stall_w_pipelined_1 = '0') then
        sink_ready_ctrl_w <= ready;
      else
        sink_ready_ctrl_w <= '0';
      end if;
    end process;


end struct;

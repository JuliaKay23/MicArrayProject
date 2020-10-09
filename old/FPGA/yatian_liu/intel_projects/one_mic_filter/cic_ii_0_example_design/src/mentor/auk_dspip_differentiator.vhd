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


-------------------------------------------------------------------------
-------------------------------------------------------------------------
--
-- Revision Control Information
--
-- $RCSfile: auk_dspip_differentiator.vhd,v $
-- $Source: /cvs/uksw/dsp_cores/CIC/src/rtl/auk_dspip_differentiator.vhd,v $
--
-- $Revision: #1 $
-- $Date: 2008/07/12 $
-- Check in by     : $Author: max $
-- Author   :  Zhengjun Pan
-- 
-- $Revision: #2 $
-- $Date: 2015/07/29 $
-- Author   :  Jianxiong Liu
--
-- Project      :  CIC Compiler
--
-- Description : 
--
-- This functional unit defines the CIC differentiator building block.
-- 
-- ALTERA Confidential and Proprietary
-- Copyright 2006 (c) Altera Corporation
-- All rights reserved
--
-------------------------------------------------------------------------
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

library altera_mf;
use altera_mf.altera_mf_components.all;

library LPM;
use LPM.LPM_COMPONENTS.all;

library work;
use work.auk_dspip_lib_pkg.all;

entity auk_dspip_differentiator is
  generic
    (
      WIDTH_g      : natural := 8;      -- data width
      DEPTH_g      : natural := 1;      -- the number of clock cycles the input
                                        -- will be delayed
      USE_MEMORY_g : boolean := false;  -- map the registers to memory
      LPM_HINT_g   : string  := "AUTO"; -- The memory type that the registers
                                        -- will be mapped onto. Supported
                                        -- types "AUTO", "M512", "M4K"
      HYPER_PIPELINE : natural := 0;    -- option of hyper pipeline for S10
      PIPELINE_STAGES : natural := 1       -- number of pipeline stages at the output
      );
  port
    (
      clk        : in  std_logic;
      reset      : in  std_logic := '0';
      ena        : in  std_logic := '1';
      din_valid  : in  std_logic;
      din        : in  std_logic_vector (WIDTH_g-1 downto 0);
      dout       : out std_logic_vector (WIDTH_g-1 downto 0);
      dout_valid : out std_logic
      );
end auk_dspip_differentiator;

architecture SYN of auk_dspip_differentiator is

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

  signal delay_out : std_logic_vector(WIDTH_g-1 downto 0);

  signal ena_and_valid : std_logic; -- temporary signal for ena and din_valid

  -- output directly from the combinatorial adder
  signal resq      : std_logic_vector(WIDTH_g-1 downto 0);
  
  -- hyper pipeline of the output
  signal resq_pipelined : std_logic_vector(WIDTH_g-1 downto 0);
  signal din_valid_pipelined : std_logic;
  
  
begin

  ena_and_valid <= ena and din_valid;

  reg_dout : process (clk) -- register the output from the adder
  begin
    if rising_edge(clk) then
      if reset = '1' then
        dout <= (others=>'0');
        dout_valid <= '0';
      elsif ena = '1' then
        if din_valid_pipelined = '1' then
          dout <= resq_pipelined;
        end if;
        dout_valid <= din_valid_pipelined;
      end if;
    end if;
  end process reg_dout;

  -----------------------------------------------------------------------------
  -- use LCs for the registers, the magic # 5 is due to that the minimum depth to
  -- use memory is 3 but the last and the first will always be put onto LCs by
  -- FU auk_dspip_delay.
  -----------------------------------------------------------------------------
  glogic : if (not USE_MEMORY_g or DEPTH_g < 5) generate
    u0 : auk_dspip_delay
      generic map
      (
        WIDTH_g          => WIDTH_g,
        DELAY_g          => DEPTH_g,
        MEMORY_TYPE_g    => "REGISTER",
        REGISTER_FIRST_g => 0,
        REGISTER_LAST_g  => 0
        )
      port map
      (
        clk     => clk,
        reset   => reset,
        enable  => ena_and_valid,
        datain  => din,
        dataout => delay_out
        );
  end generate glogic;

  -----------------------------------------------------------------------------
  -- use memories for the registers, the magic # 5 is due to that the minimum depth to
  -- use memory is 3 but the last and the first will always be put onto LCs by
  -- FU auk_dspip_delay.
  -----------------------------------------------------------------------------
  gmemory : if (USE_MEMORY_g and DEPTH_g > 4) generate
    u1 : auk_dspip_delay
      generic map
      (
        WIDTH_g          => WIDTH_g,
        DELAY_g          => DEPTH_g,
        MEMORY_TYPE_g    => LPM_HINT_g,
        REGISTER_FIRST_g => 1,
        REGISTER_LAST_g  => 1
        )
      port map
      (
        clk     => clk,
        reset   => reset,
        enable  => ena_and_valid,
        datain  => din,
        dataout => delay_out
        );
  end generate gmemory;

  -----------------------------------------------------------------------------
  -- Subtract the delayed input from the input.
  -----------------------------------------------------------------------------
  resq <= std_logic_vector(unsigned(din) - unsigned(delay_out));
  
    
  -----------------------------------------------------------------------------
  -- Add hyper pipeline stages to the output
  -----------------------------------------------------------------------------
  hyper_pipeline_gen : if (HYPER_PIPELINE = 1) generate
    out_pipeline : hyper_pipeline_interface
      generic map (
                   PIPELINE_STAGES => PIPELINE_STAGES,
                   SIGNAL_WIDTH => WIDTH_g
                  )
      port map (  
                clk => clk,
                clken => ena,
                reset => reset,
                signal_w => resq,
                signal_pipelined => resq_pipelined
               );
    valid_pipeline : hyper_pipeline_interface
      generic map (
                   PIPELINE_STAGES => PIPELINE_STAGES,
                   SIGNAL_WIDTH => 1
                  )
      port map (  
                clk => clk,
                clken => ena,
                reset => reset,
                signal_w(0) => din_valid,
                signal_pipelined(0) => din_valid_pipelined
               );
  end generate;
  no_pipeline_gen : if (HYPER_PIPELINE /= 1) generate
    resq_pipelined <= resq;
    din_valid_pipelined <= din_valid;
  end generate;

  
end SYN;


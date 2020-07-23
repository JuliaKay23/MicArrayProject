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
-- $RCSfile: auk_dspip_upsample.vhd,v $
-- $Source: /cvs/uksw/dsp_cores/CIC/src/rtl/auk_dspip_upsample.vhd,v $
--
-- $Revision: #1 $
-- $Date: 2008/07/12 $
-- Check in by     : $Author: max $
-- Author   :  Zhengjun Pan
--
-- Project      :  CIC Compiler
--
-- Description : 
--
-- This functional unit defines the CIC building block: UpSampling
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

entity auk_dspip_upsample is
  generic (
    WIDTH_g : natural := 8              -- data width
    );
  port(
    din       : in  std_logic_vector(WIDTH_g-1 downto 0);
    clk       : in  std_logic;
    ena       : in  std_logic := '1';
    reset     : in  std_logic := '0';
    din_valid : in  std_logic;          -- indicate if the input is valid
    dout      : out std_logic_vector(WIDTH_g-1 downto 0)
    );  

end auk_dspip_upsample;

architecture SYN of auk_dspip_upsample is

begin

  -----------------------------------------------------------------------------
  -- take the input when it is valid otherwise 0. It is assumed that an outside
  -- counter exists for indicating din_valid = '1' once for every interpolation
  -- factor clock cycles
  -----------------------------------------------------------------------------
  dout <= din when (din_valid = '1') else (others => '0');

end SYN;

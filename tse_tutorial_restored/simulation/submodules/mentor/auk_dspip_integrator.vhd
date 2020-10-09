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
-- $RCSfile: auk_dspip_integrator.vhd,v $
-- $Source: /cvs/uksw/dsp_cores/CIC/src/rtl/auk_dspip_integrator.vhd,v $
--
-- $Revision: #3 $
-- $Date: 2013/11/11 $
-- Check in by     : $Author: jrose $
-- Author   :  Zhengjun Pan
--
-- Project      :  CIC Compiler
--
-- Description : 
--
-- This functional unit defines the CIC integrator building block.
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

entity auk_dspip_integrator is
  generic
    (
	  I_PIPE_LINE_NUMBER: natural := 2;
      WIDTH_g      : natural := 8;      -- data width                            
      DEPTH_g      : natural := 2;      -- the number of clock cycles the input  
                                        -- will be delayed                       
      USE_MEMORY_g : boolean := false;  -- map the registers to memory           
      LPM_HINT_g   : string  := "AUTO"  -- The memory type that the registers    
      );                                -- will be mapped onto. Supported        
                                        -- types "AUTO", "M512", "M4K"           
  port
    (
      clk   : in  std_logic;
      reset : in  std_logic := '0';
      ena   : in  std_logic := '1';
      din   : in  std_logic_vector (WIDTH_g-1 downto 0);
      dout  : out std_logic_vector (WIDTH_g-1 downto 0)
      );
end auk_dspip_integrator;

architecture SYN of auk_dspip_integrator is

  signal resq : std_logic_vector(WIDTH_g-1 downto 0);

  -- output directly from the combinatorial adder
  signal resd : std_logic_vector(WIDTH_g-1 downto 0);
  --constant_define_generate: if(DEPTH_g > I_PIPE_LINE_NUMBER) generate
  --begin
--	constant DELAY_MEMORY: natural := DEPTH_g - I_PIPE_LINE_NUMBER;
--  end generate constant_define;	
  
begin

  --dout <= resd;

  -----------------------------------------------------------------------------
  -- use LCs for the registers, the magic # 5 is due to that the minimum depth to
  -- use memory is 3 but the last and the first will always be put onto LCs by
  -- FU auk_dspip_delay.
  -----------------------------------------------------------------------------
    glogic : if (not USE_MEMORY_g or DEPTH_g < 5) generate
		integrator_pipeline_0_generate: if(I_PIPE_LINE_NUMBER = 0) generate
                        resd <= std_logic_vector(unsigned(din) + unsigned(resq));
			u1 : auk_dspip_delay
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
				enable  => ena,
				datain  => resd,
				dataout => resq
				);
			dout <= resq;	
		end generate integrator_pipeline_0_generate;
		
		integrator_pipeline_1_generate: if((I_PIPE_LINE_NUMBER>0)and(DEPTH_g <= I_PIPE_LINE_NUMBER)) generate 
			u0 : lpm_add_sub
		    generic map (
		      lpm_width     => WIDTH_g,
		      lpm_direction => "ADD",
		      lpm_type      => "LPM_ADD_SUB",
		      lpm_hint      => "ONE_INPUT_IS_CONSTANT = NO",
			  lpm_pipeline  => DEPTH_g		
		      )
		    port map (
			  clock    => clk,
			  aclr	 => reset,
			  clken => ena,
		      dataa  => din,
		      datab  => resq,
		      result => resd);
			resq <= resd;
			dout <= resd;
		end generate integrator_pipeline_1_generate;
		
		integrator_pipeline_2_generate: if((I_PIPE_LINE_NUMBER>0)and(DEPTH_g > I_PIPE_LINE_NUMBER)) generate
			u0 : lpm_add_sub
			    generic map (
			      lpm_width     => WIDTH_g,
			      lpm_direction => "ADD",
			      lpm_type      => "LPM_ADD_SUB",
			      lpm_hint      => "ONE_INPUT_IS_CONSTANT = NO",
				  lpm_pipeline  => I_PIPE_LINE_NUMBER		
			      )
			    port map (
				  clock    => clk,
				  aclr	 => reset,
				  clken => ena,
			      dataa  => din,
			      datab  => resq,
			      result => resd);
			u1 : auk_dspip_delay
				generic map
				(
				WIDTH_g          => WIDTH_g,
				DELAY_g          => (DEPTH_g - I_PIPE_LINE_NUMBER),
				MEMORY_TYPE_g    => "REGISTER",
				REGISTER_FIRST_g => 0,
				REGISTER_LAST_g  => 0
				)
				port map
				(
				clk     => clk,
				reset   => reset,
				enable  => ena,
				datain  => resd,
				dataout => resq
				);
			dout <= resd;	
		end generate integrator_pipeline_2_generate;		
  end generate glogic;

  -----------------------------------------------------------------------------
  -- use memories for the registers, the magic # 5 is due to that the minimum depth to
  -- use memory is 3 but the last and the first will always be put onto LCs by
  -- FU auk_dspip_delay.
  -----------------------------------------------------------------------------
    gmemory : if (USE_MEMORY_g and DEPTH_g > 4) generate
		integrator_pipeline_3_generate:	if(I_PIPE_LINE_NUMBER = 0 or DEPTH_g = 5) generate
                      resd <= std_logic_vector(unsigned(din) + unsigned(resq));
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
		        enable  => ena,
		        datain  => resd,
		        dataout => resq
		        );
			dout <= resq;
		end generate integrator_pipeline_3_generate;
		
		integrator_pipeline_4_generate:	if((I_PIPE_LINE_NUMBER > 0)and(DEPTH_g > 5)) generate
		    u0 : lpm_add_sub
			    generic map (
			      lpm_width     => WIDTH_g,
			      lpm_direction => "ADD",
			      lpm_type      => "LPM_ADD_SUB",
			      lpm_hint      => "ONE_INPUT_IS_CONSTANT = NO",
				  lpm_pipeline  => I_PIPE_LINE_NUMBER		
			      )
			    port map (
				  clock    => clk,
				  aclr	 => reset,
				  clken => ena,
			      dataa  => din,
			      datab  => resq,
			      result => resd);
			u1 : auk_dspip_delay
		      generic map
		      (
		        WIDTH_g          => WIDTH_g,
		        DELAY_g          => (DEPTH_g - I_PIPE_LINE_NUMBER),
		        MEMORY_TYPE_g    => LPM_HINT_g,
		        REGISTER_FIRST_g => 1,
		        REGISTER_LAST_g  => 1
		        )
		      port map
		      (
		        clk     => clk,
		        reset   => reset,
		        enable  => ena,
		        datain  => resd,
		        dataout => resq
		        );
			dout <= resq;
		end generate integrator_pipeline_4_generate;	
  end generate gmemory;

end SYN;

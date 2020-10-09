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


library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

library work;
use work.auk_dspip_lib_pkg.all;
use work.auk_dspip_math_pkg.all;

library altera_mf;
use altera_mf.altera_mf_components.all;


entity auk_dspip_channel_buffer is

	generic 
	(
		DATA_WIDTH : natural := 8;
		ADDR_WIDTH : natural := 6
	);

	port 
	(
		clk			: in std_logic;
		data		: in std_logic_vector((DATA_WIDTH-1) downto 0);
    	clr   		: in std_logic;
		wrreq		: in std_logic := '1';
		rdreq		: in std_logic := '1';
		q			: out std_logic_vector((DATA_WIDTH -1) downto 0)
	);	

end entity;


architecture SYN of auk_dspip_channel_buffer is

	-- single-clock FIFO from altera_mf library
  component scfifo
  generic (
           add_ram_output_register: string := "ON"; -- NOTE: normally this is turned OFF. 
                                                    -- Turning this ON is to optimize for speed, but this introduce latency. 
                                                    -- Therefore the top level module of decimators addresses this by adding one cycle of latency to the fifo rdreq.
           allow_rwcycle_when_full: string := "OFF";
           almost_empty_value: natural := 0;
           almost_full_value: natural := 0;
           lpm_numwords: natural;
           lpm_showahead: string := "OFF";
           lpm_width: natural;
           lpm_widthu: natural;
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
  
  constant BUFFER_FIFO_WIDTHU : natural := log2_ceil_one(2**ADDR_WIDTH-1+1);

begin

-- connect the sink FIFO
buffer_FIFO : scfifo
generic map(
            lpm_numwords             => 2**ADDR_WIDTH-1,
            lpm_showahead            => "OFF",
            lpm_width                => DATA_WIDTH,
				lpm_widthu               => BUFFER_FIFO_WIDTHU,
            lpm_type                 => "scfifo"
           )
port map(
         clock         => clk,
         data          => data,
         empty         => open,
         full          => open,
         q             => q,
         rdreq         => rdreq,
         sclr          => clr,
         usedw         => open,
         wrreq         => wrreq
        );



end SYN;

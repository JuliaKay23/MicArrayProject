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


-- This is a simple fifo implementation that supports single cycle
-- writing and reading, with show-ahead feature.
-- This small fifo is used for simple control logics.

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.auk_dspip_lib_pkg.all;
use work.auk_dspip_math_pkg.all;


entity auk_dspip_avalon_streaming_small_fifo is
  generic (
  	       almost_full_value : natural := 1;
           lpm_numwords      : natural;
           lpm_width         : natural;
           lpm_widthu        : natural;
           showahead         : string := "OFF"
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
end auk_dspip_avalon_streaming_small_fifo;


architecture arch of auk_dspip_avalon_streaming_small_fifo is

  -- declare fifo array
  type array_type is array (lpm_numwords-1 downto 0) of std_logic_vector (lpm_width-1 downto 0);
  signal fifo_array : array_type;

  -- declare address pointers
  constant ADDRESS_WIDTH : natural := log2_ceil_one(lpm_numwords);
  signal wr_addr_ptr, rd_addr_ptr : unsigned (ADDRESS_WIDTH-1 downto 0);

  -- connection nodes
  signal fifo_full, fifo_empty, fifo_almost_full : std_logic;
  signal fifo_usedw : unsigned (lpm_widthu-1 downto 0);

begin


  -- fifo write process
  fifo_write : process (clock)
  begin
    if rising_edge(clock) then
      if sclr = '1' then
        wr_addr_ptr <= (others=>'0');
        fifo_array <= (others=>(others=>'0'));
      else
        if wrreq = '1' and fifo_full = '0' then 
          fifo_array(to_integer(wr_addr_ptr)) <= data;
          if wr_addr_ptr = lpm_numwords-1 then
            wr_addr_ptr <= (others=>'0');
          else
            wr_addr_ptr <= wr_addr_ptr + 1;
          end if;
        end if;
      end if;
    end if;
  end process;


  -- fifo read process
  fifo_read : process (clock)
  begin
    if rising_edge(clock) then
      if sclr = '1' then
        rd_addr_ptr <= (others=>'0');
      else
        if rdreq = '1' and fifo_empty = '0' then
          if rd_addr_ptr = lpm_numwords-1 then
            rd_addr_ptr <= (others=>'0');
          else
            rd_addr_ptr <= rd_addr_ptr + 1;
          end if;
        end if;
      end if;
    end if;
  end process;

  -- read data output connection
  output_gen_showahead : if showahead = "ON" generate
    q <= fifo_array(to_integer(rd_addr_ptr)); -- show-ahead the data
  end generate;
  output_gen_normal    : if showahead = "OFF" generate
    read_out : process (clock)
    begin
      if rising_edge(clock) then
        if sclr = '1' then
          q <= (others=>'0');
        else
          if rdreq = '1' then
            q <= fifo_array(to_integer(rd_addr_ptr)); -- normal fiforead mode
          end if;
        end if;
      end if;
    end process;
  end generate;


  -- usedw process
  usedw_process : process (clock)
  begin
    if rising_edge(clock) then
      if sclr = '1' then
        fifo_usedw <= (others=>'0');
      else
        if (wrreq = '1' and fifo_full = '0' and (rdreq = '0' or fifo_empty = '1')) then
          fifo_usedw <= fifo_usedw + 1;
        elsif ((wrreq = '0' or fifo_full = '1') and rdreq = '1' and fifo_empty = '0') then
          fifo_usedw <= fifo_usedw - 1;
        end if;
      end if;
    end if;
  end process;
  usedw <= std_logic_vector(fifo_usedw);


  -- fifo status process
  fifo_status : process (fifo_usedw)
  begin
    if fifo_usedw = to_unsigned(0,lpm_widthu) then
      fifo_empty <= '1';
    else 
      fifo_empty <= '0';
    end if;
    if fifo_usedw = to_unsigned(lpm_numwords,lpm_widthu) then
      fifo_full <= '1';
    else
      fifo_full <= '0';
    end if;
    if fifo_usedw >= to_unsigned(almost_full_value,lpm_widthu) then
      fifo_almost_full <= '1';
    else
      fifo_almost_full <= '0';
    end if;
  end process;
  empty <= fifo_empty;
  full <= fifo_full;
  almost_full <= fifo_almost_full;
 
end arch;

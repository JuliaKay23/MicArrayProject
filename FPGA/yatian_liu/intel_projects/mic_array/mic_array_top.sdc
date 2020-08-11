## Generated SDC file "mic_array.out.sdc"

## Copyright (C) 2019  Intel Corporation. All rights reserved.
## Your use of Intel Corporation's design tools, logic functions 
## and other software and tools, and any partner logic 
## functions, and any output files from any of the foregoing 
## (including device programming or simulation files), and any 
## associated documentation or information are expressly subject 
## to the terms and conditions of the Intel Program License 
## Subscription Agreement, the Intel Quartus Prime License Agreement,
## the Intel FPGA IP License Agreement, or other applicable license
## agreement, including, without limitation, that your use is for
## the sole purpose of programming logic devices manufactured by
## Intel and sold by Intel or its authorized distributors.  Please
## refer to the applicable agreement for further details, at
## https://fpgasoftware.intel.com/eula.


## VENDOR  "Altera"
## PROGRAM "Quartus Prime"
## VERSION "Version 19.1.0 Build 670 09/22/2019 Patches 0.02std SJ Standard Edition"

## DATE    "Wed Aug 05 03:01:25 2020"

##
## DEVICE  "5AGXFB3H4F35C4"
##


#**************************************************************
# Time Information
#**************************************************************

set_time_format -unit ns -decimal_places 3



#**************************************************************
# Create Clock
#**************************************************************

create_clock -name {altera_reserved_tck} -period 33.333 -waveform { 0.000 16.666 } [get_ports {altera_reserved_tck}]
create_clock -name {ext_clk} -period 20.000 -waveform { 0.000 10.000 } [get_ports {clk_50mhz}]


#**************************************************************
# Create Generated Clock
#**************************************************************

create_generated_clock -name {pll_clock_generator:pll_clock_generator0|pll_clock_generator_pll_0:pll_0|altera_pll:altera_pll_i|altera_arriav_pll:arriav_pll|divclk[3]} -source [get_pins {pll_clock_generator0|pll_0|altera_pll_i|arriav_pll|counter[3].output_counter|cascadein}] -duty_cycle 50/1 -multiply_by 1 -divide_by 5 -master_clock {pll_clock_generator:pll_clock_generator0|pll_clock_generator_pll_0:pll_0|altera_pll:altera_pll_i|altera_arriav_pll:arriav_pll|cascade_wire[2]} [get_pins {pll_clock_generator0|pll_0|altera_pll_i|arriav_pll|counter[3].output_counter|divclk}] 
create_generated_clock -name {pll_clock_generator:pll_clock_generator0|pll_clock_generator_pll_0:pll_0|altera_pll:altera_pll_i|altera_arriav_pll:arriav_pll|cascade_wire[2]} -source [get_pins {pll_clock_generator0|pll_0|altera_pll_i|arriav_pll|counter[2].output_counter|vco0ph[0]}] -duty_cycle 50/1 -multiply_by 1 -divide_by 200 -master_clock {pll_clock_generator:pll_clock_generator0|pll_clock_generator_pll_0:pll_0|altera_pll:altera_pll_i|altera_arriav_pll:arriav_pll|altera_arriav_pll_base:fpll_0|vcoph[0]} [get_pins {pll_clock_generator0|pll_0|altera_pll_i|arriav_pll|counter[2].output_counter|cascadeout}] 
create_generated_clock -name {pll_clock_generator:pll_clock_generator0|pll_clock_generator_pll_0:pll_0|altera_pll:altera_pll_i|altera_arriav_pll:arriav_pll|divclk[1]} -source [get_pins {pll_clock_generator0|pll_0|altera_pll_i|arriav_pll|counter[1].output_counter|vco0ph[0]}] -duty_cycle 50/1 -multiply_by 1 -divide_by 200 -master_clock {pll_clock_generator:pll_clock_generator0|pll_clock_generator_pll_0:pll_0|altera_pll:altera_pll_i|altera_arriav_pll:arriav_pll|altera_arriav_pll_base:fpll_0|vcoph[0]} [get_pins {pll_clock_generator0|pll_0|altera_pll_i|arriav_pll|counter[1].output_counter|divclk}] 
create_generated_clock -name {pll_clock_generator:pll_clock_generator0|pll_clock_generator_pll_0:pll_0|altera_pll:altera_pll_i|altera_arriav_pll:arriav_pll|altera_arriav_pll_base:fpll_0|vcoph[0]} -source [get_pins {pll_clock_generator0|pll_0|altera_pll_i|arriav_pll|fpll_0|fpll|refclkin}] -duty_cycle 50/1 -multiply_by 16 -divide_by 2 -master_clock {ext_clk} [get_pins {pll_clock_generator0|pll_0|altera_pll_i|arriav_pll|fpll_0|fpll|vcoph[0]}] 


#**************************************************************
# Set Clock Latency
#**************************************************************



#**************************************************************
# Set Clock Uncertainty
#**************************************************************

set_clock_uncertainty -rise_from [get_clocks {ext_clk}] -rise_to [get_clocks {ext_clk}] -setup 0.050  
set_clock_uncertainty -rise_from [get_clocks {ext_clk}] -fall_to [get_clocks {ext_clk}] -setup 0.050  
set_clock_uncertainty -rise_from [get_clocks {ext_clk}] -rise_to [get_clocks {pll_clock_generator:pll_clock_generator0|pll_clock_generator_pll_0:pll_0|altera_pll:altera_pll_i|altera_arriav_pll:arriav_pll|divclk[1]}] -setup 0.050  
set_clock_uncertainty -rise_from [get_clocks {ext_clk}] -fall_to [get_clocks {pll_clock_generator:pll_clock_generator0|pll_clock_generator_pll_0:pll_0|altera_pll:altera_pll_i|altera_arriav_pll:arriav_pll|divclk[1]}] -setup 0.050  
set_clock_uncertainty -fall_from [get_clocks {ext_clk}] -rise_to [get_clocks {ext_clk}] -setup 0.050  
set_clock_uncertainty -fall_from [get_clocks {ext_clk}] -fall_to [get_clocks {ext_clk}] -setup 0.050  
set_clock_uncertainty -fall_from [get_clocks {ext_clk}] -rise_to [get_clocks {pll_clock_generator:pll_clock_generator0|pll_clock_generator_pll_0:pll_0|altera_pll:altera_pll_i|altera_arriav_pll:arriav_pll|divclk[1]}] -setup 0.050  
set_clock_uncertainty -fall_from [get_clocks {ext_clk}] -fall_to [get_clocks {pll_clock_generator:pll_clock_generator0|pll_clock_generator_pll_0:pll_0|altera_pll:altera_pll_i|altera_arriav_pll:arriav_pll|divclk[1]}] -setup 0.050  
set_clock_uncertainty -rise_from [get_clocks {altera_reserved_tck}] -rise_to [get_clocks {altera_reserved_tck}] -setup 0.050  
set_clock_uncertainty -rise_from [get_clocks {altera_reserved_tck}] -fall_to [get_clocks {altera_reserved_tck}] -setup 0.050  
set_clock_uncertainty -fall_from [get_clocks {altera_reserved_tck}] -rise_to [get_clocks {altera_reserved_tck}] -setup 0.050  
set_clock_uncertainty -fall_from [get_clocks {altera_reserved_tck}] -fall_to [get_clocks {altera_reserved_tck}] -setup 0.050  
set_clock_uncertainty -rise_from [get_clocks {pll_clock_generator:pll_clock_generator0|pll_clock_generator_pll_0:pll_0|altera_pll:altera_pll_i|altera_arriav_pll:arriav_pll|divclk[1]}] -rise_to [get_clocks {pll_clock_generator:pll_clock_generator0|pll_clock_generator_pll_0:pll_0|altera_pll:altera_pll_i|altera_arriav_pll:arriav_pll|divclk[1]}] -setup 0.050  
set_clock_uncertainty -rise_from [get_clocks {pll_clock_generator:pll_clock_generator0|pll_clock_generator_pll_0:pll_0|altera_pll:altera_pll_i|altera_arriav_pll:arriav_pll|divclk[1]}] -fall_to [get_clocks {pll_clock_generator:pll_clock_generator0|pll_clock_generator_pll_0:pll_0|altera_pll:altera_pll_i|altera_arriav_pll:arriav_pll|divclk[1]}] -setup 0.050  
set_clock_uncertainty -rise_from [get_clocks {pll_clock_generator:pll_clock_generator0|pll_clock_generator_pll_0:pll_0|altera_pll:altera_pll_i|altera_arriav_pll:arriav_pll|divclk[1]}] -rise_to [get_clocks {pll_clock_generator:pll_clock_generator0|pll_clock_generator_pll_0:pll_0|altera_pll:altera_pll_i|altera_arriav_pll:arriav_pll|divclk[3]}] -setup 0.050  
set_clock_uncertainty -rise_from [get_clocks {pll_clock_generator:pll_clock_generator0|pll_clock_generator_pll_0:pll_0|altera_pll:altera_pll_i|altera_arriav_pll:arriav_pll|divclk[1]}] -fall_to [get_clocks {pll_clock_generator:pll_clock_generator0|pll_clock_generator_pll_0:pll_0|altera_pll:altera_pll_i|altera_arriav_pll:arriav_pll|divclk[3]}] -setup 0.050  
set_clock_uncertainty -fall_from [get_clocks {pll_clock_generator:pll_clock_generator0|pll_clock_generator_pll_0:pll_0|altera_pll:altera_pll_i|altera_arriav_pll:arriav_pll|divclk[1]}] -rise_to [get_clocks {pll_clock_generator:pll_clock_generator0|pll_clock_generator_pll_0:pll_0|altera_pll:altera_pll_i|altera_arriav_pll:arriav_pll|divclk[1]}] -setup 0.050  
set_clock_uncertainty -fall_from [get_clocks {pll_clock_generator:pll_clock_generator0|pll_clock_generator_pll_0:pll_0|altera_pll:altera_pll_i|altera_arriav_pll:arriav_pll|divclk[1]}] -fall_to [get_clocks {pll_clock_generator:pll_clock_generator0|pll_clock_generator_pll_0:pll_0|altera_pll:altera_pll_i|altera_arriav_pll:arriav_pll|divclk[1]}] -setup 0.050  
set_clock_uncertainty -fall_from [get_clocks {pll_clock_generator:pll_clock_generator0|pll_clock_generator_pll_0:pll_0|altera_pll:altera_pll_i|altera_arriav_pll:arriav_pll|divclk[1]}] -rise_to [get_clocks {pll_clock_generator:pll_clock_generator0|pll_clock_generator_pll_0:pll_0|altera_pll:altera_pll_i|altera_arriav_pll:arriav_pll|divclk[3]}] -setup 0.050  
set_clock_uncertainty -fall_from [get_clocks {pll_clock_generator:pll_clock_generator0|pll_clock_generator_pll_0:pll_0|altera_pll:altera_pll_i|altera_arriav_pll:arriav_pll|divclk[1]}] -fall_to [get_clocks {pll_clock_generator:pll_clock_generator0|pll_clock_generator_pll_0:pll_0|altera_pll:altera_pll_i|altera_arriav_pll:arriav_pll|divclk[3]}] -setup 0.050  
set_clock_uncertainty -rise_from [get_clocks {pll_clock_generator:pll_clock_generator0|pll_clock_generator_pll_0:pll_0|altera_pll:altera_pll_i|altera_arriav_pll:arriav_pll|divclk[3]}] -rise_to [get_clocks {pll_clock_generator:pll_clock_generator0|pll_clock_generator_pll_0:pll_0|altera_pll:altera_pll_i|altera_arriav_pll:arriav_pll|divclk[3]}] -setup 0.050  
set_clock_uncertainty -rise_from [get_clocks {pll_clock_generator:pll_clock_generator0|pll_clock_generator_pll_0:pll_0|altera_pll:altera_pll_i|altera_arriav_pll:arriav_pll|divclk[3]}] -fall_to [get_clocks {pll_clock_generator:pll_clock_generator0|pll_clock_generator_pll_0:pll_0|altera_pll:altera_pll_i|altera_arriav_pll:arriav_pll|divclk[3]}] -setup 0.050  
set_clock_uncertainty -fall_from [get_clocks {pll_clock_generator:pll_clock_generator0|pll_clock_generator_pll_0:pll_0|altera_pll:altera_pll_i|altera_arriav_pll:arriav_pll|divclk[3]}] -rise_to [get_clocks {pll_clock_generator:pll_clock_generator0|pll_clock_generator_pll_0:pll_0|altera_pll:altera_pll_i|altera_arriav_pll:arriav_pll|divclk[3]}] -setup 0.050  
set_clock_uncertainty -fall_from [get_clocks {pll_clock_generator:pll_clock_generator0|pll_clock_generator_pll_0:pll_0|altera_pll:altera_pll_i|altera_arriav_pll:arriav_pll|divclk[3]}] -fall_to [get_clocks {pll_clock_generator:pll_clock_generator0|pll_clock_generator_pll_0:pll_0|altera_pll:altera_pll_i|altera_arriav_pll:arriav_pll|divclk[3]}] -setup 0.050  


#**************************************************************
# Set Input Delay
#**************************************************************



#**************************************************************
# Set Output Delay
#**************************************************************



#**************************************************************
# Set Clock Groups
#**************************************************************

set_clock_groups -asynchronous -group [get_clocks {altera_reserved_tck}] 


#**************************************************************
# Set False Path
#**************************************************************

set_false_path -from [get_keepers {altera_reserved_tdi}] -to [get_keepers {pzdyqx*}]
set_false_path -to [get_pins -nocase -compatibility_mode {*|alt_rst_sync_uq1|altera_reset_synchronizer_int_chain*|clrn}]


#**************************************************************
# Set Multicycle Path
#**************************************************************



#**************************************************************
# Set Maximum Delay
#**************************************************************



#**************************************************************
# Set Minimum Delay
#**************************************************************



#**************************************************************
# Set Input Transition
#**************************************************************



#**************************************************************
# Set Disable Timing
#**************************************************************

set_disable_timing -from * -to * [get_cells -hierarchical {VVYU6267_0}]
set_disable_timing -from * -to * [get_cells -hierarchical {XWCN9723_0}]
set_disable_timing -from * -to * [get_cells -hierarchical {XWCN9723_1}]
set_disable_timing -from * -to * [get_cells -hierarchical {XWCN9723_2}]
set_disable_timing -from * -to * [get_cells -hierarchical {XWCN9723_3}]
set_disable_timing -from * -to * [get_cells -hierarchical {XWCN9723_4}]
set_disable_timing -from * -to * [get_cells -hierarchical {XWCN9723_5}]
set_disable_timing -from * -to * [get_cells -hierarchical {XWCN9723_6}]
set_disable_timing -from * -to * [get_cells -hierarchical {XWCN9723_7}]
set_disable_timing -from * -to * [get_cells -hierarchical {BVXN3148_0}]

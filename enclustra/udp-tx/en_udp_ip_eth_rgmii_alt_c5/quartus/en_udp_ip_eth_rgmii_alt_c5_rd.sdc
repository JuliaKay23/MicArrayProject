#--------------------------------------------------------------------------------------------------
#-  Project          : Enclustra UDP/IP/ETH Core
#-  File description : Reference Design for rgmii / Altera Cyclone IV Constraints File
#-  File name        : en_udp_ip_eth_rgmii_alt_c5_rd.sdc
#-  Author           : Marc Oberholzer
#--------------------------------------------------------------------------------------------------
#-  Copyright (c) 2012/2013 by Enclustra GmbH, Switzerland
#-  All rights reserved.
#--------------------------------------------------------------------------------------------------

#--------------------------------------------------------------------------------------------------
# general setup
#--------------------------------------------------------------------------------------------------

# time format
set_time_format -unit ns -decimal_places 3

#--------------------------------------------------------------------------------------------------
# clock definitions
#--------------------------------------------------------------------------------------------------

create_clock -name SysClk -period 8.000 [get_ports {Clk125}]

# virtual clock for ethernet phy rx interface
create_clock -name Rgmii_RxClk_Virt -period 8.000

# rgmii rx clock (90° phase shifted to virtual clock)
create_clock -name Rgmii_RxClk -period 8.000 [get_ports Rgmii_RxClk] -waveform {2 6}

# rgmii tx clock
create_generated_clock -name Rgmii_TxClk_Virt -source [get_ports {Clk125}] -divide_by 1 -multiply_by 1 [get_ports {Rgmii_TxClk}]

#--------------------------------------------------------------------------------------------------
# internal timing
#--------------------------------------------------------------------------------------------------

# asynchronous clock crossings
set_false_path -from [get_clocks {SysClk}] -to [get_clocks {Rgmii_RxClk}]
set_false_path -from [get_clocks {Rgmii_RxClk}] -to [get_clocks {SysClk}]
set_max_delay -from [get_clocks {SysClk}] -to [get_clocks {Rgmii_RxClk}] 8
set_max_delay -from [get_clocks {Rgmii_RxClk}] -to [get_clocks {SysClk}] 8

#--------------------------------------------------------------------------------------------------
# external timing
#--------------------------------------------------------------------------------------------------

# rgmii 2.0 receive timing
set_input_delay -max -1.2 -clock [get_clocks Rgmii_RxClk_Virt] [get_ports {Rgmii_RxD[*] Rgmii_RxCtl}] -add_delay
set_input_delay -max -1.2 -clock [get_clocks Rgmii_RxClk_Virt] [get_ports {Rgmii_RxD[*] Rgmii_RxCtl}] -add_delay -clock_fall
set_input_delay -min 1.2 -clock [get_clocks Rgmii_RxClk_Virt] [get_ports {Rgmii_RxD[*] Rgmii_RxCtl}] -add_delay
set_input_delay -min 1.2 -clock [get_clocks Rgmii_RxClk_Virt] [get_ports {Rgmii_RxD[*] Rgmii_RxCtl}] -add_delay -clock_fall

# rgmii 2.0 receive timing exceptions
set_false_path -setup -rise_from [get_clocks Rgmii_RxClk_Virt] -fall_to [get_clocks Rgmii_RxClk]
set_false_path -setup -fall_from [get_clocks Rgmii_RxClk_Virt] -rise_to [get_clocks Rgmii_RxClk]
set_false_path -hold -rise_from [get_clocks Rgmii_RxClk_Virt] -rise_to [get_clocks Rgmii_RxClk]
set_false_path -hold -fall_from [get_clocks Rgmii_RxClk_Virt] -fall_to [get_clocks Rgmii_RxClk]

# rgmii 2.0 transmit timing
set_output_delay -max -0.9 -clock [get_clocks Rgmii_TxClk_Virt] [get_ports {Rgmii_TxD[*] Rgmii_TxCtl}] -add_delay
set_output_delay -max -0.9 -clock [get_clocks Rgmii_TxClk_Virt] [get_ports {Rgmii_TxD[*] Rgmii_TxCtl}] -add_delay -clock_fall
set_output_delay -min -2.7 -clock [get_clocks Rgmii_TxClk_Virt] [get_ports {Rgmii_TxD[*] Rgmii_TxCtl}] -add_delay
set_output_delay -min -2.7 -clock [get_clocks Rgmii_TxClk_Virt] [get_ports {Rgmii_TxD[*] Rgmii_TxCtl}] -add_delay -clock_fall

# rgmii 2.0 transmit timing exceptions
set_false_path -setup -rise_from SysClk -fall_to [get_clocks Rgmii_TxClk_Virt]
set_false_path -setup -fall_from SysClk -rise_to [get_clocks Rgmii_TxClk_Virt]
set_false_path -hold -rise_from SysClk -rise_to [get_clocks Rgmii_TxClk_Virt]
set_false_path -hold -fall_from SysClk -fall_to [get_clocks Rgmii_TxClk_Virt]

# misc input timing
set_false_path -from [get_ports {RstIn_N}] -to {RstChain[*]}

# misc output timing
set_false_path -from {RstChain[0]} -to [get_ports {Eth_Rst_N}]
set_false_path -from {*} -to [get_ports {Led_N[*]}]


#--------------------------------------------------------------------------------------------------
# eof
#--------------------------------------------------------------------------------------------------

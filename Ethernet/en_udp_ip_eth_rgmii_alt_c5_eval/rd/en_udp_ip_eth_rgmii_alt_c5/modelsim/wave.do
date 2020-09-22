onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider -height 40 {simulation status}
add wave -noupdate /en_udp_ip_eth_rgmii_alt_c5_rd_tb/TbRunning
add wave -noupdate /en_udp_ip_eth_rgmii_alt_c5_rd_tb/ClkRunning
add wave -noupdate -radix decimal /en_udp_ip_eth_rgmii_alt_c5_rd_tb/TestcaseNr
add wave -noupdate -radix decimal /en_udp_ip_eth_rgmii_alt_c5_rd_tb/UdpRxCnt
add wave -noupdate -radix decimal /en_udp_ip_eth_rgmii_alt_c5_rd_tb/RawEthRxCnt
add wave -noupdate -divider -height 40 {clock and reset}
add wave -noupdate -divider -height 40 {clock and reset}
add wave -noupdate /en_udp_ip_eth_rgmii_alt_c5_rd_tb/i_dut/RstIn_N
add wave -noupdate /en_udp_ip_eth_rgmii_alt_c5_rd_tb/i_dut/Rst
add wave -noupdate -divider -height 40 {host pc emulator user interface}
add wave -noupdate -divider {UDP transmit}
add wave -noupdate -radix hexadecimal /en_udp_ip_eth_rgmii_alt_c5_rd_tb/i_pc/Tx_Data
add wave -noupdate /en_udp_ip_eth_rgmii_alt_c5_rd_tb/i_pc/Tx_Vld(0)
add wave -noupdate /en_udp_ip_eth_rgmii_alt_c5_rd_tb/i_pc/Tx_Lst(0)
add wave -noupdate /en_udp_ip_eth_rgmii_alt_c5_rd_tb/i_pc/Tx_Rdy(0)
add wave -noupdate /en_udp_ip_eth_rgmii_alt_c5_rd_tb/i_pc/Tx_Err(0)
add wave -noupdate -radix hexadecimal /en_udp_ip_eth_rgmii_alt_c5_rd_tb/i_pc/Tx_Snd(0)
add wave -noupdate -divider {UDP receive}
add wave -noupdate -radix hexadecimal /en_udp_ip_eth_rgmii_alt_c5_rd_tb/i_pc/Rx_Data
add wave -noupdate /en_udp_ip_eth_rgmii_alt_c5_rd_tb/i_pc/Rx_Vld(0)
add wave -noupdate /en_udp_ip_eth_rgmii_alt_c5_rd_tb/i_pc/Rx_Rdy(0)
add wave -noupdate /en_udp_ip_eth_rgmii_alt_c5_rd_tb/i_pc/Rx_Lst(0)
add wave -noupdate /en_udp_ip_eth_rgmii_alt_c5_rd_tb/i_pc/Rx_Err(0)
add wave -noupdate -divider {Raw Ethernet receive}
add wave -noupdate /en_udp_ip_eth_rgmii_alt_c5_rd_tb/i_pc/EthRx_Data
add wave -noupdate /en_udp_ip_eth_rgmii_alt_c5_rd_tb/i_pc/EthRx_Vld
add wave -noupdate /en_udp_ip_eth_rgmii_alt_c5_rd_tb/i_pc/EthRx_Rdy
add wave -noupdate /en_udp_ip_eth_rgmii_alt_c5_rd_tb/i_pc/EthRx_Lst
add wave -noupdate /en_udp_ip_eth_rgmii_alt_c5_rd_tb/i_pc/EthRx_Err
add wave -noupdate -divider -height 40 {rgmii interface}
add wave -noupdate -divider {host pc emulator}
add wave -noupdate /en_udp_ip_eth_rgmii_alt_c5_rd_tb/i_pc/Rgmii_RxClk
add wave -noupdate /en_udp_ip_eth_rgmii_alt_c5_rd_tb/i_pc/Rgmii_RxD
add wave -noupdate /en_udp_ip_eth_rgmii_alt_c5_rd_tb/i_pc/Rgmii_RxCtl
add wave -noupdate /en_udp_ip_eth_rgmii_alt_c5_rd_tb/i_pc/Rgmii_TxClk
add wave -noupdate /en_udp_ip_eth_rgmii_alt_c5_rd_tb/i_pc/Rgmii_TxD
add wave -noupdate /en_udp_ip_eth_rgmii_alt_c5_rd_tb/i_pc/Rgmii_TxCtl
add wave -noupdate -divider {udp core}
add wave -noupdate /en_udp_ip_eth_rgmii_alt_c5_rd_tb/i_dut/Rgmii_RxClk
add wave -noupdate /en_udp_ip_eth_rgmii_alt_c5_rd_tb/i_dut/Rgmii_RxD
add wave -noupdate /en_udp_ip_eth_rgmii_alt_c5_rd_tb/i_dut/Rgmii_RxCtl
add wave -noupdate /en_udp_ip_eth_rgmii_alt_c5_rd_tb/i_dut/Rgmii_TxClk
add wave -noupdate /en_udp_ip_eth_rgmii_alt_c5_rd_tb/i_dut/Rgmii_TxD
add wave -noupdate /en_udp_ip_eth_rgmii_alt_c5_rd_tb/i_dut/Rgmii_TxCtl
add wave -noupdate -divider -height 40 {udp core user interface}
add wave -noupdate -divider {UDP transmit}
add wave -noupdate /en_udp_ip_eth_rgmii_alt_c5_rd_tb/i_dut/i_core/Tx_Data
add wave -noupdate /en_udp_ip_eth_rgmii_alt_c5_rd_tb/i_dut/i_core/Tx_Vld
add wave -noupdate /en_udp_ip_eth_rgmii_alt_c5_rd_tb/i_dut/i_core/Tx_Lst
add wave -noupdate /en_udp_ip_eth_rgmii_alt_c5_rd_tb/i_dut/i_core/Tx_Rdy
add wave -noupdate /en_udp_ip_eth_rgmii_alt_c5_rd_tb/i_dut/i_core/Tx_Err
add wave -noupdate /en_udp_ip_eth_rgmii_alt_c5_rd_tb/i_dut/i_core/Tx_Snd
add wave -noupdate -divider {UDP receive}
add wave -noupdate /en_udp_ip_eth_rgmii_alt_c5_rd_tb/i_dut/i_core/Rx_Data
add wave -noupdate /en_udp_ip_eth_rgmii_alt_c5_rd_tb/i_dut/i_core/Rx_Vld
add wave -noupdate /en_udp_ip_eth_rgmii_alt_c5_rd_tb/i_dut/i_core/Rx_Rdy
add wave -noupdate /en_udp_ip_eth_rgmii_alt_c5_rd_tb/i_dut/i_core/Rx_Lst
add wave -noupdate /en_udp_ip_eth_rgmii_alt_c5_rd_tb/i_dut/i_core/Rx_Err
add wave -noupdate -divider {Raw Ethernet transmit}
add wave -noupdate /en_udp_ip_eth_rgmii_alt_c5_rd_tb/i_dut/EthTx_Data
add wave -noupdate /en_udp_ip_eth_rgmii_alt_c5_rd_tb/i_dut/EthTx_Vld
add wave -noupdate /en_udp_ip_eth_rgmii_alt_c5_rd_tb/i_dut/EthTx_Rdy
add wave -noupdate /en_udp_ip_eth_rgmii_alt_c5_rd_tb/i_dut/EthTx_Lst
add wave -noupdate -divider {Raw Ethernet receive}
add wave -noupdate /en_udp_ip_eth_rgmii_alt_c5_rd_tb/i_dut/EthRx_Data
add wave -noupdate /en_udp_ip_eth_rgmii_alt_c5_rd_tb/i_dut/EthRx_Vld
add wave -noupdate /en_udp_ip_eth_rgmii_alt_c5_rd_tb/i_dut/EthRx_Rdy
add wave -noupdate /en_udp_ip_eth_rgmii_alt_c5_rd_tb/i_dut/EthRx_Lst
add wave -noupdate -divider -height 40 leds
add wave -noupdate /en_udp_ip_eth_rgmii_alt_c5_rd_tb/i_dut/Led_N
add wave -noupdate -divider -height 40 end
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {22175 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 322
configure wave -valuecolwidth 58
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ns} {161230 ns}

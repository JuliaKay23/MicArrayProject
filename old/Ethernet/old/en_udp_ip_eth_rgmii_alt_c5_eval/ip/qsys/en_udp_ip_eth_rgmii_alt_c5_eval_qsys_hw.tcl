# #############################################################################
# Qsys Requirements 
# #############################################################################
package require -exact qsys 16.1

# #############################################################################
# Core Settings 
# #############################################################################
set_module_property DESCRIPTION "Enclustra UDP-IP-Ethernet IP-Core"
set_module_property NAME en_udp_ip_eth_rgmii_alt_c5_eval_qsys
set_module_property VERSION 1.0
set_module_property INTERNAL false
set_module_property OPAQUE_ADDRESS_MAP true
set_module_property GROUP enclustra
set_module_property AUTHOR "Enclustra GmbH"
set_module_property DISPLAY_NAME "EN_UDP_IP_ETH"
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE false
set_module_property REPORT_TO_TALKBACK false
set_module_property ALLOW_GREYBOX_GENERATION false
set_module_property REPORT_HIERARCHY false
set_module_property ELABORATION_CALLBACK elaborate_callback

# #############################################################################
# File Sets 
# #############################################################################
add_fileset QUARTUS_SYNTH QUARTUS_SYNTH "" ""
set_fileset_property QUARTUS_SYNTH TOP_LEVEL en_udp_ip_eth_rgmii_alt_c5_eval_qsys
set_fileset_property QUARTUS_SYNTH ENABLE_RELATIVE_INCLUDE_PATHS false
set_fileset_property QUARTUS_SYNTH ENABLE_FILE_OVERWRITE_MODE false
add_fileset_file lib_en_udp_ip_eth_rgmii_alt_c5_eval_qsys/en_udp_ip_eth_pkg.vhd VHDL PATH vhdl/en_udp_ip_eth_pkg.vhd
add_fileset_file lib_en_udp_ip_eth_rgmii_alt_c5_eval_qsys/en_udp_ip_eth_tbr.vhd VHDL PATH vhdl/en_udp_ip_eth_tbr.vhd
add_fileset_file lib_en_udp_ip_eth_rgmii_alt_c5_eval_qsys/en_udp_ip_eth_axi_rb.vhd VHDL PATH vhdl/en_udp_ip_eth_axi_rb.vhd
add_fileset_file lib_en_udp_ip_eth_rgmii_alt_c5_eval_qsys/en_udp_ip_eth_rgmii.vhd VHDL PATH vhdl/en_udp_ip_eth_rgmii.vhd
add_fileset_file lib_en_udp_ip_eth_rgmii_alt_c5_eval_qsys/en_udp_ip_eth_rgmii_alt_c5_eval_qsys.vhd VHDL PATH vhdl/en_udp_ip_eth_rgmii_alt_c5_eval_qsys.vhd
add_fileset_file en_udp_ip_eth_rgmii_alt_c5_eval_qsys_cs/en_cs_pipeline_stage.vhd VHDL PATH lib/en_udp_ip_eth_rgmii_alt_c5_eval_qsys_cs/en_cs_pipeline_stage.vhd
add_fileset_file en_udp_ip_eth_rgmii_alt_c5_eval_qsys_cs/en_cs_async.vhd VHDL PATH lib/en_udp_ip_eth_rgmii_alt_c5_eval_qsys_cs/en_cs_async.vhd
add_fileset_file en_udp_ip_eth_rgmii_alt_c5_eval_qsys_cl/en_cl_base_pkg.vhd VHDL PATH lib/en_udp_ip_eth_rgmii_alt_c5_eval_qsys_cl/en_cl_base_pkg.vhd
add_fileset_file en_udp_ip_eth_rgmii_alt_c5_eval_qsys_cl/en_cl_arbiter.vhd VHDL PATH lib/en_udp_ip_eth_rgmii_alt_c5_eval_qsys_cl/en_cl_arbiter.vhd
add_fileset_file en_udp_ip_eth_rgmii_alt_c5_eval_qsys_cl/en_cl_crc.vhd VHDL PATH lib/en_udp_ip_eth_rgmii_alt_c5_eval_qsys_cl/en_cl_crc.vhd
add_fileset_file en_udp_ip_eth_rgmii_alt_c5_eval_qsys_cl/en_cl_loadable_crc.vhd VHDL PATH lib/en_udp_ip_eth_rgmii_alt_c5_eval_qsys_cl/en_cl_loadable_crc.vhd
add_fileset_file en_udp_ip_eth_rgmii_alt_c5_eval_qsys_cl/en_cl_checksum_udp.vhd VHDL PATH lib/en_udp_ip_eth_rgmii_alt_c5_eval_qsys_cl/en_cl_checksum_udp.vhd
add_fileset_file en_udp_ip_eth_rgmii_alt_c5_eval_qsys_cl/en_cl_dpram.vhd VHDL PATH lib/en_udp_ip_eth_rgmii_alt_c5_eval_qsys_cl/en_cl_dpram.vhd
add_fileset_file en_udp_ip_eth_rgmii_alt_c5_eval_qsys_cl/en_cl_reset_sync.vhd VHDL PATH lib/en_udp_ip_eth_rgmii_alt_c5_eval_qsys_cl/en_cl_reset_sync.vhd
add_fileset_file en_udp_ip_eth_rgmii_alt_c5_eval_qsys_cl/en_cl_conv_from_gray.vhd VHDL PATH lib/en_udp_ip_eth_rgmii_alt_c5_eval_qsys_cl/en_cl_conv_from_gray.vhd
add_fileset_file en_udp_ip_eth_rgmii_alt_c5_eval_qsys_cl/en_cl_gray_incrementer.vhd VHDL PATH lib/en_udp_ip_eth_rgmii_alt_c5_eval_qsys_cl/en_cl_gray_incrementer.vhd
add_fileset_file en_udp_ip_eth_rgmii_alt_c5_eval_qsys_cl/en_cl_fifo_async_level.vhd VHDL PATH lib/en_udp_ip_eth_rgmii_alt_c5_eval_qsys_cl/en_cl_fifo_async_level.vhd
add_fileset_file en_udp_ip_eth_rgmii_alt_c5_eval_qsys_cl/en_cl_rb_clock_crossing.vhd VHDL PATH lib/en_udp_ip_eth_rgmii_alt_c5_eval_qsys_cl/en_cl_rb_clock_crossing.vhd
add_fileset_file en_udp_ip_eth_rgmii_alt_c5_eval_qsys_cl/en_cl_axi_rb_interface.vhd VHDL PATH lib/en_udp_ip_eth_rgmii_alt_c5_eval_qsys_cl/en_cl_axi_rb_interface.vhd
add_fileset_file en_udp_ip_eth_rgmii_alt_c5_eval_qsys_cl/en_cl_register_bank.vhd VHDL PATH lib/en_udp_ip_eth_rgmii_alt_c5_eval_qsys_cl/en_cl_register_bank.vhd
add_fileset_file en_udp_ip_eth_rgmii_alt_c5_eval_qsys_cl/en_cl_fifo_sync.vhd VHDL PATH lib/en_udp_ip_eth_rgmii_alt_c5_eval_qsys_cl/en_cl_fifo_sync.vhd
add_fileset_file en_udp_ip_eth_rgmii_alt_c5_eval_qsys_cl/en_cl_gmii_framer.vhd VHDL PATH lib/en_udp_ip_eth_rgmii_alt_c5_eval_qsys_cl/en_cl_gmii_framer.vhd
add_fileset_file en_udp_ip_eth_rgmii_alt_c5_eval_qsys_cl/en_cl_fifo_async.vhd VHDL PATH lib/en_udp_ip_eth_rgmii_alt_c5_eval_qsys_cl/en_cl_fifo_async.vhd
add_fileset_file en_udp_ip_eth_rgmii_alt_c5_eval_qsys_cl/en_cl_rgmii_gmii_trispeed.vhd VHDL PATH lib/en_udp_ip_eth_rgmii_alt_c5_eval_qsys_cl/en_cl_rgmii_gmii_trispeed.vhd
add_fileset_file en_udp_ip_eth_rgmii_alt_c5_eval_qsys_cl/en_cl_rgmii_trispeed_phy_mdl_ddr.vhd VHDL PATH lib/en_udp_ip_eth_rgmii_alt_c5_eval_qsys_cl/en_cl_rgmii_trispeed_phy_mdl_ddr.vhd
add_fileset_file en_udp_ip_eth_rgmii_alt_c5_eval_qsys_cl/en_cl_rgmii_trispeed_phy_mdl.vhd VHDL PATH lib/en_udp_ip_eth_rgmii_alt_c5_eval_qsys_cl/en_cl_rgmii_trispeed_phy_mdl.vhd
add_fileset_file en_udp_ip_eth_rgmii_alt_c5_eval_qsys_cl/en_cl_rom_fifo.vhd VHDL PATH lib/en_udp_ip_eth_rgmii_alt_c5_eval_qsys_cl/en_cl_rom_fifo.vhd
add_fileset_file en_udp_ip_eth_rgmii_alt_c5_eval_qsys_cl/en_cl_mdio.vhd VHDL PATH lib/en_udp_ip_eth_rgmii_alt_c5_eval_qsys_cl/en_cl_mdio.vhd
add_fileset_file en_udp_ip_eth_rgmii_alt_c5_eval_qsys_cl/en_cl_mdio_config.vhd VHDL PATH lib/en_udp_ip_eth_rgmii_alt_c5_eval_qsys_cl/en_cl_mdio_config.vhd
add_fileset_file en_udp_ip_eth_rgmii_alt_c5_eval_qsys_cn/en_cn_pipeline_stage.vhd VHDL PATH lib/en_udp_ip_eth_rgmii_alt_c5_eval_qsys_cn/en_cn_pipeline_stage.vhd
add_fileset_file en_udp_ip_eth_rgmii_alt_c5_eval_qsys_cn/en_cn_buffer.vhd VHDL PATH lib/en_udp_ip_eth_rgmii_alt_c5_eval_qsys_cn/en_cn_buffer.vhd
add_fileset_file en_udp_ip_eth_rgmii_alt_c5_eval_qsys_cn/en_cn_arp_core.vhd VHDL PATH lib/en_udp_ip_eth_rgmii_alt_c5_eval_qsys_cn/en_cn_arp_core.vhd
add_fileset_file en_udp_ip_eth_rgmii_alt_c5_eval_qsys_cn/en_cn_eth_core.vhd VHDL PATH lib/en_udp_ip_eth_rgmii_alt_c5_eval_qsys_cn/en_cn_eth_core.vhd
add_fileset_file en_udp_ip_eth_rgmii_alt_c5_eval_qsys_cn/en_cn_ip_core.vhd VHDL PATH lib/en_udp_ip_eth_rgmii_alt_c5_eval_qsys_cn/en_cn_ip_core.vhd
add_fileset_file en_udp_ip_eth_rgmii_alt_c5_eval_qsys_cn/en_cn_udp_core.vhd VHDL PATH lib/en_udp_ip_eth_rgmii_alt_c5_eval_qsys_cn/en_cn_udp_core.vhd
add_fileset_file en_udp_ip_eth_rgmii_alt_c5_eval_qsys_cn/en_cn_udp_txheader.vhd VHDL PATH lib/en_udp_ip_eth_rgmii_alt_c5_eval_qsys_cn/en_cn_udp_txheader.vhd
add_fileset_file en_udp_ip_eth_rgmii_alt_c5_eval_qsys_cn/en_cn_udp_eth_core.vhd VHDL PATH lib/en_udp_ip_eth_rgmii_alt_c5_eval_qsys_cn/en_cn_udp_eth_core.vhd

add_fileset SIM_VHDL SIM_VHDL "" ""
set_fileset_property SIM_VHDL TOP_LEVEL en_udp_ip_eth_rgmii_alt_c5_eval_qsys
set_fileset_property SIM_VHDL ENABLE_RELATIVE_INCLUDE_PATHS false
set_fileset_property SIM_VHDL ENABLE_FILE_OVERWRITE_MODE false
add_fileset_file lib_en_udp_ip_eth_rgmii_alt_c5_eval_qsys/en_udp_ip_eth_pkg.vhd VHDL PATH vhdl/en_udp_ip_eth_pkg.vhd
add_fileset_file lib_en_udp_ip_eth_rgmii_alt_c5_eval_qsys/en_udp_ip_eth_tbr.vhd VHDL PATH vhdl/en_udp_ip_eth_tbr.vhd
add_fileset_file lib_en_udp_ip_eth_rgmii_alt_c5_eval_qsys/en_udp_ip_eth_axi_rb.vhd VHDL PATH vhdl/en_udp_ip_eth_axi_rb.vhd
add_fileset_file lib_en_udp_ip_eth_rgmii_alt_c5_eval_qsys/en_udp_ip_eth_rgmii.vhd VHDL PATH vhdl/en_udp_ip_eth_rgmii.vhd
add_fileset_file lib_en_udp_ip_eth_rgmii_alt_c5_eval_qsys/en_udp_ip_eth_rgmii_alt_c5_eval_qsys.vhd VHDL PATH vhdl/en_udp_ip_eth_rgmii_alt_c5_eval_qsys.vhd
add_fileset_file en_udp_ip_eth_rgmii_alt_c5_eval_qsys_cs/en_cs_pipeline_stage.vhd VHDL PATH lib/en_udp_ip_eth_rgmii_alt_c5_eval_qsys_cs/en_cs_pipeline_stage.vhd
add_fileset_file en_udp_ip_eth_rgmii_alt_c5_eval_qsys_cs/en_cs_async.vhd VHDL PATH lib/en_udp_ip_eth_rgmii_alt_c5_eval_qsys_cs/en_cs_async.vhd
add_fileset_file en_udp_ip_eth_rgmii_alt_c5_eval_qsys_cl/en_cl_base_pkg.vhd VHDL PATH lib/en_udp_ip_eth_rgmii_alt_c5_eval_qsys_cl/en_cl_base_pkg.vhd
add_fileset_file en_udp_ip_eth_rgmii_alt_c5_eval_qsys_cl/en_cl_arbiter.vhd VHDL PATH lib/en_udp_ip_eth_rgmii_alt_c5_eval_qsys_cl/en_cl_arbiter.vhd
add_fileset_file en_udp_ip_eth_rgmii_alt_c5_eval_qsys_cl/en_cl_crc.vhd VHDL PATH lib/en_udp_ip_eth_rgmii_alt_c5_eval_qsys_cl/en_cl_crc.vhd
add_fileset_file en_udp_ip_eth_rgmii_alt_c5_eval_qsys_cl/en_cl_loadable_crc.vhd VHDL PATH lib/en_udp_ip_eth_rgmii_alt_c5_eval_qsys_cl/en_cl_loadable_crc.vhd
add_fileset_file en_udp_ip_eth_rgmii_alt_c5_eval_qsys_cl/en_cl_checksum_udp.vhd VHDL PATH lib/en_udp_ip_eth_rgmii_alt_c5_eval_qsys_cl/en_cl_checksum_udp.vhd
add_fileset_file en_udp_ip_eth_rgmii_alt_c5_eval_qsys_cl/en_cl_dpram.vhd VHDL PATH lib/en_udp_ip_eth_rgmii_alt_c5_eval_qsys_cl/en_cl_dpram.vhd
add_fileset_file en_udp_ip_eth_rgmii_alt_c5_eval_qsys_cl/en_cl_reset_sync.vhd VHDL PATH lib/en_udp_ip_eth_rgmii_alt_c5_eval_qsys_cl/en_cl_reset_sync.vhd
add_fileset_file en_udp_ip_eth_rgmii_alt_c5_eval_qsys_cl/en_cl_conv_from_gray.vhd VHDL PATH lib/en_udp_ip_eth_rgmii_alt_c5_eval_qsys_cl/en_cl_conv_from_gray.vhd
add_fileset_file en_udp_ip_eth_rgmii_alt_c5_eval_qsys_cl/en_cl_gray_incrementer.vhd VHDL PATH lib/en_udp_ip_eth_rgmii_alt_c5_eval_qsys_cl/en_cl_gray_incrementer.vhd
add_fileset_file en_udp_ip_eth_rgmii_alt_c5_eval_qsys_cl/en_cl_fifo_async_level.vhd VHDL PATH lib/en_udp_ip_eth_rgmii_alt_c5_eval_qsys_cl/en_cl_fifo_async_level.vhd
add_fileset_file en_udp_ip_eth_rgmii_alt_c5_eval_qsys_cl/en_cl_rb_clock_crossing.vhd VHDL PATH lib/en_udp_ip_eth_rgmii_alt_c5_eval_qsys_cl/en_cl_rb_clock_crossing.vhd
add_fileset_file en_udp_ip_eth_rgmii_alt_c5_eval_qsys_cl/en_cl_axi_rb_interface.vhd VHDL PATH lib/en_udp_ip_eth_rgmii_alt_c5_eval_qsys_cl/en_cl_axi_rb_interface.vhd
add_fileset_file en_udp_ip_eth_rgmii_alt_c5_eval_qsys_cl/en_cl_register_bank.vhd VHDL PATH lib/en_udp_ip_eth_rgmii_alt_c5_eval_qsys_cl/en_cl_register_bank.vhd
add_fileset_file en_udp_ip_eth_rgmii_alt_c5_eval_qsys_cl/en_cl_fifo_sync.vhd VHDL PATH lib/en_udp_ip_eth_rgmii_alt_c5_eval_qsys_cl/en_cl_fifo_sync.vhd
add_fileset_file en_udp_ip_eth_rgmii_alt_c5_eval_qsys_cl/en_cl_gmii_framer.vhd VHDL PATH lib/en_udp_ip_eth_rgmii_alt_c5_eval_qsys_cl/en_cl_gmii_framer.vhd
add_fileset_file en_udp_ip_eth_rgmii_alt_c5_eval_qsys_cl/en_cl_fifo_async.vhd VHDL PATH lib/en_udp_ip_eth_rgmii_alt_c5_eval_qsys_cl/en_cl_fifo_async.vhd
add_fileset_file en_udp_ip_eth_rgmii_alt_c5_eval_qsys_cl/en_cl_rgmii_gmii_trispeed.vhd VHDL PATH lib/en_udp_ip_eth_rgmii_alt_c5_eval_qsys_cl/en_cl_rgmii_gmii_trispeed.vhd
add_fileset_file en_udp_ip_eth_rgmii_alt_c5_eval_qsys_cl/en_cl_rgmii_trispeed_phy_mdl_ddr.vhd VHDL PATH lib/en_udp_ip_eth_rgmii_alt_c5_eval_qsys_cl/en_cl_rgmii_trispeed_phy_mdl_ddr.vhd
add_fileset_file en_udp_ip_eth_rgmii_alt_c5_eval_qsys_cl/en_cl_rgmii_trispeed_phy_mdl.vhd VHDL PATH lib/en_udp_ip_eth_rgmii_alt_c5_eval_qsys_cl/en_cl_rgmii_trispeed_phy_mdl.vhd
add_fileset_file en_udp_ip_eth_rgmii_alt_c5_eval_qsys_cl/en_cl_rom_fifo.vhd VHDL PATH lib/en_udp_ip_eth_rgmii_alt_c5_eval_qsys_cl/en_cl_rom_fifo.vhd
add_fileset_file en_udp_ip_eth_rgmii_alt_c5_eval_qsys_cl/en_cl_mdio.vhd VHDL PATH lib/en_udp_ip_eth_rgmii_alt_c5_eval_qsys_cl/en_cl_mdio.vhd
add_fileset_file en_udp_ip_eth_rgmii_alt_c5_eval_qsys_cl/en_cl_mdio_config.vhd VHDL PATH lib/en_udp_ip_eth_rgmii_alt_c5_eval_qsys_cl/en_cl_mdio_config.vhd
add_fileset_file en_udp_ip_eth_rgmii_alt_c5_eval_qsys_cn/en_cn_pipeline_stage.vhd VHDL PATH lib/en_udp_ip_eth_rgmii_alt_c5_eval_qsys_cn/en_cn_pipeline_stage.vhd
add_fileset_file en_udp_ip_eth_rgmii_alt_c5_eval_qsys_cn/en_cn_buffer.vhd VHDL PATH lib/en_udp_ip_eth_rgmii_alt_c5_eval_qsys_cn/en_cn_buffer.vhd
add_fileset_file en_udp_ip_eth_rgmii_alt_c5_eval_qsys_cn/en_cn_arp_core.vhd VHDL PATH lib/en_udp_ip_eth_rgmii_alt_c5_eval_qsys_cn/en_cn_arp_core.vhd
add_fileset_file en_udp_ip_eth_rgmii_alt_c5_eval_qsys_cn/en_cn_eth_core.vhd VHDL PATH lib/en_udp_ip_eth_rgmii_alt_c5_eval_qsys_cn/en_cn_eth_core.vhd
add_fileset_file en_udp_ip_eth_rgmii_alt_c5_eval_qsys_cn/en_cn_ip_core.vhd VHDL PATH lib/en_udp_ip_eth_rgmii_alt_c5_eval_qsys_cn/en_cn_ip_core.vhd
add_fileset_file en_udp_ip_eth_rgmii_alt_c5_eval_qsys_cn/en_cn_udp_core.vhd VHDL PATH lib/en_udp_ip_eth_rgmii_alt_c5_eval_qsys_cn/en_cn_udp_core.vhd
add_fileset_file en_udp_ip_eth_rgmii_alt_c5_eval_qsys_cn/en_cn_udp_txheader.vhd VHDL PATH lib/en_udp_ip_eth_rgmii_alt_c5_eval_qsys_cn/en_cn_udp_txheader.vhd
add_fileset_file en_udp_ip_eth_rgmii_alt_c5_eval_qsys_cn/en_cn_udp_eth_core.vhd VHDL PATH lib/en_udp_ip_eth_rgmii_alt_c5_eval_qsys_cn/en_cn_udp_eth_core.vhd

# #############################################################################
# Parameters 
# #############################################################################
add_parameter EnableRawEth_g BOOLEAN
set_parameter_property EnableRawEth_g DEFAULT_VALUE true
set_parameter_property EnableRawEth_g DISPLAY_NAME {Enable the raw Ethernet port}
set_parameter_property EnableRawEth_g HDL_PARAMETER true
set_parameter_property EnableRawEth_g GROUP "General configuration"
set_parameter_property EnableRawEth_g DESCRIPTION {EnableRawEth_g}

add_parameter MapRawEthToRb_g BOOLEAN
set_parameter_property MapRawEthToRb_g DEFAULT_VALUE true
set_parameter_property MapRawEthToRb_g DISPLAY_NAME {Map the raw Ethernet port to the registerbank}
set_parameter_property MapRawEthToRb_g HDL_PARAMETER true
set_parameter_property MapRawEthToRb_g GROUP "General configuration"
set_parameter_property MapRawEthToRb_g DESCRIPTION {MapRawEthToRb_g}

add_parameter RawEthPayloadSize_g INTEGER
set_parameter_property RawEthPayloadSize_g DEFAULT_VALUE 1600
set_parameter_property RawEthPayloadSize_g DISPLAY_NAME {Maximum raw Ethernet frame size}
set_parameter_property RawEthPayloadSize_g ALLOWED_RANGES 10:10000
set_parameter_property RawEthPayloadSize_g HDL_PARAMETER true
set_parameter_property RawEthPayloadSize_g GROUP "General configuration"
set_parameter_property RawEthPayloadSize_g DESCRIPTION {RawEthPayloadSize_g}

add_parameter RawEthRxBufferCnt_g INTEGER
set_parameter_property RawEthRxBufferCnt_g DEFAULT_VALUE 2
set_parameter_property RawEthRxBufferCnt_g DISPLAY_NAME {Number of receive buffers raw Ethernet Interface}
set_parameter_property RawEthRxBufferCnt_g ALLOWED_RANGES 0:32
set_parameter_property RawEthRxBufferCnt_g HDL_PARAMETER true
set_parameter_property RawEthRxBufferCnt_g GROUP "General configuration"
set_parameter_property RawEthRxBufferCnt_g DESCRIPTION {RawEthRxBufferCnt_g}

add_parameter RawEthTxBufferCnt_g INTEGER
set_parameter_property RawEthTxBufferCnt_g DEFAULT_VALUE 2
set_parameter_property RawEthTxBufferCnt_g DISPLAY_NAME {Number of transmit buffers raw Ethernet Interface}
set_parameter_property RawEthTxBufferCnt_g ALLOWED_RANGES 0:32
set_parameter_property RawEthTxBufferCnt_g HDL_PARAMETER true
set_parameter_property RawEthTxBufferCnt_g GROUP "General configuration"
set_parameter_property RawEthTxBufferCnt_g DESCRIPTION {RawEthTxBufferCnt_g}

add_parameter ArpReply_g BOOLEAN
set_parameter_property ArpReply_g DEFAULT_VALUE true
set_parameter_property ArpReply_g DISPLAY_NAME {Enable Arp Replies for the own IP address}
set_parameter_property ArpReply_g HDL_PARAMETER true
set_parameter_property ArpReply_g GROUP "General configuration"
set_parameter_property ArpReply_g DESCRIPTION {ArpReply_g}

add_parameter RoundRobin_g BOOLEAN
set_parameter_property RoundRobin_g DEFAULT_VALUE true
set_parameter_property RoundRobin_g DISPLAY_NAME {Choose round robin arbitration, otherwise UDP Interface 0 has the highest priority}
set_parameter_property RoundRobin_g HDL_PARAMETER true
set_parameter_property RoundRobin_g GROUP "General configuration"
set_parameter_property RoundRobin_g DESCRIPTION {RoundRobin_g}

add_parameter UdpPortCount_g INTEGER
set_parameter_property UdpPortCount_g DEFAULT_VALUE 1
set_parameter_property UdpPortCount_g DISPLAY_NAME {Number of UDP Interfaces}
set_parameter_property UdpPortCount_g ALLOWED_RANGES 1:8
set_parameter_property UdpPortCount_g HDL_PARAMETER true
set_parameter_property UdpPortCount_g GROUP "UDP configuration"
set_parameter_property UdpPortCount_g DESCRIPTION {UdpPortCount_g}

add_parameter MaxPayloadSize_g INTEGER
set_parameter_property MaxPayloadSize_g DEFAULT_VALUE 1000
set_parameter_property MaxPayloadSize_g DISPLAY_NAME {Maximum UDP Payload size}
set_parameter_property MaxPayloadSize_g ALLOWED_RANGES 10:10000
set_parameter_property MaxPayloadSize_g HDL_PARAMETER true
set_parameter_property MaxPayloadSize_g GROUP "UDP configuration"
set_parameter_property MaxPayloadSize_g DESCRIPTION {MaxPayloadSize_g}

add_parameter RxBufferCount_g INTEGER
set_parameter_property RxBufferCount_g DEFAULT_VALUE 2
set_parameter_property RxBufferCount_g DISPLAY_NAME {Number of receive buffers per UDP Interface}
set_parameter_property RxBufferCount_g ALLOWED_RANGES 0:32
set_parameter_property RxBufferCount_g HDL_PARAMETER true
set_parameter_property RxBufferCount_g GROUP "UDP configuration"
set_parameter_property RxBufferCount_g DESCRIPTION {RxBufferCount_g}

add_parameter UseStreamingMode_g BOOLEAN
set_parameter_property UseStreamingMode_g DEFAULT_VALUE false
set_parameter_property UseStreamingMode_g DISPLAY_NAME {Enable streaming mode}
set_parameter_property UseStreamingMode_g HDL_PARAMETER true
set_parameter_property UseStreamingMode_g GROUP "UDP configuration"
set_parameter_property UseStreamingMode_g DESCRIPTION {UseStreamingMode_g}

add_parameter TimeoutWidth_g INTEGER
set_parameter_property TimeoutWidth_g DEFAULT_VALUE 12
set_parameter_property TimeoutWidth_g DISPLAY_NAME {Number of bits for the Timeout counter}
set_parameter_property TimeoutWidth_g ALLOWED_RANGES 2:32
set_parameter_property TimeoutWidth_g HDL_PARAMETER true
set_parameter_property TimeoutWidth_g GROUP "UDP configuration"
set_parameter_property TimeoutWidth_g DESCRIPTION {TimeoutWidth_g}

add_parameter HdrUdpRxSrcPort_g BOOLEAN
set_parameter_property HdrUdpRxSrcPort_g DEFAULT_VALUE false
set_parameter_property HdrUdpRxSrcPort_g DISPLAY_NAME {Enable header pass-through mode for UDP RX source port}
set_parameter_property HdrUdpRxSrcPort_g HDL_PARAMETER true
set_parameter_property HdrUdpRxSrcPort_g GROUP "UDP header configuration"
set_parameter_property HdrUdpRxSrcPort_g DESCRIPTION {HdrUdpRxSrcPort_g}

add_parameter HdrUdpRxDestPort_g BOOLEAN
set_parameter_property HdrUdpRxDestPort_g DEFAULT_VALUE false
set_parameter_property HdrUdpRxDestPort_g DISPLAY_NAME {Enable header pass-through mode for UDP RX destination port}
set_parameter_property HdrUdpRxDestPort_g HDL_PARAMETER true
set_parameter_property HdrUdpRxDestPort_g GROUP "UDP header configuration"
set_parameter_property HdrUdpRxDestPort_g DESCRIPTION {HdrUdpRxDestPort_g}

add_parameter HdrUdpRxLength_g BOOLEAN
set_parameter_property HdrUdpRxLength_g DEFAULT_VALUE false
set_parameter_property HdrUdpRxLength_g DISPLAY_NAME {Enable header pass-through mode for UDP RX length}
set_parameter_property HdrUdpRxLength_g HDL_PARAMETER true
set_parameter_property HdrUdpRxLength_g GROUP "UDP header configuration"
set_parameter_property HdrUdpRxLength_g DESCRIPTION {HdrUdpRxLength_g}

add_parameter HdrUdpRxChkSum_g BOOLEAN
set_parameter_property HdrUdpRxChkSum_g DEFAULT_VALUE false
set_parameter_property HdrUdpRxChkSum_g DISPLAY_NAME {Enable header pass-through mode for UDP RX checksum}
set_parameter_property HdrUdpRxChkSum_g HDL_PARAMETER true
set_parameter_property HdrUdpRxChkSum_g GROUP "UDP header configuration"
set_parameter_property HdrUdpRxChkSum_g DESCRIPTION {HdrUdpRxChkSum_g}

add_parameter HdrUdpTxSrcPort_g BOOLEAN
set_parameter_property HdrUdpTxSrcPort_g DEFAULT_VALUE false
set_parameter_property HdrUdpTxSrcPort_g DISPLAY_NAME {Enable header pass-through mode for UDP TX source port}
set_parameter_property HdrUdpTxSrcPort_g HDL_PARAMETER true
set_parameter_property HdrUdpTxSrcPort_g GROUP "UDP header configuration"
set_parameter_property HdrUdpTxSrcPort_g DESCRIPTION {HdrUdpTxSrcPort_g}

add_parameter HdrUdpTxDestPort_g BOOLEAN
set_parameter_property HdrUdpTxDestPort_g DEFAULT_VALUE false
set_parameter_property HdrUdpTxDestPort_g DISPLAY_NAME {Enable header pass-through mode for UDP TX destination port}
set_parameter_property HdrUdpTxDestPort_g HDL_PARAMETER true
set_parameter_property HdrUdpTxDestPort_g GROUP "UDP header configuration"
set_parameter_property HdrUdpTxDestPort_g DESCRIPTION {HdrUdpTxDestPort_g}

add_parameter HdrIpRxVersion_g BOOLEAN
set_parameter_property HdrIpRxVersion_g DEFAULT_VALUE false
set_parameter_property HdrIpRxVersion_g DISPLAY_NAME {Enable header pass-through mode for IP RX Version}
set_parameter_property HdrIpRxVersion_g HDL_PARAMETER true
set_parameter_property HdrIpRxVersion_g GROUP "IP header configuration"
set_parameter_property HdrIpRxVersion_g DESCRIPTION {HdrIpRxVersion_g}

add_parameter HdrIpRxEcnDcsp_g BOOLEAN
set_parameter_property HdrIpRxEcnDcsp_g DEFAULT_VALUE false
set_parameter_property HdrIpRxEcnDcsp_g DISPLAY_NAME {Enable header pass-through mode for IP RX ECN/DCSP}
set_parameter_property HdrIpRxEcnDcsp_g HDL_PARAMETER true
set_parameter_property HdrIpRxEcnDcsp_g GROUP "IP header configuration"
set_parameter_property HdrIpRxEcnDcsp_g DESCRIPTION {HdrIpRxEcnDcsp_g}

add_parameter HdrIpRxLength_g BOOLEAN
set_parameter_property HdrIpRxLength_g DEFAULT_VALUE false
set_parameter_property HdrIpRxLength_g DISPLAY_NAME {Enable header pass-through mode for IP RX Length}
set_parameter_property HdrIpRxLength_g HDL_PARAMETER true
set_parameter_property HdrIpRxLength_g GROUP "IP header configuration"
set_parameter_property HdrIpRxLength_g DESCRIPTION {HdrIpRxLength_g}

add_parameter HdrIpRxId_g BOOLEAN
set_parameter_property HdrIpRxId_g DEFAULT_VALUE false
set_parameter_property HdrIpRxId_g DISPLAY_NAME {Enable header pass-through mode for IP RX ID}
set_parameter_property HdrIpRxId_g HDL_PARAMETER true
set_parameter_property HdrIpRxId_g GROUP "IP header configuration"
set_parameter_property HdrIpRxId_g DESCRIPTION {HdrIpRxId_g}

add_parameter HdrIpRxFragOffset_g BOOLEAN
set_parameter_property HdrIpRxFragOffset_g DEFAULT_VALUE false
set_parameter_property HdrIpRxFragOffset_g DISPLAY_NAME {Enable header pass-through mode for IP RX fragment offset}
set_parameter_property HdrIpRxFragOffset_g HDL_PARAMETER true
set_parameter_property HdrIpRxFragOffset_g GROUP "IP header configuration"
set_parameter_property HdrIpRxFragOffset_g DESCRIPTION {HdrIpRxFragOffset_g}

add_parameter HdrIpRxTtl_g BOOLEAN
set_parameter_property HdrIpRxTtl_g DEFAULT_VALUE false
set_parameter_property HdrIpRxTtl_g DISPLAY_NAME {Enable header pass-through mode for IP RX TTL}
set_parameter_property HdrIpRxTtl_g HDL_PARAMETER true
set_parameter_property HdrIpRxTtl_g GROUP "IP header configuration"
set_parameter_property HdrIpRxTtl_g DESCRIPTION {HdrIpRxTtl_g}

add_parameter HdrIpRxProtocol_g BOOLEAN
set_parameter_property HdrIpRxProtocol_g DEFAULT_VALUE false
set_parameter_property HdrIpRxProtocol_g DISPLAY_NAME {Enable header pass-through mode for IP RX Protocol}
set_parameter_property HdrIpRxProtocol_g HDL_PARAMETER true
set_parameter_property HdrIpRxProtocol_g GROUP "IP header configuration"
set_parameter_property HdrIpRxProtocol_g DESCRIPTION {HdrIpRxProtocol_g}

add_parameter HdrIpRxChkSum_g BOOLEAN
set_parameter_property HdrIpRxChkSum_g DEFAULT_VALUE false
set_parameter_property HdrIpRxChkSum_g DISPLAY_NAME {Enable header pass-through mode for IP RX checksum}
set_parameter_property HdrIpRxChkSum_g HDL_PARAMETER true
set_parameter_property HdrIpRxChkSum_g GROUP "IP header configuration"
set_parameter_property HdrIpRxChkSum_g DESCRIPTION {HdrIpRxChkSum_g}

add_parameter HdrIpRxSrcAddr_g BOOLEAN
set_parameter_property HdrIpRxSrcAddr_g DEFAULT_VALUE false
set_parameter_property HdrIpRxSrcAddr_g DISPLAY_NAME {Enable header pass-through mode for IP RX source address}
set_parameter_property HdrIpRxSrcAddr_g HDL_PARAMETER true
set_parameter_property HdrIpRxSrcAddr_g GROUP "IP header configuration"
set_parameter_property HdrIpRxSrcAddr_g DESCRIPTION {HdrIpRxSrcAddr_g}

add_parameter HdrIpRxDestAddr_g BOOLEAN
set_parameter_property HdrIpRxDestAddr_g DEFAULT_VALUE false
set_parameter_property HdrIpRxDestAddr_g DISPLAY_NAME {Enable header pass-through mode for IP RX destination address}
set_parameter_property HdrIpRxDestAddr_g HDL_PARAMETER true
set_parameter_property HdrIpRxDestAddr_g GROUP "IP header configuration"
set_parameter_property HdrIpRxDestAddr_g DESCRIPTION {HdrIpRxDestAddr_g}

add_parameter HdrIpTxEcnDcsp_g BOOLEAN
set_parameter_property HdrIpTxEcnDcsp_g DEFAULT_VALUE false
set_parameter_property HdrIpTxEcnDcsp_g DISPLAY_NAME {Enable header pass-through mode for IP TX ECN/DCSP}
set_parameter_property HdrIpTxEcnDcsp_g HDL_PARAMETER true
set_parameter_property HdrIpTxEcnDcsp_g GROUP "IP header configuration"
set_parameter_property HdrIpTxEcnDcsp_g DESCRIPTION {HdrIpTxEcnDcsp_g}

add_parameter HdrIpTxId_g BOOLEAN
set_parameter_property HdrIpTxId_g DEFAULT_VALUE false
set_parameter_property HdrIpTxId_g DISPLAY_NAME {Enable header pass-through mode for IP TX ID}
set_parameter_property HdrIpTxId_g HDL_PARAMETER true
set_parameter_property HdrIpTxId_g GROUP "IP header configuration"
set_parameter_property HdrIpTxId_g DESCRIPTION {HdrIpTxId_g}

add_parameter HdrIpTxFragOffset_g BOOLEAN
set_parameter_property HdrIpTxFragOffset_g DEFAULT_VALUE false
set_parameter_property HdrIpTxFragOffset_g DISPLAY_NAME {Enable header pass-through mode for IP TX fragment offset}
set_parameter_property HdrIpTxFragOffset_g HDL_PARAMETER true
set_parameter_property HdrIpTxFragOffset_g GROUP "IP header configuration"
set_parameter_property HdrIpTxFragOffset_g DESCRIPTION {HdrIpTxFragOffset_g}

add_parameter HdrIpTxTtl_g BOOLEAN
set_parameter_property HdrIpTxTtl_g DEFAULT_VALUE false
set_parameter_property HdrIpTxTtl_g DISPLAY_NAME {Enable header pass-through mode for IP TX TTL}
set_parameter_property HdrIpTxTtl_g HDL_PARAMETER true
set_parameter_property HdrIpTxTtl_g GROUP "IP header configuration"
set_parameter_property HdrIpTxTtl_g DESCRIPTION {HdrIpTxTtl_g}

add_parameter HdrIpTxProtocol_g BOOLEAN
set_parameter_property HdrIpTxProtocol_g DEFAULT_VALUE false
set_parameter_property HdrIpTxProtocol_g DISPLAY_NAME {Enable header pass-through mode for IP TX Protocol}
set_parameter_property HdrIpTxProtocol_g HDL_PARAMETER true
set_parameter_property HdrIpTxProtocol_g GROUP "IP header configuration"
set_parameter_property HdrIpTxProtocol_g DESCRIPTION {HdrIpTxProtocol_g}

add_parameter HdrIpTxSrcAddr_g BOOLEAN
set_parameter_property HdrIpTxSrcAddr_g DEFAULT_VALUE false
set_parameter_property HdrIpTxSrcAddr_g DISPLAY_NAME {Enable header pass-through mode for IP TX source address}
set_parameter_property HdrIpTxSrcAddr_g HDL_PARAMETER true
set_parameter_property HdrIpTxSrcAddr_g GROUP "IP header configuration"
set_parameter_property HdrIpTxSrcAddr_g DESCRIPTION {HdrIpTxSrcAddr_g}

add_parameter HdrIpTxDestAddr_g BOOLEAN
set_parameter_property HdrIpTxDestAddr_g DEFAULT_VALUE false
set_parameter_property HdrIpTxDestAddr_g DISPLAY_NAME {Enable header pass-through mode for IP TX destination address}
set_parameter_property HdrIpTxDestAddr_g HDL_PARAMETER true
set_parameter_property HdrIpTxDestAddr_g GROUP "IP header configuration"
set_parameter_property HdrIpTxDestAddr_g DESCRIPTION {HdrIpTxDestAddr_g}

add_parameter HdrEthRxDestMac_g BOOLEAN
set_parameter_property HdrEthRxDestMac_g DEFAULT_VALUE false
set_parameter_property HdrEthRxDestMac_g DISPLAY_NAME {Enable header pass-through mode for ETH RX destination MAC address}
set_parameter_property HdrEthRxDestMac_g HDL_PARAMETER true
set_parameter_property HdrEthRxDestMac_g GROUP "Ethernet header configuration"
set_parameter_property HdrEthRxDestMac_g DESCRIPTION {HdrEthRxDestMac_g}

add_parameter HdrEthRxSrcMac_g BOOLEAN
set_parameter_property HdrEthRxSrcMac_g DEFAULT_VALUE false
set_parameter_property HdrEthRxSrcMac_g DISPLAY_NAME {Enable header pass-through mode for ETH RX source MAC address}
set_parameter_property HdrEthRxSrcMac_g HDL_PARAMETER true
set_parameter_property HdrEthRxSrcMac_g GROUP "Ethernet header configuration"
set_parameter_property HdrEthRxSrcMac_g DESCRIPTION {HdrEthRxSrcMac_g}

add_parameter HdrEthRxEthType_g BOOLEAN
set_parameter_property HdrEthRxEthType_g DEFAULT_VALUE false
set_parameter_property HdrEthRxEthType_g DISPLAY_NAME {Enable header pass-through mode for ETH RX Ethertype}
set_parameter_property HdrEthRxEthType_g HDL_PARAMETER true
set_parameter_property HdrEthRxEthType_g GROUP "Ethernet header configuration"
set_parameter_property HdrEthRxEthType_g DESCRIPTION {HdrEthRxEthType_g}

add_parameter HdrEthTxDestMac_g BOOLEAN
set_parameter_property HdrEthTxDestMac_g DEFAULT_VALUE false
set_parameter_property HdrEthTxDestMac_g DISPLAY_NAME {Enable header pass-through mode for ETH TX destination MAC address}
set_parameter_property HdrEthTxDestMac_g HDL_PARAMETER true
set_parameter_property HdrEthTxDestMac_g GROUP "Ethernet header configuration"
set_parameter_property HdrEthTxDestMac_g DESCRIPTION {HdrEthTxDestMac_g}

add_parameter HdrEthTxSrcMac_g BOOLEAN
set_parameter_property HdrEthTxSrcMac_g DEFAULT_VALUE false
set_parameter_property HdrEthTxSrcMac_g DISPLAY_NAME {Enable header pass-through mode for ETH TX source MAC address}
set_parameter_property HdrEthTxSrcMac_g HDL_PARAMETER true
set_parameter_property HdrEthTxSrcMac_g GROUP "Ethernet header configuration"
set_parameter_property HdrEthTxSrcMac_g DESCRIPTION {HdrEthTxSrcMac_g}

add_parameter HdrEthTxEthType_g BOOLEAN
set_parameter_property HdrEthTxEthType_g DEFAULT_VALUE false
set_parameter_property HdrEthTxEthType_g DISPLAY_NAME {Enable header pass-through mode for ETH TX Ethertype}
set_parameter_property HdrEthTxEthType_g HDL_PARAMETER true
set_parameter_property HdrEthTxEthType_g GROUP "Ethernet header configuration"
set_parameter_property HdrEthTxEthType_g DESCRIPTION {HdrEthTxEthType_g}

proc elaborate_callback {} {
	# #############################################################################
	# Bus Connection Points
	# #############################################################################
	add_interface RGMII conduit end
	set_interface_property RGMII associatedClock Clk
	set_interface_property RGMII ENABLED true
	add_interface_port RGMII Rgmii_TxClk enclustra_rgmii_Rgmii_TxClk Output 1
	add_interface_port RGMII Rgmii_TxD enclustra_rgmii_Rgmii_Txd Output 4
	add_interface_port RGMII Rgmii_TxCtl enclustra_rgmii_Rgmii_TxCtl Output 1
	add_interface_port RGMII Rgmii_RxClk enclustra_rgmii_Rgmii_RxClk Input 1
	add_interface_port RGMII Rgmii_RxD enclustra_rgmii_Rgmii_Rxd Input 4
	add_interface_port RGMII Rgmii_RxCtl enclustra_rgmii_Rgmii_RxCtl Input 1
	
	# #############################################################################
	# AXI Stream Connection Points
	# #############################################################################
	add_interface UdpTx0 axi4stream end
	set_interface_property UdpTx0 associatedClock Clk
	set_interface_property UdpTx0 associatedReset S_AXI_ARESETN
	set_interface_property UdpTx0 ENABLED true
	add_interface_port UdpTx0 Tx0_TDATA tdata Input 8
	add_interface_port UdpTx0 Tx0_TLAST tlast Input 1
	add_interface_port UdpTx0 Tx0_TUSER tuser Input 2
	add_interface_port UdpTx0 Tx0_TVALID tvalid Input 1
	add_interface_port UdpTx0 Tx0_TREADY tready Output 1
	
	add_interface UdpRx0 axi4stream start
	set_interface_property UdpRx0 associatedClock Clk
	set_interface_property UdpRx0 associatedReset S_AXI_ARESETN
	set_interface_property UdpRx0 ENABLED true
	add_interface_port UdpRx0 Rx0_TDATA tdata Output 8
	add_interface_port UdpRx0 Rx0_TLAST tlast Output 1
	add_interface_port UdpRx0 Rx0_TUSER tuser Output 1
	add_interface_port UdpRx0 Rx0_TVALID tvalid Output 1
	add_interface_port UdpRx0 Rx0_TREADY tready Input 1
	
	add_interface UdpTx1 axi4stream end
	set_interface_property UdpTx1 associatedClock Clk
	set_interface_property UdpTx1 associatedReset S_AXI_ARESETN
	set_interface_property UdpTx1 ENABLED true
	add_interface_port UdpTx1 Tx1_TDATA tdata Input 8
	add_interface_port UdpTx1 Tx1_TLAST tlast Input 1
	add_interface_port UdpTx1 Tx1_TUSER tuser Input 2
	add_interface_port UdpTx1 Tx1_TVALID tvalid Input 1
	add_interface_port UdpTx1 Tx1_TREADY tready Output 1
	
	add_interface UdpRx1 axi4stream start
	set_interface_property UdpRx1 associatedClock Clk
	set_interface_property UdpRx1 associatedReset S_AXI_ARESETN
	set_interface_property UdpRx1 ENABLED true
	add_interface_port UdpRx1 Rx1_TDATA tdata Output 8
	add_interface_port UdpRx1 Rx1_TLAST tlast Output 1
	add_interface_port UdpRx1 Rx1_TUSER tuser Output 1
	add_interface_port UdpRx1 Rx1_TVALID tvalid Output 1
	add_interface_port UdpRx1 Rx1_TREADY tready Input 1
	
	add_interface UdpTx2 axi4stream end
	set_interface_property UdpTx2 associatedClock Clk
	set_interface_property UdpTx2 associatedReset S_AXI_ARESETN
	set_interface_property UdpTx2 ENABLED true
	add_interface_port UdpTx2 Tx2_TDATA tdata Input 8
	add_interface_port UdpTx2 Tx2_TLAST tlast Input 1
	add_interface_port UdpTx2 Tx2_TUSER tuser Input 2
	add_interface_port UdpTx2 Tx2_TVALID tvalid Input 1
	add_interface_port UdpTx2 Tx2_TREADY tready Output 1
	
	add_interface UdpRx2 axi4stream start
	set_interface_property UdpRx2 associatedClock Clk
	set_interface_property UdpRx2 associatedReset S_AXI_ARESETN
	set_interface_property UdpRx2 ENABLED true
	add_interface_port UdpRx2 Rx2_TDATA tdata Output 8
	add_interface_port UdpRx2 Rx2_TLAST tlast Output 1
	add_interface_port UdpRx2 Rx2_TUSER tuser Output 1
	add_interface_port UdpRx2 Rx2_TVALID tvalid Output 1
	add_interface_port UdpRx2 Rx2_TREADY tready Input 1
	
	add_interface UdpTx3 axi4stream end
	set_interface_property UdpTx3 associatedClock Clk
	set_interface_property UdpTx3 associatedReset S_AXI_ARESETN
	set_interface_property UdpTx3 ENABLED true
	add_interface_port UdpTx3 Tx3_TDATA tdata Input 8
	add_interface_port UdpTx3 Tx3_TLAST tlast Input 1
	add_interface_port UdpTx3 Tx3_TUSER tuser Input 2
	add_interface_port UdpTx3 Tx3_TVALID tvalid Input 1
	add_interface_port UdpTx3 Tx3_TREADY tready Output 1
	
	add_interface UdpRx3 axi4stream start
	set_interface_property UdpRx3 associatedClock Clk
	set_interface_property UdpRx3 associatedReset S_AXI_ARESETN
	set_interface_property UdpRx3 ENABLED true
	add_interface_port UdpRx3 Rx3_TDATA tdata Output 8
	add_interface_port UdpRx3 Rx3_TLAST tlast Output 1
	add_interface_port UdpRx3 Rx3_TUSER tuser Output 1
	add_interface_port UdpRx3 Rx3_TVALID tvalid Output 1
	add_interface_port UdpRx3 Rx3_TREADY tready Input 1
	
	add_interface UdpTx4 axi4stream end
	set_interface_property UdpTx4 associatedClock Clk
	set_interface_property UdpTx4 associatedReset S_AXI_ARESETN
	set_interface_property UdpTx4 ENABLED true
	add_interface_port UdpTx4 Tx4_TDATA tdata Input 8
	add_interface_port UdpTx4 Tx4_TLAST tlast Input 1
	add_interface_port UdpTx4 Tx4_TUSER tuser Input 2
	add_interface_port UdpTx4 Tx4_TVALID tvalid Input 1
	add_interface_port UdpTx4 Tx4_TREADY tready Output 1
	
	add_interface UdpRx4 axi4stream start
	set_interface_property UdpRx4 associatedClock Clk
	set_interface_property UdpRx4 associatedReset S_AXI_ARESETN
	set_interface_property UdpRx4 ENABLED true
	add_interface_port UdpRx4 Rx4_TDATA tdata Output 8
	add_interface_port UdpRx4 Rx4_TLAST tlast Output 1
	add_interface_port UdpRx4 Rx4_TUSER tuser Output 1
	add_interface_port UdpRx4 Rx4_TVALID tvalid Output 1
	add_interface_port UdpRx4 Rx4_TREADY tready Input 1
	
	add_interface UdpTx5 axi4stream end
	set_interface_property UdpTx5 associatedClock Clk
	set_interface_property UdpTx5 associatedReset S_AXI_ARESETN
	set_interface_property UdpTx5 ENABLED true
	add_interface_port UdpTx5 Tx5_TDATA tdata Input 8
	add_interface_port UdpTx5 Tx5_TLAST tlast Input 1
	add_interface_port UdpTx5 Tx5_TUSER tuser Input 2
	add_interface_port UdpTx5 Tx5_TVALID tvalid Input 1
	add_interface_port UdpTx5 Tx5_TREADY tready Output 1
	
	add_interface UdpRx5 axi4stream start
	set_interface_property UdpRx5 associatedClock Clk
	set_interface_property UdpRx5 associatedReset S_AXI_ARESETN
	set_interface_property UdpRx5 ENABLED true
	add_interface_port UdpRx5 Rx5_TDATA tdata Output 8
	add_interface_port UdpRx5 Rx5_TLAST tlast Output 1
	add_interface_port UdpRx5 Rx5_TUSER tuser Output 1
	add_interface_port UdpRx5 Rx5_TVALID tvalid Output 1
	add_interface_port UdpRx5 Rx5_TREADY tready Input 1
	
	add_interface UdpTx6 axi4stream end
	set_interface_property UdpTx6 associatedClock Clk
	set_interface_property UdpTx6 associatedReset S_AXI_ARESETN
	set_interface_property UdpTx6 ENABLED true
	add_interface_port UdpTx6 Tx6_TDATA tdata Input 8
	add_interface_port UdpTx6 Tx6_TLAST tlast Input 1
	add_interface_port UdpTx6 Tx6_TUSER tuser Input 2
	add_interface_port UdpTx6 Tx6_TVALID tvalid Input 1
	add_interface_port UdpTx6 Tx6_TREADY tready Output 1
	
	add_interface UdpRx6 axi4stream start
	set_interface_property UdpRx6 associatedClock Clk
	set_interface_property UdpRx6 associatedReset S_AXI_ARESETN
	set_interface_property UdpRx6 ENABLED true
	add_interface_port UdpRx6 Rx6_TDATA tdata Output 8
	add_interface_port UdpRx6 Rx6_TLAST tlast Output 1
	add_interface_port UdpRx6 Rx6_TUSER tuser Output 1
	add_interface_port UdpRx6 Rx6_TVALID tvalid Output 1
	add_interface_port UdpRx6 Rx6_TREADY tready Input 1
	
	add_interface UdpTx7 axi4stream end
	set_interface_property UdpTx7 associatedClock Clk
	set_interface_property UdpTx7 associatedReset S_AXI_ARESETN
	set_interface_property UdpTx7 ENABLED true
	add_interface_port UdpTx7 Tx7_TDATA tdata Input 8
	add_interface_port UdpTx7 Tx7_TLAST tlast Input 1
	add_interface_port UdpTx7 Tx7_TUSER tuser Input 2
	add_interface_port UdpTx7 Tx7_TVALID tvalid Input 1
	add_interface_port UdpTx7 Tx7_TREADY tready Output 1
	
	add_interface UdpRx7 axi4stream start
	set_interface_property UdpRx7 associatedClock Clk
	set_interface_property UdpRx7 associatedReset S_AXI_ARESETN
	set_interface_property UdpRx7 ENABLED true
	add_interface_port UdpRx7 Rx7_TDATA tdata Output 8
	add_interface_port UdpRx7 Rx7_TLAST tlast Output 1
	add_interface_port UdpRx7 Rx7_TUSER tuser Output 1
	add_interface_port UdpRx7 Rx7_TVALID tvalid Output 1
	add_interface_port UdpRx7 Rx7_TREADY tready Input 1
	
	add_interface RawEthTx axi4stream end
	set_interface_property RawEthTx associatedClock Clk
	set_interface_property RawEthTx associatedReset S_AXI_ARESETN
	set_interface_property RawEthTx ENABLED true
	add_interface_port RawEthTx EthTx_TDATA tdata Input 8
	add_interface_port RawEthTx EthTx_TLAST tlast Input 1
	add_interface_port RawEthTx EthTx_TUSER tuser Input 1
	add_interface_port RawEthTx EthTx_TVALID tvalid Input 1
	add_interface_port RawEthTx EthTx_TREADY tready Output 1
	
	add_interface RawEthRx axi4stream start
	set_interface_property RawEthRx associatedClock Clk
	set_interface_property RawEthRx associatedReset S_AXI_ARESETN
	set_interface_property RawEthRx ENABLED true
	add_interface_port RawEthRx EthRx_TDATA tdata Output 8
	add_interface_port RawEthRx EthRx_TLAST tlast Output 1
	add_interface_port RawEthRx EthRx_TUSER tuser Output 1
	add_interface_port RawEthRx EthRx_TVALID tvalid Output 1
	add_interface_port RawEthRx EthRx_TREADY tready Input 1
	
	# #############################################################################
	# AXI Master Connection Points
	# #############################################################################
	# #############################################################################
	# AXI Lite Connection Points
	# #############################################################################
	add_interface S_AXI axi4lite end
	set_interface_property S_AXI associatedClock S_AXI_ACLK
	set_interface_property S_AXI associatedReset S_AXI_ARESETN
	set_interface_property S_AXI readAcceptanceCapability 1
	set_interface_property S_AXI writeAcceptanceCapability 1
	set_interface_property S_AXI combinedAcceptanceCapability 1
	set_interface_property S_AXI readDataReorderingDepth 1
	set_interface_property S_AXI ENABLED true
	add_interface_port S_AXI S_AXI_AWADDR awaddr Input 16
	add_interface_port S_AXI S_AXI_AWVALID awvalid Input 1
	add_interface_port S_AXI S_AXI_AWREADY awready Output 1
	add_interface_port S_AXI S_AXI_AWPROT awprot Input 3
	add_interface_port S_AXI S_AXI_WDATA wdata Input 32
	add_interface_port S_AXI S_AXI_WSTRB wstrb Input 4
	add_interface_port S_AXI S_AXI_WVALID wvalid Input 1
	add_interface_port S_AXI S_AXI_WREADY wready Output 1
	add_interface_port S_AXI S_AXI_BRESP bresp Output 2
	add_interface_port S_AXI S_AXI_BVALID bvalid Output 1
	add_interface_port S_AXI S_AXI_BREADY bready Input 1
	add_interface_port S_AXI S_AXI_ARADDR araddr Input 16
	add_interface_port S_AXI S_AXI_ARVALID arvalid Input 1
	add_interface_port S_AXI S_AXI_ARREADY arready Output 1
	add_interface_port S_AXI S_AXI_RDATA rdata Output 32
	add_interface_port S_AXI S_AXI_RRESP rresp Output 2
	add_interface_port S_AXI S_AXI_RVALID rvalid Output 1
	add_interface_port S_AXI S_AXI_RREADY rready Input 1
	add_interface_port S_AXI S_AXI_ARPROT arprot Input 3
	
	# #############################################################################
	# Other Connection Points
	# #############################################################################
	# #############################################################################
	# Clock and Reset Connection Points
	# #############################################################################
	### Clocks ###
	add_interface Clk clock end
	set_interface_property Clk clockRate 0
	set_interface_property Clk ENABLED true
	add_interface_port Clk Clk clk Input 1
	
	add_interface S_AXI_ACLK clock end
	set_interface_property S_AXI_ACLK clockRate 0
	set_interface_property S_AXI_ACLK ENABLED true
	add_interface_port S_AXI_ACLK S_AXI_ACLK clk Input 1
	
	### Resets ###
	add_interface Rst reset end
	set_interface_property Rst associatedClock Clk
	set_interface_property Rst synchronousEdges DEASSERT
	set_interface_property Rst ENABLED true
	add_interface_port Rst Rst reset Input 1
	
	add_interface S_AXI_ARESETN reset end
	set_interface_property S_AXI_ARESETN associatedClock S_AXI_ACLK
	set_interface_property S_AXI_ARESETN synchronousEdges DEASSERT
	set_interface_property S_AXI_ARESETN ENABLED true
	add_interface_port S_AXI_ARESETN S_AXI_ARESETN reset_n Input 1
	
	# #############################################################################
	# IRQ Connection Points
	# #############################################################################
	add_interface IntTx interrupt end
	set_interface_property IntTx associatedClock S_AXI_ACLK
	set_interface_property IntTx ENABLED true
	add_interface_port IntTx IntTx irq Output 1
	
	add_interface IntRx interrupt end
	set_interface_property IntRx associatedClock S_AXI_ACLK
	set_interface_property IntRx ENABLED true
	add_interface_port IntRx IntRx irq Output 1
	
	# #############################################################################
	# Enable Update 
	# #############################################################################
	### Parameters ###
	if {[get_parameter_value EnableRawEth_g] == true} {
		set_parameter_property MapRawEthToRb_g VISIBLE true
	} else {
		set_parameter_property MapRawEthToRb_g VISIBLE false
	}
	
	if {[get_parameter_value EnableRawEth_g] == true} {
		set_parameter_property RawEthPayloadSize_g VISIBLE true
	} else {
		set_parameter_property RawEthPayloadSize_g VISIBLE false
	}
	
	if {[get_parameter_value EnableRawEth_g] == true} {
		set_parameter_property RawEthRxBufferCnt_g VISIBLE true
	} else {
		set_parameter_property RawEthRxBufferCnt_g VISIBLE false
	}
	
	if {[get_parameter_value EnableRawEth_g] == true} {
		set_parameter_property RawEthTxBufferCnt_g VISIBLE true
	} else {
		set_parameter_property RawEthTxBufferCnt_g VISIBLE false
	}
	
	if {[get_parameter_value UseStreamingMode_g] == true} {
		set_parameter_property TimeoutWidth_g VISIBLE true
	} else {
		set_parameter_property TimeoutWidth_g VISIBLE false
	}
	
	if {[get_parameter_value UseStreamingMode_g] == false} {
		set_parameter_property HdrUdpRxSrcPort_g VISIBLE true
	} else {
		set_parameter_property HdrUdpRxSrcPort_g VISIBLE false
	}
	
	if {[get_parameter_value UseStreamingMode_g] == false} {
		set_parameter_property HdrUdpRxDestPort_g VISIBLE true
	} else {
		set_parameter_property HdrUdpRxDestPort_g VISIBLE false
	}
	
	if {[get_parameter_value UseStreamingMode_g] == false} {
		set_parameter_property HdrUdpRxLength_g VISIBLE true
	} else {
		set_parameter_property HdrUdpRxLength_g VISIBLE false
	}
	
	if {[get_parameter_value UseStreamingMode_g] == false} {
		set_parameter_property HdrUdpRxChkSum_g VISIBLE true
	} else {
		set_parameter_property HdrUdpRxChkSum_g VISIBLE false
	}
	
	if {[get_parameter_value UseStreamingMode_g] == false} {
		set_parameter_property HdrUdpTxSrcPort_g VISIBLE true
	} else {
		set_parameter_property HdrUdpTxSrcPort_g VISIBLE false
	}
	
	if {[get_parameter_value UseStreamingMode_g] == false} {
		set_parameter_property HdrUdpTxDestPort_g VISIBLE true
	} else {
		set_parameter_property HdrUdpTxDestPort_g VISIBLE false
	}
	
	if {[get_parameter_value UseStreamingMode_g] == false} {
		set_parameter_property HdrIpRxVersion_g VISIBLE true
	} else {
		set_parameter_property HdrIpRxVersion_g VISIBLE false
	}
	
	if {[get_parameter_value UseStreamingMode_g] == false} {
		set_parameter_property HdrIpRxEcnDcsp_g VISIBLE true
	} else {
		set_parameter_property HdrIpRxEcnDcsp_g VISIBLE false
	}
	
	if {[get_parameter_value UseStreamingMode_g] == false} {
		set_parameter_property HdrIpRxLength_g VISIBLE true
	} else {
		set_parameter_property HdrIpRxLength_g VISIBLE false
	}
	
	if {[get_parameter_value UseStreamingMode_g] == false} {
		set_parameter_property HdrIpRxId_g VISIBLE true
	} else {
		set_parameter_property HdrIpRxId_g VISIBLE false
	}
	
	if {[get_parameter_value UseStreamingMode_g] == false} {
		set_parameter_property HdrIpRxFragOffset_g VISIBLE true
	} else {
		set_parameter_property HdrIpRxFragOffset_g VISIBLE false
	}
	
	if {[get_parameter_value UseStreamingMode_g] == false} {
		set_parameter_property HdrIpRxTtl_g VISIBLE true
	} else {
		set_parameter_property HdrIpRxTtl_g VISIBLE false
	}
	
	if {[get_parameter_value UseStreamingMode_g] == false} {
		set_parameter_property HdrIpRxProtocol_g VISIBLE true
	} else {
		set_parameter_property HdrIpRxProtocol_g VISIBLE false
	}
	
	if {[get_parameter_value UseStreamingMode_g] == false} {
		set_parameter_property HdrIpRxChkSum_g VISIBLE true
	} else {
		set_parameter_property HdrIpRxChkSum_g VISIBLE false
	}
	
	if {[get_parameter_value UseStreamingMode_g] == false} {
		set_parameter_property HdrIpRxSrcAddr_g VISIBLE true
	} else {
		set_parameter_property HdrIpRxSrcAddr_g VISIBLE false
	}
	
	if {[get_parameter_value UseStreamingMode_g] == false} {
		set_parameter_property HdrIpRxDestAddr_g VISIBLE true
	} else {
		set_parameter_property HdrIpRxDestAddr_g VISIBLE false
	}
	
	if {[get_parameter_value UseStreamingMode_g] == false} {
		set_parameter_property HdrIpTxEcnDcsp_g VISIBLE true
	} else {
		set_parameter_property HdrIpTxEcnDcsp_g VISIBLE false
	}
	
	if {[get_parameter_value UseStreamingMode_g] == false} {
		set_parameter_property HdrIpTxId_g VISIBLE true
	} else {
		set_parameter_property HdrIpTxId_g VISIBLE false
	}
	
	if {[get_parameter_value UseStreamingMode_g] == false} {
		set_parameter_property HdrIpTxFragOffset_g VISIBLE true
	} else {
		set_parameter_property HdrIpTxFragOffset_g VISIBLE false
	}
	
	if {[get_parameter_value UseStreamingMode_g] == false} {
		set_parameter_property HdrIpTxTtl_g VISIBLE true
	} else {
		set_parameter_property HdrIpTxTtl_g VISIBLE false
	}
	
	if {[get_parameter_value UseStreamingMode_g] == false} {
		set_parameter_property HdrIpTxProtocol_g VISIBLE true
	} else {
		set_parameter_property HdrIpTxProtocol_g VISIBLE false
	}
	
	if {[get_parameter_value UseStreamingMode_g] == false} {
		set_parameter_property HdrIpTxSrcAddr_g VISIBLE true
	} else {
		set_parameter_property HdrIpTxSrcAddr_g VISIBLE false
	}
	
	if {[get_parameter_value UseStreamingMode_g] == false} {
		set_parameter_property HdrIpTxDestAddr_g VISIBLE true
	} else {
		set_parameter_property HdrIpTxDestAddr_g VISIBLE false
	}
	
	if {[get_parameter_value UseStreamingMode_g] == false} {
		set_parameter_property HdrEthRxDestMac_g VISIBLE true
	} else {
		set_parameter_property HdrEthRxDestMac_g VISIBLE false
	}
	
	if {[get_parameter_value UseStreamingMode_g] == false} {
		set_parameter_property HdrEthRxSrcMac_g VISIBLE true
	} else {
		set_parameter_property HdrEthRxSrcMac_g VISIBLE false
	}
	
	if {[get_parameter_value UseStreamingMode_g] == false} {
		set_parameter_property HdrEthRxEthType_g VISIBLE true
	} else {
		set_parameter_property HdrEthRxEthType_g VISIBLE false
	}
	
	if {[get_parameter_value UseStreamingMode_g] == false} {
		set_parameter_property HdrEthTxDestMac_g VISIBLE true
	} else {
		set_parameter_property HdrEthTxDestMac_g VISIBLE false
	}
	
	if {[get_parameter_value UseStreamingMode_g] == false} {
		set_parameter_property HdrEthTxSrcMac_g VISIBLE true
	} else {
		set_parameter_property HdrEthTxSrcMac_g VISIBLE false
	}
	
	if {[get_parameter_value UseStreamingMode_g] == false} {
		set_parameter_property HdrEthTxEthType_g VISIBLE true
	} else {
		set_parameter_property HdrEthTxEthType_g VISIBLE false
	}
	
	### Ports ###
	if {[get_parameter_value UdpPortCount_g] > 0} {
		set_port_property Tx0_TDATA TERMINATION false
	} else {
		set_port_property Tx0_TDATA TERMINATION true
		set_port_property Tx0_TDATA TERMINATION_VALUE 0
	}
	
	if {[get_parameter_value UdpPortCount_g] > 0} {
		set_port_property Tx0_TVALID TERMINATION false
	} else {
		set_port_property Tx0_TVALID TERMINATION true
		set_port_property Tx0_TVALID TERMINATION_VALUE 0
	}
	
	if {[get_parameter_value UdpPortCount_g] > 0} {
		set_port_property Tx0_TUSER TERMINATION false
	} else {
		set_port_property Tx0_TUSER TERMINATION true
		set_port_property Tx0_TUSER TERMINATION_VALUE 0
	}
	
	if {[get_parameter_value UdpPortCount_g] > 0} {
		set_port_property Tx0_TLAST TERMINATION false
	} else {
		set_port_property Tx0_TLAST TERMINATION true
		set_port_property Tx0_TLAST TERMINATION_VALUE 0
	}
	
	if {[get_parameter_value UdpPortCount_g] > 0} {
		set_port_property Tx0_TREADY TERMINATION false
	} else {
		set_port_property Tx0_TREADY TERMINATION true
		set_port_property Tx0_TREADY TERMINATION_VALUE 0
	}
	
	if {[get_parameter_value UdpPortCount_g] > 0} {
		set_port_property Rx0_TDATA TERMINATION false
	} else {
		set_port_property Rx0_TDATA TERMINATION true
		set_port_property Rx0_TDATA TERMINATION_VALUE 0
	}
	
	if {[get_parameter_value UdpPortCount_g] > 0} {
		set_port_property Rx0_TVALID TERMINATION false
	} else {
		set_port_property Rx0_TVALID TERMINATION true
		set_port_property Rx0_TVALID TERMINATION_VALUE 0
	}
	
	if {[get_parameter_value UdpPortCount_g] > 0} {
		set_port_property Rx0_TUSER TERMINATION false
	} else {
		set_port_property Rx0_TUSER TERMINATION true
		set_port_property Rx0_TUSER TERMINATION_VALUE 0
	}
	
	if {[get_parameter_value UdpPortCount_g] > 0} {
		set_port_property Rx0_TLAST TERMINATION false
	} else {
		set_port_property Rx0_TLAST TERMINATION true
		set_port_property Rx0_TLAST TERMINATION_VALUE 0
	}
	
	if {[get_parameter_value UdpPortCount_g] > 0} {
		set_port_property Rx0_TREADY TERMINATION false
	} else {
		set_port_property Rx0_TREADY TERMINATION true
		set_port_property Rx0_TREADY TERMINATION_VALUE 0
	}
	
	if {[get_parameter_value UdpPortCount_g] > 1} {
		set_port_property Tx1_TDATA TERMINATION false
	} else {
		set_port_property Tx1_TDATA TERMINATION true
		set_port_property Tx1_TDATA TERMINATION_VALUE 0
	}
	
	if {[get_parameter_value UdpPortCount_g] > 1} {
		set_port_property Tx1_TVALID TERMINATION false
	} else {
		set_port_property Tx1_TVALID TERMINATION true
		set_port_property Tx1_TVALID TERMINATION_VALUE 0
	}
	
	if {[get_parameter_value UdpPortCount_g] > 1} {
		set_port_property Tx1_TUSER TERMINATION false
	} else {
		set_port_property Tx1_TUSER TERMINATION true
		set_port_property Tx1_TUSER TERMINATION_VALUE 0
	}
	
	if {[get_parameter_value UdpPortCount_g] > 1} {
		set_port_property Tx1_TLAST TERMINATION false
	} else {
		set_port_property Tx1_TLAST TERMINATION true
		set_port_property Tx1_TLAST TERMINATION_VALUE 0
	}
	
	if {[get_parameter_value UdpPortCount_g] > 1} {
		set_port_property Tx1_TREADY TERMINATION false
	} else {
		set_port_property Tx1_TREADY TERMINATION true
		set_port_property Tx1_TREADY TERMINATION_VALUE 0
	}
	
	if {[get_parameter_value UdpPortCount_g] > 1} {
		set_port_property Rx1_TDATA TERMINATION false
	} else {
		set_port_property Rx1_TDATA TERMINATION true
		set_port_property Rx1_TDATA TERMINATION_VALUE 0
	}
	
	if {[get_parameter_value UdpPortCount_g] > 1} {
		set_port_property Rx1_TVALID TERMINATION false
	} else {
		set_port_property Rx1_TVALID TERMINATION true
		set_port_property Rx1_TVALID TERMINATION_VALUE 0
	}
	
	if {[get_parameter_value UdpPortCount_g] > 1} {
		set_port_property Rx1_TUSER TERMINATION false
	} else {
		set_port_property Rx1_TUSER TERMINATION true
		set_port_property Rx1_TUSER TERMINATION_VALUE 0
	}
	
	if {[get_parameter_value UdpPortCount_g] > 1} {
		set_port_property Rx1_TLAST TERMINATION false
	} else {
		set_port_property Rx1_TLAST TERMINATION true
		set_port_property Rx1_TLAST TERMINATION_VALUE 0
	}
	
	if {[get_parameter_value UdpPortCount_g] > 1} {
		set_port_property Rx1_TREADY TERMINATION false
	} else {
		set_port_property Rx1_TREADY TERMINATION true
		set_port_property Rx1_TREADY TERMINATION_VALUE 0
	}
	
	if {[get_parameter_value UdpPortCount_g] > 2} {
		set_port_property Tx2_TDATA TERMINATION false
	} else {
		set_port_property Tx2_TDATA TERMINATION true
		set_port_property Tx2_TDATA TERMINATION_VALUE 0
	}
	
	if {[get_parameter_value UdpPortCount_g] > 2} {
		set_port_property Tx2_TVALID TERMINATION false
	} else {
		set_port_property Tx2_TVALID TERMINATION true
		set_port_property Tx2_TVALID TERMINATION_VALUE 0
	}
	
	if {[get_parameter_value UdpPortCount_g] > 2} {
		set_port_property Tx2_TUSER TERMINATION false
	} else {
		set_port_property Tx2_TUSER TERMINATION true
		set_port_property Tx2_TUSER TERMINATION_VALUE 0
	}
	
	if {[get_parameter_value UdpPortCount_g] > 2} {
		set_port_property Tx2_TLAST TERMINATION false
	} else {
		set_port_property Tx2_TLAST TERMINATION true
		set_port_property Tx2_TLAST TERMINATION_VALUE 0
	}
	
	if {[get_parameter_value UdpPortCount_g] > 2} {
		set_port_property Tx2_TREADY TERMINATION false
	} else {
		set_port_property Tx2_TREADY TERMINATION true
		set_port_property Tx2_TREADY TERMINATION_VALUE 0
	}
	
	if {[get_parameter_value UdpPortCount_g] > 2} {
		set_port_property Rx2_TDATA TERMINATION false
	} else {
		set_port_property Rx2_TDATA TERMINATION true
		set_port_property Rx2_TDATA TERMINATION_VALUE 0
	}
	
	if {[get_parameter_value UdpPortCount_g] > 2} {
		set_port_property Rx2_TVALID TERMINATION false
	} else {
		set_port_property Rx2_TVALID TERMINATION true
		set_port_property Rx2_TVALID TERMINATION_VALUE 0
	}
	
	if {[get_parameter_value UdpPortCount_g] > 2} {
		set_port_property Rx2_TUSER TERMINATION false
	} else {
		set_port_property Rx2_TUSER TERMINATION true
		set_port_property Rx2_TUSER TERMINATION_VALUE 0
	}
	
	if {[get_parameter_value UdpPortCount_g] > 2} {
		set_port_property Rx2_TLAST TERMINATION false
	} else {
		set_port_property Rx2_TLAST TERMINATION true
		set_port_property Rx2_TLAST TERMINATION_VALUE 0
	}
	
	if {[get_parameter_value UdpPortCount_g] > 2} {
		set_port_property Rx2_TREADY TERMINATION false
	} else {
		set_port_property Rx2_TREADY TERMINATION true
		set_port_property Rx2_TREADY TERMINATION_VALUE 0
	}
	
	if {[get_parameter_value UdpPortCount_g] > 3} {
		set_port_property Tx3_TDATA TERMINATION false
	} else {
		set_port_property Tx3_TDATA TERMINATION true
		set_port_property Tx3_TDATA TERMINATION_VALUE 0
	}
	
	if {[get_parameter_value UdpPortCount_g] > 3} {
		set_port_property Tx3_TVALID TERMINATION false
	} else {
		set_port_property Tx3_TVALID TERMINATION true
		set_port_property Tx3_TVALID TERMINATION_VALUE 0
	}
	
	if {[get_parameter_value UdpPortCount_g] > 3} {
		set_port_property Tx3_TUSER TERMINATION false
	} else {
		set_port_property Tx3_TUSER TERMINATION true
		set_port_property Tx3_TUSER TERMINATION_VALUE 0
	}
	
	if {[get_parameter_value UdpPortCount_g] > 3} {
		set_port_property Tx3_TLAST TERMINATION false
	} else {
		set_port_property Tx3_TLAST TERMINATION true
		set_port_property Tx3_TLAST TERMINATION_VALUE 0
	}
	
	if {[get_parameter_value UdpPortCount_g] > 3} {
		set_port_property Tx3_TREADY TERMINATION false
	} else {
		set_port_property Tx3_TREADY TERMINATION true
		set_port_property Tx3_TREADY TERMINATION_VALUE 0
	}
	
	if {[get_parameter_value UdpPortCount_g] > 3} {
		set_port_property Rx3_TDATA TERMINATION false
	} else {
		set_port_property Rx3_TDATA TERMINATION true
		set_port_property Rx3_TDATA TERMINATION_VALUE 0
	}
	
	if {[get_parameter_value UdpPortCount_g] > 3} {
		set_port_property Rx3_TVALID TERMINATION false
	} else {
		set_port_property Rx3_TVALID TERMINATION true
		set_port_property Rx3_TVALID TERMINATION_VALUE 0
	}
	
	if {[get_parameter_value UdpPortCount_g] > 3} {
		set_port_property Rx3_TUSER TERMINATION false
	} else {
		set_port_property Rx3_TUSER TERMINATION true
		set_port_property Rx3_TUSER TERMINATION_VALUE 0
	}
	
	if {[get_parameter_value UdpPortCount_g] > 3} {
		set_port_property Rx3_TLAST TERMINATION false
	} else {
		set_port_property Rx3_TLAST TERMINATION true
		set_port_property Rx3_TLAST TERMINATION_VALUE 0
	}
	
	if {[get_parameter_value UdpPortCount_g] > 3} {
		set_port_property Rx3_TREADY TERMINATION false
	} else {
		set_port_property Rx3_TREADY TERMINATION true
		set_port_property Rx3_TREADY TERMINATION_VALUE 0
	}
	
	if {[get_parameter_value UdpPortCount_g] > 4} {
		set_port_property Tx4_TDATA TERMINATION false
	} else {
		set_port_property Tx4_TDATA TERMINATION true
		set_port_property Tx4_TDATA TERMINATION_VALUE 0
	}
	
	if {[get_parameter_value UdpPortCount_g] > 4} {
		set_port_property Tx4_TVALID TERMINATION false
	} else {
		set_port_property Tx4_TVALID TERMINATION true
		set_port_property Tx4_TVALID TERMINATION_VALUE 0
	}
	
	if {[get_parameter_value UdpPortCount_g] > 4} {
		set_port_property Tx4_TUSER TERMINATION false
	} else {
		set_port_property Tx4_TUSER TERMINATION true
		set_port_property Tx4_TUSER TERMINATION_VALUE 0
	}
	
	if {[get_parameter_value UdpPortCount_g] > 4} {
		set_port_property Tx4_TLAST TERMINATION false
	} else {
		set_port_property Tx4_TLAST TERMINATION true
		set_port_property Tx4_TLAST TERMINATION_VALUE 0
	}
	
	if {[get_parameter_value UdpPortCount_g] > 4} {
		set_port_property Tx4_TREADY TERMINATION false
	} else {
		set_port_property Tx4_TREADY TERMINATION true
		set_port_property Tx4_TREADY TERMINATION_VALUE 0
	}
	
	if {[get_parameter_value UdpPortCount_g] > 4} {
		set_port_property Rx4_TDATA TERMINATION false
	} else {
		set_port_property Rx4_TDATA TERMINATION true
		set_port_property Rx4_TDATA TERMINATION_VALUE 0
	}
	
	if {[get_parameter_value UdpPortCount_g] > 4} {
		set_port_property Rx4_TVALID TERMINATION false
	} else {
		set_port_property Rx4_TVALID TERMINATION true
		set_port_property Rx4_TVALID TERMINATION_VALUE 0
	}
	
	if {[get_parameter_value UdpPortCount_g] > 4} {
		set_port_property Rx4_TUSER TERMINATION false
	} else {
		set_port_property Rx4_TUSER TERMINATION true
		set_port_property Rx4_TUSER TERMINATION_VALUE 0
	}
	
	if {[get_parameter_value UdpPortCount_g] > 4} {
		set_port_property Rx4_TLAST TERMINATION false
	} else {
		set_port_property Rx4_TLAST TERMINATION true
		set_port_property Rx4_TLAST TERMINATION_VALUE 0
	}
	
	if {[get_parameter_value UdpPortCount_g] > 4} {
		set_port_property Rx4_TREADY TERMINATION false
	} else {
		set_port_property Rx4_TREADY TERMINATION true
		set_port_property Rx4_TREADY TERMINATION_VALUE 0
	}
	
	if {[get_parameter_value UdpPortCount_g] > 5} {
		set_port_property Tx5_TDATA TERMINATION false
	} else {
		set_port_property Tx5_TDATA TERMINATION true
		set_port_property Tx5_TDATA TERMINATION_VALUE 0
	}
	
	if {[get_parameter_value UdpPortCount_g] > 5} {
		set_port_property Tx5_TVALID TERMINATION false
	} else {
		set_port_property Tx5_TVALID TERMINATION true
		set_port_property Tx5_TVALID TERMINATION_VALUE 0
	}
	
	if {[get_parameter_value UdpPortCount_g] > 5} {
		set_port_property Tx5_TUSER TERMINATION false
	} else {
		set_port_property Tx5_TUSER TERMINATION true
		set_port_property Tx5_TUSER TERMINATION_VALUE 0
	}
	
	if {[get_parameter_value UdpPortCount_g] > 5} {
		set_port_property Tx5_TLAST TERMINATION false
	} else {
		set_port_property Tx5_TLAST TERMINATION true
		set_port_property Tx5_TLAST TERMINATION_VALUE 0
	}
	
	if {[get_parameter_value UdpPortCount_g] > 5} {
		set_port_property Tx5_TREADY TERMINATION false
	} else {
		set_port_property Tx5_TREADY TERMINATION true
		set_port_property Tx5_TREADY TERMINATION_VALUE 0
	}
	
	if {[get_parameter_value UdpPortCount_g] > 5} {
		set_port_property Rx5_TDATA TERMINATION false
	} else {
		set_port_property Rx5_TDATA TERMINATION true
		set_port_property Rx5_TDATA TERMINATION_VALUE 0
	}
	
	if {[get_parameter_value UdpPortCount_g] > 5} {
		set_port_property Rx5_TVALID TERMINATION false
	} else {
		set_port_property Rx5_TVALID TERMINATION true
		set_port_property Rx5_TVALID TERMINATION_VALUE 0
	}
	
	if {[get_parameter_value UdpPortCount_g] > 5} {
		set_port_property Rx5_TUSER TERMINATION false
	} else {
		set_port_property Rx5_TUSER TERMINATION true
		set_port_property Rx5_TUSER TERMINATION_VALUE 0
	}
	
	if {[get_parameter_value UdpPortCount_g] > 5} {
		set_port_property Rx5_TLAST TERMINATION false
	} else {
		set_port_property Rx5_TLAST TERMINATION true
		set_port_property Rx5_TLAST TERMINATION_VALUE 0
	}
	
	if {[get_parameter_value UdpPortCount_g] > 5} {
		set_port_property Rx5_TREADY TERMINATION false
	} else {
		set_port_property Rx5_TREADY TERMINATION true
		set_port_property Rx5_TREADY TERMINATION_VALUE 0
	}
	
	if {[get_parameter_value UdpPortCount_g] > 6} {
		set_port_property Tx6_TDATA TERMINATION false
	} else {
		set_port_property Tx6_TDATA TERMINATION true
		set_port_property Tx6_TDATA TERMINATION_VALUE 0
	}
	
	if {[get_parameter_value UdpPortCount_g] > 6} {
		set_port_property Tx6_TVALID TERMINATION false
	} else {
		set_port_property Tx6_TVALID TERMINATION true
		set_port_property Tx6_TVALID TERMINATION_VALUE 0
	}
	
	if {[get_parameter_value UdpPortCount_g] > 6} {
		set_port_property Tx6_TUSER TERMINATION false
	} else {
		set_port_property Tx6_TUSER TERMINATION true
		set_port_property Tx6_TUSER TERMINATION_VALUE 0
	}
	
	if {[get_parameter_value UdpPortCount_g] > 6} {
		set_port_property Tx6_TLAST TERMINATION false
	} else {
		set_port_property Tx6_TLAST TERMINATION true
		set_port_property Tx6_TLAST TERMINATION_VALUE 0
	}
	
	if {[get_parameter_value UdpPortCount_g] > 6} {
		set_port_property Tx6_TREADY TERMINATION false
	} else {
		set_port_property Tx6_TREADY TERMINATION true
		set_port_property Tx6_TREADY TERMINATION_VALUE 0
	}
	
	if {[get_parameter_value UdpPortCount_g] > 6} {
		set_port_property Rx6_TDATA TERMINATION false
	} else {
		set_port_property Rx6_TDATA TERMINATION true
		set_port_property Rx6_TDATA TERMINATION_VALUE 0
	}
	
	if {[get_parameter_value UdpPortCount_g] > 6} {
		set_port_property Rx6_TVALID TERMINATION false
	} else {
		set_port_property Rx6_TVALID TERMINATION true
		set_port_property Rx6_TVALID TERMINATION_VALUE 0
	}
	
	if {[get_parameter_value UdpPortCount_g] > 6} {
		set_port_property Rx6_TUSER TERMINATION false
	} else {
		set_port_property Rx6_TUSER TERMINATION true
		set_port_property Rx6_TUSER TERMINATION_VALUE 0
	}
	
	if {[get_parameter_value UdpPortCount_g] > 6} {
		set_port_property Rx6_TLAST TERMINATION false
	} else {
		set_port_property Rx6_TLAST TERMINATION true
		set_port_property Rx6_TLAST TERMINATION_VALUE 0
	}
	
	if {[get_parameter_value UdpPortCount_g] > 6} {
		set_port_property Rx6_TREADY TERMINATION false
	} else {
		set_port_property Rx6_TREADY TERMINATION true
		set_port_property Rx6_TREADY TERMINATION_VALUE 0
	}
	
	if {[get_parameter_value UdpPortCount_g] > 7} {
		set_port_property Tx7_TDATA TERMINATION false
	} else {
		set_port_property Tx7_TDATA TERMINATION true
		set_port_property Tx7_TDATA TERMINATION_VALUE 0
	}
	
	if {[get_parameter_value UdpPortCount_g] > 7} {
		set_port_property Tx7_TVALID TERMINATION false
	} else {
		set_port_property Tx7_TVALID TERMINATION true
		set_port_property Tx7_TVALID TERMINATION_VALUE 0
	}
	
	if {[get_parameter_value UdpPortCount_g] > 7} {
		set_port_property Tx7_TUSER TERMINATION false
	} else {
		set_port_property Tx7_TUSER TERMINATION true
		set_port_property Tx7_TUSER TERMINATION_VALUE 0
	}
	
	if {[get_parameter_value UdpPortCount_g] > 7} {
		set_port_property Tx7_TLAST TERMINATION false
	} else {
		set_port_property Tx7_TLAST TERMINATION true
		set_port_property Tx7_TLAST TERMINATION_VALUE 0
	}
	
	if {[get_parameter_value UdpPortCount_g] > 7} {
		set_port_property Tx7_TREADY TERMINATION false
	} else {
		set_port_property Tx7_TREADY TERMINATION true
		set_port_property Tx7_TREADY TERMINATION_VALUE 0
	}
	
	if {[get_parameter_value UdpPortCount_g] > 7} {
		set_port_property Rx7_TDATA TERMINATION false
	} else {
		set_port_property Rx7_TDATA TERMINATION true
		set_port_property Rx7_TDATA TERMINATION_VALUE 0
	}
	
	if {[get_parameter_value UdpPortCount_g] > 7} {
		set_port_property Rx7_TVALID TERMINATION false
	} else {
		set_port_property Rx7_TVALID TERMINATION true
		set_port_property Rx7_TVALID TERMINATION_VALUE 0
	}
	
	if {[get_parameter_value UdpPortCount_g] > 7} {
		set_port_property Rx7_TUSER TERMINATION false
	} else {
		set_port_property Rx7_TUSER TERMINATION true
		set_port_property Rx7_TUSER TERMINATION_VALUE 0
	}
	
	if {[get_parameter_value UdpPortCount_g] > 7} {
		set_port_property Rx7_TLAST TERMINATION false
	} else {
		set_port_property Rx7_TLAST TERMINATION true
		set_port_property Rx7_TLAST TERMINATION_VALUE 0
	}
	
	if {[get_parameter_value UdpPortCount_g] > 7} {
		set_port_property Rx7_TREADY TERMINATION false
	} else {
		set_port_property Rx7_TREADY TERMINATION true
		set_port_property Rx7_TREADY TERMINATION_VALUE 0
	}
	
	if {[get_parameter_value EnableRawEth_g] == true && [get_parameter_value MapRawEthToRb_g] == false} {
		set_port_property EthTx_TDATA TERMINATION false
	} else {
		set_port_property EthTx_TDATA TERMINATION true
		set_port_property EthTx_TDATA TERMINATION_VALUE 0
	}
	
	if {[get_parameter_value EnableRawEth_g] == true && [get_parameter_value MapRawEthToRb_g] == false} {
		set_port_property EthTx_TVALID TERMINATION false
	} else {
		set_port_property EthTx_TVALID TERMINATION true
		set_port_property EthTx_TVALID TERMINATION_VALUE 0
	}
	
	if {[get_parameter_value EnableRawEth_g] == true && [get_parameter_value MapRawEthToRb_g] == false} {
		set_port_property EthTx_TUSER TERMINATION false
	} else {
		set_port_property EthTx_TUSER TERMINATION true
		set_port_property EthTx_TUSER TERMINATION_VALUE 0
	}
	
	if {[get_parameter_value EnableRawEth_g] == true && [get_parameter_value MapRawEthToRb_g] == false} {
		set_port_property EthTx_TLAST TERMINATION false
	} else {
		set_port_property EthTx_TLAST TERMINATION true
		set_port_property EthTx_TLAST TERMINATION_VALUE 0
	}
	
	if {[get_parameter_value EnableRawEth_g] == true && [get_parameter_value MapRawEthToRb_g] == false} {
		set_port_property EthTx_TREADY TERMINATION false
	} else {
		set_port_property EthTx_TREADY TERMINATION true
		set_port_property EthTx_TREADY TERMINATION_VALUE 0
	}
	
	if {[get_parameter_value EnableRawEth_g] == true && [get_parameter_value MapRawEthToRb_g] == false} {
		set_port_property EthRx_TDATA TERMINATION false
	} else {
		set_port_property EthRx_TDATA TERMINATION true
		set_port_property EthRx_TDATA TERMINATION_VALUE 0
	}
	
	if {[get_parameter_value EnableRawEth_g] == true && [get_parameter_value MapRawEthToRb_g] == false} {
		set_port_property EthRx_TVALID TERMINATION false
	} else {
		set_port_property EthRx_TVALID TERMINATION true
		set_port_property EthRx_TVALID TERMINATION_VALUE 0
	}
	
	if {[get_parameter_value EnableRawEth_g] == true && [get_parameter_value MapRawEthToRb_g] == false} {
		set_port_property EthRx_TUSER TERMINATION false
	} else {
		set_port_property EthRx_TUSER TERMINATION true
		set_port_property EthRx_TUSER TERMINATION_VALUE 0
	}
	
	if {[get_parameter_value EnableRawEth_g] == true && [get_parameter_value MapRawEthToRb_g] == false} {
		set_port_property EthRx_TLAST TERMINATION false
	} else {
		set_port_property EthRx_TLAST TERMINATION true
		set_port_property EthRx_TLAST TERMINATION_VALUE 0
	}
	
	if {[get_parameter_value EnableRawEth_g] == true && [get_parameter_value MapRawEthToRb_g] == false} {
		set_port_property EthRx_TREADY TERMINATION false
	} else {
		set_port_property EthRx_TREADY TERMINATION true
		set_port_property EthRx_TREADY TERMINATION_VALUE 0
	}
	
	### Busses ###
	### AXI-Stream ###
	if {[get_parameter_value UdpPortCount_g] > 0} {
		set_interface_property UdpTx0 ENABLED true
	} else {
		set_interface_property UdpTx0 ENABLED false
	}
	
	if {[get_parameter_value UdpPortCount_g] > 0} {
		set_interface_property UdpRx0 ENABLED true
	} else {
		set_interface_property UdpRx0 ENABLED false
	}
	
	if {[get_parameter_value UdpPortCount_g] > 1} {
		set_interface_property UdpTx1 ENABLED true
	} else {
		set_interface_property UdpTx1 ENABLED false
	}
	
	if {[get_parameter_value UdpPortCount_g] > 1} {
		set_interface_property UdpRx1 ENABLED true
	} else {
		set_interface_property UdpRx1 ENABLED false
	}
	
	if {[get_parameter_value UdpPortCount_g] > 2} {
		set_interface_property UdpTx2 ENABLED true
	} else {
		set_interface_property UdpTx2 ENABLED false
	}
	
	if {[get_parameter_value UdpPortCount_g] > 2} {
		set_interface_property UdpRx2 ENABLED true
	} else {
		set_interface_property UdpRx2 ENABLED false
	}
	
	if {[get_parameter_value UdpPortCount_g] > 3} {
		set_interface_property UdpTx3 ENABLED true
	} else {
		set_interface_property UdpTx3 ENABLED false
	}
	
	if {[get_parameter_value UdpPortCount_g] > 3} {
		set_interface_property UdpRx3 ENABLED true
	} else {
		set_interface_property UdpRx3 ENABLED false
	}
	
	if {[get_parameter_value UdpPortCount_g] > 4} {
		set_interface_property UdpTx4 ENABLED true
	} else {
		set_interface_property UdpTx4 ENABLED false
	}
	
	if {[get_parameter_value UdpPortCount_g] > 4} {
		set_interface_property UdpRx4 ENABLED true
	} else {
		set_interface_property UdpRx4 ENABLED false
	}
	
	if {[get_parameter_value UdpPortCount_g] > 5} {
		set_interface_property UdpTx5 ENABLED true
	} else {
		set_interface_property UdpTx5 ENABLED false
	}
	
	if {[get_parameter_value UdpPortCount_g] > 5} {
		set_interface_property UdpRx5 ENABLED true
	} else {
		set_interface_property UdpRx5 ENABLED false
	}
	
	if {[get_parameter_value UdpPortCount_g] > 6} {
		set_interface_property UdpTx6 ENABLED true
	} else {
		set_interface_property UdpTx6 ENABLED false
	}
	
	if {[get_parameter_value UdpPortCount_g] > 6} {
		set_interface_property UdpRx6 ENABLED true
	} else {
		set_interface_property UdpRx6 ENABLED false
	}
	
	if {[get_parameter_value UdpPortCount_g] > 7} {
		set_interface_property UdpTx7 ENABLED true
	} else {
		set_interface_property UdpTx7 ENABLED false
	}
	
	if {[get_parameter_value UdpPortCount_g] > 7} {
		set_interface_property UdpRx7 ENABLED true
	} else {
		set_interface_property UdpRx7 ENABLED false
	}
	
	if {[get_parameter_value EnableRawEth_g] == true && [get_parameter_value MapRawEthToRb_g] == false} {
		set_interface_property RawEthTx ENABLED true
	} else {
		set_interface_property RawEthTx ENABLED false
	}
	
	if {[get_parameter_value EnableRawEth_g] == true && [get_parameter_value MapRawEthToRb_g] == false} {
		set_interface_property RawEthRx ENABLED true
	} else {
		set_interface_property RawEthRx ENABLED false
	}
	
}

# #############################################################################
# QIP creation
# #############################################################################
set_qip_strings {
	"set family [get_global_assignment -entity \"system\" -library \"system\" -name IP_TARGETED_DEVICE_FAMILY]"
	"if {$family eq \"Cyclone V\"} {"
	"set_global_assignment -library \"lib_en_udp_ip_eth_rgmii_alt_c5_eval_qsys\" -name VHDL_FILE [file join $::quartus(qip_path) \"submodules/lib_en_udp_ip_eth_rgmii_alt_c5_eval_qsys/en_udp_ip_eth_pkg.vhd\"]"
	"set_global_assignment -library \"lib_en_udp_ip_eth_rgmii_alt_c5_eval_qsys\" -name VHDL_FILE [file join $::quartus(qip_path) \"submodules/lib_en_udp_ip_eth_rgmii_alt_c5_eval_qsys/en_udp_ip_eth_tbr.vhd\"]"
	"set_global_assignment -library \"lib_en_udp_ip_eth_rgmii_alt_c5_eval_qsys\" -name VHDL_FILE [file join $::quartus(qip_path) \"submodules/lib_en_udp_ip_eth_rgmii_alt_c5_eval_qsys/en_udp_ip_eth_axi_rb.vhd\"]"
	"set_global_assignment -library \"lib_en_udp_ip_eth_rgmii_alt_c5_eval_qsys\" -name VHDL_FILE [file join $::quartus(qip_path) \"submodules/lib_en_udp_ip_eth_rgmii_alt_c5_eval_qsys/en_udp_ip_eth_rgmii.vhd\"]"
	"set_global_assignment -library \"lib_en_udp_ip_eth_rgmii_alt_c5_eval_qsys\" -name VHDL_FILE [file join $::quartus(qip_path) \"submodules/lib_en_udp_ip_eth_rgmii_alt_c5_eval_qsys/en_udp_ip_eth_rgmii_alt_c5_eval_qsys.vhd\"]"
	"set_global_assignment -library \"en_udp_ip_eth_rgmii_alt_c5_eval_qsys_cs\" -name VHDL_FILE [file join $::quartus(qip_path) \"submodules/en_udp_ip_eth_rgmii_alt_c5_eval_qsys_cs/en_cs_pipeline_stage.vhd\"]"
	"set_global_assignment -library \"en_udp_ip_eth_rgmii_alt_c5_eval_qsys_cs\" -name VHDL_FILE [file join $::quartus(qip_path) \"submodules/en_udp_ip_eth_rgmii_alt_c5_eval_qsys_cs/en_cs_async.vhd\"]"
	"set_global_assignment -library \"en_udp_ip_eth_rgmii_alt_c5_eval_qsys_cl\" -name VHDL_FILE [file join $::quartus(qip_path) \"submodules/en_udp_ip_eth_rgmii_alt_c5_eval_qsys_cl/en_cl_base_pkg.vhd\"]"
	"set_global_assignment -library \"en_udp_ip_eth_rgmii_alt_c5_eval_qsys_cl\" -name VHDL_FILE [file join $::quartus(qip_path) \"submodules/en_udp_ip_eth_rgmii_alt_c5_eval_qsys_cl/en_cl_arbiter.vhd\"]"
	"set_global_assignment -library \"en_udp_ip_eth_rgmii_alt_c5_eval_qsys_cl\" -name VHDL_FILE [file join $::quartus(qip_path) \"submodules/en_udp_ip_eth_rgmii_alt_c5_eval_qsys_cl/en_cl_crc.vhd\"]"
	"set_global_assignment -library \"en_udp_ip_eth_rgmii_alt_c5_eval_qsys_cl\" -name VHDL_FILE [file join $::quartus(qip_path) \"submodules/en_udp_ip_eth_rgmii_alt_c5_eval_qsys_cl/en_cl_loadable_crc.vhd\"]"
	"set_global_assignment -library \"en_udp_ip_eth_rgmii_alt_c5_eval_qsys_cl\" -name VHDL_FILE [file join $::quartus(qip_path) \"submodules/en_udp_ip_eth_rgmii_alt_c5_eval_qsys_cl/en_cl_checksum_udp.vhd\"]"
	"set_global_assignment -library \"en_udp_ip_eth_rgmii_alt_c5_eval_qsys_cl\" -name VHDL_FILE [file join $::quartus(qip_path) \"submodules/en_udp_ip_eth_rgmii_alt_c5_eval_qsys_cl/en_cl_dpram.vhd\"]"
	"set_global_assignment -library \"en_udp_ip_eth_rgmii_alt_c5_eval_qsys_cl\" -name VHDL_FILE [file join $::quartus(qip_path) \"submodules/en_udp_ip_eth_rgmii_alt_c5_eval_qsys_cl/en_cl_reset_sync.vhd\"]"
	"set_global_assignment -library \"en_udp_ip_eth_rgmii_alt_c5_eval_qsys_cl\" -name VHDL_FILE [file join $::quartus(qip_path) \"submodules/en_udp_ip_eth_rgmii_alt_c5_eval_qsys_cl/en_cl_conv_from_gray.vhd\"]"
	"set_global_assignment -library \"en_udp_ip_eth_rgmii_alt_c5_eval_qsys_cl\" -name VHDL_FILE [file join $::quartus(qip_path) \"submodules/en_udp_ip_eth_rgmii_alt_c5_eval_qsys_cl/en_cl_gray_incrementer.vhd\"]"
	"set_global_assignment -library \"en_udp_ip_eth_rgmii_alt_c5_eval_qsys_cl\" -name VHDL_FILE [file join $::quartus(qip_path) \"submodules/en_udp_ip_eth_rgmii_alt_c5_eval_qsys_cl/en_cl_fifo_async_level.vhd\"]"
	"set_global_assignment -library \"en_udp_ip_eth_rgmii_alt_c5_eval_qsys_cl\" -name VHDL_FILE [file join $::quartus(qip_path) \"submodules/en_udp_ip_eth_rgmii_alt_c5_eval_qsys_cl/en_cl_rb_clock_crossing.vhd\"]"
	"set_global_assignment -library \"en_udp_ip_eth_rgmii_alt_c5_eval_qsys_cl\" -name VHDL_FILE [file join $::quartus(qip_path) \"submodules/en_udp_ip_eth_rgmii_alt_c5_eval_qsys_cl/en_cl_axi_rb_interface.vhd\"]"
	"set_global_assignment -library \"en_udp_ip_eth_rgmii_alt_c5_eval_qsys_cl\" -name VHDL_FILE [file join $::quartus(qip_path) \"submodules/en_udp_ip_eth_rgmii_alt_c5_eval_qsys_cl/en_cl_register_bank.vhd\"]"
	"set_global_assignment -library \"en_udp_ip_eth_rgmii_alt_c5_eval_qsys_cl\" -name VHDL_FILE [file join $::quartus(qip_path) \"submodules/en_udp_ip_eth_rgmii_alt_c5_eval_qsys_cl/en_cl_fifo_sync.vhd\"]"
	"set_global_assignment -library \"en_udp_ip_eth_rgmii_alt_c5_eval_qsys_cl\" -name VHDL_FILE [file join $::quartus(qip_path) \"submodules/en_udp_ip_eth_rgmii_alt_c5_eval_qsys_cl/en_cl_gmii_framer.vhd\"]"
	"set_global_assignment -library \"en_udp_ip_eth_rgmii_alt_c5_eval_qsys_cl\" -name VHDL_FILE [file join $::quartus(qip_path) \"submodules/en_udp_ip_eth_rgmii_alt_c5_eval_qsys_cl/en_cl_fifo_async.vhd\"]"
	"set_global_assignment -library \"en_udp_ip_eth_rgmii_alt_c5_eval_qsys_cl\" -name VHDL_FILE [file join $::quartus(qip_path) \"submodules/en_udp_ip_eth_rgmii_alt_c5_eval_qsys_cl/en_cl_rgmii_gmii_trispeed.vhd\"]"
	"set_global_assignment -library \"en_udp_ip_eth_rgmii_alt_c5_eval_qsys_cl\" -name VHDL_FILE [file join $::quartus(qip_path) \"submodules/en_udp_ip_eth_rgmii_alt_c5_eval_qsys_cl/en_cl_rgmii_trispeed_phy_mdl_ddr.vhd\"]"
	"set_global_assignment -library \"en_udp_ip_eth_rgmii_alt_c5_eval_qsys_cl\" -name VHDL_FILE [file join $::quartus(qip_path) \"submodules/en_udp_ip_eth_rgmii_alt_c5_eval_qsys_cl/en_cl_rgmii_trispeed_phy_mdl.vhd\"]"
	"set_global_assignment -library \"en_udp_ip_eth_rgmii_alt_c5_eval_qsys_cl\" -name VHDL_FILE [file join $::quartus(qip_path) \"submodules/en_udp_ip_eth_rgmii_alt_c5_eval_qsys_cl/en_cl_rom_fifo.vhd\"]"
	"set_global_assignment -library \"en_udp_ip_eth_rgmii_alt_c5_eval_qsys_cl\" -name VHDL_FILE [file join $::quartus(qip_path) \"submodules/en_udp_ip_eth_rgmii_alt_c5_eval_qsys_cl/en_cl_mdio.vhd\"]"
	"set_global_assignment -library \"en_udp_ip_eth_rgmii_alt_c5_eval_qsys_cl\" -name VHDL_FILE [file join $::quartus(qip_path) \"submodules/en_udp_ip_eth_rgmii_alt_c5_eval_qsys_cl/en_cl_mdio_config.vhd\"]"
	"set_global_assignment -library \"en_udp_ip_eth_rgmii_alt_c5_eval_qsys_cn\" -name VHDL_FILE [file join $::quartus(qip_path) \"submodules/en_udp_ip_eth_rgmii_alt_c5_eval_qsys_cn/en_cn_pipeline_stage.vhd\"]"
	"set_global_assignment -library \"en_udp_ip_eth_rgmii_alt_c5_eval_qsys_cn\" -name VHDL_FILE [file join $::quartus(qip_path) \"submodules/en_udp_ip_eth_rgmii_alt_c5_eval_qsys_cn/en_cn_buffer.vhd\"]"
	"set_global_assignment -library \"en_udp_ip_eth_rgmii_alt_c5_eval_qsys_cn\" -name VHDL_FILE [file join $::quartus(qip_path) \"submodules/en_udp_ip_eth_rgmii_alt_c5_eval_qsys_cn/en_cn_arp_core.vhd\"]"
	"set_global_assignment -library \"en_udp_ip_eth_rgmii_alt_c5_eval_qsys_cn\" -name VHDL_FILE [file join $::quartus(qip_path) \"submodules/en_udp_ip_eth_rgmii_alt_c5_eval_qsys_cn/en_cn_eth_core.vhd\"]"
	"set_global_assignment -library \"en_udp_ip_eth_rgmii_alt_c5_eval_qsys_cn\" -name VHDL_FILE [file join $::quartus(qip_path) \"submodules/en_udp_ip_eth_rgmii_alt_c5_eval_qsys_cn/en_cn_ip_core.vhd\"]"
	"set_global_assignment -library \"en_udp_ip_eth_rgmii_alt_c5_eval_qsys_cn\" -name VHDL_FILE [file join $::quartus(qip_path) \"submodules/en_udp_ip_eth_rgmii_alt_c5_eval_qsys_cn/en_cn_udp_core.vhd\"]"
	"set_global_assignment -library \"en_udp_ip_eth_rgmii_alt_c5_eval_qsys_cn\" -name VHDL_FILE [file join $::quartus(qip_path) \"submodules/en_udp_ip_eth_rgmii_alt_c5_eval_qsys_cn/en_cn_udp_txheader.vhd\"]"
	"set_global_assignment -library \"en_udp_ip_eth_rgmii_alt_c5_eval_qsys_cn\" -name VHDL_FILE [file join $::quartus(qip_path) \"submodules/en_udp_ip_eth_rgmii_alt_c5_eval_qsys_cn/en_cn_udp_eth_core.vhd\"]"
	"}"
	"if {$family eq \"Arria 10\"} {"
	"set_global_assignment -library \"lib_en_udp_ip_eth_rgmii_alt_c5_eval_qsys\" -name VHDL_FILE [file join $::quartus(qip_path) \"en_udp_ip_eth_rgmii_alt_c5_eval_qsys_10/synth/lib_en_udp_ip_eth_rgmii_alt_c5_eval_qsys/en_udp_ip_eth_pkg.vhd\"]"
	"set_global_assignment -library \"lib_en_udp_ip_eth_rgmii_alt_c5_eval_qsys\" -name VHDL_FILE [file join $::quartus(qip_path) \"en_udp_ip_eth_rgmii_alt_c5_eval_qsys_10/synth/lib_en_udp_ip_eth_rgmii_alt_c5_eval_qsys/en_udp_ip_eth_tbr.vhd\"]"
	"set_global_assignment -library \"lib_en_udp_ip_eth_rgmii_alt_c5_eval_qsys\" -name VHDL_FILE [file join $::quartus(qip_path) \"en_udp_ip_eth_rgmii_alt_c5_eval_qsys_10/synth/lib_en_udp_ip_eth_rgmii_alt_c5_eval_qsys/en_udp_ip_eth_axi_rb.vhd\"]"
	"set_global_assignment -library \"lib_en_udp_ip_eth_rgmii_alt_c5_eval_qsys\" -name VHDL_FILE [file join $::quartus(qip_path) \"en_udp_ip_eth_rgmii_alt_c5_eval_qsys_10/synth/lib_en_udp_ip_eth_rgmii_alt_c5_eval_qsys/en_udp_ip_eth_rgmii.vhd\"]"
	"set_global_assignment -library \"lib_en_udp_ip_eth_rgmii_alt_c5_eval_qsys\" -name VHDL_FILE [file join $::quartus(qip_path) \"en_udp_ip_eth_rgmii_alt_c5_eval_qsys_10/synth/lib_en_udp_ip_eth_rgmii_alt_c5_eval_qsys/en_udp_ip_eth_rgmii_alt_c5_eval_qsys.vhd\"]"
	"set_global_assignment -library \"en_udp_ip_eth_rgmii_alt_c5_eval_qsys_cs\" -name VHDL_FILE [file join $::quartus(qip_path) \"en_udp_ip_eth_rgmii_alt_c5_eval_qsys_10/synth/en_udp_ip_eth_rgmii_alt_c5_eval_qsys_cs/en_cs_pipeline_stage.vhd\"]"
	"set_global_assignment -library \"en_udp_ip_eth_rgmii_alt_c5_eval_qsys_cs\" -name VHDL_FILE [file join $::quartus(qip_path) \"en_udp_ip_eth_rgmii_alt_c5_eval_qsys_10/synth/en_udp_ip_eth_rgmii_alt_c5_eval_qsys_cs/en_cs_async.vhd\"]"
	"set_global_assignment -library \"en_udp_ip_eth_rgmii_alt_c5_eval_qsys_cl\" -name VHDL_FILE [file join $::quartus(qip_path) \"en_udp_ip_eth_rgmii_alt_c5_eval_qsys_10/synth/en_udp_ip_eth_rgmii_alt_c5_eval_qsys_cl/en_cl_base_pkg.vhd\"]"
	"set_global_assignment -library \"en_udp_ip_eth_rgmii_alt_c5_eval_qsys_cl\" -name VHDL_FILE [file join $::quartus(qip_path) \"en_udp_ip_eth_rgmii_alt_c5_eval_qsys_10/synth/en_udp_ip_eth_rgmii_alt_c5_eval_qsys_cl/en_cl_arbiter.vhd\"]"
	"set_global_assignment -library \"en_udp_ip_eth_rgmii_alt_c5_eval_qsys_cl\" -name VHDL_FILE [file join $::quartus(qip_path) \"en_udp_ip_eth_rgmii_alt_c5_eval_qsys_10/synth/en_udp_ip_eth_rgmii_alt_c5_eval_qsys_cl/en_cl_crc.vhd\"]"
	"set_global_assignment -library \"en_udp_ip_eth_rgmii_alt_c5_eval_qsys_cl\" -name VHDL_FILE [file join $::quartus(qip_path) \"en_udp_ip_eth_rgmii_alt_c5_eval_qsys_10/synth/en_udp_ip_eth_rgmii_alt_c5_eval_qsys_cl/en_cl_loadable_crc.vhd\"]"
	"set_global_assignment -library \"en_udp_ip_eth_rgmii_alt_c5_eval_qsys_cl\" -name VHDL_FILE [file join $::quartus(qip_path) \"en_udp_ip_eth_rgmii_alt_c5_eval_qsys_10/synth/en_udp_ip_eth_rgmii_alt_c5_eval_qsys_cl/en_cl_checksum_udp.vhd\"]"
	"set_global_assignment -library \"en_udp_ip_eth_rgmii_alt_c5_eval_qsys_cl\" -name VHDL_FILE [file join $::quartus(qip_path) \"en_udp_ip_eth_rgmii_alt_c5_eval_qsys_10/synth/en_udp_ip_eth_rgmii_alt_c5_eval_qsys_cl/en_cl_dpram.vhd\"]"
	"set_global_assignment -library \"en_udp_ip_eth_rgmii_alt_c5_eval_qsys_cl\" -name VHDL_FILE [file join $::quartus(qip_path) \"en_udp_ip_eth_rgmii_alt_c5_eval_qsys_10/synth/en_udp_ip_eth_rgmii_alt_c5_eval_qsys_cl/en_cl_reset_sync.vhd\"]"
	"set_global_assignment -library \"en_udp_ip_eth_rgmii_alt_c5_eval_qsys_cl\" -name VHDL_FILE [file join $::quartus(qip_path) \"en_udp_ip_eth_rgmii_alt_c5_eval_qsys_10/synth/en_udp_ip_eth_rgmii_alt_c5_eval_qsys_cl/en_cl_conv_from_gray.vhd\"]"
	"set_global_assignment -library \"en_udp_ip_eth_rgmii_alt_c5_eval_qsys_cl\" -name VHDL_FILE [file join $::quartus(qip_path) \"en_udp_ip_eth_rgmii_alt_c5_eval_qsys_10/synth/en_udp_ip_eth_rgmii_alt_c5_eval_qsys_cl/en_cl_gray_incrementer.vhd\"]"
	"set_global_assignment -library \"en_udp_ip_eth_rgmii_alt_c5_eval_qsys_cl\" -name VHDL_FILE [file join $::quartus(qip_path) \"en_udp_ip_eth_rgmii_alt_c5_eval_qsys_10/synth/en_udp_ip_eth_rgmii_alt_c5_eval_qsys_cl/en_cl_fifo_async_level.vhd\"]"
	"set_global_assignment -library \"en_udp_ip_eth_rgmii_alt_c5_eval_qsys_cl\" -name VHDL_FILE [file join $::quartus(qip_path) \"en_udp_ip_eth_rgmii_alt_c5_eval_qsys_10/synth/en_udp_ip_eth_rgmii_alt_c5_eval_qsys_cl/en_cl_rb_clock_crossing.vhd\"]"
	"set_global_assignment -library \"en_udp_ip_eth_rgmii_alt_c5_eval_qsys_cl\" -name VHDL_FILE [file join $::quartus(qip_path) \"en_udp_ip_eth_rgmii_alt_c5_eval_qsys_10/synth/en_udp_ip_eth_rgmii_alt_c5_eval_qsys_cl/en_cl_axi_rb_interface.vhd\"]"
	"set_global_assignment -library \"en_udp_ip_eth_rgmii_alt_c5_eval_qsys_cl\" -name VHDL_FILE [file join $::quartus(qip_path) \"en_udp_ip_eth_rgmii_alt_c5_eval_qsys_10/synth/en_udp_ip_eth_rgmii_alt_c5_eval_qsys_cl/en_cl_register_bank.vhd\"]"
	"set_global_assignment -library \"en_udp_ip_eth_rgmii_alt_c5_eval_qsys_cl\" -name VHDL_FILE [file join $::quartus(qip_path) \"en_udp_ip_eth_rgmii_alt_c5_eval_qsys_10/synth/en_udp_ip_eth_rgmii_alt_c5_eval_qsys_cl/en_cl_fifo_sync.vhd\"]"
	"set_global_assignment -library \"en_udp_ip_eth_rgmii_alt_c5_eval_qsys_cl\" -name VHDL_FILE [file join $::quartus(qip_path) \"en_udp_ip_eth_rgmii_alt_c5_eval_qsys_10/synth/en_udp_ip_eth_rgmii_alt_c5_eval_qsys_cl/en_cl_gmii_framer.vhd\"]"
	"set_global_assignment -library \"en_udp_ip_eth_rgmii_alt_c5_eval_qsys_cl\" -name VHDL_FILE [file join $::quartus(qip_path) \"en_udp_ip_eth_rgmii_alt_c5_eval_qsys_10/synth/en_udp_ip_eth_rgmii_alt_c5_eval_qsys_cl/en_cl_fifo_async.vhd\"]"
	"set_global_assignment -library \"en_udp_ip_eth_rgmii_alt_c5_eval_qsys_cl\" -name VHDL_FILE [file join $::quartus(qip_path) \"en_udp_ip_eth_rgmii_alt_c5_eval_qsys_10/synth/en_udp_ip_eth_rgmii_alt_c5_eval_qsys_cl/en_cl_rgmii_gmii_trispeed.vhd\"]"
	"set_global_assignment -library \"en_udp_ip_eth_rgmii_alt_c5_eval_qsys_cl\" -name VHDL_FILE [file join $::quartus(qip_path) \"en_udp_ip_eth_rgmii_alt_c5_eval_qsys_10/synth/en_udp_ip_eth_rgmii_alt_c5_eval_qsys_cl/en_cl_rgmii_trispeed_phy_mdl_ddr.vhd\"]"
	"set_global_assignment -library \"en_udp_ip_eth_rgmii_alt_c5_eval_qsys_cl\" -name VHDL_FILE [file join $::quartus(qip_path) \"en_udp_ip_eth_rgmii_alt_c5_eval_qsys_10/synth/en_udp_ip_eth_rgmii_alt_c5_eval_qsys_cl/en_cl_rgmii_trispeed_phy_mdl.vhd\"]"
	"set_global_assignment -library \"en_udp_ip_eth_rgmii_alt_c5_eval_qsys_cl\" -name VHDL_FILE [file join $::quartus(qip_path) \"en_udp_ip_eth_rgmii_alt_c5_eval_qsys_10/synth/en_udp_ip_eth_rgmii_alt_c5_eval_qsys_cl/en_cl_rom_fifo.vhd\"]"
	"set_global_assignment -library \"en_udp_ip_eth_rgmii_alt_c5_eval_qsys_cl\" -name VHDL_FILE [file join $::quartus(qip_path) \"en_udp_ip_eth_rgmii_alt_c5_eval_qsys_10/synth/en_udp_ip_eth_rgmii_alt_c5_eval_qsys_cl/en_cl_mdio.vhd\"]"
	"set_global_assignment -library \"en_udp_ip_eth_rgmii_alt_c5_eval_qsys_cl\" -name VHDL_FILE [file join $::quartus(qip_path) \"en_udp_ip_eth_rgmii_alt_c5_eval_qsys_10/synth/en_udp_ip_eth_rgmii_alt_c5_eval_qsys_cl/en_cl_mdio_config.vhd\"]"
	"set_global_assignment -library \"en_udp_ip_eth_rgmii_alt_c5_eval_qsys_cn\" -name VHDL_FILE [file join $::quartus(qip_path) \"en_udp_ip_eth_rgmii_alt_c5_eval_qsys_10/synth/en_udp_ip_eth_rgmii_alt_c5_eval_qsys_cn/en_cn_pipeline_stage.vhd\"]"
	"set_global_assignment -library \"en_udp_ip_eth_rgmii_alt_c5_eval_qsys_cn\" -name VHDL_FILE [file join $::quartus(qip_path) \"en_udp_ip_eth_rgmii_alt_c5_eval_qsys_10/synth/en_udp_ip_eth_rgmii_alt_c5_eval_qsys_cn/en_cn_buffer.vhd\"]"
	"set_global_assignment -library \"en_udp_ip_eth_rgmii_alt_c5_eval_qsys_cn\" -name VHDL_FILE [file join $::quartus(qip_path) \"en_udp_ip_eth_rgmii_alt_c5_eval_qsys_10/synth/en_udp_ip_eth_rgmii_alt_c5_eval_qsys_cn/en_cn_arp_core.vhd\"]"
	"set_global_assignment -library \"en_udp_ip_eth_rgmii_alt_c5_eval_qsys_cn\" -name VHDL_FILE [file join $::quartus(qip_path) \"en_udp_ip_eth_rgmii_alt_c5_eval_qsys_10/synth/en_udp_ip_eth_rgmii_alt_c5_eval_qsys_cn/en_cn_eth_core.vhd\"]"
	"set_global_assignment -library \"en_udp_ip_eth_rgmii_alt_c5_eval_qsys_cn\" -name VHDL_FILE [file join $::quartus(qip_path) \"en_udp_ip_eth_rgmii_alt_c5_eval_qsys_10/synth/en_udp_ip_eth_rgmii_alt_c5_eval_qsys_cn/en_cn_ip_core.vhd\"]"
	"set_global_assignment -library \"en_udp_ip_eth_rgmii_alt_c5_eval_qsys_cn\" -name VHDL_FILE [file join $::quartus(qip_path) \"en_udp_ip_eth_rgmii_alt_c5_eval_qsys_10/synth/en_udp_ip_eth_rgmii_alt_c5_eval_qsys_cn/en_cn_udp_core.vhd\"]"
	"set_global_assignment -library \"en_udp_ip_eth_rgmii_alt_c5_eval_qsys_cn\" -name VHDL_FILE [file join $::quartus(qip_path) \"en_udp_ip_eth_rgmii_alt_c5_eval_qsys_10/synth/en_udp_ip_eth_rgmii_alt_c5_eval_qsys_cn/en_cn_udp_txheader.vhd\"]"
	"set_global_assignment -library \"en_udp_ip_eth_rgmii_alt_c5_eval_qsys_cn\" -name VHDL_FILE [file join $::quartus(qip_path) \"en_udp_ip_eth_rgmii_alt_c5_eval_qsys_10/synth/en_udp_ip_eth_rgmii_alt_c5_eval_qsys_cn/en_cn_udp_eth_core.vhd\"]"
	"}"
}


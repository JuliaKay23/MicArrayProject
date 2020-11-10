
# maping precompiled libraries
vmap en_udp_ip_eth_rgmii_alt_c5_eval_cl ../../../ip/hdl/sim/en_udp_ip_eth_rgmii_alt_c5_eval_cl
vmap en_udp_ip_eth_rgmii_alt_c5_eval_cn ../../../ip/hdl/sim/en_udp_ip_eth_rgmii_alt_c5_eval_cn
vmap en_udp_ip_eth_rgmii_alt_c5_eval_cs ../../../ip/hdl/sim/en_udp_ip_eth_rgmii_alt_c5_eval_cs
vmap lib_en_udp_ip_eth_rgmii_alt_c5_eval ../../../ip/hdl/sim/lib_en_udp_ip_eth_rgmii_alt_c5_eval

# compiling source files
vcom -2008 -quiet -suppress 1236 -suppress 1073 -work lib_en_udp_ip_eth_rgmii_alt_c5_eval "../../../ip/hdl/vhdl/en_udp_ip_eth_rgmii_alt_c5.vhd"

# compining reference design and testbech
vcom -2008 -quiet -suppress 1236 -suppress 1073 -work work "../vhdl/en_udp_ip_eth_rgmii_alt_c5_rd.vhd"
vcom -2008 -quiet -suppress 1236 -suppress 1073 -work work "../vhdl/txt_util.vhd"
vcom -2008 -quiet -suppress 1236 -suppress 1073 -work work "../vhdl/en_udp_ip_eth_rgmii_alt_c5_rd_tb.vhd"

# start the simulation
vsim work.en_udp_ip_eth_rgmii_alt_c5_rd_tb
do wave.do
run -all
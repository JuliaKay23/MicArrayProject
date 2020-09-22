##############################
# Modelsim Version Info
##############################

# Model Technology ModelSim PE vsim 2019.3 Simulator 2019.07 Jul 24 2019
##############################
# Setup
##############################

# get path of the script
variable scriptPath [file dirname [file normalize [info script]]]

##############################
# Refresh Encrypted Libraries
##############################

vlog -work ./lib_en_udp_ip_eth_rgmii_alt_c5_eval -refresh -force_refresh
vcom -work ./lib_en_udp_ip_eth_rgmii_alt_c5_eval -refresh -force_refresh
vlog -work ./en_udp_ip_eth_rgmii_alt_c5_eval_cs -refresh -force_refresh
vcom -work ./en_udp_ip_eth_rgmii_alt_c5_eval_cs -refresh -force_refresh
vlog -work ./en_udp_ip_eth_rgmii_alt_c5_eval_cl -refresh -force_refresh
vcom -work ./en_udp_ip_eth_rgmii_alt_c5_eval_cl -refresh -force_refresh
vlog -work ./en_udp_ip_eth_rgmii_alt_c5_eval_cn -refresh -force_refresh
vcom -work ./en_udp_ip_eth_rgmii_alt_c5_eval_cn -refresh -force_refresh

##############################
# Create Libraries
##############################

if {![file exists {lib_en_udp_ip_eth_rgmii_alt_c5_eval}]} {
	echo create library: lib_en_udp_ip_eth_rgmii_alt_c5_eval
	vlib {lib_en_udp_ip_eth_rgmii_alt_c5_eval}
	vmap {lib_en_udp_ip_eth_rgmii_alt_c5_eval} {./lib_en_udp_ip_eth_rgmii_alt_c5_eval}
}

##############################
# Compile Files
##############################

vcom -2008 -quiet -suppress 1236 -suppress 1073 -work ./lib_en_udp_ip_eth_rgmii_alt_c5_eval "$scriptPath/../vhdl/en_udp_ip_eth_rgmii_alt_c5.vhd"

##############################
# Teardown
##############################

echo done!

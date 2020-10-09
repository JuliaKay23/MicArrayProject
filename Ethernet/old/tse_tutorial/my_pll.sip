set_global_assignment -entity "my_pll" -library "lib_my_pll" -name IP_TOOL_NAME "altera_pll"
set_global_assignment -entity "my_pll" -library "lib_my_pll" -name IP_TOOL_VERSION "19.1"
set_global_assignment -entity "my_pll" -library "lib_my_pll" -name IP_TOOL_ENV "mwpim"
set_global_assignment -library "lib_my_pll" -name SPD_FILE [file join $::quartus(sip_path) "my_pll.spd"]

set_global_assignment -library "lib_my_pll" -name MISC_FILE [file join $::quartus(sip_path) "my_pll_sim/my_pll.vo"]

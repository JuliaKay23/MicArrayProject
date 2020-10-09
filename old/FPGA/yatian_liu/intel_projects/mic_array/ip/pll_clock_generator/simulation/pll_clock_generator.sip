set_global_assignment -entity "pll_clock_generator" -library "lib_pll_clock_generator" -name IP_TOOL_NAME "Qsys"
set_global_assignment -entity "pll_clock_generator" -library "lib_pll_clock_generator" -name IP_TOOL_VERSION "19.1"
set_global_assignment -entity "pll_clock_generator" -library "lib_pll_clock_generator" -name IP_TOOL_ENV "Qsys"
set_global_assignment -library "lib_pll_clock_generator" -name SPD_FILE [file join $::quartus(sip_path) "../pll_clock_generator.spd"]
set_global_assignment -library "lib_pll_clock_generator" -name MISC_FILE [file join $::quartus(sip_path) "../../pll_clock_generator.qsys"]

set_global_assignment -library "lib_pll_clock_generator" -name MISC_FILE [file join $::quartus(sip_path) "pll_clock_generator.v"]
set_global_assignment -library "lib_pll_clock_generator" -name MISC_FILE [file join $::quartus(sip_path) "submodules/pll_clock_generator_pll_0.vo"]

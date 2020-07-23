

ncvlog      "D:/Documents/shared_documents/intelFPGA/mic_full_filter/oscillator/simulation/submodules/altera_int_osc.v"                   -work int_osc_0 -cdslib <<int_osc_0>>
ncvlog      "D:/Documents/shared_documents/intelFPGA/mic_full_filter/oscillator/simulation/oscillator.v"                                                                       
ncvhdl -v93 "D:/Documents/shared_documents/intelFPGA/mic_full_filter/cic_dec_filter/simulation/submodules/auk_dspip_math_pkg.vhd"         -work cic_ii_0  -cdslib <<cic_ii_0>> 
ncvhdl -v93 "D:/Documents/shared_documents/intelFPGA/mic_full_filter/cic_dec_filter/simulation/submodules/auk_dspip_text_pkg.vhd"         -work cic_ii_0  -cdslib <<cic_ii_0>> 
ncvhdl -v93 "D:/Documents/shared_documents/intelFPGA/mic_full_filter/cic_dec_filter/simulation/submodules/auk_dspip_lib_pkg.vhd"          -work cic_ii_0  -cdslib <<cic_ii_0>> 
ncvhdl -v93 "D:/Documents/shared_documents/intelFPGA/mic_full_filter/cic_dec_filter/simulation/submodules/auk_dspip_delay.vhd"            -work cic_ii_0  -cdslib <<cic_ii_0>> 
ncvhdl -v93 "D:/Documents/shared_documents/intelFPGA/mic_full_filter/cic_dec_filter/simulation/submodules/auk_dspip_fastaddsub.vhd"       -work cic_ii_0  -cdslib <<cic_ii_0>> 
ncvhdl -v93 "D:/Documents/shared_documents/intelFPGA/mic_full_filter/cic_dec_filter/simulation/submodules/auk_dspip_fastadd.vhd"          -work cic_ii_0  -cdslib <<cic_ii_0>> 
ncvhdl -v93 "D:/Documents/shared_documents/intelFPGA/mic_full_filter/cic_dec_filter/simulation/submodules/auk_dspip_pipelined_adder.vhd"  -work cic_ii_0  -cdslib <<cic_ii_0>> 
ncvhdl -v93 "D:/Documents/shared_documents/intelFPGA/mic_full_filter/cic_dec_filter/simulation/submodules/auk_dspip_roundsat.vhd"         -work cic_ii_0  -cdslib <<cic_ii_0>> 
ncvlog -sv  "D:/Documents/shared_documents/intelFPGA/mic_full_filter/cic_dec_filter/simulation/submodules/cic_dec_filter_cic_ii_0.sv"     -work cic_ii_0  -cdslib <<cic_ii_0>> 
ncvlog      "D:/Documents/shared_documents/intelFPGA/mic_full_filter/cic_dec_filter/simulation/cic_dec_filter.v"                                                               
ncvhdl -v93 "D:/Documents/shared_documents/intelFPGA/mic_full_filter/fir_comp_filter_sim/dspba_library_package.vhd"                                                            
ncvhdl -v93 "D:/Documents/shared_documents/intelFPGA/mic_full_filter/fir_comp_filter_sim/dspba_library.vhd"                                                                    
ncvhdl -v93 "D:/Documents/shared_documents/intelFPGA/mic_full_filter/fir_comp_filter_sim/auk_dspip_math_pkg_hpfir.vhd"                                                         
ncvhdl -v93 "D:/Documents/shared_documents/intelFPGA/mic_full_filter/fir_comp_filter_sim/auk_dspip_lib_pkg_hpfir.vhd"                                                          
ncvhdl -v93 "D:/Documents/shared_documents/intelFPGA/mic_full_filter/fir_comp_filter_sim/auk_dspip_avalon_streaming_controller_hpfir.vhd"                                      
ncvhdl -v93 "D:/Documents/shared_documents/intelFPGA/mic_full_filter/fir_comp_filter_sim/auk_dspip_avalon_streaming_sink_hpfir.vhd"                                            
ncvhdl -v93 "D:/Documents/shared_documents/intelFPGA/mic_full_filter/fir_comp_filter_sim/auk_dspip_avalon_streaming_source_hpfir.vhd"                                          
ncvhdl -v93 "D:/Documents/shared_documents/intelFPGA/mic_full_filter/fir_comp_filter_sim/auk_dspip_roundsat_hpfir.vhd"                                                         
ncvlog      "D:/Documents/shared_documents/intelFPGA/mic_full_filter/fir_comp_filter_sim/altera_avalon_sc_fifo.v"                                                              
ncvhdl -v93 "D:/Documents/shared_documents/intelFPGA/mic_full_filter/fir_comp_filter_sim/fir_comp_filter_rtl_core.vhd"                                                         
ncvhdl -v93 "D:/Documents/shared_documents/intelFPGA/mic_full_filter/fir_comp_filter_sim/fir_comp_filter_ast.vhd"                                                              
ncvhdl -v93 "D:/Documents/shared_documents/intelFPGA/mic_full_filter/fir_comp_filter_sim/fir_comp_filter.vhd"                                                                  
ncvhdl -v93 "D:/Documents/shared_documents/intelFPGA/mic_full_filter/fir_comp_filter_sim/fir_comp_filter_tb.vhd"                                                               

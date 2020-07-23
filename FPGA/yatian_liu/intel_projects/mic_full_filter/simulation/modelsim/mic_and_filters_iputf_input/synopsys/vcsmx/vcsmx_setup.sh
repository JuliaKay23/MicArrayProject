

vlogan +v2k           "D:/Documents/shared_documents/intelFPGA/mic_full_filter/oscillator/simulation/submodules/altera_int_osc.v"                   -work int_osc_0
vlogan +v2k           "D:/Documents/shared_documents/intelFPGA/mic_full_filter/oscillator/simulation/oscillator.v"                                                 
vhdlan -xlrm          "D:/Documents/shared_documents/intelFPGA/mic_full_filter/cic_dec_filter/simulation/submodules/auk_dspip_math_pkg.vhd"         -work cic_ii_0 
vhdlan -xlrm          "D:/Documents/shared_documents/intelFPGA/mic_full_filter/cic_dec_filter/simulation/submodules/auk_dspip_text_pkg.vhd"         -work cic_ii_0 
vhdlan -xlrm          "D:/Documents/shared_documents/intelFPGA/mic_full_filter/cic_dec_filter/simulation/submodules/auk_dspip_lib_pkg.vhd"          -work cic_ii_0 
vhdlan -xlrm          "D:/Documents/shared_documents/intelFPGA/mic_full_filter/cic_dec_filter/simulation/submodules/auk_dspip_delay.vhd"            -work cic_ii_0 
vhdlan -xlrm          "D:/Documents/shared_documents/intelFPGA/mic_full_filter/cic_dec_filter/simulation/submodules/auk_dspip_fastaddsub.vhd"       -work cic_ii_0 
vhdlan -xlrm          "D:/Documents/shared_documents/intelFPGA/mic_full_filter/cic_dec_filter/simulation/submodules/auk_dspip_fastadd.vhd"          -work cic_ii_0 
vhdlan -xlrm          "D:/Documents/shared_documents/intelFPGA/mic_full_filter/cic_dec_filter/simulation/submodules/auk_dspip_pipelined_adder.vhd"  -work cic_ii_0 
vhdlan -xlrm          "D:/Documents/shared_documents/intelFPGA/mic_full_filter/cic_dec_filter/simulation/submodules/auk_dspip_roundsat.vhd"         -work cic_ii_0 
vlogan +v2k -sverilog "D:/Documents/shared_documents/intelFPGA/mic_full_filter/cic_dec_filter/simulation/submodules/cic_dec_filter_cic_ii_0.sv"     -work cic_ii_0 
vlogan +v2k           "D:/Documents/shared_documents/intelFPGA/mic_full_filter/cic_dec_filter/simulation/cic_dec_filter.v"                                         
vhdlan -xlrm          "D:/Documents/shared_documents/intelFPGA/mic_full_filter/fir_comp_filter_sim/dspba_library_package.vhd"                                      
vhdlan -xlrm          "D:/Documents/shared_documents/intelFPGA/mic_full_filter/fir_comp_filter_sim/dspba_library.vhd"                                              
vhdlan -xlrm          "D:/Documents/shared_documents/intelFPGA/mic_full_filter/fir_comp_filter_sim/auk_dspip_math_pkg_hpfir.vhd"                                   
vhdlan -xlrm          "D:/Documents/shared_documents/intelFPGA/mic_full_filter/fir_comp_filter_sim/auk_dspip_lib_pkg_hpfir.vhd"                                    
vhdlan -xlrm          "D:/Documents/shared_documents/intelFPGA/mic_full_filter/fir_comp_filter_sim/auk_dspip_avalon_streaming_controller_hpfir.vhd"                
vhdlan -xlrm          "D:/Documents/shared_documents/intelFPGA/mic_full_filter/fir_comp_filter_sim/auk_dspip_avalon_streaming_sink_hpfir.vhd"                      
vhdlan -xlrm          "D:/Documents/shared_documents/intelFPGA/mic_full_filter/fir_comp_filter_sim/auk_dspip_avalon_streaming_source_hpfir.vhd"                    
vhdlan -xlrm          "D:/Documents/shared_documents/intelFPGA/mic_full_filter/fir_comp_filter_sim/auk_dspip_roundsat_hpfir.vhd"                                   
vlogan +v2k           "D:/Documents/shared_documents/intelFPGA/mic_full_filter/fir_comp_filter_sim/altera_avalon_sc_fifo.v"                                        
vhdlan -xlrm          "D:/Documents/shared_documents/intelFPGA/mic_full_filter/fir_comp_filter_sim/fir_comp_filter_rtl_core.vhd"                                   
vhdlan -xlrm          "D:/Documents/shared_documents/intelFPGA/mic_full_filter/fir_comp_filter_sim/fir_comp_filter_ast.vhd"                                        
vhdlan -xlrm          "D:/Documents/shared_documents/intelFPGA/mic_full_filter/fir_comp_filter_sim/fir_comp_filter.vhd"                                            
vhdlan -xlrm          "D:/Documents/shared_documents/intelFPGA/mic_full_filter/fir_comp_filter_sim/fir_comp_filter_tb.vhd"                                         

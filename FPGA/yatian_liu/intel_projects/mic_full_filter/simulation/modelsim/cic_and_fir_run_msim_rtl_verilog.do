transcript on
if ![file isdirectory cic_and_fir_iputf_libs] {
	file mkdir cic_and_fir_iputf_libs
}

if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

###### Libraries for IPUTF cores 
vlib cic_and_fir_iputf_libs/int_osc_0
vmap int_osc_0 ./cic_and_fir_iputf_libs/int_osc_0
vlib cic_and_fir_iputf_libs/cic_ii_0
vmap cic_ii_0 ./cic_and_fir_iputf_libs/cic_ii_0
###### End libraries for IPUTF cores 
###### MIF file copy and HDL compilation commands for IPUTF cores 


vlog     "D:/Documents/shared_documents/intelFPGA/mic_full_filter/oscillator/simulation/submodules/altera_int_osc.v"                                     -work int_osc_0
vlog     "D:/Documents/shared_documents/intelFPGA/mic_full_filter/oscillator/simulation/oscillator.v"                                                                   
vcom     "D:/Documents/shared_documents/intelFPGA/mic_full_filter/cic_dec_filter/simulation/submodules/auk_dspip_math_pkg.vhd"                           -work cic_ii_0 
vcom     "D:/Documents/shared_documents/intelFPGA/mic_full_filter/cic_dec_filter/simulation/submodules/auk_dspip_text_pkg.vhd"                           -work cic_ii_0 
vcom     "D:/Documents/shared_documents/intelFPGA/mic_full_filter/cic_dec_filter/simulation/submodules/auk_dspip_lib_pkg.vhd"                            -work cic_ii_0 
vcom     "D:/Documents/shared_documents/intelFPGA/mic_full_filter/cic_dec_filter/simulation/submodules/mentor/auk_dspip_avalon_streaming_small_fifo.vhd" -work cic_ii_0 
vcom     "D:/Documents/shared_documents/intelFPGA/mic_full_filter/cic_dec_filter/simulation/submodules/mentor/auk_dspip_avalon_streaming_controller.vhd" -work cic_ii_0 
vcom     "D:/Documents/shared_documents/intelFPGA/mic_full_filter/cic_dec_filter/simulation/submodules/mentor/auk_dspip_avalon_streaming_sink.vhd"       -work cic_ii_0 
vcom     "D:/Documents/shared_documents/intelFPGA/mic_full_filter/cic_dec_filter/simulation/submodules/mentor/auk_dspip_avalon_streaming_source.vhd"     -work cic_ii_0 
vcom     "D:/Documents/shared_documents/intelFPGA/mic_full_filter/cic_dec_filter/simulation/submodules/auk_dspip_delay.vhd"                              -work cic_ii_0 
vcom     "D:/Documents/shared_documents/intelFPGA/mic_full_filter/cic_dec_filter/simulation/submodules/auk_dspip_fastaddsub.vhd"                         -work cic_ii_0 
vcom     "D:/Documents/shared_documents/intelFPGA/mic_full_filter/cic_dec_filter/simulation/submodules/auk_dspip_fastadd.vhd"                            -work cic_ii_0 
vcom     "D:/Documents/shared_documents/intelFPGA/mic_full_filter/cic_dec_filter/simulation/submodules/auk_dspip_pipelined_adder.vhd"                    -work cic_ii_0 
vcom     "D:/Documents/shared_documents/intelFPGA/mic_full_filter/cic_dec_filter/simulation/submodules/auk_dspip_roundsat.vhd"                           -work cic_ii_0 
vlog -sv "D:/Documents/shared_documents/intelFPGA/mic_full_filter/cic_dec_filter/simulation/submodules/mentor/alt_dsp_cic_common_pkg.sv"                 -work cic_ii_0 
vcom     "D:/Documents/shared_documents/intelFPGA/mic_full_filter/cic_dec_filter/simulation/submodules/mentor/auk_dspip_cic_lib_pkg.vhd"                 -work cic_ii_0 
vcom     "D:/Documents/shared_documents/intelFPGA/mic_full_filter/cic_dec_filter/simulation/submodules/mentor/auk_dspip_differentiator.vhd"              -work cic_ii_0 
vlog -sv "D:/Documents/shared_documents/intelFPGA/mic_full_filter/cic_dec_filter/simulation/submodules/mentor/auk_dspip_downsample.sv"                   -work cic_ii_0 
vcom     "D:/Documents/shared_documents/intelFPGA/mic_full_filter/cic_dec_filter/simulation/submodules/mentor/auk_dspip_integrator.vhd"                  -work cic_ii_0 
vcom     "D:/Documents/shared_documents/intelFPGA/mic_full_filter/cic_dec_filter/simulation/submodules/mentor/auk_dspip_upsample.vhd"                    -work cic_ii_0 
vcom     "D:/Documents/shared_documents/intelFPGA/mic_full_filter/cic_dec_filter/simulation/submodules/mentor/auk_dspip_channel_buffer.vhd"              -work cic_ii_0 
vlog -sv "D:/Documents/shared_documents/intelFPGA/mic_full_filter/cic_dec_filter/simulation/submodules/mentor/auk_dspip_variable_downsample.sv"          -work cic_ii_0 
vlog     "D:/Documents/shared_documents/intelFPGA/mic_full_filter/cic_dec_filter/simulation/submodules/mentor/hyper_pipeline_interface.v"                -work cic_ii_0 
vlog -sv "D:/Documents/shared_documents/intelFPGA/mic_full_filter/cic_dec_filter/simulation/submodules/mentor/counter_module.sv"                         -work cic_ii_0 
vlog -sv "D:/Documents/shared_documents/intelFPGA/mic_full_filter/cic_dec_filter/simulation/submodules/mentor/alt_cic_int_siso.sv"                       -work cic_ii_0 
vlog -sv "D:/Documents/shared_documents/intelFPGA/mic_full_filter/cic_dec_filter/simulation/submodules/mentor/alt_cic_dec_siso.sv"                       -work cic_ii_0 
vlog -sv "D:/Documents/shared_documents/intelFPGA/mic_full_filter/cic_dec_filter/simulation/submodules/mentor/alt_cic_int_simo.sv"                       -work cic_ii_0 
vlog -sv "D:/Documents/shared_documents/intelFPGA/mic_full_filter/cic_dec_filter/simulation/submodules/mentor/alt_cic_dec_miso.sv"                       -work cic_ii_0 
vlog -sv "D:/Documents/shared_documents/intelFPGA/mic_full_filter/cic_dec_filter/simulation/submodules/mentor/alt_cic_core.sv"                           -work cic_ii_0 
vlog -sv "D:/Documents/shared_documents/intelFPGA/mic_full_filter/cic_dec_filter/simulation/submodules/cic_dec_filter_cic_ii_0.sv"                       -work cic_ii_0 
vlog     "D:/Documents/shared_documents/intelFPGA/mic_full_filter/cic_dec_filter/simulation/cic_dec_filter.v"                                                           
vcom     "D:/Documents/shared_documents/intelFPGA/mic_full_filter/fir_comp_filter_sim/dspba_library_package.vhd"                                                        
vcom     "D:/Documents/shared_documents/intelFPGA/mic_full_filter/fir_comp_filter_sim/dspba_library.vhd"                                                                
vcom     "D:/Documents/shared_documents/intelFPGA/mic_full_filter/fir_comp_filter_sim/auk_dspip_math_pkg_hpfir.vhd"                                                     
vcom     "D:/Documents/shared_documents/intelFPGA/mic_full_filter/fir_comp_filter_sim/auk_dspip_lib_pkg_hpfir.vhd"                                                      
vcom     "D:/Documents/shared_documents/intelFPGA/mic_full_filter/fir_comp_filter_sim/auk_dspip_avalon_streaming_controller_hpfir.vhd"                                  
vcom     "D:/Documents/shared_documents/intelFPGA/mic_full_filter/fir_comp_filter_sim/auk_dspip_avalon_streaming_sink_hpfir.vhd"                                        
vcom     "D:/Documents/shared_documents/intelFPGA/mic_full_filter/fir_comp_filter_sim/auk_dspip_avalon_streaming_source_hpfir.vhd"                                      
vcom     "D:/Documents/shared_documents/intelFPGA/mic_full_filter/fir_comp_filter_sim/auk_dspip_roundsat_hpfir.vhd"                                                     
vlog     "D:/Documents/shared_documents/intelFPGA/mic_full_filter/fir_comp_filter_sim/altera_avalon_sc_fifo.v"                                                          
vcom     "D:/Documents/shared_documents/intelFPGA/mic_full_filter/fir_comp_filter_sim/fir_comp_filter_rtl_core.vhd"                                                     
vcom     "D:/Documents/shared_documents/intelFPGA/mic_full_filter/fir_comp_filter_sim/fir_comp_filter_ast.vhd"                                                          
vcom     "D:/Documents/shared_documents/intelFPGA/mic_full_filter/fir_comp_filter_sim/fir_comp_filter.vhd"                                                              
vcom     "D:/Documents/shared_documents/intelFPGA/mic_full_filter/fir_comp_filter_sim/fir_comp_filter_tb.vhd"                                                           

vlog -vlog01compat -work work +incdir+D:/Documents/shared_documents/intelFPGA/mic_full_filter {D:/Documents/shared_documents/intelFPGA/mic_full_filter/mic_full_filter_wt.v}
vlog -vlog01compat -work work +incdir+D:/Documents/shared_documents/intelFPGA/mic_full_filter {D:/Documents/shared_documents/intelFPGA/mic_full_filter/wave_gen_direct_pdm.v}
vlog -vlog01compat -work work +incdir+D:/Documents/shared_documents/intelFPGA/mic_full_filter {D:/Documents/shared_documents/intelFPGA/mic_full_filter/clk_divider_N.v}
vlog -vlog01compat -work work +incdir+D:/Documents/shared_documents/intelFPGA/mic_full_filter {D:/Documents/shared_documents/intelFPGA/mic_full_filter/wavetable.v}
vlog -vlog01compat -work work +incdir+D:/Documents/shared_documents/intelFPGA/mic_full_filter/cic_dec_filter/simulation {D:/Documents/shared_documents/intelFPGA/mic_full_filter/cic_dec_filter/simulation/cic_dec_filter.v}


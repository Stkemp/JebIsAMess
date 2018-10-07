# 
# Synthesis run script generated by Vivado
# 

set_msg_config -id {HDL 9-1061} -limit 100000
set_msg_config -id {HDL 9-1654} -limit 100000
create_project -in_memory -part xc7a35tcpg236-1

set_param project.singleFileAddWarning.threshold 0
set_param project.compositeFile.enableAutoGeneration 0
set_param synth.vivado.isSynthRun true
set_property webtalk.parent_dir C:/Users/secomd/Documents/UCSC_Schoolwork/Win18/CMPE100/Lab5/Lab5.cache/wt [current_project]
set_property parent.project_path C:/Users/secomd/Documents/UCSC_Schoolwork/Win18/CMPE100/Lab5/Lab5.xpr [current_project]
set_property default_lib xil_defaultlib [current_project]
set_property target_language Verilog [current_project]
set_property board_part digilentinc.com:basys3:part0:1.1 [current_project]
set_property ip_output_repo c:/Users/secomd/Documents/UCSC_Schoolwork/Win18/CMPE100/Lab5/Lab5.cache/ip [current_project]
set_property ip_cache_permissions {read write} [current_project]
read_verilog -library xil_defaultlib {
  C:/Users/secomd/Documents/UCSC_Schoolwork/Win18/CMPE100/Lab5/Lab5.srcs/sources_1/imports/CMPE100/Lab3/Lab3.srcs/sources_1/new/m8_1e.v
  C:/Users/secomd/Documents/UCSC_Schoolwork/Win18/CMPE100/Lab5/Lab5.srcs/sources_1/imports/new/ANDFullAdder.v
  C:/Users/secomd/Documents/UCSC_Schoolwork/Win18/CMPE100/Lab5/Lab5.srcs/sources_1/imports/CMPE100/Lab3/Lab3.srcs/sources_1/new/MultiplierStage.v
  C:/Users/secomd/Documents/UCSC_Schoolwork/Win18/CMPE100/Lab5/Lab5.srcs/sources_1/imports/CMPE100/Lab4/Lab4.srcs/sources_1/new/m2_1.v
  C:/Users/secomd/Documents/UCSC_Schoolwork/Win18/CMPE100/Lab5/Lab5.srcs/sources_1/imports/CMPE100/Lab4/Lab4.srcs/sources_1/new/m4_1x4.v
  C:/Users/secomd/Documents/UCSC_Schoolwork/Win18/CMPE100/Lab5/Lab5.srcs/sources_1/new/Time_Counter.v
  C:/Users/secomd/Documents/UCSC_Schoolwork/Win18/CMPE100/Lab5/Lab5.srcs/sources_1/new/State_Machine.v
  C:/Users/secomd/Documents/UCSC_Schoolwork/Win18/CMPE100/Lab5/Lab5.srcs/sources_1/imports/CMPE100/Lab4/Lab4.srcs/sources_1/new/Selector.v
  C:/Users/secomd/Documents/UCSC_Schoolwork/Win18/CMPE100/Lab5/Lab5.srcs/sources_1/imports/CMPE100/Lab4/Lab4.srcs/sources_1/new/Ring_Counter.v
  C:/Users/secomd/Documents/UCSC_Schoolwork/Win18/CMPE100/Lab5/Lab5.srcs/sources_1/imports/CMPE100/Lab3/Lab3.srcs/sources_1/new/Multiplier.v
  C:/Users/secomd/Documents/UCSC_Schoolwork/Win18/CMPE100/Lab5/Lab5.srcs/sources_1/new/LFSR.v
  C:/Users/secomd/Documents/UCSC_Schoolwork/Win18/CMPE100/Lab5/Lab5.srcs/sources_1/imports/Lab5/lab5_clks.v
  C:/Users/secomd/Documents/UCSC_Schoolwork/Win18/CMPE100/Lab5/Lab5.srcs/sources_1/imports/CMPE100/Lab3/Lab3.srcs/sources_1/new/hex7seg.v
  C:/Users/secomd/Documents/UCSC_Schoolwork/Win18/CMPE100/Lab5/Lab5.srcs/sources_1/imports/CMPE100/Lab4/Lab4.srcs/sources_1/new/CountUD4L.v
  C:/Users/secomd/Documents/UCSC_Schoolwork/Win18/CMPE100/Lab5/Lab5.srcs/sources_1/new/Top.v
}
foreach dcp [get_files -quiet -all *.dcp] {
  set_property used_in_implementation false $dcp
}
read_xdc C:/Users/secomd/Documents/UCSC_Schoolwork/Win18/CMPE100/Lab5/Lab5.srcs/constrs_1/imports/CMPE100/Basys3_Master.xdc
set_property used_in_implementation false [get_files C:/Users/secomd/Documents/UCSC_Schoolwork/Win18/CMPE100/Lab5/Lab5.srcs/constrs_1/imports/CMPE100/Basys3_Master.xdc]


synth_design -top Top -part xc7a35tcpg236-1


write_checkpoint -force -noxdef Top.dcp

catch { report_utilization -file Top_utilization_synth.rpt -pb Top_utilization_synth.pb }

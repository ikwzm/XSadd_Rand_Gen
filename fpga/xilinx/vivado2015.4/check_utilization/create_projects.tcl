#
# create_project.tcl  Tcl script for creating project
#
proc add_vhdl_file {fileset library_name file_name} {
    set file    [file normalize $file_name]
    set fileset [get_filesets   $fileset  ] 
    add_files -norecurse -fileset $fileset $file
    set file_obj [get_files -of_objects $fileset $file]
    set_property "file_type" "VHDL"        $file_obj
    set_property "library"   $library_name $file_obj
}
proc create_sample_project { project_name device_parts lane } {
  set project_directory       [file dirname [info script]]
  # puts "create_project -force $project_name $project_directory"
  #
  # Create project
  #
  create_project -force $project_name $project_directory
  #
  # Set project properties
  #
  set_property "part"               $device_parts    [get_projects $project_name]
  set_property "default_lib"        "xil_defaultlib" [get_projects $project_name]
  set_property "simulator_language" "Mixed"          [get_projects $project_name]
  set_property "target_language"    "VHDL"           [get_projects $project_name]
  #
  # Create fileset "sources_1"
  #
  if {[string equal [get_filesets -quiet sources_1] ""]} {
      create_fileset -srcset sources_1
  }
  #
  # Create fileset "constrs_1"
  #
  if {[string equal [get_filesets -quiet constrs_1] ""]} {
      create_fileset -constrset constrs_1
  }
  #
  # Create fileset "sim_1"
  #
  if {[string equal [get_filesets -quiet sim_1] ""]} {
      create_fileset -simset sim_1
  }
  #
  # Create run "synth_1" and set property
  #
  if {[string equal [get_runs -quiet synth_1] ""]} {
    create_run -name synth_1 -part $device_parts -flow "Vivado Synthesis 2015" -strategy "Vivado Synthesis Defaults" -constrset constrs_1
  } else {
      set_property strategy "Vivado Synthesis Defaults" [get_runs synth_1]
      set_property strategy "Flow_PerfOptimized_High"   [get_runs synth_1]
  }
  current_run -synthesis [get_runs synth_1]
  #
  # Create run "impl_1" and set property
  #
  if {[string equal [get_runs -quiet impl_1] ""]} {
    create_run -name impl_1 -part $device_parts -flow "Vivado Implementation 2015" -strategy "Vivado Implementation Defaults" -constrset constrs_1 -parent_run synth_1
  } else {
      set_property strategy "Vivado Implementation Defaults" [get_runs impl_1]
      set_property strategy "Performance_Explore"            [get_runs impl_1]
  }
  current_run -implementation [get_runs impl_1]
  #
  # Set 'sources_1' fileset object
  #
  add_vhdl_file sources_1 XSADD "../../../../src/main/vhdl/xsadd.vhd"
  add_vhdl_file sources_1 XSADD "../../../../src/main/vhdl/xsadd_rand_gen.vhd"
  add_vhdl_file sources_1 XSADD "sample.vhd"
  #
  # Set 'sources_1' fileset properties
  #
  set obj [get_filesets sources_1]
  set_property "top" "SAMPLE" $obj
  #
  # Set 'constrs_1' fileset object
  #
  set obj [get_filesets constrs_1]
  set files [list \
   "[file normalize "$project_directory/timing.xdc"]"\
  ]
  add_files -norecurse -fileset $obj $files
  #
  set_property generic L=$lane [get_filesets sources_1]
  #
  # Close project
  #
  close_project
}

create_sample_project "xsadd_rand_gen_artix7_l01" "xc7a15tcsg324-3"  1  
create_sample_project "xsadd_rand_gen_artix7_l02" "xc7a15tcsg324-3"  2  
create_sample_project "xsadd_rand_gen_artix7_l03" "xc7a15tcsg324-3"  3  
create_sample_project "xsadd_rand_gen_artix7_l04" "xc7a15tcsg324-3"  4  
create_sample_project "xsadd_rand_gen_artix7_l05" "xc7a15tcsg324-3"  5  
create_sample_project "xsadd_rand_gen_artix7_l06" "xc7a15tcsg324-3"  6  
create_sample_project "xsadd_rand_gen_artix7_l07" "xc7a15tcsg324-3"  7  
create_sample_project "xsadd_rand_gen_artix7_l08" "xc7a15tcsg324-3"  8  
create_sample_project "xsadd_rand_gen_artix7_l12" "xc7a15tcsg324-3" 12  
create_sample_project "xsadd_rand_gen_artix7_l16" "xc7a15tcsg324-3" 16 
create_sample_project "xsadd_rand_gen_artix7_l20" "xc7a15tcsg324-3" 20
create_sample_project "xsadd_rand_gen_artix7_l24" "xc7a15tcsg324-3" 24
create_sample_project "xsadd_rand_gen_artix7_l28" "xc7a15tcsg324-3" 28
create_sample_project "xsadd_rand_gen_artix7_l32" "xc7a15tcsg324-3" 32


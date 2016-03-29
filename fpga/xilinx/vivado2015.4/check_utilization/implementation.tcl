proc implementation_sample_project { project_name report_name } {
    set project_directory       [file dirname [info script]]
    open_project [file join $project_directory $project_name]
    launch_runs synth_1
    wait_on_run synth_1
    launch_runs impl_1
    wait_on_run impl_1
    open_run    impl_1
    report_utilization -file [file join $project_directory $report_name] -cells [get_cells U]
    report_timing      -file [file join $project_directory $report_name] -append
    close_project
}

implementation_sample_project "xsadd_rand_gen_artix7_l01.xpr" "xsadd_rand_gen_artix7_l01.rpt"
implementation_sample_project "xsadd_rand_gen_artix7_l02.xpr" "xsadd_rand_gen_artix7_l02.rpt"
implementation_sample_project "xsadd_rand_gen_artix7_l03.xpr" "xsadd_rand_gen_artix7_l03.rpt"
implementation_sample_project "xsadd_rand_gen_artix7_l04.xpr" "xsadd_rand_gen_artix7_l04.rpt"
implementation_sample_project "xsadd_rand_gen_artix7_l05.xpr" "xsadd_rand_gen_artix7_l05.rpt"
implementation_sample_project "xsadd_rand_gen_artix7_l06.xpr" "xsadd_rand_gen_artix7_l06.rpt"
implementation_sample_project "xsadd_rand_gen_artix7_l07.xpr" "xsadd_rand_gen_artix7_l07.rpt"
implementation_sample_project "xsadd_rand_gen_artix7_l08.xpr" "xsadd_rand_gen_artix7_l08.rpt"
implementation_sample_project "xsadd_rand_gen_artix7_l12.xpr" "xsadd_rand_gen_artix7_l12.rpt"
implementation_sample_project "xsadd_rand_gen_artix7_l16.xpr" "xsadd_rand_gen_artix7_l16.rpt"
implementation_sample_project "xsadd_rand_gen_artix7_l20.xpr" "xsadd_rand_gen_artix7_l20.rpt"
implementation_sample_project "xsadd_rand_gen_artix7_l24.xpr" "xsadd_rand_gen_artix7_l24.rpt"
implementation_sample_project "xsadd_rand_gen_artix7_l28.xpr" "xsadd_rand_gen_artix7_l28.rpt"
implementation_sample_project "xsadd_rand_gen_artix7_l32.xpr" "xsadd_rand_gen_artix7_l32.rpt"

# Vivado 2022.2: vivado -mode batch -source tcl/build.tcl -tclargs bit build/vivado
# Stages: project (BD only), synth, bit. Optional third argument: bundled.
# The Python helper creates the project from RTL; no generated project is required.
# Existing output directories are rejected.
set root [file normalize [file join [file dirname [info script]] ..]]
set stage [expr {$argc > 0 ? [lindex $argv 0] : "project"}]
set work [file normalize [expr {$argc > 1 ? [lindex $argv 1] : [file join $root build vivado]}]]
if {$stage ni {project synth bit}} { error "Stage must be project, synth, or bit" }
if {[file exists $work]} { error "Output directory already exists: $work; choose a fresh path" }
if {![string match "2022.2*" [version -short]]} { error "This recipe targets Vivado 2022.2" }
set jobs 4
if {[info exists ::env(MAXCUT_BUILD_JOBS)]} { set jobs $::env(MAXCUT_BUILD_JOBS) }
file mkdir $work
file mkdir [file join $work reports]
set part xc7z020clg400-1
set project_name maxcut26_lfsr
set bundled [expr {$argc > 2 && [lindex $argv 2] eq "bundled"}]
if {$bundled} {
    set project_name maxcut26
    file mkdir [file join $work project]
    foreach entry {maxcut26.xpr maxcut26.srcs hdl ip_repo constraints} {
        if {[file exists [file join $root $entry]]} {
            file copy [file join $root $entry] [file join $work project $entry]
        }
    }
    open_project [file join $work project maxcut26.xpr]
    update_ip_catalog
    open_bd_design [get_files design_1.bd]
    validate_bd_design
    save_bd_design
    write_bd_tcl [file join $work design_1.tcl]
    generate_target all [get_files design_1.bd]
    set hwh [file join $work project ${project_name}.gen sources_1 bd design_1 hw_handoff design_1.hwh]
    if {![file exists $hwh]} { error "Missing generated hardware handoff: $hwh" }
    puts [exec python3 [file join $root scripts validate_hwh_reset.py] --hwh $hwh --output [file join $work reports reset_validation.json]]
    update_compile_order -fileset sources_1
} else {
set ipdir [file join $work ip_repo maxcut26]
create_project package_maxcut26 [file join $work package] -part $part
set_property target_language Verilog [current_project]
add_files -norecurse [glob [file join $root ip_repo maxcut26 src *.sv]]
add_files -norecurse [glob [file join $root ip_repo maxcut26 src *.hex]]
set_property file_type {Memory Initialization Files} [get_files *.hex]
set_property top maxcut26_axi [current_fileset]
update_compile_order -fileset sources_1
ipx::package_project -root_dir $ipdir -vendor date2027.local -library user -taxonomy /UserIP -import_files -set_current true
set core [ipx::current_core]
set_property name maxcut26_axi $core
set_property display_name {maxcut288 one shared LFSR and EPIX solver} $core
set_property description {Fixed 288-variable solver, one shared serial LFSR, runtime IID/EPIX mode, ABI 6.0.} $core
set_property version 1.0 $core
set bus [ipx::get_bus_interfaces S_AXI -of_objects $core]
if {[llength $bus] != 1} { error "AXI inference failed" }
set map [ipx::get_memory_maps -of_objects $core]
if {![llength $map]} {
    set map [ipx::add_memory_map S_AXI $core]
    set_property slave_memory_map_ref S_AXI $bus
}
set blocks [ipx::get_address_blocks -of_objects $map]
if {![llength $blocks]} { set blocks [ipx::add_address_block registers $map] }
foreach block $blocks {
    set_property range 4096 $block
    set_property width 32 $block
    set_property usage register $block
}
ipx::create_xgui_files $core
ipx::update_checksums $core
ipx::check_integrity -quiet $core
ipx::save_core $core
close_project

create_project maxcut26_lfsr [file join $work project] -part $part
set_property target_language Verilog [current_project]
set_property ip_repo_paths [file join $work ip_repo] [current_project]
update_ip_catalog
create_bd_design design_1
set ps [create_bd_cell -type ip -vlnv xilinx.com:ip:processing_system7:5.5 ps7_0]
source [file join $root tcl pynq_z1_ps7.tcl]
configure_pynq_z1_ps7 $ps
make_bd_intf_pins_external [get_bd_intf_pins ps7_0/DDR]
make_bd_intf_pins_external [get_bd_intf_pins ps7_0/FIXED_IO]
set solver [create_bd_cell -type ip -vlnv date2027.local:user:maxcut26_axi:1.0 maxcut26_0]
set axi [create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_interconnect_0]
set_property CONFIG.NUM_MI 1 $axi
set reset [create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 rst_ps7_0_100M]
# FCLK_RESET0_N is active low. The unused auxiliary/debug inputs are tied low,
# so auxiliary reset must explicitly use active-high polarity.
set_property -dict [list CONFIG.C_EXT_RESET_HIGH 0 CONFIG.C_AUX_RESET_HIGH 1] $reset
set one [create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 const_one]
set zero [create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 const_zero]
set_property -dict [list CONFIG.CONST_WIDTH 1 CONFIG.CONST_VAL 1] $one
set_property -dict [list CONFIG.CONST_WIDTH 1 CONFIG.CONST_VAL 0] $zero
connect_bd_intf_net [get_bd_intf_pins ps7_0/M_AXI_GP0] [get_bd_intf_pins axi_interconnect_0/S00_AXI]
connect_bd_intf_net [get_bd_intf_pins axi_interconnect_0/M00_AXI] [get_bd_intf_pins maxcut26_0/S_AXI]
connect_bd_net [get_bd_pins ps7_0/FCLK_CLK0] [get_bd_pins ps7_0/M_AXI_GP0_ACLK] \
    [get_bd_pins axi_interconnect_0/ACLK] [get_bd_pins axi_interconnect_0/S00_ACLK] \
    [get_bd_pins axi_interconnect_0/M00_ACLK] [get_bd_pins maxcut26_0/s_axi_aclk] \
    [get_bd_pins rst_ps7_0_100M/slowest_sync_clk]
connect_bd_net [get_bd_pins ps7_0/FCLK_RESET0_N] [get_bd_pins rst_ps7_0_100M/ext_reset_in]
connect_bd_net [get_bd_pins const_one/dout] [get_bd_pins rst_ps7_0_100M/dcm_locked]
connect_bd_net [get_bd_pins const_zero/dout] [get_bd_pins rst_ps7_0_100M/aux_reset_in] [get_bd_pins rst_ps7_0_100M/mb_debug_sys_rst]
connect_bd_net [get_bd_pins rst_ps7_0_100M/interconnect_aresetn] [get_bd_pins axi_interconnect_0/ARESETN]
connect_bd_net [get_bd_pins rst_ps7_0_100M/peripheral_aresetn] [get_bd_pins axi_interconnect_0/S00_ARESETN] \
    [get_bd_pins axi_interconnect_0/M00_ARESETN] [get_bd_pins maxcut26_0/s_axi_aresetn]
set seg [get_bd_addr_segs maxcut26_0/S_AXI/*]
if {[llength $seg] != 1} { error "Expected one AXI register segment, got $seg" }
assign_bd_address -offset 0x43C00000 -range 4K -target_address_space [get_bd_addr_spaces ps7_0/Data] $seg
validate_bd_design
if {[get_property CONFIG.C_EXT_RESET_HIGH $reset] != 0} { error "PS7 fabric reset must propagate as active low" }
if {[get_property CONFIG.C_AUX_RESET_HIGH $reset] != 1} { error "Auxiliary reset tied low must be active high" }
save_bd_design
write_bd_tcl [file join $work design_1.tcl]
generate_target all [get_files design_1.bd]
set hwh [file join $work project ${project_name}.gen sources_1 bd design_1 hw_handoff design_1.hwh]
if {![file exists $hwh]} { error "Missing generated hardware handoff: $hwh" }
puts [exec python3 [file join $root scripts validate_hwh_reset.py] --hwh $hwh --output [file join $work reports reset_validation.json]]
make_wrapper -files [get_files design_1.bd] -top
set wrapper [glob [file join $work project ${project_name}.gen sources_1 bd design_1 hdl design_1_wrapper.v]]
add_files -norecurse $wrapper
set_property top design_1_wrapper [current_fileset]
update_compile_order -fileset sources_1
}
set_property strategy Flow_PerfOptimized_high [get_runs synth_1]
set_property strategy Performance_ExplorePostRoutePhysOpt [get_runs impl_1]
if {$stage eq "project"} { puts "MAXCUT_PROJECT_READY $work"; close_project; exit 0 }
launch_runs synth_1 -jobs $jobs
wait_on_run synth_1
if {[get_property PROGRESS [get_runs synth_1]] ne "100%"} { error "Synthesis did not complete" }
open_run synth_1
report_utilization -file [file join $work reports synthesis_utilization.rpt]
# Preserve evidence that this build contains exactly one shared physical source.
set sources [get_cells -hierarchical -filter {ORIG_REF_NAME == lfsr32_word || REF_NAME =~ lfsr32_word*}]
if {[llength $sources] != 1} { error "Expected 1 synthesized LFSR instances, found [llength $sources]: $sources" }
set source_receipt [open [file join $work reports source_instances.txt] w]
foreach source [lsort $sources] { puts $source_receipt $source }
close $source_receipt
report_utilization -hierarchical -hierarchical_depth 8 -file [file join $work reports synthesis_hierarchy.rpt]
report_timing_summary -file [file join $work reports synthesis_timing.rpt]
if {$stage eq "synth"} { puts "MAXCUT_SYNTH_READY $work"; close_project; exit 0 }
close_design
launch_runs impl_1 -to_step write_bitstream -jobs $jobs
wait_on_run impl_1
if {[get_property PROGRESS [get_runs impl_1]] ne "100%"} { error "Implementation did not complete" }
open_run impl_1
report_utilization -file [file join $work reports utilization.rpt]
report_timing_summary -delay_type min_max -check_timing_verbose -file [file join $work reports timing_summary.rpt]
report_drc -file [file join $work reports drc.rpt]
report_timing -delay_type max -max_paths 20 -path_type full_clock_expanded -file [file join $work reports critical_paths.rpt]
set worst_setup [get_timing_paths -delay_type max -max_paths 1]
set worst_hold [get_timing_paths -delay_type min -max_paths 1]
if {![llength $worst_setup] || ![llength $worst_hold]} { error "No timing paths found" }
set setup_slack [get_property SLACK $worst_setup]
set hold_slack [get_property SLACK $worst_hold]
if {$setup_slack < 0 || $hold_slack < 0} { error "Timing failed: setup $setup_slack ns, hold $hold_slack ns" }
if {[llength [get_drc_violations -filter {SEVERITY == Error}]]} { error "DRC errors remain" }
set deliver [file join $work overlay]
file mkdir $deliver
file copy [file join $work project ${project_name}.runs impl_1 design_1_wrapper.bit] [file join $deliver text288_shared_lfsr_100mhz.bit]
set hwh [file join $work project ${project_name}.gen sources_1 bd design_1 hw_handoff design_1.hwh]
if {![file exists $hwh]} { error "Missing hardware handoff: $hwh" }
file copy $hwh [file join $deliver text288_shared_lfsr_100mhz.hwh]
set receipt [open [file join $deliver BUILD.txt] w]
puts $receipt "Vivado [version -short]\nPart $part\nClock 100 MHz\nMode IID-fresh/EPIX, one shared LFSR, ABI 6.0, delta_q 1, age_max 2\nSetup slack $setup_slack ns\nHold slack $hold_slack ns\nSource $root\nAXI base 0x43C00000"
close $receipt
puts "MAXCUT_OVERLAY_READY $deliver"
close_project

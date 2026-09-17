# Check activity annotations using a small test circuit.
read_liberty $::env(TEST_LIBERTY)
read_verilog $::env(TEST_NETLIST)
link_design pin_activity
create_clock -name clk -period 100 [get_ports clk]
set_input_transition 0.1 [all_inputs]
set_clock_transition 0.1 [all_clocks]
set_load 0.01 [all_outputs]

set expected {}
foreach {name density duty} {
  ff/CLK 0.008 0.3  ff/D 0.01 0.4  ff/Q 0.007 0.3
  gate/A 0.007 0.3  gate/B 0.005 0.6  gate/X 0.003 0.2
  buffer/A 0.003 0.2  buffer/X 0.003 0.2
  clock_gate/CLK 0.02 0.5  clock_gate/GATE 0.005 0.6  clock_gate/GCLK 0.008 0.3
  inverter/A 0.008 0.3  inverter/Y 0.008 0.7
} {
  set object [get_pins $name]
  if {[llength $object] != 1} {error "Missing pin: $name"}
  set_power_activity -pins $object -density $density -duty $duty
  lappend expected [list $object $density $duty]
}
foreach {name density duty} {d 0.01 0.4 en 0.005 0.6} {
  set object [get_ports $name]
  set_power_activity -input_ports $object -density $density -duty $duty
  lappend expected [list $object $density $duty]
}

proc verify_annotations {phase expected} {
  set checked 0
  foreach row $expected {
    lassign $row object density duty
    lassign [get_property $object activity] actual_density actual_duty origin
    set expected_density [expr {$density * 1e9}]
    if {abs($actual_density - $expected_density) > abs($expected_density) * 1e-5
        || abs($actual_duty - $duty) > 0.000501 || $origin ne "user"} {
      error "Annotation lost: $phase [get_full_name $object] expected=$density,$duty actual=$actual_density,$actual_duty,$origin"
    }
    incr checked
  }
  lassign [get_property [get_ports clk] activity] density duty origin
  if {abs($density - 2e7) > 200 || $duty != 0.5 || $origin ne "clock"} {
    error "Root clock activity changed"
  }
  puts "PIN_ACTIVITY_PASS $phase $checked"
}

report_power
verify_annotations first $expected
report_power
verify_annotations repeated $expected
exit

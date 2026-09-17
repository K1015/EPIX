# Save the pins and ports with measured activity.
# Check their activity values after every power report.
namespace eval ::epix_readback {
  variable expected [dict create]
  variable window unset
  variable expected_count 0
}
rename ::set_power_activity ::epix_readback::original_set_power_activity
proc ::set_power_activity {args} {
  if {[llength $args] != 6} {error "Readback requires explicit objects, density and duty"}
  set options [dict create {*}$args]
  if {![dict exists $options -density] || ![dict exists $options -duty]} {
    error "Readback requires explicit density and duty"
  }
  if {[dict exists $options -pins] && ![dict exists $options -input_ports]} {
    set objects [dict get $options -pins]
    set kind pin
  } elseif {[dict exists $options -input_ports] && ![dict exists $options -pins]} {
    set objects [dict get $options -input_ports]
    set kind input
  } else {error "Readback requires either pins or input ports"}
  if {![llength $objects]} {error "Empty activity object collection"}
  set density [expr {double([dict get $options -density])*1e9}]
  set duty [expr {double([dict get $options -duty])}]
  if {$density < 0 || $duty < 0 || $duty > 1} {error "Activity out of range"}
  uplevel 1 [list ::epix_readback::original_set_power_activity {*}$args]
  foreach object $objects {
    dict set ::epix_readback::expected $object [list $density $duty $kind]
  }
}
proc epix_readback_reset {window count} {
  set ::epix_readback::expected [dict create]
  set ::epix_readback::window $window
  set ::epix_readback::expected_count $count
}
proc epix_readback_matches {expected_density expected_duty activity root} {
  if {[llength $activity] != 3} {return 0}
  lassign $activity density duty origin
  if {![string is double -strict $density] || ![string is double -strict $duty]} {return 0}
  if {$density != $density || $duty != $duty} {return 0}
  # OpenSTA emits six significant density digits and three duty decimals.
  if {abs($density-$expected_density) > max(1e-12,abs($expected_density)*1e-5)
      || abs($duty-$expected_duty) > 0.000501} {return 0}
  if {$root} {return [expr {$origin eq "clock"}]}
  if {$origin eq "user"} {return 1}
  # STA may report a proved constant instead of the user's identical value.
  return [expr {$origin eq "constant" && $expected_density == 0
                && ($expected_duty == 0 || $expected_duty == 1)
                && $density == 0 && $duty == $expected_duty}]
}
proc epix_readback_check {phase} {
  set checked 0
  set inputs 0
  set pins 0
  set users 0
  set constants 0
  set errors 0
  dict for {object expected} $::epix_readback::expected {
    lassign $expected density duty kind
    incr checked
    if {$kind eq "input"} {incr inputs} else {incr pins}
    set actual [get_property $object activity]
    if {[epix_readback_matches $density $duty $actual 0]} {
      if {[lindex $actual 2] eq "user"} {incr users} else {incr constants}
    } else {
      incr errors
      if {$errors <= 50} {
        puts [list ACTIVITY_READBACK_ERROR $::epix_readback::window $phase \
                    [get_full_name $object] $expected $actual]
      }
    }
  }
  set root [get_ports clk]
  if {[llength $root] != 1} {error "Root clock port missing"}
  set root_activity [get_property $root activity]
  set root_ok [epix_readback_matches 1e7 0.5 $root_activity 1]
  if {!$root_ok} {incr errors}
  if {$checked != $::epix_readback::expected_count} {incr errors}
  puts [join [list ACTIVITY_READBACK $::epix_readback::window $phase $checked \
              $inputs $pins $users $constants $errors {*}$root_activity] "\t"]
  flush stdout
  if {$errors != 0} {error "Post-power activity readback failed: $errors failures"}
}

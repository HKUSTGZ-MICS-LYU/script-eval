puts "RM-info: Running script [info script]\n"

##########################################################################################
# Tool: IC Compiler II
# Script: report_qor.tcl
# Copyright (C) 2014-2017 Synopsys, Inc. All rights reserved.
##########################################################################################
if {$REPORT_PREFIX != ""} {


####################################
## Timing Constraints 
####################################
puts "RM-info: Reporting timing constraints ...\n"
redirect -file ${REPORTS_DIR}/${REPORT_PREFIX}.report_mode {report_mode}
redirect -file ${REPORTS_DIR}/${REPORT_PREFIX}.report_scenarios {report_scenarios}
redirect -file ${REPORTS_DIR}/${REPORT_PREFIX}.report_pvt {report_pvt}

####################################
## Timing and QoR 
####################################
puts "RM-info: Reporting timing and QoR ...\n"
## QoR
redirect -file ${REPORTS_DIR}/${REPORT_PREFIX}.report_qor {report_qor -scenarios [all_scenarios]}
redirect -tee -append -file ${REPORTS_DIR}/${REPORT_PREFIX}.report_qor {report_qor -summary}

## Timing (-variation enabled for POCV)
if {[get_app_option_value -name time.pocvm_enable_analysis]} {
	redirect -file ${REPORTS_DIR}/${REPORT_PREFIX}.report_timing.max {report_timing -delay max -scenarios [all_scenarios] \
	-input_pins -nets -transition_time -capacitance -attributes -physical -derate -report_by group -variation}
} else {
	redirect -file ${REPORTS_DIR}/${REPORT_PREFIX}.report_timing.max {report_timing -delay max -scenarios [all_scenarios] \
	-input_pins -nets -transition_time -capacitance -attributes -physical -derate -report_by group}
}

if {[regexp $REPORT_PREFIX "$PLACEMENT_BLOCK_NAME|$CTS_BLOCK_NAME|$ROUTE_BLOCK_NAME|$CHIP_FINISH_BLOCK_NAME"]} {
	redirect -file ${REPORTS_DIR}/${REPORT_PREFIX}.check_legality { check_legality }
}
# Min timing report is generated in postcts (-variation enabled for POCV)
if {[regexp $REPORT_PREFIX "$CTS_BLOCK_NAME|$ROUTE_BLOCK_NAME|$CHIP_FINISH_BLOCK_NAME"]} {
	if {[get_app_option_value -name time.pocvm_enable_analysis]} {
		redirect -file ${REPORTS_DIR}/${REPORT_PREFIX}.report_timing.min {report_timing -delay min -scenarios [all_scenarios] \
		-input_pins -nets -transition_time -capacitance -attributes -physical -derate -report_by group -variation}
	} else {
		redirect -file ${REPORTS_DIR}/${REPORT_PREFIX}.report_timing.min {report_timing -delay min -scenarios [all_scenarios] \
		-input_pins -nets -transition_time -capacitance -attributes -physical -derate -report_by group}
	}
}

## Constraint violations
redirect -file ${REPORTS_DIR}/${REPORT_PREFIX}.report_constraint {report_constraint -all_violators -max_transition -max_capacitance -scenarios [all_scenarios]}

## Debugging
puts "RM-info: Analyzing design violations ...\n"
# analyze_design_violations for setup
# The command will automatically add "type" (ie, setup or hold) as part of the report name
# For example, the report name for setup type would be ${REPORTS_DIR}/${REPORT_PREFIX}.analyze_design_violations.setup
if {[regexp $REPORT_PREFIX "$PLACEMENT_BLOCK_NAME|$CTS_BLOCK_NAME"]} {
	analyze_design_violations -type setup -stage preroute -output ${REPORTS_DIR}/${REPORT_PREFIX}.analyze_design_violations
} elseif {[regexp $REPORT_PREFIX "$ROUTE_BLOCK_NAME"]} {
	analyze_design_violations -type setup -stage postroute -output ${REPORTS_DIR}/${REPORT_PREFIX}.analyze_design_violations
} 

# analyze_design_violations for hold
if {[regexp $REPORT_PREFIX "$CTS_BLOCK_NAME"]} {
	analyze_design_violations -type hold -stage preroute -output ${REPORTS_DIR}/${REPORT_PREFIX}.analyze_design_violations
} elseif {[regexp $REPORT_PREFIX "$ROUTE_BLOCK_NAME"]} {
	analyze_design_violations -type hold -stage postroute -output ${REPORTS_DIR}/${REPORT_PREFIX}.analyze_design_violations
}

####################################
## UPF and power 
####################################
# redirect -file ${REPORTS_DIR}/${REPORT_PREFIX}.check_mv_design {check_mv_design} ;# included in the check_design commands
if {![regexp $REPORT_PREFIX $FLOORPLAN_BLOCK_NAME]} {
	redirect -file ${REPORTS_DIR}/${REPORT_PREFIX}.report_threshold_voltage_group {report_threshold_voltage_group}
}

if {$REPORT_QOR_REPORT_POWER == "true" || ($REPORT_QOR_REPORT_POWER == "auto" && ($OPTIMIZATION_FLOW == "hplp" || $OPTIMIZATION_FLOW == "arlp"))} { 
	puts "RM-info: Reporting power ...\n"
	## For hierarchical designs, use report_power -blocks to get the power consumption for the top and sub-blocks separately
	if {$USE_ABSTRACTS_FOR_BLOCKS != "" && $USE_ABSTRACTS_FOR_POWER_ANALYSIS == "true"} {
		redirect -file ${REPORTS_DIR}/${REPORT_PREFIX}.report_power {report_power -blocks -verbose -scenarios [all_scenarios]}
	} else {
		redirect -file ${REPORTS_DIR}/${REPORT_PREFIX}.report_power {report_power -verbose -scenarios [all_scenarios]}
	}
	redirect -file ${REPORTS_DIR}/${REPORT_PREFIX}.report_clock_qor.power {report_clock_qor -type power}
}

redirect -file ${REPORTS_DIR}/${REPORT_PREFIX}.report_mv_path {report_mv_path -all_not_associated}

####################################
## Clock trees 
####################################
if {[regexp $REPORT_PREFIX $FLOORPLAN_BLOCK_NAME]} {

	puts "RM-info: Reporting clock tree information ...\n"
	redirect -file ${REPORTS_DIR}/${REPORT_PREFIX}.report_clock_qor.cell_area {report_clock_qor -type area}
	redirect -file ${REPORTS_DIR}/${REPORT_PREFIX}.report_clock_qor.structure {report_clock_qor -type structure}

} else {

	puts "RM-info: Reporting clock tree information and QoR ...\n"
	redirect -tee -file ${REPORTS_DIR}/${REPORT_PREFIX}.report_clock_qor.summary {report_clock_qor}
	redirect -file ${REPORTS_DIR}/${REPORT_PREFIX}.report_clock_qor.latency {report_clock_qor -type latency -show_paths}
	redirect -file ${REPORTS_DIR}/${REPORT_PREFIX}.report_clock_qor.cell_area {report_clock_qor -type area}
	redirect -file ${REPORTS_DIR}/${REPORT_PREFIX}.report_clock_qor.structure {report_clock_qor -type structure}
	redirect -file ${REPORTS_DIR}/${REPORT_PREFIX}.report_clock_qor.drc_violators {report_clock_qor -type drc_violators -all}
	if {[get_app_option_value -name cts.compile.enable_local_skew] || [get_app_option_value -name cts.optimize.enable_local_skew] || [get_app_option_value -name clock_opt.flow.enable_ccd]} {\
		redirect -file ${REPORTS_DIR}/${REPORT_PREFIX}.report_clock_qor.local_skew {report_clock_qor -type local_skew}
	}

}

####################################
## Routing  
####################################
## check_routes is performed for postroute
if {[regexp $REPORT_PREFIX "$ROUTE_BLOCK_NAME|$CHIP_FINISH_BLOCK_NAME"]} {
	puts "RM-info: Verifying and checking routing ...\n"
	redirect -file ${REPORTS_DIR}/${REPORT_PREFIX}.check_routes {check_routes}
}

####################################
## report_design  
####################################
puts "RM-info: Reporting design information ...\n"
if {[regexp $REPORT_PREFIX "$ROUTE_BLOCK_NAME|$CHIP_FINISH_BLOCK_NAME"]} {
	redirect -file ${REPORTS_DIR}/${REPORT_PREFIX}.report_design {report_design -library -netlist -floorplan -routing}
} else {
	redirect -file ${REPORTS_DIR}/${REPORT_PREFIX}.report_design {report_design -library -netlist -floorplan}
}
redirect -tee -file ${REPORTS_DIR}/${REPORT_PREFIX}.report_utilization {report_utilization}

####################################
## check_design  
####################################
puts "RM-info: Checking design issues ...\n"

## Run the pre-defined mega-check pre_placement_stage which includes
#  atomic checks such as mv_design, design_mismatch, rp_constraints, timing, and scan chain.
if {[regexp $REPORT_PREFIX "$FLOORPLAN_BLOCK_NAME"]} {
	redirect -file ${REPORTS_DIR}/${REPORT_PREFIX}.check_design.pre_placement_stage {check_design -ems_database check_design.pre_placement_stage.ems -checks pre_placement_stage}
}

## Run the pre-defined mega-check pre_clock_tree_stage which includes
#  atomic checks such as mv_design, design_mismatch, timing, scan chain, legality, design_extraction, and clock tree.
if {[regexp $REPORT_PREFIX "$PLACEMENT_BLOCK_NAME"]} {
	redirect -file ${REPORTS_DIR}/${REPORT_PREFIX}.check_design.pre_clock_tree_stage {check_design -ems_database check_design.pre_clock_tree_stage.ems -checks pre_clock_tree_stage}
}

## Run the pre-defined mega-check pre_route_stage which includes
#  atomic checks such as mv_design, design_mismatch, timing, scan chain, design_extraction, and routeability. 
#if {[regexp $REPORT_PREFIX "$CTS_BLOCK_NAME"]} {
#	redirect -file ${REPORTS_DIR}/${REPORT_PREFIX}.check_design.pre_route_stage {check_design -ems_database check_design.pre_route_stage.ems -checks pre_route_stage}
#}

####################################
## MISC  
####################################
puts "RM-info: Reporting units ...\n"
if {[regexp $REPORT_PREFIX "$FLOORPLAN_BLOCK_NAME"]} {
	redirect -file ${REPORTS_DIR}/${REPORT_PREFIX}.report_units {report_units}
}

puts "RM-info: Reporting non-default app option settings ...\n"
    redirect -file ${REPORTS_DIR}/${REPORT_PREFIX}.report_app_options.end {report_app_options              }
### redirect -file ${REPORTS_DIR}/${REPORT_PREFIX}.report_app_options.end {report_app_options -non_default}

########################################################################
## Additional Zero interconnect delay reporting at init_design stage  
########################################################################
if {[regexp $REPORT_PREFIX $FLOORPLAN_BLOCK_NAME]} {
	puts "RM-info: time.delay_calculation_style is set to zero_interconnect ...\n"
	# To restore user settings later
	set RM_current_value_high_fanout_net_pin_capacitance [get_app_option_value -name time.high_fanout_net_pin_capacitance]
	set RM_current_value_high_fanout_net_threshold [get_app_option_value -name time.high_fanout_net_threshold]

	set_app_options -name time.delay_calculation_style -value zero_interconnect ;# tool default auto
	set_app_options -name time.high_fanout_net_pin_capacitance -value 0pF ;# tool default 1pF
	set_app_options -name time.high_fanout_net_threshold -value 100 ;# tool default 1000

	puts "RM-info: Reporting timing and QoR in zero_interconnect mode with zero pin cap ...\n"
	## QoR
	redirect -file ${REPORTS_DIR}/${REPORT_PREFIX}.zwlm.report_qor {report_qor -scenarios [all_scenarios]}
	redirect -tee -append -file ${REPORTS_DIR}/${REPORT_PREFIX}.zwlm.report_qor {report_qor -summary}
	
	## Timing (-variation enabled for POCV)
	if {[get_app_option_value -name time.pocvm_enable_analysis]} {
		redirect -file ${REPORTS_DIR}/${REPORT_PREFIX}.zwlm.report_timing.max {report_timing -delay max -scenarios [all_scenarios] \
		-input_pins -nets -transition_time -capacitance -attributes -physical -derate -report_by group -variation}

                redirect -file ${REPORTS_DIR}/${REPORT_PREFIX}_top300.zwlm.rpt        {report_timing                 -significant_digits 6 \
                         -max_paths 300 -nosplit -input_pins -capacitance -nets -transition_time -delay_type max -slack_lesser_than 300 }
                redirect -file ${REPORTS_DIR}/${REPORT_PREFIX}_top300_R2R.zwlm.rpt    {report_timing -groups REG2REG -significant_digits 6 \
                         -max_paths 300 -nosplit -input_pins -capacitance -nets -transition_time -delay_type max -slack_lesser_than 300 }
	} else {
		redirect -file ${REPORTS_DIR}/${REPORT_PREFIX}.zwlm.report_timing.max {report_timing -delay max -scenarios [all_scenarios] \
		-input_pins -nets -transition_time -capacitance -attributes -physical -derate -report_by group}

                redirect -file ${REPORTS_DIR}/${REPORT_PREFIX}_top300.zwlm.rpt        {report_timing                 -significant_digits 6 \
                         -max_paths 300 -nosplit -input_pins -capacitance -nets -transition_time -delay_type max -slack_lesser_than 300 }
                redirect -file ${REPORTS_DIR}/${REPORT_PREFIX}_top300_R2R.zwlm.rpt    {report_timing -groups REG2REG -significant_digits 6 \
                         -max_paths 300 -nosplit -input_pins -capacitance -nets -transition_time -delay_type max -slack_lesser_than 300 }
	}

	puts "RM-info: time.delay_calculation_style is reset...\n"
	reset_app_options time.delay_calculation_style
	set_app_options -name time.high_fanout_net_pin_capacitance -value $RM_current_value_high_fanout_net_pin_capacitance
	set_app_options -name time.high_fanout_net_threshold -value $RM_current_value_high_fanout_net_threshold
}

########################################################################
## Additional non-SI reporting at route_auto stage  
########################################################################
if {[regexp $REPORT_PREFIX $ROUTE_BLOCK_NAME]} {
	if {[get_app_option_value -name time.si_enable_analysis]} {
		set RM_current_value_enable_si true
	}
	puts "RM-info: time.si_enable_analysis is set to false ...\n"
	set_app_options -name time.si_enable_analysis -value false
	
	puts "RM-info: Reporting timing and QoR in non-SI mode ...\n"
	## QoR
	redirect -file ${REPORTS_DIR}/${REPORT_PREFIX}.no_si.report_qor {report_qor -scenarios [all_scenarios]}
	redirect -tee -append -file ${REPORTS_DIR}/${REPORT_PREFIX}.no_si.report_qor {report_qor -summary}
	
	## Timing (-variation enabled for POCV)
	if {[get_app_option_value -name time.pocvm_enable_analysis]} {
		redirect -file ${REPORTS_DIR}/${REPORT_PREFIX}.no_si.report_timing.max {report_timing -delay max -scenarios [all_scenarios] \
		-input_pins -nets -transition_time -capacitance -attributes -physical -derate -report_by group -variation}
	} else {
		redirect -file ${REPORTS_DIR}/${REPORT_PREFIX}.no_si.report_timing.max {report_timing -delay max -scenarios [all_scenarios] \
		-input_pins -nets -transition_time -capacitance -attributes -physical -derate -report_by group}
	}

	## Restore user default of time.enable_si
	if {[info exists RM_current_value_enable_si] && ${RM_current_value_enable_si}} {
		set_app_options -name time.si_enable_analysis -value true
	}
}

} else {

puts "RM-error: REPORTS_DIR is not specified. Exiting."

}
#report_timing -significant_digits 6 -max_paths 300 -nosplit -input_pins -capacitance -nets -transition_time -delay_type max -slack_lesser_than 300 > ${REPORTS_DIR}/${REPORT_PREFIX}_top300.rpt
#report_timing -groups REG2REG -significant_digits 6 -max_paths 300 -nosplit -input_pins -capacitance -nets -transition_time -delay_type max -slack_lesser_than 300 > ${REPORTS_DIR}/${REPORT_PREFIX}_top300_R2R.rpt

puts "RM-info: Completed script [info script]\n"


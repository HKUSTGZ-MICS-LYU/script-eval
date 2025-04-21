set SCRIPT ../script

puts "INFO: Sourcing ${SCRIPT}/project_setup.tcl"
source ${SCRIPT}/project_setup.tcl

set SRC_BLOCK_NAME $PLACEMENT_BLOCK_NAME
set DST_BLOCK_NAME $CTS_BLOCK_NAME
set REPORT_PREFIX $DST_BLOCK_NAME

open_lib $DESIGN_LIBRARY
copy_block -from $SRC_BLOCK_NAME -to $DST_BLOCK_NAME
current_block $DST_BLOCK_NAME
link_block

puts "INFO: Sourcing ${SCRIPT}/common_setting.tcl"
source ${SCRIPT}/common_setting.tcl

puts "INFO: Sourcing ${CELL_USAGE_FILE}"
source ${CELL_USAGE_FILE}

set_app_options -name opt.common.user_instance_name_prefix -value $DST_BLOCK_NAME

if {[file exists [which $ANTENNA_RULE_FILE]]} {
	puts "source ANTENNA_RULE_FILE $ANTENNA_RULE_FILE"
	source $ANTENNA_RULE_FILE
}


puts "INFO: Running clock_opt -from build_clock -to build_clock command"
clock_opt -from build_clock -to build_clock
save_block -as ${DST_BLOCK_NAME}_build

puts "INFO: Running clock_opt -from route_clock -to route_clock command"
clock_opt -from route_clock -to route_clock
save_block -as ${DST_BLOCK_NAME}_route

puts "INFO: Enale hold fixing"
set_scenario_status -hold true [get_scenarios -filter "active==true"]

puts "INFO: Running clock_opt -from final_opto -to final_opto command"
clock_opt -from final_opto -to final_opto

report_cell_em

connect_pg_net
save_block -as ${DST_BLOCK_NAME}
save_lib

if {$REPORT_QOR} {
        puts "INFO: Sourcing ${SCRIPT}/report_qor.tcl"
        source ${SCRIPT}/report_qor.tcl
}


exit


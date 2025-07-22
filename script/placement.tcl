set SCRIPT_DIR ../../../script

puts "INFO: Sourcing ${SCRIPT_DIR}/project_setup.tcl"
source ${SCRIPT_DIR}/project_setup.tcl

set SRC_BLOCK_NAME $FLOORPLAN_BLOCK_NAME
set DST_BLOCK_NAME $PLACEMENT_BLOCK_NAME
set REPORT_PREFIX $DST_BLOCK_NAME

open_lib $DESIGN_LIBRARY
copy_block -from $SRC_BLOCK_NAME -to $DST_BLOCK_NAME
current_block $DST_BLOCK_NAME
link_block

puts "INFO: Sourcing ${SCRIPT_DIR}/common_setting.tcl"
source ${SCRIPT_DIR}/common_setting.tcl

set_app_options -name opt.common.user_instance_name_prefix -value $DST_BLOCK_NAME

puts "INFO: Sourcing ${CELL_USAGE_FILE}"
source ${CELL_USAGE_FILE}

puts "INFO: Sourcing $CLOCK_NDR_RULE_FILE"
source -e $CLOCK_NDR_RULE_FILE

puts "INFO: Clock NDR modeling at place_opt"
mark_clock_trees -routing_rules

set rm_clock_period $CLOCK_PERIOD
set_clock_tree_options -target_skew $TARGET_SKEW
set_clock_transition [expr $rm_clock_period/6.0] [get_clocks]

## DFP checker
source $DFP_CHECKER
dfp_check_placement



puts "INFO: Running compile_fusion -to final_opto command"
compile_fusion -to final_opto


connect_pg_net
save_block -as ${DST_BLOCK_NAME}
save_lib

if {$REPORT_QOR} {
        puts "INFO: Sourcing ${SCRIPT_DIR}/report_qor.tcl"
        source ${SCRIPT_DIR}/report_qor.tcl
}


exit


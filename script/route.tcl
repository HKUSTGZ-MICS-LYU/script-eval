set SCRIPT ../../../script

puts "INFO: Sourcing ${SCRIPT}/project_setup.tcl"
source ${SCRIPT}/project_setup.tcl
set SRC_BLOCK_NAME $CTS_BLOCK_NAME
set DST_BLOCK_NAME $ROUTE_BLOCK_NAME
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
## DFP checker
source $DFP_CHECKER
dfp_check_routing

puts "INFO: Running route_auto command"
route_auto
save_block -as ${DST_BLOCK_NAME}_route_auto

puts "INFO: Running route_detail -incremental true command"
route_detail -incremental true -max_number_iterations 20
save_block -as ${DST_BLOCK_NAME}_route_incr

puts "INFO: Running route_opt command"
route_opt
save_block -as ${DST_BLOCK_NAME}_route_opt

report_cell_em

puts "INFO: Running DFM via swapping command"
source $DFM_TCL_FILE
route_detail -incremental true

connect_pg_net

save_block -as $DST_BLOCK_NAME
save_lib

if {$REPORT_QOR} {
        puts "INFO: Sourcing ${SCRIPT}/report_qor.tcl"
        source ${SCRIPT}/report_qor.tcl
}


exit


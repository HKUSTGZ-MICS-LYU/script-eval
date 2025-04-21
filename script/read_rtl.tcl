set SCRIPT_DIR ../script

puts "INFO: Sourcing ${SCRIPT_DIR}/project_setup.tcl"
source ${SCRIPT_DIR}/project_setup.tcl

set SRC_BLOCK_NAME ""
set DST_BLOCK_NAME $READ_RTL_BLOCK_NAME
set REPORT_PREFIX $DST_BLOCK_NAME

puts "INFO: Design creation"
if {[file exists $DESIGN_LIBRARY]} { file delete -force $DESIGN_LIBRARY }

set_app_options -name lib.configuration.cdpl_host -value "-hosts localhost:${NUM_CORE}"

create_lib $DESIGN_LIBRARY -tech $TECH_FILE -ref_libs $REFERENCE_LIBRARY

analyze -format sv {../rtl/common.sv ../rtl/salsa8d.sv}
elaborate ${DESIGN_NAME}
set_top_module ${DESIGN_NAME}

save_block -as ${DST_BLOCK_NAME}
save_lib

exit 


source ../script/project_setup.tcl

set power_enable_analysis true

set link_path ${DB_TT}

read_verilog ./out/${DESIGN_NAME}.v.sta

link_design ${DESIGN_NAME}
create_clock -period ${CLOCK_PERIOD} -name clk [get_ports clk]

read_parasitics ./out/${DESIGN_NAME}.nomTLU_85.spef
report_annotated_parasitics

# get start & end time
set stet_f [open "./stet"]
set stet [gets $stet_f]
set st [lindex [split $stet " "] 0]
set et [lindex [split $stet " "] 1]

read_fsdb ./netlist.fsdb -strip_path /salsa8d_tb/dut_i -time "$st $et"

redirect -file ${REPORTS_DIR}/power.report_power {report_power}

redirect -file ${REPORTS_DIR}/power.total_power {get_attribute [get_designs [current_design]] total_power}

exit

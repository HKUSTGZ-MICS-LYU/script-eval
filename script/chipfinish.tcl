set SCRIPT ../script

puts "INFO: Sourcing ${SCRIPT}/project_setup.tcl"
source ${SCRIPT}/project_setup.tcl

set SRC_BLOCK_NAME $ROUTE_BLOCK_NAME
set DST_BLOCK_NAME $CHIP_FINISH_BLOCK_NAME
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

puts "INFO: With M0 shape DCAP cell insertion"
set dcap_cell_list [sort_collection -descending [get_lib_cells {*/DCAP*XPBWP* */DCAP*XNBWP*}] area]

set full_cell_list ""
set full_cell_list [append_to_collection full_cell_list $dcap_cell_list]
create_stdcell_filler -prefix DCAP_M0 -lib_cell $full_cell_list 

connect_pg_net
remove_stdcell_fillers_with_violation

puts "INFO: Without M0 shape DCAP/FILL cell insertion"
set dcap_cell_list [sort_collection -descending [get_lib_cells */DCAP*NMBWP*] area]
set fill_cell_list [sort_collection -descending [remove_from_collection [get_lib_cells */FILL*] [get_lib_cells {*/FILL*NOBCM*}]] area]

set full_cell_list ""
set full_cell_list [append_to_collection full_cell_list $dcap_cell_list]
set full_cell_list [append_to_collection full_cell_list $fill_cell_list]

create_stdcell_filler -lib_cell $full_cell_list

puts "INFO: Filler cell swapping"

set replaceList ""
foreach_in_collection cell [get_lib_cells */FILL1BWP*] {
set from_filler [get_attribute $cell full_name]
set lib_name [get_attribute $cell lib_name]
set to_filler [get_attribute [get_lib_cells [get_attr $cell lib_name]/FILL1NOBCMBWP*] full_name]
lappend replaceList "$from_filler $to_filler"
}

replace_fillers_by_rules \
    -replacement_rule illegal_abutment \
    -replace_abutment $replaceList \
    -illegal_abutment [get_lib_cells {*/FILL1BWP* */FILL1NOBCMBWP*}]

if {$STD_CELL_TYPE=="H240CPODE"} {

	save_block
	puts "INFO:  M0 Fill Generation"
	# 0.5 CPP M0 Fill Generation
	# ICV version: O-2018.12-SP1
	reset_app_options signoff.create_metal_fill.*
	reset_app_options signoff.create_active_fill.*

	signoff_create_metal_fill -mode remove
	signoff_create_active_fill -mode remove
	set_app_options -name signoff.create_metal_fill.flat -value true

	set_app_options -name  signoff.create_metal_fill.user_defined_options -value {-D MAX_OBS_EXTENSION_LENGTH=0.0285}
	signoff_create_metal_fill -track_fill tsmc6  -output_colored_fill true -fill_all_tracks true  -select_layers {M0} -active_fill drc
}

connect_pg_net
change_names -rules verilog -hierarchy

## DFP checker
source $DFP_CHECKER
dfp_check_design_finish

save_block -as ${DST_BLOCK_NAME}
save_lib

# Output final netlist for STA and LVS.
write_verilog -exclude {scalar_wire_declarations leaf_module_declarations pg_objects end_cap_cells well_tap_cells filler_cells pad_spacer_cells physical_only_cells cover_cells} \
-hierarchy all ${OUTPUTS_DIR}/${DESIGN_NAME}.v.sta

write_verilog  -rename_cell $RENAME_CELL_FILE \
-exclude {scalar_wire_declarations leaf_module_declarations end_cap_cells well_tap_cells filler_cells pad_spacer_cells physical_only_cells cover_cells} \
-hierarchy all ${OUTPUTS_DIR}/${DESIGN_NAME}.v.lvs

# # Output no reset cell paths
# set cell_key "
# DFQD
# DFMQD
# "
# foreach key $cell_key {
# 	foreach inst [get_cells -filter "ref_name=~$key*"] {
# 		foreach pin [get_pins -of_object $inst -filter "direction==out"] {
# 			redirect -append ${OUTPUTS_DIR}/${DESIGN_NAME}.no_reset_reg_list {get_object_name $pin}
# 		}
# 	}
# }

# Output final design SDF.
write_sdf ${OUTPUTS_DIR}/${DESIGN_NAME}.sdf -corner Typical

write_parasitics -output ${OUTPUTS_DIR}/${DESIGN_NAME}

## Set to write out a UPF file compatible for other Synopsys tools
#set_app_option -name mv.upf.write_crosstool_wrappers -value true

# Output final UPF.
save_upf ${OUTPUTS_DIR}/${DESIGN_NAME}.upf

# Output final design DEF.
write_def -version 5.8 ${OUTPUTS_DIR}/${DESIGN_NAME}.def

# Output final design GDS and OASIS.
write_gds  -rename_cell $RENAME_CELL_FILE -lib_cell_view frame -hierarchy all -long_names ${OUTPUTS_DIR}/${DESIGN_NAME}.gds \
-output_pin {all} -keep_data_type \
-units 2000 -write_default_layers {VIA1}  \
-layer_map $WRITE_GDS_LAYER_MAP_FILE -layer_map_format icc_extended

if {$REPORT_QOR} {
        puts "INFO: Sourcing ${SCRIPT}/report_qor.tcl"
        source ${SCRIPT}/report_qor.tcl

}

exit



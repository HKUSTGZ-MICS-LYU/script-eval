


################################################################################
# For TSMC N6 node specific setting
# set_technology 6.08
################################################################################
set_technology -node 6

################################################################################
# TSMC N6 H240 CPP57 tcbn06_bwph240l8p57cpd_base library specific setting
################################################################################

if {$STD_CELL_TYPE=="H240CPODE"} {
        echo "Additional setting for $STD_CELL_TYPE library"
        # M0 layer routing
        set_ignored_layers -min_routing_layer M0

        #For CPODE.L.2 rule
        #ICC2 tech file syntax example : Layer "CPODE" { maskName   = "cpode" ; yMaxLength = 30 ; }
        if { [sizeof_collection [get_layers -quiet -filter "mask_name==cpode"]] == 0} {
                echo "ICC2 tech file does not have CPODE rule, specify CPODE length constraint by place.legalize.max_vertical_stacked_length app_option"
                set_app_options -name place.legalize.max_vertical_stacked_length -value [expr 30 -[get_attribute [get_site_defs unit] height]]
        }

        # Area-based rule
        set_app_options -name chipfinishing.standard_cell_region_vertical_shrink_factor -value 0.50
        set_app_options -name chipfinishing.standard_cell_region_horizontal_shrink_factor -value -0.50

} elseif {$STD_CELL_TYPE=="H240PODE"} {
        echo "Additional setting for $STD_CELL_TYPE library"
        # M1 layer routing
        set_ignored_layers -min_routing_layer M1
} elseif {$STD_CELL_TYPE=="H300PODE"} {
        echo "Additional setting for $STD_CELL_TYPE library"
        # M1 layer routing
        set_ignored_layers -min_routing_layer M1
} else {
        echo "Error : Does not $STD_CELL_TYPE library in current flow."
}

# Specify site def symmetry
set_attribute [get_site_defs] symmetry Y

# For gate array ECO cell placement
set_app_options -name place.legalize.enable_allowable_orient -value true

# For Macro cell M1 pin alignment. If M1 pin width less than 40 , macro M1 pin can align M1 track when snap option it enable.
set_snap_setting -macro_by_color true -enabled true
set_snap_setting -class macro_cell  -snap finfet -enabled true
set_snap_setting -class io_cell     -snap finfet -enabled true

# Filler / DCAP cell list.
set_app_options -name place.legalize.filler_lib_cells -value [get_attribute [get_lib_cells {*/FILL* */DCAP*}] name]

if {[sizeof_collection [get_flat_pins -quiet -of_objects [get_flat_cells -quiet -filter "design_type==macro"] -filter "layer_name==M1"]] > 0} {
 # For mixed M1 pitch Macro pin connection
 set m1_macro_pins [get_flat_pins -quiet -of_objects [get_flat_cells -quiet -filter "design_type==macro"] -filter "layer_name==M1"]
 set_attribute -objects [get_terminals -of_objects $m1_macro_pins] -name port.connect_within_pin -value via_wire
 set_app_options -name route.common.derive_connect_within_pin_via_region -value true
}

################################################################################
# Design related setting
################################################################################

#Enable remove_net command to remove shape/via in the ECO flow
set_app_options -name design.remove_net_shapes -value true

# for port/pin antenna setting (2018/03/01)
set_app_options -block [current_block] -list {route.detail.default_port_external_gate_size 0.0}
set_app_options -block [current_block] -list {route.detail.default_gate_size 0.0}

set_app_options -name shell.common.report_default_significant_digits -value 4

set_ignored_layers -max_routing_layer $MAX_ROUTING_LAYER

if {[regexp $DST_BLOCK_NAME $FLOORPLAN_BLOCK_NAME]} {
	echo "Additional setting for $FLOORPLAN_BLOCK_NAME step"
	set_app_options -name place.coarse.continue_on_missing_scandef -value true
}
if {[regexp $DST_BLOCK_NAME $PLACEMENT_BLOCK_NAME]} {
	echo "Additional setting for $PLACEMENT_BLOCK_NAME step"

}
if {[regexp $DST_BLOCK_NAME $CTS_BLOCK_NAME]} {
	echo "Additional setting for $CTS_BLOCK_NAME step"
	set_app_options -name time.remove_clock_reconvergence_pessimism -value true
	set_app_options -name ccd.hold_control_effort -value medium
        set_clock_cell_spacing -x_spacing 1 -y_spacing 1
}
if {[regexp $DST_BLOCK_NAME $ROUTE_BLOCK_NAME]} {
	echo "Additional setting for $ROUTE_BLOCK_NAME step"
	set_app_options -name extract.enable_coupling_cap -value true
        set_app_options -name time.si_enable_analysis -value true
        set_app_options -name time.enable_ccs_rcv_cap -value true
	set_app_options -name ccd.hold_control_effort -value medium

}
if {[regexp $DST_BLOCK_NAME $CHIP_FINISH_BLOCK_NAME]} {
	echo "Additional setting for $CHIP_FINISH_BLOCK_NAME step"
}


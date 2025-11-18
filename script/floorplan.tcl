set SCRIPT_DIR ../../../script

puts "INFO: Sourcing ${SCRIPT_DIR}/project_setup.tcl"
source ${SCRIPT_DIR}/project_setup.tcl

set SRC_BLOCK_NAME $READ_RTL_BLOCK_NAME
set DST_BLOCK_NAME $FLOORPLAN_BLOCK_NAME
set REPORT_PREFIX $DST_BLOCK_NAME

open_lib $DESIGN_LIBRARY
copy_block -from $SRC_BLOCK_NAME -to $DST_BLOCK_NAME
current_block $DST_BLOCK_NAME
link_block


puts "INFO: Sourcing ${SCRIPT_DIR}/common_setting.tcl"
source ${SCRIPT_DIR}/common_setting.tcl

puts "INFO: Sourcing ${CELL_USAGE_FILE}"
source ${CELL_USAGE_FILE}

# For low-power flow
if {[file exists [which $UPF_FILE]]} {
	puts "INFO: Load UPF"
        load_upf $UPF_FILE
        commit_upf
        associate_mv_cells -all
}

set sh_continue_on_error true

foreach par_file $PLACEMENT_CONSTRAINT {
	puts "INFO: Sourcing placement constraint file : $par_file"
	source $par_file
}

set sh_continue_on_error false

puts "INFO: Sourcing Multi-Corner Multi-Mode timing scenario setting ${MCMM_FILE}"
source ${MCMM_FILE}

###################
## Floorplanning ##
###################

## Set metal layer routing direction
set i 0
foreach Mask_name_index [lsort -dictionary -increasing [get_attribute [get_layers -filter "is_routing_layer==true&&is_default_layer==true&&mask_name=~metal*"] mask_name]] {
        set Layer [get_layer -filter "mask_name==$Mask_name_index"]
        set Layer_name [get_attribute $Layer full_name]
        incr i
        if {[expr $i%2] == 0 } { set_attribute $Layer routing_direction vertical
        } else                 { set_attribute $Layer routing_direction horizontal }
}

# Check the design before compile_fusion
compile_fusion -check_only

#### Initial auto floorplan creation
compile_fusion -to logic_opto

puts "INFO: Floorplan creation"
initialize_floorplan -shape [dict get $params fp_shape] -core_utilization [expr $UTIL/100.0] -side_ratio {1 1} \
-core_offset [list $boundary_offset_x $boundary_offset_y]   -flip_first_row true


puts "INFO: Wire track creation"
source $TCL_TRACK_CREATION_FILE

if {[sizeof_collection [get_flat_cells -quiet -filter "design_type==macro"]] > 0} {
	#Macro placement
	puts "INFO: Macro placement"
	set macro_cells [get_flat_cells -quiet -filter "design_type==macro"]
	set_locked_objects $macro_cells -unlock
	set_macro_constraints -align_pins_to_tracks $macro_cells
	set_snap_setting -macro_by_color true
	create_placement -floorplan
	snap_objects $macro_cells
	report_placement -hard_macro_pin_track_violations constrained_only
	check_finfet_grid
	set_locked_objects $macro_cells
}

if {[file exists $ADDITIONAL_FLOORPLAN_FILE]} {
	puts "INFO: Sourcing $ADDITIONAL_FLOORPLAN_FILE"
	source $ADDITIONAL_FLOORPLAN_FILE
}

puts "INFO: Check same length poly rule"
redirect -file ${REPORTS_DIR}/${FLOORPLAN_BLOCK_NAME}.report_placement.rpt { report_placement -poly_rule -hierarchical }

set tile_width [lindex [get_attribute [get_site_rows] site_width] 0]
set tile_height [lindex [get_attribute [get_site_rows] site_height] 0]

##  Boundary cell insertion 

# Add "-at_va_boundary" for MV design

set_boundary_cell_rules \
		-at_va_boundary \
		-top_boundary_cells               [sort_collection -descending [get_lib_cells */BOUNDARYNROW?BWP240H8P57CPDSVT ] area] \
		-bottom_boundary_cells            [sort_collection -descending [get_lib_cells */BOUNDARYPROW?BWP240H8P57CPDSVT ] area] \
		-left_boundary_cell               "*/$BOUNDARY_LEFT" \
        -right_boundary_cell              "*/$BOUNDARY_RIGHT" \
        -top_right_outside_corner_cell    "*/$BOUNDARY_NCORNER" \
        -bottom_right_outside_corner_cell "*/$BOUNDARY_PCORNER" \
        -top_left_outside_corner_cell     "*/$BOUNDARY_NCORNER" \
        -bottom_left_outside_corner_cell  "*/$BOUNDARY_PCORNER" \
        -top_right_inside_corner_cells    "*/$BOUNDARY_NINCORNER" \
        -bottom_right_inside_corner_cells "*/$BOUNDARY_PINCORNER" \
        -top_left_inside_corner_cells     "*/$BOUNDARY_NINCORNER" \
        -bottom_left_inside_corner_cells  "*/$BOUNDARY_PINCORNER" \
        -top_left_inside_horizontal_abutment_cells     "*/$BOUNDARY_NGAP_LEFT" \
        -top_right_inside_horizontal_abutment_cells    "*/$BOUNDARY_NGAP_RIGHT" \
        -bottom_left_inside_horizontal_abutment_cells  "*/$BOUNDARY_PGAP_LEFT" \
        -bottom_right_inside_horizontal_abutment_cells "*/$BOUNDARY_PGAP_RIGHT" \
        -mirror_left_inside_corner_cell \
        -mirror_left_outside_corner_cell \
        -segment_parity {horizontal_odd vertical_even} \
        -min_vertical_jog 0.48 \
        -min_horizontal_jog 0.798 \
        -min_vertical_separation 2.40 \
        -min_horizontal_separation 2.109

compile_boundary_cells -add_placement_blockage

#for fixing verticl max length of CPODE
replace_fillers_by_rules -replacement_rule boundary_cell_vertical_constraint \
    -replace_top_bottom \
    -left_boundary_cell */$BOUNDARY_LEFT \
    -right_boundary_cell */$BOUNDARY_RIGHT \
    -left_replacement_cell */$BOUNDARY_REPLACE_LEFT \
    -right_replacement_cell */$BOUNDARY_REPLACE_RIGHT \
    -max_constraint_length [expr 30 -[get_attribute [get_site_defs unit] height]]

## Tapcell insertion.

create_tap_cells -lib_cell */$TAP_CELL \
        -distance 100 \
        -pattern stagger \
        -no_abutment \
        -no_abutment_horizontal_spacing 1 \
        -no_abutment_corner_spacing 0 \
        -skip_fixed_cells

connect_pg_net -automatic

## tCIC checker
#source $tCIC_CHECKER

## Power planning.
puts "INFO: Sourcing $TCL_PG_CREATION_FILE"
source $TCL_PG_CREATION_FILE

if {[file exists $PLACE_PIN_FILE]} {
	source $PLACE_PIN_FILE
} else {
	place_pins -self
}

connect_pg_net

## Create design level halo metal blockage
set halo_width -0.5
set halo_width_M1 [expr $halo_width + 0.03]
set chop_width [expr - $halo_width]

set die_area_boundary [get_att [current_design] boundary]

set die_area_boundary_halo [resize_polygons -objects $die_area_boundary -size $halo_width]
set blockage_area [compute_polygons -objects1 $die_area_boundary -operation NOT -objects2 $die_area_boundary_halo]

set die_area_boundary_halo_M1 [resize_polygons -objects $die_area_boundary -size $halo_width_M1]
set blockage_area_M1 [compute_polygons -objects1 $die_area_boundary -operation NOT -objects2 $die_area_boundary_halo_M1]

foreach layer_name [get_attribute [get_layers -filter "is_routing_layer==true&&is_default_layer==true&&mask_name=~metal*"] full_name] {
        if {$layer_name=="M1"} {
                set future_rb_gms $blockage_area_M1
        } else {
                set future_rb_gms $blockage_area
        }
        set terminals [ get_terminals -quiet -filter "layer.name==$layer_name" ]
        if { [sizeof_collection $terminals] > 0 } {
                foreach_in_collection terminal $terminals {
                        set resized_terminals_gm [ resize_polygons -objects $terminal -size $chop_width ]
                        set future_rb_gms [ compute_polygons -operation NOT -objects1 $future_rb_gms -objects2 $resized_terminals_gm ]
                }
        }
        foreach_in_collection donut_pr [ split_polygons -objects $future_rb_gms -output poly_rect ] {
                create_routing_blockage -zero_spacing \
                -name_prefix RB_HALO \
                -boundary $donut_pr \
                -layer $layer_name
        }
}

derive_standard_cell_region_routing_guides

## DFP checker
source $DFP_CHECKER
dfp_check_floorplan

save_block -as $DST_BLOCK_NAME
save_lib

if {$REPORT_QOR} {
        puts "INFO: Sourcing ${SCRIPT_DIR}/report_qor.tcl"
        source ${SCRIPT_DIR}/report_qor.tcl
}

exit
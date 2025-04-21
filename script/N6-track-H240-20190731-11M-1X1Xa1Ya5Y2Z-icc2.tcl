set cell_height_track 0.240
set two_cell_height_track [expr 2*$cell_height_track]
set l 0
while {$l<=11} {
	set M${l}_pitch_track [get_attribute [get_layers M${l}] pitch]
	incr l
}

set M0_track_offset 0.0 ;
set M1_track_offset 0.0285 ;
set M2_track_offset -0.02 ;
set M3_track_offset 0.0 ;
set M4_track_offset -0.02 ;
set M5_track_offset 0.0 ;
set M6_track_offset -0.02 ;
set M7_track_offset 0.0 ;
set M8_track_offset -0.02 ;
set M9_track_offset 0.0 ;
set M10_track_offset 0.0 ;
set M11_track_offset 0.0 ;

echo "Getting FP Info"
set core_llx_track [lindex [lindex [get_attribute [get_core_area] bbox] 0] 0]
set core_lly_track [lindex [lindex [get_attribute [get_core_area] bbox] 0] 1]
set core_urx_track [lindex [lindex [get_attribute [get_core_area] bbox] 1] 0]
set core_ury_track [lindex [lindex [get_attribute [get_core_area] bbox] 1] 1]

set die_llx_track [lindex [lindex [get_attribute [current_block] boundary_bbox] 0] 0]
set die_lly_track [lindex [lindex [get_attribute [current_block] boundary_bbox] 0] 1]
set die_urx_track [lindex [lindex [get_attribute [current_block] boundary_bbox] 1] 0]
set die_ury_track [lindex [lindex [get_attribute [current_block] boundary_bbox] 1] 1]

echo "Track Creation..."
set_attribute [get_layer M0]  routing_direction horizontal
set_attribute [get_layer M1]  routing_direction vertical
set_attribute [get_layer M2]  routing_direction horizontal
set_attribute [get_layer M3]  routing_direction vertical
set_attribute [get_layer M4]  routing_direction horizontal
set_attribute [get_layer M5]  routing_direction vertical
set_attribute [get_layer M6]  routing_direction horizontal
set_attribute [get_layer M7]  routing_direction vertical
set_attribute [get_layer M8]  routing_direction horizontal
set_attribute [get_layer M9]  routing_direction vertical
set_attribute [get_layer M10] routing_direction horizontal
set_attribute [get_layer M11] routing_direction vertical
set_attribute [get_layer AP]  routing_direction horizontal


#########################
###  Vertical tracks  ###
#########################
echo "M1 Track Creation ..."
set first_track_color mask_one
set second_track_color mask_two
set even_odd [expr int (($core_llx_track - $die_llx_track + $M1_track_offset)/$M1_pitch_track)]

if { $even_odd%2 == 0} {
	if {$first_track_color == "mask_one" } { 
		set first_track_color mask_one 
	} else {
		set first_track_color mask_two
	}
} else {
	if {$first_track_color == "mask_one" } { 
		set first_track_color mask_two
	} else {
		set first_track_color mask_one 
	}
}

if {$first_track_color == "mask_one" } { 
	set second_track_color mask_two
} else {
	set second_track_color mask_one 
}

set track_x [expr $core_llx_track + $M1_track_offset - (int (($core_llx_track - $die_llx_track + $M1_track_offset)/$M1_pitch_track)*$M1_pitch_track)]
set count [expr 1 + int (($die_urx_track - $track_x)/$M1_pitch_track)]
remove_tracks -layer M1

if {$first_track_color == "mask_two"} {
  create_track -layer M1 -dir X -mask_pattern $first_track_color -space [expr 2*$M1_pitch_track] -coord [expr $track_x]  -count $count
  
  set track_x [expr $track_x + $M1_pitch_track]
  set count [expr 1+ int (($die_urx_track - $track_x)/(2*$M1_pitch_track))]
  create_track -layer M1 -dir X -mask_pattern $second_track_color -space [expr 2*$M1_pitch_track] -coord $track_x -count $count
} else {
  create_track -layer M1 -dir X -mask_pattern $first_track_color -space [expr 2*$M1_pitch_track] -coord [expr $track_x]  -count $count
  
  set track_x [expr $track_x + $M1_pitch_track]
  set count [expr 1+ int (($die_urx_track - $track_x)/(2*$M1_pitch_track))]
  create_track -layer M1 -dir X -mask_pattern $second_track_color -space [expr 2*$M1_pitch_track] -coord $track_x -count $count
}


echo "M3 Track Creation ..."
set first_track_color mask_one
set second_track_color mask_two
set even_odd [expr int (($core_llx_track - $die_llx_track + $M3_track_offset)/$M3_pitch_track)]

if { $even_odd%2 == 0} {
	if {$first_track_color == "mask_one" } { 
		set first_track_color mask_one 
	} else {
		set first_track_color mask_two
	}
} else {
	if {$first_track_color == "mask_one" } { 
		set first_track_color mask_two
	} else {
		set first_track_color mask_one 
	}
}

if {$first_track_color == "mask_one" } { 
	set second_track_color mask_two
} else {
	set second_track_color mask_one 
}

set track_x [expr $core_llx_track + $M3_track_offset - (int (($core_llx_track - $die_llx_track + $M3_track_offset)/$M3_pitch_track)*$M3_pitch_track)]
set count [expr 1 + int (($die_urx_track - $track_x)/$M3_pitch_track)]
remove_tracks -layer M3

if {$first_track_color == "mask_two"} {
  create_track -layer M3 -dir X -mask_pattern $first_track_color -space [expr 2*$M3_pitch_track] -coord [expr $track_x]  -count $count
  
  set track_x [expr $track_x + $M3_pitch_track]
  set count [expr 1+ int (($die_urx_track - $track_x)/(2*$M3_pitch_track))]
  create_track -layer M3 -dir X -mask_pattern $second_track_color -space [expr 2*$M3_pitch_track] -coord $track_x -count $count
} else {
  create_track -layer M3 -dir X -mask_pattern $first_track_color -space [expr 2*$M3_pitch_track] -coord [expr $track_x]  -count $count
  
  set track_x [expr $track_x + $M3_pitch_track]
  set count [expr 1+ int (($die_urx_track - $track_x)/(2*$M3_pitch_track))]
  create_track -layer M3 -dir X -mask_pattern $second_track_color -space [expr 2*$M3_pitch_track] -coord $track_x -count $count
}


echo "M5 Track Creation ..."
set track_x [expr $core_llx_track + $M5_track_offset - (int (($core_llx_track - $die_llx_track + $M5_track_offset)/$M5_pitch_track)*$M5_pitch_track)]
set count [expr 1 + int (($die_urx_track - $track_x)/$M5_pitch_track)]
remove_tracks -layer M5
create_track -layer M5  -coord $track_x -space $M5_pitch_track -dir X -count $count 


echo "M7 Track Creation ..."
set track_x [expr $core_llx_track + $M7_track_offset - (int (($core_llx_track - $die_llx_track + $M7_track_offset)/$M7_pitch_track)*$M7_pitch_track)]
set count [expr 1 + int (($die_urx_track - $track_x)/$M7_pitch_track)]
remove_tracks -layer M7
create_track -layer M7  -coord $track_x -space $M7_pitch_track -dir X -count $count 


echo "M9 Track Creation ..."
set track_x [expr $core_llx_track + $M9_track_offset - (int (($core_llx_track - $die_llx_track + $M9_track_offset)/$M9_pitch_track)*$M9_pitch_track)]
set count [expr 1 + int (($die_urx_track - $track_x)/$M9_pitch_track)]
remove_tracks -layer M9
create_track -layer M9  -coord $track_x -space $M9_pitch_track -dir X -count $count 


echo "M11 Track Creation ..."
set track_x [expr $core_llx_track + $M11_track_offset - (int (($core_llx_track - $die_llx_track + $M11_track_offset)/$M11_pitch_track)*$M11_pitch_track)]
set count [expr 1 + int (($die_urx_track - $track_x)/$M11_pitch_track)]
remove_tracks -layer M11
create_track -layer M11  -coord $track_x -space $M11_pitch_track -dir X -count $count 


###########################
###  Horizontal tracks  ###
###########################

echo "M0 Track Creation ..."
remove_tracks -layer M0
set track_y [expr $core_lly_track + $M0_track_offset - (int (($core_lly_track - $die_lly_track + $M0_track_offset)/$cell_height_track)*$cell_height_track)]
set count [expr 1 + int (($die_ury_track - $track_y)/$cell_height_track)]
create_track -layer M0 -dir Y -mask_pattern {mask_two} -space $two_cell_height_track -coord [expr $track_y + 0.000] -count $count
create_track -layer M0 -dir Y -mask_pattern {mask_one} -space $two_cell_height_track -coord [expr $track_y + 0.060] -count $count -end_grid_high_offset 0.0165 -end_grid_low_offset 0.012 -end_grid_low_steps 0.0285 -end_grid_high_steps 0.0285 -end_grid_relative_to core_area
create_track -layer M0 -dir Y -mask_pattern {mask_two} -space $two_cell_height_track -coord [expr $track_y + 0.100] -count $count -end_grid_high_offset 0.0165 -end_grid_low_offset 0.012 -end_grid_low_steps 0.0285 -end_grid_high_steps 0.0285 -end_grid_relative_to core_area
create_track -layer M0 -dir Y -mask_pattern {mask_one} -space $two_cell_height_track -coord [expr $track_y + 0.140] -count $count -end_grid_high_offset 0.0165 -end_grid_low_offset 0.012 -end_grid_low_steps 0.0285 -end_grid_high_steps 0.0285 -end_grid_relative_to core_area
create_track -layer M0 -dir Y -mask_pattern {mask_two} -space $two_cell_height_track -coord [expr $track_y + 0.180] -count $count -end_grid_high_offset 0.0165 -end_grid_low_offset 0.012 -end_grid_low_steps 0.0285 -end_grid_high_steps 0.0285 -end_grid_relative_to core_area
create_track -layer M0 -dir Y -mask_pattern {mask_one} -space $two_cell_height_track -coord [expr $track_y + 0.240] -count $count
create_track -layer M0 -dir Y -mask_pattern {mask_two} -space $two_cell_height_track -coord [expr $track_y + 0.300] -count $count -end_grid_high_offset 0.0165 -end_grid_low_offset 0.012 -end_grid_low_steps 0.0285 -end_grid_high_steps 0.0285 -end_grid_relative_to core_area
create_track -layer M0 -dir Y -mask_pattern {mask_one} -space $two_cell_height_track -coord [expr $track_y + 0.340] -count $count -end_grid_high_offset 0.0165 -end_grid_low_offset 0.012 -end_grid_low_steps 0.0285 -end_grid_high_steps 0.0285 -end_grid_relative_to core_area
create_track -layer M0 -dir Y -mask_pattern {mask_two} -space $two_cell_height_track -coord [expr $track_y + 0.380] -count $count -end_grid_high_offset 0.0165 -end_grid_low_offset 0.012 -end_grid_low_steps 0.0285 -end_grid_high_steps 0.0285 -end_grid_relative_to core_area
create_track -layer M0 -dir Y -mask_pattern {mask_one} -space $two_cell_height_track -coord [expr $track_y + 0.420] -count $count -end_grid_high_offset 0.0165 -end_grid_low_offset 0.012 -end_grid_low_steps 0.0285 -end_grid_high_steps 0.0285 -end_grid_relative_to core_area


echo "M2 Track Creation ..."
set first_track_color mask_one
set second_track_color mask_two
set even_odd [expr int (($core_lly_track - $die_lly_track + $M2_track_offset)/$M2_pitch_track)]

if { $even_odd%2 == 0} {
	if {$first_track_color == "mask_one" } { 
		set first_track_color mask_one 
	} else {
		set first_track_color mask_two
	}
} else {
	if {$first_track_color == "mask_one" } { 
		set first_track_color mask_two
	} else {
		set first_track_color mask_one 
	}
}

if {$first_track_color == "mask_one" } { 
	set second_track_color mask_two
} else {
	set second_track_color mask_one 
}

set track_y [expr $core_lly_track + $M2_track_offset - (int (($core_lly_track - $die_lly_track + $M2_track_offset)/$M2_pitch_track)*$M2_pitch_track)]
set count [expr 1 + int (($die_ury_track - $track_y)/$M2_pitch_track)]
remove_tracks -layer M2
create_track -layer M2  -mask_pattern "$first_track_color $second_track_color" -coord $track_y -space $M2_pitch_track -dir Y -count $count


echo "M4 Track Creation ..."
set track_y [expr $core_lly_track + $M4_track_offset - (int (($core_lly_track - $die_lly_track + $M4_track_offset)/$M4_pitch_track)*$M4_pitch_track)]
set count [expr 1 + int (($die_ury_track - $track_y)/$M4_pitch_track)]
remove_tracks -layer M4
create_track -layer M4  -coord $track_y -space $M4_pitch_track -dir Y -count $count


echo "M6 Track Creation ..."
set track_y [expr $core_lly_track + $M6_track_offset - (int (($core_lly_track - $die_lly_track + $M6_track_offset)/$M6_pitch_track)*$M6_pitch_track)]
set count [expr 1 + int (($die_ury_track - $track_y)/$M6_pitch_track)]
remove_tracks -layer M6
create_track -layer M6  -coord $track_y -space $M6_pitch_track -dir Y -count $count


echo "M8 Track Creation ..."
set track_y [expr $core_lly_track + $M8_track_offset - (int (($core_lly_track - $die_lly_track + $M8_track_offset)/$M8_pitch_track)*$M8_pitch_track)]
set count [expr 1 + int (($die_ury_track - $track_y)/$M8_pitch_track)]
remove_tracks -layer M8
create_track -layer M8  -coord $track_y -space $M8_pitch_track -dir Y -count $count


echo "M10 Track Creation ..."
set track_y [expr $core_lly_track + $M10_track_offset - (int (($core_lly_track - $die_lly_track + $M10_track_offset)/$M10_pitch_track)*$M10_pitch_track)]
set count [expr 1 + int (($die_ury_track - $track_y)/$M10_pitch_track)]
remove_tracks -layer M10
create_track -layer M10  -coord $track_y -space $M10_pitch_track -dir Y -count $count

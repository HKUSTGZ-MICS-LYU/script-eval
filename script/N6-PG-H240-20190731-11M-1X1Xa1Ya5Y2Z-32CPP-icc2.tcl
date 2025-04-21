# **********************************************************" 
# *                          DFD                           *" 
# *            Design and Technology Platform              *" 
# *                Research and Development                *" 
# *    Taiwan Semiconductor Manufacturing Co. Ltd. (tsmc)  *" 
# **********************************************************"

# Metal scheme : 1P12M_1X1Xa1Ya4Y2Yy2Z
# PG script for design with Boundary Cell


# PG script run log
set runlog pg_creation.log

redirect -file $runlog {
  echo "#########################"
  echo "##  PG script run log  ##"
  echo "#########################"
  echo ""
  echo "Date and time: [date]"
  echo ""
  echo ""
}


# PG script for design with Boundary Cell

set_host_options -max_cores 16


### Delete all PG shapes
remove_shapes [get_shapes -of_objects [get_nets VDD]]
remove_shapes [get_shapes -of_objects [get_nets VSS]]
remove_vias [get_vias -of_objects [get_nets VDD]]
remove_vias [get_vias -of_objects [get_nets VSS]]

connect_pg_net


### For PG coloring ###
set_app_options -name plan.pgroute.set_mask_fixed -value true


### Power plan structure ###
set layout_grid 0.0005
set cell_height 0.240
set cell_height_half [expr $cell_height/2]
set cell_height2 [expr 2*$cell_height]
set poly_pitch 0.057
set round_fix 0.001
set float_fix 1e-9
set boundary_pg_offset_x [expr 0.456]
set boundary_pg_offset_y [expr 0.0]

### Define first PG net type
set net_1st "VDD"
if {$net_1st eq "VDD"} {
  set net_2nd "VSS"
}
if {$net_1st eq "VSS"} {
  set net_2nd "VDD"
}

###Define chip area
set chip_llx [lindex [lindex [get_attribute [get_designs] boundary_bbox] 0] 0]
set chip_lly [lindex [lindex [get_attribute [get_designs] boundary_bbox] 0] 1]
set chip_urx [lindex [lindex [get_attribute [get_designs] boundary_bbox] 1] 0]
set chip_ury [lindex [lindex [get_attribute [get_designs] boundary_bbox] 1] 1]

###Define core area
set core_llx [lindex [lindex [get_attribute [get_core_area] bbox] 0] 0]
set core_lly [lindex [lindex [get_attribute [get_core_area] bbox] 0] 1]
set core_urx [lindex [lindex [get_attribute [get_core_area] bbox] 1] 0]
set core_ury [lindex [lindex [get_attribute [get_core_area] bbox] 1] 1]

# set core_urx 58.5
# set core_ury 49.74

set M0_pitch [get_attribute [get_layers M0] pitch]
set M1_pitch [get_attribute [get_layers M1] pitch]
set M2_pitch [get_attribute [get_layers M2] pitch]
set M3_pitch [get_attribute [get_layers M3] pitch]
set M4_pitch [get_attribute [get_layers M4] pitch]
set M5_pitch [get_attribute [get_layers M5] pitch]
set M6_pitch [get_attribute [get_layers M6] pitch]
set M7_pitch [get_attribute [get_layers M7] pitch]
set M8_pitch [get_attribute [get_layers M8] pitch]
set M9_pitch [get_attribute [get_layers M9] pitch]
set M10_pitch [get_attribute [get_layers M10] pitch]
set M11_pitch [get_attribute [get_layers M11] pitch]


set M0_width   0.060 ; set M0_step   0.4800 ; set M0_offset   0.000 ; set M0_track_offset   0.0000 ;
set M1_width   0.037 ; set M1_step   1.8240 ; set M1_offset   0.000 ; set M1_track_offset   0.0285 ;
set M2_width   0.020 ; set M2_step   0.4800 ; set M2_offset   0.000 ; set M2_track_offset   -0.020 ;
set M3_width   0.024 ; set M3_step   1.8240 ; set M3_offset   0.000 ; set M3_track_offset   0.0000 ;
set M4_width   0.038 ; set M4_step   0.9600 ; set M4_offset   0.000 ; set M4_track_offset   -0.020 ;
set M5_width   0.038 ; set M5_step   1.8240 ; set M5_offset   0.000 ; set M5_track_offset   0.0000 ;
set M6_width   0.038 ; set M6_step   0.9600 ; set M6_offset   0.000 ; set M6_track_offset   -0.020 ;
set M7_width   0.038 ; set M7_step   1.8240 ; set M7_offset   0.000 ; set M7_track_offset   0.0000 ;
set M8_width   0.038 ; set M8_step   0.9600 ; set M8_offset   0.000 ; set M8_track_offset   -0.020 ;
set M9_width   0.076 ; set M9_step   1.8240 ; set M9_offset   0.000 ; set M9_track_offset   0.0000 ;
set M10_width  0.360 ; set M10_step  7.2960 ; set M10_offset  [expr $M10_pitch*3] ; set M10_track_offset  0.0000 ;
set M11_width  3.672 ; set M11_step  10.800 ; set M11_offset  [expr $M11_pitch*5] ; set M11_track_offset  0.0000 ;


# Minimum area for each metal
set M0_area [get_attribute [get_layers M0] min_area]
set M1_area [get_attribute [get_layers M1] min_area]
set M2_area [get_attribute [get_layers M2] min_area]
set M3_area [get_attribute [get_layers M3] min_area]
set M4_area [get_attribute [get_layers M4] min_area]
set M5_area [get_attribute [get_layers M5] min_area]
set M6_area [get_attribute [get_layers M6] min_area]
set M7_area [get_attribute [get_layers M7] min_area]
set M8_area [get_attribute [get_layers M8] min_area]
set M9_area [get_attribute [get_layers M9] min_area]
set M10_area [get_attribute [get_layers M10] min_area]
set M11_area [get_attribute [get_layers M11] min_area]

# Minimum line length for each metal
set M0_min_length [expr (round($round_fix+(double(int(($M0_area/$M0_width)/$layout_grid)+1)/2)))*2*$layout_grid]
set M1_min_length [expr (round($round_fix+(double(int(($M1_area/$M1_width)/$layout_grid)+1)/2)))*2*$layout_grid]
set M2_min_length [expr (round($round_fix+(double(int(($M2_area/$M2_width)/$layout_grid)+1)/2)))*2*$layout_grid]
set M3_min_length [expr (round($round_fix+(double(int(($M3_area/$M3_width)/$layout_grid)+1)/2)))*2*$layout_grid]
set M4_min_length [expr (round($round_fix+(double(int(($M4_area/$M4_width)/$layout_grid)+1)/2)))*2*$layout_grid]
set M5_min_length [expr (round($round_fix+(double(int(($M5_area/$M5_width)/$layout_grid)+1)/2)))*2*$layout_grid]
set M6_min_length [expr (round($round_fix+(double(int(($M6_area/$M6_width)/$layout_grid)+1)/2)))*2*$layout_grid]
set M7_min_length [expr (round($round_fix+(double(int(($M7_area/$M7_width)/$layout_grid)+1)/2)))*2*$layout_grid]
set M8_min_length [expr (round($round_fix+(double(int(($M8_area/$M8_width)/$layout_grid)+1)/2)))*2*$layout_grid]
set M9_min_length [expr (round($round_fix+(double(int(($M9_area/$M9_width)/$layout_grid)+1)/2)))*2*$layout_grid]
set M10_min_length [expr (round($round_fix+(double(int(($M10_area/$M10_width)/$layout_grid)+1)/2)))*2*$layout_grid]
set M11_min_length [expr (round($round_fix+(double(int(($M11_area/$M11_width)/$layout_grid)+1)/2)))*2*$layout_grid]

#Define PG VIA cut
create_via_def -force VIA01_PG_RECT -shapes { {VIA0 {-0.01 -0.017}{0.01 0.017}} {M0 {-0.04 -0.027}{0.04 0.027}} {M1 {-0.0185 -0.037}{0.0185 0.037}} }
create_via_def -force VIA1011_PG_SQ -shapes { {VIA10 {-0.162 -1.818}{0.162 -1.494}} {VIA10 {-0.162 -0.99}{0.162 -0.666}} {VIA10 {-0.162 -0.162}{0.162 0.162}} {VIA10 {-0.162 0.666}{0.162 0.99}} {VIA10 {-0.162 1.494}{0.162 1.818}} {M10 {-0.18 -1.89}{0.18 1.89}} {M11 {-0.234 -1.836}{0.234 1.836}} }

set VIA0_master VIA01_PG_RECT
set VIA1_master VIA12_1cut_BW37_UW20
set VIA2_master VIA23_1cut_BW20_UW24
set VIA3_master VIA34_1cut_BW24_UW38_ISO
set VIA4_master VIA45_1cut_BW38_UW38_ISO
set VIA5_master VIA56_1cut_BW38_UW38_ISO
set VIA6_master VIA67_1cut_BW38_UW38_ISO
set VIA7_master VIA78_1cut_BW38_UW76_ISO
set VIA8_master VIA89_1cut_BW76_UW76
set VIA9_master VIA910_1cut
set VIA10_master VIA1011_PG_SQ


#Define PG region
set pg_llx [expr $core_llx + $boundary_pg_offset_x]
set pg_lly [expr $core_lly + $boundary_pg_offset_y]
set pg_urx [expr $core_urx - $boundary_pg_offset_x]
set pg_ury [expr $core_ury - $boundary_pg_offset_y]

if {$pg_lly < $chip_lly} {
  set pg_lly [expr $chip_lly]
}
if {$pg_ury > $chip_ury} {
  set pg_ury [expr $chip_ury]
}


###Draw tracks
# source N6-track-H240-20190731-12M-1X1Xa1Ya4Y2Yy2Z-icc2.tcl


### M0 PG
echo "Creating M0 PG..."
redirect -append -file $runlog {
  echo ""
  echo ""
  echo "Creating M0 PG..."
  echo ""
  echo ""
}

#==> draw 1st/2nd net
set m0_adjust_offset [expr $cell_height*1 + $M0_offset]
redirect -append -file $runlog {
  set bound_llx [expr $pg_llx]
  set bound_lly [expr $pg_lly]
  set bound_urx [expr $pg_urx]
  set bound_ury [expr $pg_ury]
  set bound_offset [expr $m0_adjust_offset]

 create_pg_mesh_pattern M0_mesh \
  -layers "{ {horizontal_layer: M0} {width: $M0_width} \
  {spacing: [expr $M0_step/2 - $M0_width]} {offset: $bound_offset} \
  {pitch: $M0_step} {track_alignment: track} }"

  set_pg_strategy M0_strategy \
    -polygon "{$bound_llx $bound_lly} {$bound_urx $bound_lly} \
    {$bound_urx $bound_ury} {$bound_llx $bound_ury}" \
    -pattern "{name: M0_mesh} {nets: $net_2nd $net_1st}"
  
  compile_pg -strategies {M0_strategy}
}




# M1, VIA0 PG
echo "Creating M1 & VIA0 PG..."
redirect -append -file $runlog {
  echo ""
  echo ""
  echo "Creating M1 & VIA0 PG..."
  echo ""
  echo ""
}


#==> create 1st net blockage
set M1_length [expr 0.18]
set blk_name_set [list]
set i 0 
while 1 { 
  set locate_y1 [expr $core_lly + 2*$cell_height + $M0_step*$i]
  set locate_y2 [expr $core_lly + 2*$cell_height + $M0_step*($i+1)]
  if {[expr $locate_y1 - ($M1_length/2)] > [expr $core_ury+$float_fix]} {
    set blk_llx [expr $core_llx]
    set blk_lly [expr $locate_y1 - ($M1_length/2)]
    set blk_urx [expr $core_urx]
    set blk_ury [expr $pg_ury]
    set blk_name "blockage_name_fin"
    if {[expr $blk_lly] > [expr $pg_ury-$float_fix]} {
      break
    }
    set blk_name [get_attribute [create_routing_blockage -boundary "{$blk_llx $blk_lly} {$blk_urx $blk_ury}" -layers M1 -net_types {power ground} -zero_spacing -name_prefix "blk_name"] full_name]
    lappend blk_name_set "$blk_name"
    break
  } else {
    if {$i == 0} {
      set blk_llx [expr $core_llx]
      set blk_lly [expr $pg_lly]
      set blk_urx [expr $core_urx]
      set blk_ury [expr $locate_y1 - ($M1_length/2)]
      set blk_name "blockage_name_init"
      if {[expr $blk_ury] < [expr $pg_lly+$float_fix]} {
        set blk_ury [expr $pg_lly]
      }
      set blk_name [get_attribute [create_routing_blockage -boundary "{$blk_llx $blk_lly} {$blk_urx $blk_ury}" -layers M1 -net_types {power ground} -zero_spacing -name_prefix "blk_name"] full_name]
      lappend blk_name_set "$blk_name"
    }

    set blk_llx [expr $core_llx]
    set blk_lly [expr $locate_y1 + ($M1_length/2)]
    set blk_urx [expr $core_urx]
    set blk_ury [expr $locate_y2 - ($M1_length/2)]
    set blk_name "blockage_name_$i"
    if {[expr $blk_ury] > [expr $pg_ury+$float_fix]} {
      set blk_ury [expr $pg_ury]
    }
    set blk_name [get_attribute [create_routing_blockage -boundary "{$blk_llx $blk_lly} {$blk_urx $blk_ury}" -layers M1 -net_types {power ground} -zero_spacing -name_prefix "blk_name"] full_name]
    lappend blk_name_set "$blk_name"
  }
  incr i
}

#==> draw 1st net
# M1 at center of site
set m1_left_base_offset [expr $M1_track_offset + $boundary_pg_offset_x + ($M1_pitch*3)]
set m1_adjust_offset_1st [expr $m1_left_base_offset + $M1_offset]
set m1_loc_x_1st [expr $core_llx + round($round_fix+($m1_adjust_offset_1st - $M1_track_offset)/$M1_pitch)*$M1_pitch + $M1_track_offset]

redirect -append -file $runlog {
  set bound_llx [expr $core_llx]
  set bound_lly [expr $pg_lly]
  set bound_urx [expr $pg_urx]
  set bound_ury [expr $pg_ury  - ($cell_height/2)]
  set bound_offset [expr $m1_adjust_offset_1st]

  create_pg_mesh_pattern M1_mesh_1st \
    -layers "{{vertical_layer: M1}{width: $M1_width}{spacing: [expr $M1_pitch*1]}{offset: $bound_offset}{pitch: $M1_step}{track_alignment: track}{trim: false}}"

  set_pg_strategy M1_strategy_1st \
    -polygon "{$bound_llx $bound_lly} {$bound_urx $bound_lly} {$bound_urx $bound_ury} {$bound_llx $bound_ury}" \
    -pattern "{name: M1_mesh_1st} {nets: $net_1st}"
    
  set_pg_via_master_rule VIA01_rule_1st -contact_code $VIA0_master -via_array_dimension {1 1} -cut_spacing {1 1}

  set_pg_strategy_via_rule VIA01_strategy_1st -via_rule "{{intersection : adjacent}{via_master: VIA01_rule_1st}}"
  
  compile_pg -strategies {M1_strategy_1st} -via_rule {VIA01_strategy_1st}
}

#==> remove 1st net blockage
remove_routing_blockages $blk_name_set


#==> create 2nd net blockage
set M1_length [expr 0.18]
set blk_name_set [list]
set i 0 
while 1 { 
  set locate_y1 [expr $core_lly + 1*$cell_height + $M0_step*$i]
  set locate_y2 [expr $core_lly + 1*$cell_height + $M0_step*($i+1)]
  if {[expr $locate_y1 - ($M1_length/2)] > [expr $core_ury+$float_fix]} {
    set blk_llx [expr $core_llx]
    set blk_lly [expr $locate_y1 - ($M1_length/2)]
    set blk_urx [expr $core_urx]
    set blk_ury [expr $pg_ury]
    set blk_name "blockage_name_fin"
    if {[expr $blk_lly] > [expr $pg_ury-$float_fix]} {
      break
    }
    set blk_name [get_attribute [create_routing_blockage -boundary "{$blk_llx $blk_lly} {$blk_urx $blk_ury}" -layers M1 -net_types {power ground} -zero_spacing -name_prefix "blk_name"] full_name]
    lappend blk_name_set "$blk_name"
    break
  } else {
    if {$i == 0} {
      set blk_llx [expr $core_llx]
      set blk_lly [expr $pg_lly]
      set blk_urx [expr $core_urx]
      set blk_ury [expr $locate_y1 - ($M1_length/2)]
      set blk_name "blockage_name_init"
      if {[expr $blk_ury] < [expr $pg_lly+$float_fix]} {
        set blk_ury [expr $pg_lly]
      }
      set blk_name [get_attribute [create_routing_blockage -boundary "{$blk_llx $blk_lly} {$blk_urx $blk_ury}" -layers M1 -net_types {power ground} -zero_spacing -name_prefix "blk_name"] full_name]
      lappend blk_name_set "$blk_name"
    }

    set blk_llx [expr $core_llx]
    set blk_lly [expr $locate_y1 + ($M1_length/2)]
    set blk_urx [expr $core_urx]
    set blk_ury [expr $locate_y2 - ($M1_length/2)]
    set blk_name "blockage_name_$i"
    if {[expr $blk_ury] > [expr $pg_ury+$float_fix]} {
      set blk_ury [expr $pg_ury]
    }
    set blk_name [get_attribute [create_routing_blockage -boundary "{$blk_llx $blk_lly} {$blk_urx $blk_ury}" -layers M1 -net_types {power ground} -zero_spacing -name_prefix "blk_name"] full_name]
    lappend blk_name_set "$blk_name"
  }
  incr i
}

#==> draw 2nd net
# M1 at center of site
set m1_left_base_offset [expr $M1_track_offset + $boundary_pg_offset_x + ($M1_pitch*3) + ($M1_step/2)]
set m1_adjust_offset_2nd [expr $m1_left_base_offset + $M1_offset]
set m1_loc_x_2nd [expr $core_llx + round($round_fix+($m1_adjust_offset_2nd - $M1_track_offset)/$M1_pitch)*$M1_pitch + $M1_track_offset]

redirect -append -file $runlog {
  set bound_llx [expr $core_llx]
  set bound_lly [expr $pg_lly]
  set bound_urx [expr $pg_urx]
  set bound_ury [expr $pg_ury  - ($cell_height/2)]
  set bound_offset [expr $m1_adjust_offset_2nd]

  create_pg_mesh_pattern M1_mesh_2nd \
    -layers "{{vertical_layer: M1}{width: $M1_width}{spacing: [expr $M1_pitch*1]}{offset: $bound_offset}{pitch: $M1_step}{track_alignment: track}{trim: false}}"

  set_pg_strategy M1_strategy_2nd \
    -polygon "{$bound_llx $bound_lly} {$bound_urx $bound_lly} {$bound_urx $bound_ury} {$bound_llx $bound_ury}" \
    -pattern "{name: M1_mesh_2nd} {nets: $net_2nd}"
    
  set_pg_via_master_rule VIA01_rule_2nd -contact_code $VIA0_master -via_array_dimension {1 1} -cut_spacing {1 1}

  set_pg_strategy_via_rule VIA01_strategy_2nd -via_rule "{{intersection : adjacent}{via_master: VIA01_rule_2nd}}"
  
  compile_pg -strategies {M1_strategy_2nd} -via_rule {VIA01_strategy_2nd}
}

#==> remove 2nd net blockage
remove_routing_blockages $blk_name_set


set extend [expr ($M1_length - 0.08)/2]
resize_objects [get_shapes -filter {layer_name == "M1"} -of_objects [get_net $net_1st]] -delta "{0 [expr $extend]} {0 [expr -$extend]}"
resize_objects [get_shapes -filter {layer_name == "M1"} -of_objects [get_net $net_2nd]] -delta "{0 [expr $extend]} {0 [expr -$extend]}"


# M3, VIA2 PG
echo "Creating M3 & VIA2 PG..."
redirect -append -file $runlog {
  echo ""
  echo ""
  echo "Creating M3 & VIA2 PG..."
  echo ""
  echo ""
}

redirect -append -file $runlog {
  reset_app_options plan.pgroute.maximize_total_cut_area
}


#==> draw 1st net
set m3_adjust_offset_1st [expr $m1_adjust_offset_1st + $M3_offset]
set m3_loc_x_1st [expr $core_llx + round($round_fix+($m3_adjust_offset_1st - $M3_track_offset)/$M3_pitch)*$M3_pitch + $M3_track_offset]

redirect -append -file $runlog {
  set bound_llx [expr $core_llx]
  set bound_lly [expr $pg_lly]
  set bound_urx [expr $pg_urx]
  set bound_ury [expr $pg_ury]
  set bound_offset [expr $m3_adjust_offset_1st]

  create_pg_mesh_pattern M3_mesh_1st \
    -layers "{{vertical_layer: M3}{width: $M3_width}{spacing: [expr $M3_pitch*1]}{offset: $bound_offset}{pitch: $M3_step}{track_alignment: track}{trim: false}}"

  set_pg_strategy M3_strategy_1st \
    -polygon "{$bound_llx $bound_lly} {$bound_urx $bound_lly} {$bound_urx $bound_ury} {$bound_llx $bound_ury}" \
    -pattern "{name: M3_mesh_1st} {nets: $net_1st}"
    
  set_pg_via_master_rule VIA23_rule_1st -contact_code $VIA2_master -via_array_dimension {1 1} -cut_spacing {1 1}

  set_pg_strategy_via_rule VIA23_strategy_1st -via_rule "{{intersection : adjacent}{via_master: VIA23_rule_1st}}"
  
  compile_pg -strategies {M3_strategy_1st} -via_rule {VIA23_strategy_1st}
}


#==> draw 2nd net
set m3_adjust_offset_2nd [expr $m1_adjust_offset_2nd + $M3_offset]
set m3_loc_x_2nd [expr $core_llx + round($round_fix+($m3_adjust_offset_2nd - $M3_track_offset)/$M3_pitch)*$M3_pitch + $M3_track_offset]

redirect -append -file $runlog {
  set bound_llx [expr $core_llx]
  set bound_lly [expr $pg_lly]
  set bound_urx [expr $pg_urx]
  set bound_ury [expr $pg_ury]
  set bound_offset [expr $m3_adjust_offset_2nd]

  create_pg_mesh_pattern M3_mesh_2nd \
    -layers "{{vertical_layer: M3}{width: $M3_width}{spacing: [expr $M3_pitch*1]}{offset: $bound_offset}{pitch: $M3_step}{track_alignment: track}{trim: false}}"

  set_pg_strategy M3_strategy_2nd \
    -polygon "{$bound_llx $bound_lly} {$bound_urx $bound_lly} {$bound_urx $bound_ury} {$bound_llx $bound_ury}" \
    -pattern "{name: M3_mesh_2nd} {nets: $net_2nd}"
    
  set_pg_via_master_rule VIA23_rule_2nd -contact_code $VIA2_master -via_array_dimension {1 1} -cut_spacing {1 1}

  set_pg_strategy_via_rule VIA23_strategy_2nd -via_rule "{{intersection : adjacent}{via_master: VIA23_rule_2nd}}"
  
  compile_pg -strategies {M3_strategy_2nd} -via_rule {VIA23_strategy_2nd}

}


# M2, VIA1 PG
echo "Creating M2 & VIA1 PG..."
redirect -append -file $runlog {
  echo ""
  echo ""
  echo "Creating M2 & VIA1 PG..."
  echo ""
  echo ""
}

redirect -append -file $runlog {
  reset_app_options plan.pgroute.maximize_total_cut_area
}

#==> create 1st net blockage
set M2_length [expr 0.16]
set blk_name_set [list]
set i 0 
while 1 { 
  set locate_low_x1 [expr $core_llx + round($round_fix+($m1_adjust_offset_1st-$M1_track_offset+$M1_step*$i)/$M1_pitch)*$M1_pitch + $M1_track_offset]
  set locate_low_x2 [expr $core_llx + round($round_fix+($m1_adjust_offset_1st-$M1_track_offset+$M1_step*($i+1))/$M1_pitch)*$M1_pitch + $M1_track_offset]
  set locate_high_x1 [expr $core_llx + round($round_fix+($m3_adjust_offset_1st-$M3_track_offset+$M3_step*$i)/$M3_pitch)*$M3_pitch + $M3_track_offset]
  set locate_high_x2 [expr $core_llx + round($round_fix+($m3_adjust_offset_1st-$M3_track_offset+$M3_step*($i+1))/$M3_pitch)*$M3_pitch + $M3_track_offset]
  set locate_x1 [expr ($locate_low_x1 + $locate_high_x1)/2]
  set locate_x2 [expr ($locate_low_x2 + $locate_high_x2)/2]
  if {[expr $locate_x1 - ($M2_length/2)] > [expr $pg_urx+$float_fix]} {
    set blk_llx [expr $locate_x1 - ($M2_length/2)]
    set blk_lly [expr $pg_lly]
    set blk_urx [expr $core_urx]
    set blk_ury [expr $pg_ury]
    set blk_name "blockage_name_fin"
    if {[expr $blk_llx] > [expr $core_urx-$float_fix]} {
      break
    }
    if {[expr $blk_urx] < [expr $blk_llx+$float_fix]} {
    } else {
      set blk_name [get_attribute [create_routing_blockage -boundary "{$blk_llx $blk_lly} {$blk_urx $blk_ury}" -layers M2 -net_types {power ground} -zero_spacing -name_prefix "blk_name"] full_name]
      lappend blk_name_set "$blk_name"
      break
    }
  } else {
    if {$i == 0} {
      set blk_llx [expr $core_llx]
      set blk_lly [expr $pg_lly]
      set blk_urx [expr $locate_x1 - ($M2_length/2)]
      set blk_ury [expr $pg_ury]
      set blk_name "blockage_name_init"
      if {[expr $blk_urx] < [expr $core_llx+$float_fix]} {
        break
      }
      if {[expr $blk_urx] < [expr $blk_llx+$float_fix]} {
      } else {
        set blk_name [get_attribute [create_routing_blockage -boundary "{$blk_llx $blk_lly} {$blk_urx $blk_ury}" -layers M2 -net_types {power ground} -zero_spacing -name_prefix "blk_name"] full_name]
        lappend blk_name_set "$blk_name"
      }
    }

    set blk_llx [expr $locate_x1 + ($M2_length/2)]
    set blk_lly [expr $pg_lly]
    set blk_urx [expr $locate_x2 - ($M2_length/2)]
    set blk_ury [expr $pg_ury]
    set blk_name "blockage_name_$i"
    if {[expr $blk_urx] > [expr $core_urx+$float_fix]} {
      set blk_urx [expr $core_urx]
    }
    if {[expr $blk_llx] > [expr $core_urx-$float_fix]} {
      break
    }
      set blk_name [get_attribute [create_routing_blockage -boundary "{$blk_llx $blk_lly} {$blk_urx $blk_ury}" -layers M2 -net_types {power ground} -zero_spacing -name_prefix "blk_name"] full_name]
    lappend blk_name_set "$blk_name"
  }
  incr i
}

#==> draw 1st net
set m2_adjust_offset_1st [expr $cell_height*2 + $M2_offset]
set m2_loc_y_1st [expr $core_lly + round($round_fix+($m2_adjust_offset_1st - $M2_track_offset + $M2_step*0)/$M2_pitch)*$M2_pitch + $M2_track_offset]
redirect -append -file $runlog {
  set bound_llx [expr $core_llx]
  set bound_lly [expr $core_lly]
  set bound_urx [expr $core_urx]
  set bound_ury [expr $core_ury]
  set bound_offset [expr $m2_adjust_offset_1st]

  create_pg_mesh_pattern M2_mesh_1st \
    -layers "{{horizontal_layer: M2}{width: $M2_width}{spacing: [expr $M2_pitch*1]}{offset: $bound_offset}{pitch: $M2_step}{track_alignment: track}{trim: false}}"

  set_pg_strategy M2_strategy_1st \
    -polygon "{$bound_llx $bound_lly} {$bound_urx $bound_lly} {$bound_urx $bound_ury} {$bound_llx $bound_ury}" \
    -pattern "{name: M2_mesh_1st} {nets: $net_1st}"
    
  set_pg_via_master_rule VIA12_rule_1st -contact_code $VIA1_master -via_array_dimension {1 1} -cut_spacing {1 1}
  set_pg_via_master_rule VIA23_rule_1st -contact_code $VIA2_master -via_array_dimension {1 1} -cut_spacing {1 1}

  set_pg_strategy_via_rule VIA12_strategy_1st -via_rule "{{intersection : adjacent}{via_master: VIA12_rule_1st}}"
  set_pg_strategy_via_rule VIA23_strategy_1st -via_rule "{{intersection : adjacent}{via_master: VIA23_rule_1st}}"
  
  compile_pg -strategies {M2_strategy_1st} -via_rule {VIA12_strategy_1st VIA23_strategy_1st}
}

#==> remove 1st net blockage
remove_routing_blockages $blk_name_set


#==> create 2nd net blockage
set M2_length [expr 0.16]
set blk_name_set [list]
set i 0 
while 1 { 
  set locate_low_x1 [expr $core_llx + round($round_fix+($m1_adjust_offset_2nd-$M1_track_offset+$M1_step*$i)/$M1_pitch)*$M1_pitch + $M1_track_offset]
  set locate_low_x2 [expr $core_llx + round($round_fix+($m1_adjust_offset_2nd-$M1_track_offset+$M1_step*($i+1))/$M1_pitch)*$M1_pitch + $M1_track_offset]
  set locate_high_x1 [expr $core_llx + round($round_fix+($m3_adjust_offset_2nd-$M3_track_offset+$M3_step*$i)/$M3_pitch)*$M3_pitch + $M3_track_offset]
  set locate_high_x2 [expr $core_llx + round($round_fix+($m3_adjust_offset_2nd-$M3_track_offset+$M3_step*($i+1))/$M3_pitch)*$M3_pitch + $M3_track_offset]
  set locate_x1 [expr ($locate_low_x1 + $locate_high_x1)/2]
  set locate_x2 [expr ($locate_low_x2 + $locate_high_x2)/2]
  if {[expr $locate_x1 - ($M2_length/2)] > [expr $pg_urx+$float_fix]} {
    set blk_llx [expr $locate_x1 - ($M2_length/2)]
    set blk_lly [expr $pg_lly]
    set blk_urx [expr $core_urx]
    set blk_ury [expr $pg_ury]
    set blk_name "blockage_name_fin"
    if {[expr $blk_llx] > [expr $core_urx-$float_fix]} {
      break
    }
    if {[expr $blk_urx] < [expr $blk_llx+$float_fix]} {
    } else {
      set blk_name [get_attribute [create_routing_blockage -boundary "{$blk_llx $blk_lly} {$blk_urx $blk_ury}" -layers M2 -net_types {power ground} -zero_spacing -name_prefix "blk_name"] full_name]
      lappend blk_name_set "$blk_name"
      break
    }
  } else {
    if {$i == 0} {
      set blk_llx [expr $core_llx]
      set blk_lly [expr $pg_lly]
      set blk_urx [expr $locate_x1 - ($M2_length/2)]
      set blk_ury [expr $pg_ury]
      set blk_name "blockage_name_init"
      if {[expr $blk_urx] < [expr $core_llx+$float_fix]} {
        break
      }
      if {[expr $blk_urx] < [expr $blk_llx+$float_fix]} {
      } else {
        set blk_name [get_attribute [create_routing_blockage -boundary "{$blk_llx $blk_lly} {$blk_urx $blk_ury}" -layers M2 -net_types {power ground} -zero_spacing -name_prefix "blk_name"] full_name]
        lappend blk_name_set "$blk_name"
      }
    }

    set blk_llx [expr $locate_x1 + ($M2_length/2)]
    set blk_lly [expr $pg_lly]
    set blk_urx [expr $locate_x2 - ($M2_length/2)]
    set blk_ury [expr $pg_ury]
    set blk_name "blockage_name_$i"
    if {[expr $blk_urx] > [expr $core_urx+$float_fix]} {
      set blk_urx [expr $core_urx]
    }
    if {[expr $blk_llx] > [expr $core_urx-$float_fix]} {
      break
    }
      set blk_name [get_attribute [create_routing_blockage -boundary "{$blk_llx $blk_lly} {$blk_urx $blk_ury}" -layers M2 -net_types {power ground} -zero_spacing -name_prefix "blk_name"] full_name]
    lappend blk_name_set "$blk_name"
  }
  incr i
}

#==> draw 2nd net
set m2_adjust_offset_2nd [expr $cell_height*1 + $M2_offset]
set m2_loc_y_2nd [expr $core_lly + round($round_fix+($m2_adjust_offset_2nd - $M2_track_offset + $M2_step*0)/$M2_pitch)*$M2_pitch + $M2_track_offset]
redirect -append -file $runlog {
  set bound_llx [expr $core_llx]
  set bound_lly [expr $core_lly]
  set bound_urx [expr $core_urx]
  set bound_ury [expr $core_ury]
  set bound_offset [expr $m2_adjust_offset_2nd]

  create_pg_mesh_pattern M2_mesh_2nd \
    -layers "{{horizontal_layer: M2}{width: $M2_width}{spacing: [expr $M2_pitch*1]}{offset: $bound_offset}{pitch: $M2_step}{track_alignment: track}{trim: false}}"

  set_pg_strategy M2_strategy_2nd \
    -polygon "{$bound_llx $bound_lly} {$bound_urx $bound_lly} {$bound_urx $bound_ury} {$bound_llx $bound_ury}" \
    -pattern "{name: M2_mesh_2nd} {nets: $net_2nd}"
    
  set_pg_via_master_rule VIA12_rule_2nd -contact_code $VIA1_master -via_array_dimension {1 1} -cut_spacing {1 1}
  set_pg_via_master_rule VIA23_rule_2nd -contact_code $VIA2_master -via_array_dimension {1 1} -cut_spacing {1 1}

  set_pg_strategy_via_rule VIA12_strategy_2nd -via_rule "{{intersection : adjacent}{via_master: VIA12_rule_2nd}}"
  set_pg_strategy_via_rule VIA23_strategy_2nd -via_rule "{{intersection : adjacent}{via_master: VIA23_rule_2nd}}"
  
  compile_pg -strategies {M2_strategy_2nd} -via_rule {VIA12_strategy_2nd VIA23_strategy_2nd}
}

#==> remove 1st net blockage
remove_routing_blockages $blk_name_set


# M5, VIA4 PG
echo "Creating M5 & VIA4 PG..."
redirect -append -file $runlog {
  echo ""
  echo ""
  echo "Creating M5 & VIA4 PG..."
  echo ""
  echo ""
}

redirect -append -file $runlog {
  reset_app_options plan.pgroute.maximize_total_cut_area
}

#==> create 1st net blockage
set M5_length [expr $M5_min_length]
set blk_name_set [list]
set i 0 
while 1 { 
  set locate_y1 [expr $core_lly + round($round_fix+($m2_adjust_offset_2nd - $M2_track_offset + $M2_step*2*$i)/$M2_pitch)*$M2_pitch + $M2_track_offset]
  set locate_y2 [expr $core_lly + round($round_fix+($m2_adjust_offset_2nd - $M2_track_offset + $M2_step*2*($i+1))/$M2_pitch)*$M2_pitch + $M2_track_offset]
  if {[expr $locate_y1 - ($M5_length/2)] > [expr $core_ury+$float_fix]} {
    set blk_llx [expr $core_llx]
    set blk_lly [expr $locate_y1 - ($M5_length/2)]
    set blk_urx [expr $core_urx]
    set blk_ury [expr $pg_ury]
    set blk_name "blockage_name_fin"
    if {[expr $blk_lly] > [expr $pg_ury-$float_fix]} {
      break
    }
    set blk_name [get_attribute [create_routing_blockage -boundary "{$blk_llx $blk_lly} {$blk_urx $blk_ury}" -layers M5 -net_types {power ground} -zero_spacing -name_prefix "blk_name"] full_name]
    lappend blk_name_set "$blk_name"
    break
  } else {
    if {$i == 0} {
      set blk_llx [expr $core_llx]
      set blk_lly [expr $pg_lly]
      set blk_urx [expr $core_urx]
      set blk_ury [expr $locate_y1 - ($M5_length/2)]
      set blk_name "blockage_name_init"
      if {[expr $blk_ury] < [expr $pg_lly+$float_fix]} {
        set blk_ury [expr $pg_lly]
      }
      set blk_name [get_attribute [create_routing_blockage -boundary "{$blk_llx $blk_lly} {$blk_urx $blk_ury}" -layers M5 -net_types {power ground} -zero_spacing -name_prefix "blk_name"] full_name]
      lappend blk_name_set "$blk_name"
    }

    set blk_llx [expr $core_llx]
    set blk_lly [expr $locate_y1 + ($M5_length/2)]
    set blk_urx [expr $core_urx]
    set blk_ury [expr $locate_y2 - ($M5_length/2)]
    set blk_name "blockage_name_$i"
    if {[expr $blk_ury] > [expr $pg_ury+$float_fix]} {
      set blk_ury [expr $pg_ury]
    }
    set blk_name [get_attribute [create_routing_blockage -boundary "{$blk_llx $blk_lly} {$blk_urx $blk_ury}" -layers M5 -net_types {power ground} -zero_spacing -name_prefix "blk_name"] full_name]
    lappend blk_name_set "$blk_name"
  }
  incr i
}

#==> draw 1st net
set m5_adjust_offset_1st [expr $m3_adjust_offset_1st + $M5_offset]
set m5_loc_x_1st [expr $core_llx + round($round_fix+($m5_adjust_offset_1st - $M5_track_offset)/$M5_pitch)*$M5_pitch + $M5_track_offset]

redirect -append -file $runlog {
  set bound_llx [expr $core_llx]
  set bound_lly [expr $pg_lly]
  set bound_urx [expr $pg_urx]
  set bound_ury [expr $pg_ury]
  set bound_offset [expr $m5_adjust_offset_1st]

  create_pg_mesh_pattern M5_mesh_1st \
    -layers "{{vertical_layer: M5}{width: $M5_width}{spacing: [expr $M5_pitch*1]}{offset: $bound_offset}{pitch: $M5_step}{track_alignment: track}{trim: false}}"

  set_pg_strategy M5_strategy_1st \
    -polygon "{$bound_llx $bound_lly} {$bound_urx $bound_lly} {$bound_urx $bound_ury} {$bound_llx $bound_ury}" \
    -pattern "{name: M5_mesh_1st} {nets: $net_1st}"
    
  set_pg_via_master_rule VIA45_rule_1st -contact_code $VIA4_master -via_array_dimension {1 1} -cut_spacing {1 1}

  set_pg_strategy_via_rule VIA45_strategy_1st -via_rule "{{intersection : adjacent}{via_master: VIA45_rule_1st}}"
  
  compile_pg -strategies {M5_strategy_1st} -via_rule {VIA45_strategy_1st}
}

#==> remove 1st net blockage
remove_routing_blockages $blk_name_set


#==> create 2nd net blockage
set M5_length [expr $M5_min_length]
set blk_name_set [list]
set i 0 
while 1 { 
  set locate_y1 [expr $core_lly + round($round_fix+($m2_adjust_offset_2nd - $M2_track_offset + $M2_step*2*$i)/$M2_pitch)*$M2_pitch + $M2_track_offset]
  set locate_y2 [expr $core_lly + round($round_fix+($m2_adjust_offset_2nd - $M2_track_offset + $M2_step*2*($i+1))/$M2_pitch)*$M2_pitch + $M2_track_offset]
  if {[expr $locate_y1 - ($M5_length/2)] > [expr $core_ury+$float_fix]} {
    set blk_llx [expr $core_llx]
    set blk_lly [expr $locate_y1 - ($M5_length/2)]
    set blk_urx [expr $core_urx]
    set blk_ury [expr $pg_ury]
    set blk_name "blockage_name_fin"
    if {[expr $blk_lly] > [expr $pg_ury-$float_fix]} {
      break
    }
    set blk_name [get_attribute [create_routing_blockage -boundary "{$blk_llx $blk_lly} {$blk_urx $blk_ury}" -layers M5 -net_types {power ground} -zero_spacing -name_prefix "blk_name"] full_name]
    lappend blk_name_set "$blk_name"
    break
  } else {
    if {$i == 0} {
      set blk_llx [expr $core_llx]
      set blk_lly [expr $pg_lly]
      set blk_urx [expr $core_urx]
      set blk_ury [expr $locate_y1 - ($M5_length/2)]
      set blk_name "blockage_name_init"
      if {[expr $blk_ury] < [expr $pg_lly+$float_fix]} {
        set blk_ury [expr $pg_lly]
      }
      set blk_name [get_attribute [create_routing_blockage -boundary "{$blk_llx $blk_lly} {$blk_urx $blk_ury}" -layers M5 -net_types {power ground} -zero_spacing -name_prefix "blk_name"] full_name]
      lappend blk_name_set "$blk_name"
    }

    set blk_llx [expr $core_llx]
    set blk_lly [expr $locate_y1 + ($M5_length/2)]
    set blk_urx [expr $core_urx]
    set blk_ury [expr $locate_y2 - ($M5_length/2)]
    set blk_name "blockage_name_$i"
    if {[expr $blk_ury] > [expr $pg_ury+$float_fix]} {
      set blk_ury [expr $pg_ury]
    }
    set blk_name [get_attribute [create_routing_blockage -boundary "{$blk_llx $blk_lly} {$blk_urx $blk_ury}" -layers M5 -net_types {power ground} -zero_spacing -name_prefix "blk_name"] full_name]
    lappend blk_name_set "$blk_name"
  }
  incr i
}

#==> draw 2nd net
set m5_adjust_offset_2nd [expr $m5_adjust_offset_1st + ($M5_step/2) + $M5_offset]
set m5_loc_x_2nd [expr $core_llx + round($round_fix+($m5_adjust_offset_2nd - $M5_track_offset)/$M5_pitch)*$M5_pitch + $M5_track_offset]

redirect -append -file $runlog {
  set bound_llx [expr $core_llx]
  set bound_lly [expr $pg_lly]
  set bound_urx [expr $pg_urx]
  set bound_ury [expr $pg_ury]
  set bound_offset [expr $m5_adjust_offset_2nd]

  create_pg_mesh_pattern M5_mesh_2nd \
    -layers "{{vertical_layer: M5}{width: $M5_width}{spacing: [expr $M5_pitch*1]}{offset: $bound_offset}{pitch: $M5_step}{track_alignment: track}{trim: false}}"

  set_pg_strategy M5_strategy_2nd \
    -polygon "{$bound_llx $bound_lly} {$bound_urx $bound_lly} {$bound_urx $bound_ury} {$bound_llx $bound_ury}" \
    -pattern "{name: M5_mesh_2nd} {nets: $net_2nd}"
    
  set_pg_via_master_rule VIA45_rule_2nd -contact_code $VIA4_master -via_array_dimension {1 1} -cut_spacing {1 1}

  set_pg_strategy_via_rule VIA45_strategy_2nd -via_rule "{{intersection : adjacent}{via_master: VIA45_rule_2nd}}"
  
  compile_pg -strategies {M5_strategy_2nd} -via_rule {VIA45_strategy_2nd}
}

#==> remove 2nd net blockage
remove_routing_blockages $blk_name_set


# M4, VIA3 PG
echo "Creating M4 & VIA3 PG..."
redirect -append -file $runlog {
  echo ""
  echo ""
  echo "Creating M4 & VIA3 PG..."
  echo ""
  echo ""
}

redirect -append -file $runlog {
  reset_app_options plan.pgroute.maximize_total_cut_area
}

#==> create 1st net blockage
set M4_length [expr 0.395]
set blk_name_set [list]
set i 0 
while 1 { 
  set locate_low_x1 [expr $core_llx + round($round_fix+($m3_adjust_offset_1st-$M3_track_offset+$M3_step*$i)/$M3_pitch)*$M3_pitch + $M3_track_offset]
  set locate_low_x2 [expr $core_llx + round($round_fix+($m3_adjust_offset_1st-$M3_track_offset+$M3_step*($i+1))/$M3_pitch)*$M3_pitch + $M3_track_offset]
  set locate_high_x1 [expr $core_llx + round($round_fix+($m5_adjust_offset_1st-$M5_track_offset+$M5_step*$i)/$M5_pitch)*$M5_pitch + $M5_track_offset]
  set locate_high_x2 [expr $core_llx + round($round_fix+($m5_adjust_offset_1st-$M5_track_offset+$M5_step*($i+1))/$M5_pitch)*$M5_pitch + $M5_track_offset]
  set locate_x1 [expr ($locate_low_x1 + $locate_high_x1)/2]
  set locate_x2 [expr ($locate_low_x2 + $locate_high_x2)/2]
  if {[expr $locate_x1 - ($M4_length/2)] > [expr $pg_urx+$float_fix]} {
    set blk_llx [expr $locate_x1 - ($M4_length/2)]
    set blk_lly [expr $pg_lly]
    set blk_urx [expr $core_urx]
    set blk_ury [expr $pg_ury]
    set blk_name "blockage_name_fin"
    if {[expr $blk_llx] > [expr $core_urx-$float_fix]} {
      break
    }
    if {[expr $blk_urx] < [expr $blk_llx+$float_fix]} {
    } else {
      set blk_name [get_attribute [create_routing_blockage -boundary "{$blk_llx $blk_lly} {$blk_urx $blk_ury}" -layers M4 -net_types {power ground} -zero_spacing -name_prefix "blk_name"] full_name]
      lappend blk_name_set "$blk_name"
      break
    }
  } else {
    if {$i == 0} {
      set blk_llx [expr $core_llx]
      set blk_lly [expr $pg_lly]
      set blk_urx [expr $locate_x1 - ($M4_length/2)]
      set blk_ury [expr $pg_ury]
      set blk_name "blockage_name_init"
      if {[expr $blk_urx] < [expr $core_llx+$float_fix]} {
        break
      }
      if {[expr $blk_urx] < [expr $blk_llx+$float_fix]} {
      } else {
        set blk_name [get_attribute [create_routing_blockage -boundary "{$blk_llx $blk_lly} {$blk_urx $blk_ury}" -layers M4 -net_types {power ground} -zero_spacing -name_prefix "blk_name"] full_name]
        lappend blk_name_set "$blk_name"
      }
    }

    set blk_llx [expr $locate_x1 + ($M4_length/2)]
    set blk_lly [expr $pg_lly]
    set blk_urx [expr $locate_x2 - ($M4_length/2)]
    set blk_ury [expr $pg_ury]
    set blk_name "blockage_name_$i"
    if {[expr $blk_urx] > [expr $core_urx+$float_fix]} {
      set blk_urx [expr $core_urx]
    }
    if {[expr $blk_llx] > [expr $core_urx-$float_fix]} {
      break
    }
      set blk_name [get_attribute [create_routing_blockage -boundary "{$blk_llx $blk_lly} {$blk_urx $blk_ury}" -layers M4 -net_types {power ground} -zero_spacing -name_prefix "blk_name"] full_name]
    lappend blk_name_set "$blk_name"
  }
  incr i
}

#==> draw 1st net
set m4_adjust_offset_1st [expr $m2_adjust_offset_2nd + $M4_offset]
set m4_loc_y_1st [expr $core_lly + round($round_fix+($m4_adjust_offset_1st - $M4_track_offset + $M4_step*0)/$M4_pitch)*$M4_pitch + $M4_track_offset]
redirect -append -file $runlog {
  set bound_llx [expr $core_llx]
  set bound_lly [expr $core_lly]
  set bound_urx [expr $core_urx]
  set bound_ury [expr $core_ury]
  set bound_offset [expr $m4_adjust_offset_1st]

  create_pg_mesh_pattern M4_mesh_1st \
    -layers "{{horizontal_layer: M4}{width: $M4_width}{spacing: [expr $M4_pitch*1]}{offset: $bound_offset}{pitch: $M4_step}{track_alignment: track}{trim: false}}"

  set_pg_strategy M4_strategy_1st \
    -polygon "{$bound_llx $bound_lly} {$bound_urx $bound_lly} {$bound_urx $bound_ury} {$bound_llx $bound_ury}" \
    -pattern "{name: M4_mesh_1st} {nets: $net_1st}"
    
  set_pg_via_master_rule VIA34_rule_1st -contact_code $VIA3_master -via_array_dimension {1 1} -cut_spacing {1 1}
  set_pg_via_master_rule VIA45_rule_1st -contact_code $VIA4_master -via_array_dimension {1 1} -cut_spacing {1 1}

  set_pg_strategy_via_rule VIA34_strategy_1st -via_rule "{{intersection : adjacent}{via_master: VIA34_rule_1st}}"
  set_pg_strategy_via_rule VIA45_strategy_1st -via_rule "{{intersection : adjacent}{via_master: VIA45_rule_1st}}"
  
  compile_pg -strategies {M4_strategy_1st} -via_rule {VIA34_strategy_1st VIA45_strategy_1st}
}

#==> remove 1st net blockage
remove_routing_blockages $blk_name_set


#==> create 2nd net blockage
set M4_length [expr 0.395]
set blk_name_set [list]
set i 0 
while 1 { 
  set locate_low_x1 [expr $core_llx + round($round_fix+($m3_adjust_offset_2nd-$M3_track_offset+$M3_step*$i)/$M3_pitch)*$M3_pitch + $M3_track_offset]
  set locate_low_x2 [expr $core_llx + round($round_fix+($m3_adjust_offset_2nd-$M3_track_offset+$M3_step*($i+1))/$M3_pitch)*$M3_pitch + $M3_track_offset]
  set locate_high_x1 [expr $core_llx + round($round_fix+($m5_adjust_offset_2nd-$M5_track_offset+$M5_step*$i)/$M5_pitch)*$M5_pitch + $M5_track_offset]
  set locate_high_x2 [expr $core_llx + round($round_fix+($m5_adjust_offset_2nd-$M5_track_offset+$M5_step*($i+1))/$M5_pitch)*$M5_pitch + $M5_track_offset]
  set locate_x1 [expr ($locate_low_x1 + $locate_high_x1)/2]
  set locate_x2 [expr ($locate_low_x2 + $locate_high_x2)/2]
  if {[expr $locate_x1 - ($M4_length/2)] > [expr $pg_urx+$float_fix]} {
    set blk_llx [expr $locate_x1 - ($M4_length/2)]
    set blk_lly [expr $pg_lly]
    set blk_urx [expr $core_urx]
    set blk_ury [expr $pg_ury]
    set blk_name "blockage_name_fin"
    if {[expr $blk_llx] > [expr $core_urx-$float_fix]} {
      break
    }
    if {[expr $blk_urx] < [expr $blk_llx+$float_fix]} {
    } else {
      set blk_name [get_attribute [create_routing_blockage -boundary "{$blk_llx $blk_lly} {$blk_urx $blk_ury}" -layers M4 -net_types {power ground} -zero_spacing -name_prefix "blk_name"] full_name]
      lappend blk_name_set "$blk_name"
      break
    }
  } else {
    if {$i == 0} {
      set blk_llx [expr $core_llx]
      set blk_lly [expr $pg_lly]
      set blk_urx [expr $locate_x1 - ($M4_length/2)]
      set blk_ury [expr $pg_ury]
      set blk_name "blockage_name_init"
      if {[expr $blk_urx] < [expr $core_llx+$float_fix]} {
        break
      }
      if {[expr $blk_urx] < [expr $blk_llx+$float_fix]} {
      } else {
        set blk_name [get_attribute [create_routing_blockage -boundary "{$blk_llx $blk_lly} {$blk_urx $blk_ury}" -layers M4 -net_types {power ground} -zero_spacing -name_prefix "blk_name"] full_name]
        lappend blk_name_set "$blk_name"
      }
    }

    set blk_llx [expr $locate_x1 + ($M4_length/2)]
    set blk_lly [expr $pg_lly]
    set blk_urx [expr $locate_x2 - ($M4_length/2)]
    set blk_ury [expr $pg_ury]
    set blk_name "blockage_name_$i"
    if {[expr $blk_urx] > [expr $core_urx+$float_fix]} {
      set blk_urx [expr $core_urx]
    }
    if {[expr $blk_llx] > [expr $core_urx-$float_fix]} {
      break
    }
      set blk_name [get_attribute [create_routing_blockage -boundary "{$blk_llx $blk_lly} {$blk_urx $blk_ury}" -layers M4 -net_types {power ground} -zero_spacing -name_prefix "blk_name"] full_name]
    lappend blk_name_set "$blk_name"
  }
  incr i
}

#==> draw 2nd net
set m4_adjust_offset_2nd [expr $m2_adjust_offset_2nd + $M4_offset]
set m4_loc_y_2nd [expr $core_lly + round($round_fix+($m4_adjust_offset_2nd - $M4_track_offset + $M4_step*0)/$M4_pitch)*$M4_pitch + $M4_track_offset]
redirect -append -file $runlog {
  set bound_llx [expr $core_llx]
  set bound_lly [expr $core_lly]
  set bound_urx [expr $core_urx]
  set bound_ury [expr $core_ury]
  set bound_offset [expr $m4_adjust_offset_2nd]

  create_pg_mesh_pattern M4_mesh_2nd \
    -layers "{{horizontal_layer: M4}{width: $M4_width}{spacing: [expr $M4_pitch*1]}{offset: $bound_offset}{pitch: $M4_step}{track_alignment: track}{trim: false}}"

  set_pg_strategy M4_strategy_2nd \
    -polygon "{$bound_llx $bound_lly} {$bound_urx $bound_lly} {$bound_urx $bound_ury} {$bound_llx $bound_ury}" \
    -pattern "{name: M4_mesh_2nd} {nets: $net_2nd}"
    
  set_pg_via_master_rule VIA34_rule_2nd -contact_code $VIA3_master -via_array_dimension {1 1} -cut_spacing {1 1}
  set_pg_via_master_rule VIA45_rule_2nd -contact_code $VIA4_master -via_array_dimension {1 1} -cut_spacing {1 1}

  set_pg_strategy_via_rule VIA34_strategy_2nd -via_rule "{{intersection : adjacent}{via_master: VIA34_rule_2nd}}"
  set_pg_strategy_via_rule VIA45_strategy_2nd -via_rule "{{intersection : adjacent}{via_master: VIA45_rule_2nd}}"
  
  compile_pg -strategies {M4_strategy_2nd} -via_rule {VIA34_strategy_2nd VIA45_strategy_2nd}
}

#==> remove 2nd net blockage
remove_routing_blockages $blk_name_set


# M7, VIA6 PG
echo "Creating M7 & VIA6 PG..."
redirect -append -file $runlog {
  echo ""
  echo ""
  echo "Creating M7 & VIA6 PG..."
  echo ""
  echo ""
}

redirect -append -file $runlog {
  reset_app_options plan.pgroute.maximize_total_cut_area
}

#==> create 1st net blockage
set M7_length [expr $M7_min_length]
set blk_name_set [list]
set i 0 
while 1 { 
  set locate_y1 [expr $core_lly + round($round_fix+($m2_adjust_offset_2nd - $M2_track_offset + $M2_step*2*$i)/$M2_pitch)*$M2_pitch + $M2_track_offset]
  set locate_y2 [expr $core_lly + round($round_fix+($m2_adjust_offset_2nd - $M2_track_offset + $M2_step*2*($i+1))/$M2_pitch)*$M2_pitch + $M2_track_offset]
  if {[expr $locate_y1 - ($M7_length/2)] > [expr $core_ury+$float_fix]} {
    set blk_llx [expr $core_llx]
    set blk_lly [expr $locate_y1 - ($M7_length/2)]
    set blk_urx [expr $core_urx]
    set blk_ury [expr $pg_ury]
    set blk_name "blockage_name_fin"
    if {[expr $blk_lly] > [expr $pg_ury-$float_fix]} {
      break
    }
    set blk_name [get_attribute [create_routing_blockage -boundary "{$blk_llx $blk_lly} {$blk_urx $blk_ury}" -layers M7 -net_types {power ground} -zero_spacing -name_prefix "blk_name"] full_name]
    lappend blk_name_set "$blk_name"
    break
  } else {
    if {$i == 0} {
      set blk_llx [expr $core_llx]
      set blk_lly [expr $pg_lly]
      set blk_urx [expr $core_urx]
      set blk_ury [expr $locate_y1 - ($M7_length/2)]
      set blk_name "blockage_name_init"
      if {[expr $blk_ury] < [expr $pg_lly+$float_fix]} {
        set blk_ury [expr $pg_lly]
      }
      set blk_name [get_attribute [create_routing_blockage -boundary "{$blk_llx $blk_lly} {$blk_urx $blk_ury}" -layers M7 -net_types {power ground} -zero_spacing -name_prefix "blk_name"] full_name]
      lappend blk_name_set "$blk_name"
    }

    set blk_llx [expr $core_llx]
    set blk_lly [expr $locate_y1 + ($M7_length/2)]
    set blk_urx [expr $core_urx]
    set blk_ury [expr $locate_y2 - ($M7_length/2)]
    set blk_name "blockage_name_$i"
    if {[expr $blk_ury] > [expr $pg_ury+$float_fix]} {
      set blk_ury [expr $pg_ury]
    }
    set blk_name [get_attribute [create_routing_blockage -boundary "{$blk_llx $blk_lly} {$blk_urx $blk_ury}" -layers M7 -net_types {power ground} -zero_spacing -name_prefix "blk_name"] full_name]
    lappend blk_name_set "$blk_name"
  }
  incr i
}

#==> draw 1st net
set m7_adjust_offset_1st [expr $m5_adjust_offset_1st + $M7_offset]
set m7_loc_x_1st [expr $core_llx + round($round_fix+($m7_adjust_offset_1st - $M7_track_offset)/$M7_pitch)*$M7_pitch + $M7_track_offset]

redirect -append -file $runlog {
  set bound_llx [expr $core_llx]
  set bound_lly [expr $pg_lly]
  set bound_urx [expr $pg_urx]
  set bound_ury [expr $pg_ury]
  set bound_offset [expr $m7_adjust_offset_1st]

  create_pg_mesh_pattern M7_mesh_1st \
    -layers "{{vertical_layer: M7}{width: $M7_width}{spacing: [expr $M7_pitch*1]}{offset: $bound_offset}{pitch: $M7_step}{track_alignment: track}{trim: false}}"

  set_pg_strategy M7_strategy_1st \
    -polygon "{$bound_llx $bound_lly} {$bound_urx $bound_lly} {$bound_urx $bound_ury} {$bound_llx $bound_ury}" \
    -pattern "{name: M7_mesh_1st} {nets: $net_1st}"
    
  set_pg_via_master_rule VIA67_rule_1st -contact_code $VIA6_master -via_array_dimension {1 1} -cut_spacing {1 1}

  set_pg_strategy_via_rule VIA67_strategy_1st -via_rule "{{intersection : adjacent}{via_master: VIA67_rule_1st}}"
  
  compile_pg -strategies {M7_strategy_1st} -via_rule {VIA67_strategy_1st}
}

#==> remove 1st net blockage
remove_routing_blockages $blk_name_set


#==> create 2nd net blockage
set M7_length [expr $M7_min_length]
set blk_name_set [list]
set i 0 
while 1 { 
  set locate_y1 [expr $core_lly + round($round_fix+($m2_adjust_offset_2nd - $M2_track_offset + $M2_step*2*$i)/$M2_pitch)*$M2_pitch + $M2_track_offset]
  set locate_y2 [expr $core_lly + round($round_fix+($m2_adjust_offset_2nd - $M2_track_offset + $M2_step*2*($i+1))/$M2_pitch)*$M2_pitch + $M2_track_offset]
  if {[expr $locate_y1 - ($M7_length/2)] > [expr $core_ury+$float_fix]} {
    set blk_llx [expr $core_llx]
    set blk_lly [expr $locate_y1 - ($M7_length/2)]
    set blk_urx [expr $core_urx]
    set blk_ury [expr $pg_ury]
    set blk_name "blockage_name_fin"
    if {[expr $blk_lly] > [expr $pg_ury-$float_fix]} {
      break
    }
    set blk_name [get_attribute [create_routing_blockage -boundary "{$blk_llx $blk_lly} {$blk_urx $blk_ury}" -layers M7 -net_types {power ground} -zero_spacing -name_prefix "blk_name"] full_name]
    lappend blk_name_set "$blk_name"
    break
  } else {
    if {$i == 0} {
      set blk_llx [expr $core_llx]
      set blk_lly [expr $pg_lly]
      set blk_urx [expr $core_urx]
      set blk_ury [expr $locate_y1 - ($M7_length/2)]
      set blk_name "blockage_name_init"
      if {[expr $blk_ury] < [expr $pg_lly+$float_fix]} {
        set blk_ury [expr $pg_lly]
      }
      set blk_name [get_attribute [create_routing_blockage -boundary "{$blk_llx $blk_lly} {$blk_urx $blk_ury}" -layers M7 -net_types {power ground} -zero_spacing -name_prefix "blk_name"] full_name]
      lappend blk_name_set "$blk_name"
    }

    set blk_llx [expr $core_llx]
    set blk_lly [expr $locate_y1 + ($M7_length/2)]
    set blk_urx [expr $core_urx]
    set blk_ury [expr $locate_y2 - ($M7_length/2)]
    set blk_name "blockage_name_$i"
    if {[expr $blk_ury] > [expr $pg_ury+$float_fix]} {
      set blk_ury [expr $pg_ury]
    }
    set blk_name [get_attribute [create_routing_blockage -boundary "{$blk_llx $blk_lly} {$blk_urx $blk_ury}" -layers M7 -net_types {power ground} -zero_spacing -name_prefix "blk_name"] full_name]
    lappend blk_name_set "$blk_name"
  }
  incr i
}

#==> draw 2nd net
set m7_adjust_offset_2nd [expr $m5_adjust_offset_2nd + $M7_offset]
set m7_loc_x_2nd [expr $core_llx + round($round_fix+($m7_adjust_offset_2nd - $M7_track_offset)/$M7_pitch)*$M7_pitch + $M7_track_offset]

redirect -append -file $runlog {
  set bound_llx [expr $core_llx]
  set bound_lly [expr $pg_lly]
  set bound_urx [expr $pg_urx]
  set bound_ury [expr $pg_ury]
  set bound_offset [expr $m7_adjust_offset_2nd]

  create_pg_mesh_pattern M7_mesh_2nd \
    -layers "{{vertical_layer: M7}{width: $M7_width}{spacing: [expr $M7_pitch*1]}{offset: $bound_offset}{pitch: $M7_step}{track_alignment: track}{trim: false}}"

  set_pg_strategy M7_strategy_2nd \
    -polygon "{$bound_llx $bound_lly} {$bound_urx $bound_lly} {$bound_urx $bound_ury} {$bound_llx $bound_ury}" \
    -pattern "{name: M7_mesh_2nd} {nets: $net_2nd}"
    
  set_pg_via_master_rule VIA67_rule_2nd -contact_code $VIA6_master -via_array_dimension {1 1} -cut_spacing {1 1}

  set_pg_strategy_via_rule VIA67_strategy_2nd -via_rule "{{intersection : adjacent}{via_master: VIA67_rule_2nd}}"
  
  compile_pg -strategies {M7_strategy_2nd} -via_rule {VIA67_strategy_2nd}
}

#==> remove 2nd net blockage
remove_routing_blockages $blk_name_set


# M6, VIA5 PG
echo "Creating M6 & VIA5 PG..."
redirect -append -file $runlog {
  echo ""
  echo ""
  echo "Creating M6 & VIA5 PG..."
  echo ""
  echo ""
}

redirect -append -file $runlog {
  reset_app_options plan.pgroute.maximize_total_cut_area
}

#==> create 1st net blockage
set M6_length [expr 0.395]
set blk_name_set [list]
set i 0 
while 1 { 
  set locate_low_x1 [expr $core_llx + round($round_fix+($m5_adjust_offset_1st-$M5_track_offset+$M5_step*$i)/$M5_pitch)*$M5_pitch + $M5_track_offset]
  set locate_low_x2 [expr $core_llx + round($round_fix+($m5_adjust_offset_1st-$M5_track_offset+$M5_step*($i+1))/$M5_pitch)*$M5_pitch + $M5_track_offset]
  set locate_high_x1 [expr $core_llx + round($round_fix+($m7_adjust_offset_1st-$M7_track_offset+$M7_step*$i)/$M7_pitch)*$M7_pitch + $M7_track_offset]
  set locate_high_x2 [expr $core_llx + round($round_fix+($m7_adjust_offset_1st-$M7_track_offset+$M7_step*($i+1))/$M7_pitch)*$M7_pitch + $M7_track_offset]
  set locate_x1 [expr ($locate_low_x1 + $locate_high_x1)/2]
  set locate_x2 [expr ($locate_low_x2 + $locate_high_x2)/2]
  if {[expr $locate_x1 - ($M6_length/2)] > [expr $pg_urx+$float_fix]} {
    set blk_llx [expr $locate_x1 - ($M6_length/2)]
    set blk_lly [expr $pg_lly]
    set blk_urx [expr $core_urx]
    set blk_ury [expr $pg_ury]
    set blk_name "blockage_name_fin"
    if {[expr $blk_llx] > [expr $core_urx-$float_fix]} {
      break
    }
    if {[expr $blk_urx] < [expr $blk_llx+$float_fix]} {
    } else {
      set blk_name [get_attribute [create_routing_blockage -boundary "{$blk_llx $blk_lly} {$blk_urx $blk_ury}" -layers M6 -net_types {power ground} -zero_spacing -name_prefix "blk_name"] full_name]
      lappend blk_name_set "$blk_name"
      break
    }
  } else {
    if {$i == 0} {
      set blk_llx [expr $core_llx]
      set blk_lly [expr $pg_lly]
      set blk_urx [expr $locate_x1 - ($M6_length/2)]
      set blk_ury [expr $pg_ury]
      set blk_name "blockage_name_init"
      if {[expr $blk_urx] < [expr $core_llx+$float_fix]} {
        break
      }
      if {[expr $blk_urx] < [expr $blk_llx+$float_fix]} {
      } else {
        set blk_name [get_attribute [create_routing_blockage -boundary "{$blk_llx $blk_lly} {$blk_urx $blk_ury}" -layers M6 -net_types {power ground} -zero_spacing -name_prefix "blk_name"] full_name]
        lappend blk_name_set "$blk_name"
      }
    }

    set blk_llx [expr $locate_x1 + ($M6_length/2)]
    set blk_lly [expr $pg_lly]
    set blk_urx [expr $locate_x2 - ($M6_length/2)]
    set blk_ury [expr $pg_ury]
    set blk_name "blockage_name_$i"
    if {[expr $blk_urx] > [expr $core_urx+$float_fix]} {
      set blk_urx [expr $core_urx]
    }
    if {[expr $blk_llx] > [expr $core_urx-$float_fix]} {
      break
    }
      set blk_name [get_attribute [create_routing_blockage -boundary "{$blk_llx $blk_lly} {$blk_urx $blk_ury}" -layers M6 -net_types {power ground} -zero_spacing -name_prefix "blk_name"] full_name]
    lappend blk_name_set "$blk_name"
  }
  incr i
}

#==> draw 1st net
set m6_adjust_offset_1st [expr $m4_adjust_offset_1st + $M6_offset]
set m6_loc_y_1st [expr $core_lly + round($round_fix+($m6_adjust_offset_1st - $M6_track_offset + $M6_step*0)/$M6_pitch)*$M6_pitch + $M6_track_offset]
redirect -append -file $runlog {
  set bound_llx [expr $core_llx]
  set bound_lly [expr $core_lly]
  set bound_urx [expr $core_urx]
  set bound_ury [expr $core_ury]
  set bound_offset [expr $m6_adjust_offset_1st]

  create_pg_mesh_pattern M6_mesh_1st \
    -layers "{{horizontal_layer: M6}{width: $M6_width}{spacing: [expr $M6_pitch*1]}{offset: $bound_offset}{pitch: $M6_step}{track_alignment: track}{trim: false}}"

  set_pg_strategy M6_strategy_1st \
    -polygon "{$bound_llx $bound_lly} {$bound_urx $bound_lly} {$bound_urx $bound_ury} {$bound_llx $bound_ury}" \
    -pattern "{name: M6_mesh_1st} {nets: $net_1st}"
    
  set_pg_via_master_rule VIA56_rule_1st -contact_code $VIA5_master -via_array_dimension {1 1} -cut_spacing {1 1}
  set_pg_via_master_rule VIA67_rule_1st -contact_code $VIA6_master -via_array_dimension {1 1} -cut_spacing {1 1}

  set_pg_strategy_via_rule VIA56_strategy_1st -via_rule "{{intersection : adjacent}{via_master: VIA56_rule_1st}}"
  set_pg_strategy_via_rule VIA67_strategy_1st -via_rule "{{intersection : adjacent}{via_master: VIA67_rule_1st}}"
  
  compile_pg -strategies {M6_strategy_1st} -via_rule {VIA56_strategy_1st VIA67_strategy_1st}
}

#==> remove 1st net blockage
remove_routing_blockages $blk_name_set


#==> create 2nd net blockage
set M6_length [expr 0.395]
set blk_name_set [list]
set i 0 
while 1 { 
  set locate_low_x1 [expr $core_llx + round($round_fix+($m5_adjust_offset_2nd-$M5_track_offset+$M5_step*$i)/$M5_pitch)*$M5_pitch + $M5_track_offset]
  set locate_low_x2 [expr $core_llx + round($round_fix+($m5_adjust_offset_2nd-$M5_track_offset+$M5_step*($i+1))/$M5_pitch)*$M5_pitch + $M5_track_offset]
  set locate_high_x1 [expr $core_llx + round($round_fix+($m7_adjust_offset_2nd-$M7_track_offset+$M7_step*$i)/$M7_pitch)*$M7_pitch + $M7_track_offset]
  set locate_high_x2 [expr $core_llx + round($round_fix+($m7_adjust_offset_2nd-$M7_track_offset+$M7_step*($i+1))/$M7_pitch)*$M7_pitch + $M7_track_offset]
  set locate_x1 [expr ($locate_low_x1 + $locate_high_x1)/2]
  set locate_x2 [expr ($locate_low_x2 + $locate_high_x2)/2]
  if {[expr $locate_x1 - ($M6_length/2)] > [expr $pg_urx+$float_fix]} {
    set blk_llx [expr $locate_x1 - ($M6_length/2)]
    set blk_lly [expr $pg_lly]
    set blk_urx [expr $core_urx]
    set blk_ury [expr $pg_ury]
    set blk_name "blockage_name_fin"
    if {[expr $blk_llx] > [expr $core_urx-$float_fix]} {
      break
    }
    if {[expr $blk_urx] < [expr $blk_llx+$float_fix]} {
    } else {
      set blk_name [get_attribute [create_routing_blockage -boundary "{$blk_llx $blk_lly} {$blk_urx $blk_ury}" -layers M6 -net_types {power ground} -zero_spacing -name_prefix "blk_name"] full_name]
      lappend blk_name_set "$blk_name"
      break
    }
  } else {
    if {$i == 0} {
      set blk_llx [expr $core_llx]
      set blk_lly [expr $pg_lly]
      set blk_urx [expr $locate_x1 - ($M6_length/2)]
      set blk_ury [expr $pg_ury]
      set blk_name "blockage_name_init"
      if {[expr $blk_urx] < [expr $core_llx+$float_fix]} {
        break
      }
      if {[expr $blk_urx] < [expr $blk_llx+$float_fix]} {
      } else {
        set blk_name [get_attribute [create_routing_blockage -boundary "{$blk_llx $blk_lly} {$blk_urx $blk_ury}" -layers M6 -net_types {power ground} -zero_spacing -name_prefix "blk_name"] full_name]
        lappend blk_name_set "$blk_name"
      }
    }

    set blk_llx [expr $locate_x1 + ($M6_length/2)]
    set blk_lly [expr $pg_lly]
    set blk_urx [expr $locate_x2 - ($M6_length/2)]
    set blk_ury [expr $pg_ury]
    set blk_name "blockage_name_$i"
    if {[expr $blk_urx] > [expr $core_urx+$float_fix]} {
      set blk_urx [expr $core_urx]
    }
    if {[expr $blk_llx] > [expr $core_urx-$float_fix]} {
      break
    }
      set blk_name [get_attribute [create_routing_blockage -boundary "{$blk_llx $blk_lly} {$blk_urx $blk_ury}" -layers M6 -net_types {power ground} -zero_spacing -name_prefix "blk_name"] full_name]
    lappend blk_name_set "$blk_name"
  }
  incr i
}

#==> draw 2nd net
set m6_adjust_offset_2nd [expr $m4_adjust_offset_2nd + $M6_offset]
set m6_loc_y_2nd [expr $core_lly + round($round_fix+($m6_adjust_offset_2nd - $M6_track_offset + $M6_step*0)/$M6_pitch)*$M6_pitch + $M6_track_offset]
redirect -append -file $runlog {
  set bound_llx [expr $core_llx]
  set bound_lly [expr $core_lly]
  set bound_urx [expr $core_urx]
  set bound_ury [expr $core_ury]
  set bound_offset [expr $m6_adjust_offset_2nd]

  create_pg_mesh_pattern M6_mesh_2nd \
    -layers "{{horizontal_layer: M6}{width: $M6_width}{spacing: [expr $M6_pitch*1]}{offset: $bound_offset}{pitch: $M6_step}{track_alignment: track}{trim: false}}"

  set_pg_strategy M6_strategy_2nd \
    -polygon "{$bound_llx $bound_lly} {$bound_urx $bound_lly} {$bound_urx $bound_ury} {$bound_llx $bound_ury}" \
    -pattern "{name: M6_mesh_2nd} {nets: $net_2nd}"
    
  set_pg_via_master_rule VIA56_rule_2nd -contact_code $VIA5_master -via_array_dimension {1 1} -cut_spacing {1 1}
  set_pg_via_master_rule VIA67_rule_2nd -contact_code $VIA6_master -via_array_dimension {1 1} -cut_spacing {1 1}

  set_pg_strategy_via_rule VIA56_strategy_2nd -via_rule "{{intersection : adjacent}{via_master: VIA56_rule_2nd}}"
  set_pg_strategy_via_rule VIA67_strategy_2nd -via_rule "{{intersection : adjacent}{via_master: VIA67_rule_2nd}}"
  
  compile_pg -strategies {M6_strategy_2nd} -via_rule {VIA56_strategy_2nd VIA67_strategy_2nd}
}

#==> remove 1st net blockage
remove_routing_blockages $blk_name_set


# M9, VIA8 PG
echo "Creating M9 & VIA8 PG..."
redirect -append -file $runlog {
  echo ""
  echo ""
  echo "Creating M9 & VIA8 PG..."
  echo ""
  echo ""
}

redirect -append -file $runlog {
  reset_app_options plan.pgroute.maximize_total_cut_area
}

#==> create 1st net blockage
set M9_length [expr $M9_min_length]
set blk_name_set [list]
set i 0 
while 1 { 
  set locate_y1 [expr $core_lly + round($round_fix+($m2_adjust_offset_2nd - $M2_track_offset + $M2_step*2*$i)/$M2_pitch)*$M2_pitch + $M2_track_offset]
  set locate_y2 [expr $core_lly + round($round_fix+($m2_adjust_offset_2nd - $M2_track_offset + $M2_step*2*($i+1))/$M2_pitch)*$M2_pitch + $M2_track_offset]
  if {[expr $locate_y1 - ($M9_length/2)] > [expr $core_ury+$float_fix]} {
    set blk_llx [expr $core_llx]
    set blk_lly [expr $locate_y1 - ($M9_length/2)]
    set blk_urx [expr $core_urx]
    set blk_ury [expr $pg_ury]
    set blk_name "blockage_name_fin"
    if {[expr $blk_lly] > [expr $pg_ury-$float_fix]} {
      break
    }
    set blk_name [get_attribute [create_routing_blockage -boundary "{$blk_llx $blk_lly} {$blk_urx $blk_ury}" -layers M9 -net_types {power ground} -zero_spacing -name_prefix "blk_name"] full_name]
    lappend blk_name_set "$blk_name"
    break
  } else {
    if {$i == 0} {
      set blk_llx [expr $core_llx]
      set blk_lly [expr $pg_lly]
      set blk_urx [expr $core_urx]
      set blk_ury [expr $locate_y1 - ($M9_length/2)]
      set blk_name "blockage_name_init"
      if {[expr $blk_ury] < [expr $pg_lly+$float_fix]} {
        set blk_ury [expr $pg_lly]
      }
      set blk_name [get_attribute [create_routing_blockage -boundary "{$blk_llx $blk_lly} {$blk_urx $blk_ury}" -layers M9 -net_types {power ground} -zero_spacing -name_prefix "blk_name"] full_name]
      lappend blk_name_set "$blk_name"
    }

    set blk_llx [expr $core_llx]
    set blk_lly [expr $locate_y1 + ($M9_length/2)]
    set blk_urx [expr $core_urx]
    set blk_ury [expr $locate_y2 - ($M9_length/2)]
    set blk_name "blockage_name_$i"
    if {[expr $blk_ury] > [expr $pg_ury+$float_fix]} {
      set blk_ury [expr $pg_ury]
    }
    set blk_name [get_attribute [create_routing_blockage -boundary "{$blk_llx $blk_lly} {$blk_urx $blk_ury}" -layers M9 -net_types {power ground} -zero_spacing -name_prefix "blk_name"] full_name]
    lappend blk_name_set "$blk_name"
  }
  incr i
}

#==> draw 1st net
set m9_adjust_offset_1st [expr $m5_adjust_offset_1st + $M9_offset]
set m9_loc_x_1st [expr $core_llx + round($round_fix+($m9_adjust_offset_1st - $M9_track_offset)/$M9_pitch)*$M9_pitch + $M9_track_offset]

redirect -append -file $runlog {
  set bound_llx [expr $core_llx]
  set bound_lly [expr $pg_lly]
  set bound_urx [expr $pg_urx]
  set bound_ury [expr $pg_ury]
  set bound_offset [expr $m9_adjust_offset_1st]

  create_pg_mesh_pattern M9_mesh_1st \
    -layers "{{vertical_layer: M9}{width: $M9_width}{spacing: [expr $M9_pitch*1]}{offset: $bound_offset}{pitch: $M9_step}{track_alignment: track}{trim: false}}"

  set_pg_strategy M9_strategy_1st \
    -polygon "{$bound_llx $bound_lly} {$bound_urx $bound_lly} {$bound_urx $bound_ury} {$bound_llx $bound_ury}" \
    -pattern "{name: M9_mesh_1st} {nets: $net_1st}"
    
  set_pg_via_master_rule VIA89_rule_1st -contact_code $VIA8_master -via_array_dimension {1 1} -cut_spacing {1 1}

  set_pg_strategy_via_rule VIA89_strategy_1st -via_rule "{{intersection : adjacent}{via_master: VIA89_rule_1st}}"
  
  compile_pg -strategies {M9_strategy_1st} -via_rule {VIA89_strategy_1st}
}

#==> remove 1st net blockage
remove_routing_blockages $blk_name_set


#==> create 2nd net blockage
set M9_length [expr $M9_min_length]
set blk_name_set [list]
set i 0 
while 1 { 
  set locate_y1 [expr $core_lly + round($round_fix+($m2_adjust_offset_2nd - $M2_track_offset + $M2_step*2*$i)/$M2_pitch)*$M2_pitch + $M2_track_offset]
  set locate_y2 [expr $core_lly + round($round_fix+($m2_adjust_offset_2nd - $M2_track_offset + $M2_step*2*($i+1))/$M2_pitch)*$M2_pitch + $M2_track_offset]
  if {[expr $locate_y1 - ($M9_length/2)] > [expr $core_ury+$float_fix]} {
    set blk_llx [expr $core_llx]
    set blk_lly [expr $locate_y1 - ($M9_length/2)]
    set blk_urx [expr $core_urx]
    set blk_ury [expr $pg_ury]
    set blk_name "blockage_name_fin"
    if {[expr $blk_lly] > [expr $pg_ury-$float_fix]} {
      break
    }
    set blk_name [get_attribute [create_routing_blockage -boundary "{$blk_llx $blk_lly} {$blk_urx $blk_ury}" -layers M9 -net_types {power ground} -zero_spacing -name_prefix "blk_name"] full_name]
    lappend blk_name_set "$blk_name"
    break
  } else {
    if {$i == 0} {
      set blk_llx [expr $core_llx]
      set blk_lly [expr $pg_lly]
      set blk_urx [expr $core_urx]
      set blk_ury [expr $locate_y1 - ($M9_length/2)]
      set blk_name "blockage_name_init"
      if {[expr $blk_ury] < [expr $pg_lly+$float_fix]} {
        set blk_ury [expr $pg_lly]
      }
      set blk_name [get_attribute [create_routing_blockage -boundary "{$blk_llx $blk_lly} {$blk_urx $blk_ury}" -layers M9 -net_types {power ground} -zero_spacing -name_prefix "blk_name"] full_name]
      lappend blk_name_set "$blk_name"
    }

    set blk_llx [expr $core_llx]
    set blk_lly [expr $locate_y1 + ($M9_length/2)]
    set blk_urx [expr $core_urx]
    set blk_ury [expr $locate_y2 - ($M9_length/2)]
    set blk_name "blockage_name_$i"
    if {[expr $blk_ury] > [expr $pg_ury+$float_fix]} {
      set blk_ury [expr $pg_ury]
    }
    set blk_name [get_attribute [create_routing_blockage -boundary "{$blk_llx $blk_lly} {$blk_urx $blk_ury}" -layers M9 -net_types {power ground} -zero_spacing -name_prefix "blk_name"] full_name]
    lappend blk_name_set "$blk_name"
  }
  incr i
}

#==> draw 2nd net
set m9_adjust_offset_2nd [expr $m5_adjust_offset_2nd + $M9_offset]
set m9_loc_x_2nd [expr $core_llx + round($round_fix+($m9_adjust_offset_2nd - $M9_track_offset)/$M9_pitch)*$M9_pitch + $M9_track_offset]

redirect -append -file $runlog {
  set bound_llx [expr $core_llx]
  set bound_lly [expr $pg_lly]
  set bound_urx [expr $pg_urx]
  set bound_ury [expr $pg_ury]
  set bound_offset [expr $m9_adjust_offset_2nd]

  create_pg_mesh_pattern M9_mesh_2nd \
    -layers "{{vertical_layer: M9}{width: $M9_width}{spacing: [expr $M9_pitch*1]}{offset: $bound_offset}{pitch: $M9_step}{track_alignment: track}{trim: false}}"

  set_pg_strategy M9_strategy_2nd \
    -polygon "{$bound_llx $bound_lly} {$bound_urx $bound_lly} {$bound_urx $bound_ury} {$bound_llx $bound_ury}" \
    -pattern "{name: M9_mesh_2nd} {nets: $net_2nd}"
    
  set_pg_via_master_rule VIA89_rule_2nd -contact_code $VIA8_master -via_array_dimension {1 1} -cut_spacing {1 1}

  set_pg_strategy_via_rule VIA89_strategy_2nd -via_rule "{{intersection : adjacent}{via_master: VIA89_rule_2nd}}"
  
  compile_pg -strategies {M9_strategy_2nd} -via_rule {VIA89_strategy_2nd}
}

#==> remove 2nd net blockage
remove_routing_blockages $blk_name_set


# M8, VIA7 PG
echo "Creating M8 & VIA7 PG..."
redirect -append -file $runlog {
  echo ""
  echo ""
  echo "Creating M8 & VIA7 PG..."
  echo ""
  echo ""
}

redirect -append -file $runlog {
  reset_app_options plan.pgroute.maximize_total_cut_area
}

#==> create 1st net blockage
set M8_length [expr 0.35]
set blk_name_set [list]
set i 0 
while 1 { 
  set locate_low_x1 [expr $core_llx + round($round_fix+($m7_adjust_offset_1st-$M7_track_offset+$M7_step*$i)/$M7_pitch)*$M7_pitch + $M7_track_offset]
  set locate_low_x2 [expr $core_llx + round($round_fix+($m7_adjust_offset_1st-$M7_track_offset+$M7_step*($i+1))/$M7_pitch)*$M7_pitch + $M7_track_offset]
  set locate_high_x1 [expr $core_llx + round($round_fix+($m9_adjust_offset_1st-$M9_track_offset+$M9_step*$i)/$M9_pitch)*$M9_pitch + $M9_track_offset]
  set locate_high_x2 [expr $core_llx + round($round_fix+($m9_adjust_offset_1st-$M9_track_offset+$M9_step*($i+1))/$M9_pitch)*$M9_pitch + $M9_track_offset]
  set locate_x1 [expr ($locate_low_x1 + $locate_high_x1)/2]
  set locate_x2 [expr ($locate_low_x2 + $locate_high_x2)/2]
  if {[expr $locate_x1 - ($M8_length/2)] > [expr $pg_urx+$float_fix]} {
    set blk_llx [expr $locate_x1 - ($M8_length/2)]
    set blk_lly [expr $pg_lly]
    set blk_urx [expr $core_urx]
    set blk_ury [expr $pg_ury]
    set blk_name "blockage_name_fin"
    if {[expr $blk_llx] > [expr $core_urx-$float_fix]} {
      break
    }
    if {[expr $blk_urx] < [expr $blk_llx+$float_fix]} {
    } else {
      set blk_name [get_attribute [create_routing_blockage -boundary "{$blk_llx $blk_lly} {$blk_urx $blk_ury}" -layers M8 -net_types {power ground} -zero_spacing -name_prefix "blk_name"] full_name]
      lappend blk_name_set "$blk_name"
      break
    }
  } else {
    if {$i == 0} {
      set blk_llx [expr $core_llx]
      set blk_lly [expr $pg_lly]
      set blk_urx [expr $locate_x1 - ($M8_length/2)]
      set blk_ury [expr $pg_ury]
      set blk_name "blockage_name_init"
      if {[expr $blk_urx] < [expr $core_llx+$float_fix]} {
        break
      }
      if {[expr $blk_urx] < [expr $blk_llx+$float_fix]} {
      } else {
        set blk_name [get_attribute [create_routing_blockage -boundary "{$blk_llx $blk_lly} {$blk_urx $blk_ury}" -layers M8 -net_types {power ground} -zero_spacing -name_prefix "blk_name"] full_name]
        lappend blk_name_set "$blk_name"
      }
    }

    set blk_llx [expr $locate_x1 + ($M8_length/2)]
    set blk_lly [expr $pg_lly]
    set blk_urx [expr $locate_x2 - ($M8_length/2)]
    set blk_ury [expr $pg_ury]
    set blk_name "blockage_name_$i"
    if {[expr $blk_urx] > [expr $core_urx+$float_fix]} {
      set blk_urx [expr $core_urx]
    }
    if {[expr $blk_llx] > [expr $core_urx-$float_fix]} {
      break
    }
      set blk_name [get_attribute [create_routing_blockage -boundary "{$blk_llx $blk_lly} {$blk_urx $blk_ury}" -layers M8 -net_types {power ground} -zero_spacing -name_prefix "blk_name"] full_name]
    lappend blk_name_set "$blk_name"
  }
  incr i
}

#==> draw 1st net
set m8_adjust_offset_1st [expr $m6_adjust_offset_1st + $M8_offset]
set m8_loc_y_1st [expr $core_lly + round($round_fix+($m8_adjust_offset_1st - $M8_track_offset + $M8_step*0)/$M8_pitch)*$M8_pitch + $M8_track_offset]
redirect -append -file $runlog {
  set bound_llx [expr $core_llx]
  set bound_lly [expr $core_lly]
  set bound_urx [expr $core_urx]
  set bound_ury [expr $core_ury]
  set bound_offset [expr $m8_adjust_offset_1st]

  create_pg_mesh_pattern M8_mesh_1st \
    -layers "{{horizontal_layer: M8}{width: $M8_width}{spacing: [expr $M8_pitch*1]}{offset: $bound_offset}{pitch: $M8_step}{track_alignment: half_track}{trim: false}}"

  set_pg_strategy M8_strategy_1st \
    -polygon "{$bound_llx $bound_lly} {$bound_urx $bound_lly} {$bound_urx $bound_ury} {$bound_llx $bound_ury}" \
    -pattern "{name: M8_mesh_1st} {nets: $net_1st}"
    
  set_pg_via_master_rule VIA78_rule_1st -contact_code $VIA7_master -via_array_dimension {1 1} -cut_spacing {1 1}
  set_pg_via_master_rule VIA89_rule_1st -contact_code $VIA8_master -via_array_dimension {1 1} -cut_spacing {1 1}

  set_pg_strategy_via_rule VIA78_strategy_1st -via_rule "{{intersection : adjacent}{via_master: VIA78_rule_1st}}"
  set_pg_strategy_via_rule VIA89_strategy_1st -via_rule "{{intersection : adjacent}{via_master: VIA89_rule_1st}}"
  
  compile_pg -strategies {M8_strategy_1st} -via_rule {VIA78_strategy_1st VIA89_strategy_1st}
}

#==> remove 1st net blockage
remove_routing_blockages $blk_name_set


#==> create 2nd net blockage
set M8_length [expr 0.35]
set blk_name_set [list]
set i 0 
while 1 { 
  set locate_low_x1 [expr $core_llx + round($round_fix+($m7_adjust_offset_2nd-$M7_track_offset+$M7_step*$i)/$M7_pitch)*$M7_pitch + $M7_track_offset]
  set locate_low_x2 [expr $core_llx + round($round_fix+($m7_adjust_offset_2nd-$M7_track_offset+$M7_step*($i+1))/$M7_pitch)*$M7_pitch + $M7_track_offset]
  set locate_high_x1 [expr $core_llx + round($round_fix+($m9_adjust_offset_2nd-$M9_track_offset+$M9_step*$i)/$M9_pitch)*$M9_pitch + $M9_track_offset]
  set locate_high_x2 [expr $core_llx + round($round_fix+($m9_adjust_offset_2nd-$M9_track_offset+$M9_step*($i+1))/$M9_pitch)*$M9_pitch + $M9_track_offset]
  set locate_x1 [expr ($locate_low_x1 + $locate_high_x1)/2]
  set locate_x2 [expr ($locate_low_x2 + $locate_high_x2)/2]
  if {[expr $locate_x1 - ($M8_length/2)] > [expr $pg_urx+$float_fix]} {
    set blk_llx [expr $locate_x1 - ($M8_length/2)]
    set blk_lly [expr $pg_lly]
    set blk_urx [expr $core_urx]
    set blk_ury [expr $pg_ury]
    set blk_name "blockage_name_fin"
    if {[expr $blk_llx] > [expr $core_urx-$float_fix]} {
      break
    }
    if {[expr $blk_urx] < [expr $blk_llx+$float_fix]} {
    } else {
      set blk_name [get_attribute [create_routing_blockage -boundary "{$blk_llx $blk_lly} {$blk_urx $blk_ury}" -layers M8 -net_types {power ground} -zero_spacing -name_prefix "blk_name"] full_name]
      lappend blk_name_set "$blk_name"
      break
    }
  } else {
    if {$i == 0} {
      set blk_llx [expr $core_llx]
      set blk_lly [expr $pg_lly]
      set blk_urx [expr $locate_x1 - ($M8_length/2)]
      set blk_ury [expr $pg_ury]
      set blk_name "blockage_name_init"
      if {[expr $blk_urx] < [expr $core_llx+$float_fix]} {
        break
      }
      if {[expr $blk_urx] < [expr $blk_llx+$float_fix]} {
      } else {
        set blk_name [get_attribute [create_routing_blockage -boundary "{$blk_llx $blk_lly} {$blk_urx $blk_ury}" -layers M8 -net_types {power ground} -zero_spacing -name_prefix "blk_name"] full_name]
        lappend blk_name_set "$blk_name"
      }
    }

    set blk_llx [expr $locate_x1 + ($M8_length/2)]
    set blk_lly [expr $pg_lly]
    set blk_urx [expr $locate_x2 - ($M8_length/2)]
    set blk_ury [expr $pg_ury]
    set blk_name "blockage_name_$i"
    if {[expr $blk_urx] > [expr $core_urx+$float_fix]} {
      set blk_urx [expr $core_urx]
    }
    if {[expr $blk_llx] > [expr $core_urx-$float_fix]} {
      break
    }
      set blk_name [get_attribute [create_routing_blockage -boundary "{$blk_llx $blk_lly} {$blk_urx $blk_ury}" -layers M8 -net_types {power ground} -zero_spacing -name_prefix "blk_name"] full_name]
    lappend blk_name_set "$blk_name"
  }
  incr i
}

#==> draw 2nd net
set m8_adjust_offset_2nd [expr $m6_adjust_offset_2nd + $M8_offset]
set m8_loc_y_2nd [expr $core_lly + round($round_fix+($m8_adjust_offset_2nd - $M8_track_offset + $M8_step*0)/$M8_pitch)*$M8_pitch + $M8_track_offset]
redirect -append -file $runlog {
  set bound_llx [expr $core_llx]
  set bound_lly [expr $core_lly]
  set bound_urx [expr $core_urx]
  set bound_ury [expr $core_ury]
  set bound_offset [expr $m8_adjust_offset_2nd]

  create_pg_mesh_pattern M8_mesh_2nd \
    -layers "{{horizontal_layer: M8}{width: $M8_width}{spacing: [expr $M8_pitch*1]}{offset: $bound_offset}{pitch: $M8_step}{track_alignment: half_track}{trim: false}}"

  set_pg_strategy M8_strategy_2nd \
    -polygon "{$bound_llx $bound_lly} {$bound_urx $bound_lly} {$bound_urx $bound_ury} {$bound_llx $bound_ury}" \
    -pattern "{name: M8_mesh_2nd} {nets: $net_2nd}"
    
  set_pg_via_master_rule VIA78_rule_2nd -contact_code $VIA7_master -via_array_dimension {1 1} -cut_spacing {1 1}
  set_pg_via_master_rule VIA89_rule_2nd -contact_code $VIA8_master -via_array_dimension {1 1} -cut_spacing {1 1}

  set_pg_strategy_via_rule VIA78_strategy_2nd -via_rule "{{intersection : adjacent}{via_master: VIA78_rule_2nd}}"
  set_pg_strategy_via_rule VIA89_strategy_2nd -via_rule "{{intersection : adjacent}{via_master: VIA89_rule_2nd}}"
  
  compile_pg -strategies {M8_strategy_2nd} -via_rule {VIA78_strategy_2nd VIA89_strategy_2nd}
}

#==> remove 1st net blockage
remove_routing_blockages $blk_name_set


# M10, VIA9 PG
echo "Creating M10 & VIA9 PG..."
redirect -append -file $runlog {
  echo ""
  echo ""
  echo "Creating M10 & VIA9 PG..."
  echo ""
  echo ""
}

redirect -append -file $runlog {
  reset_app_options plan.pgroute.maximize_total_cut_area
}

#==> draw 1st net
set m10_adjust_offset_1st [expr $M10_offset]
set m10_loc_y_1st [expr $core_lly + round($round_fix+($m10_adjust_offset_1st - $M10_track_offset + $M10_step*0)/$M10_pitch)*$M10_pitch + $M10_track_offset]
redirect -append -file $runlog {
  set bound_llx [expr $core_llx]
  set bound_lly [expr $core_lly]
  set bound_urx [expr $core_urx]
  set bound_ury [expr $core_ury]
  set bound_offset [expr $m10_adjust_offset_1st - ($M10_pitch*3)]

  create_pg_mesh_pattern M10_mesh_1st \
    -layers "{{horizontal_layer: M10}{width: $M10_width}{spacing: [expr $M10_pitch*7 - $M10_width]}{offset: $bound_offset}{pitch: $M10_step}{track_alignment: track}{trim: false}}"

  set_pg_strategy M10_strategy_1st \
    -polygon "{$bound_llx $bound_lly} {$bound_urx $bound_lly} {$bound_urx $bound_ury} {$bound_llx $bound_ury}" \
    -pattern "{name: M10_mesh_1st} {nets: $net_1st $net_1st}"
    
  set_pg_via_master_rule VIA910_rule_1st -contact_code $VIA9_master -via_array_dimension {1 3} -cut_spacing {1 0.064}

  set_pg_strategy_via_rule VIA910_strategy_1st -via_rule "{{intersection : adjacent}{via_master: VIA910_rule_1st}}"
  
  compile_pg -strategies {M10_strategy_1st} -via_rule {VIA910_strategy_1st}
}


#==> draw 2nd net
set m10_adjust_offset_2nd [expr $M10_offset + ($M10_step/2)]
set m10_loc_y_2nd [expr $core_lly + round($round_fix+($m10_adjust_offset_2nd - $M10_track_offset + $M10_step*0)/$M10_pitch)*$M10_pitch + $M10_track_offset]
redirect -append -file $runlog {
  set bound_llx [expr $core_llx]
  set bound_lly [expr $core_lly]
  set bound_urx [expr $core_urx]
  set bound_ury [expr $core_ury]
  set bound_offset [expr $m10_adjust_offset_2nd - ($M10_pitch*3)]

  create_pg_mesh_pattern M10_mesh_2nd \
    -layers "{{horizontal_layer: M10}{width: $M10_width}{spacing: [expr $M10_pitch*7 - $M10_width]}{offset: $bound_offset}{pitch: $M10_step}{track_alignment: track}{trim: false}}"

  set_pg_strategy M10_strategy_2nd \
    -polygon "{$bound_llx $bound_lly} {$bound_urx $bound_lly} {$bound_urx $bound_ury} {$bound_llx $bound_ury}" \
    -pattern "{name: M10_mesh_2nd} {nets: $net_2nd $net_2nd}"
    
  set_pg_via_master_rule VIA910_rule_2nd -contact_code $VIA9_master -via_array_dimension {1 3} -cut_spacing {1 0.064}

  set_pg_strategy_via_rule VIA910_strategy_2nd -via_rule "{{intersection : adjacent}{via_master: VIA910_rule_2nd}}"
  
  compile_pg -strategies {M10_strategy_2nd} -via_rule {VIA910_strategy_2nd}
}


# M11, VIA10 PG
echo "Creating M11 & VIA10 PG..."
redirect -append -file $runlog {
  echo ""
  echo ""
  echo "Creating M11 & VIA10 PG..."
  echo ""
  echo ""
}

redirect -append -file $runlog {
  reset_app_options plan.pgroute.maximize_total_cut_area
}

#==> draw 1st net
set M11_adjust_offset_1st [expr $M11_offset]
set M11_loc_y_1st [expr $core_lly + round($round_fix+($M11_adjust_offset_1st - $M11_track_offset + $M11_step*0)/$M11_pitch)*$M11_pitch + $M11_track_offset]

redirect -append -file $runlog {
  set bound_llx [expr $core_llx]
  set bound_lly [expr $core_lly]
  set bound_urx [expr $core_urx]
  set bound_ury [expr $core_ury]
  set bound_offset [expr $M11_adjust_offset_1st]

  create_pg_mesh_pattern M11_mesh_1st \
    -layers "{{horizontal_layer: M11}{width: $M11_width}{spacing: [expr $M11_pitch*1]}{offset: $bound_offset}{pitch: $M11_step}{track_alignment: track}{trim: false}}"

  set_pg_strategy M11_strategy_1st \
    -polygon "{$bound_llx $bound_lly} {$bound_urx $bound_lly} {$bound_urx $bound_ury} {$bound_llx $bound_ury}" \
    -pattern "{name: M11_mesh_1st} {nets: $net_1st}"
    
  set_pg_via_master_rule VIA1011_rule_1st -contact_code $VIA10_master -via_array_dimension {1 1} -cut_spacing {1 1}

  set_pg_strategy_via_rule VIA1011_strategy_1st -via_rule "{{intersection : adjacent}{via_master: VIA1011_rule_1st}}"
  
  compile_pg -strategies {M11_strategy_1st} -via_rule {VIA1011_strategy_1st}
}


#==> draw 2nd net
set M11_adjust_offset_2nd [expr $M11_offset + ($M11_step/2)]
set M11_loc_y_2nd [expr $core_lly + round($round_fix+($M11_adjust_offset_2nd - $M11_track_offset + $M11_step*0)/$M11_pitch)*$M11_pitch + $M11_track_offset]
redirect -append -file $runlog {
  set bound_llx [expr $core_llx]
  set bound_lly [expr $core_lly]
  set bound_urx [expr $core_urx]
  set bound_ury [expr $core_ury]
  set bound_offset [expr $M11_adjust_offset_2nd]

  create_pg_mesh_pattern M11_mesh_2nd \
    -layers "{{horizontal_layer: M11}{width: $M11_width}{spacing: [expr $M11_pitch*1]}{offset: $bound_offset}{pitch: $M11_step}{track_alignment: track}{trim: false}}"

  set_pg_strategy M11_strategy_2nd \
    -polygon "{$bound_llx $bound_lly} {$bound_urx $bound_lly} {$bound_urx $bound_ury} {$bound_llx $bound_ury}" \
    -pattern "{name: M11_mesh_2nd} {nets: $net_2nd}"
    
  set_pg_via_master_rule VIA1011_rule_2nd -contact_code $VIA10_master -via_array_dimension {1 1} -cut_spacing {1 1}

  set_pg_strategy_via_rule VIA1011_strategy_2nd -via_rule "{{intersection : adjacent}{via_master: VIA1011_rule_2nd}}"
  
  compile_pg -strategies {M11_strategy_2nd} -via_rule {VIA1011_strategy_2nd}
}


### Assign PG coloring ###
derive_pg_mask_constraint -derive_cut_mask -always_align_color_layers M0 -overwrite

### Verify Missing VIA ###
check_pg_missing_vias -nets "VDD VSS" -output_file missing_via.rpt

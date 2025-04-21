#--------------------------------------------------------------------------------------------
#	Revision History
#
#	2019/7/10
#		- Preliminary development of N6 DFP checker
#	2019/7/22
#		- change dfp_first_track_mask(2) from "mask_two mask_one" to "mask_one mask_one"
#	2019/8/26
#		- temp close check_m1_pg
#	2019/9/2
#		- M1 first track change to M1CA (set dfp_first_track_mask(1) "mask_two mask_two" -> mask_one mask_one)
#		- modify awk of query track due to format changed
#	2019/11/22
#		- update the horizontal shrink factor from 0 to -0.5
#	2020/01/15
#		- open check_m1_pg and modify mathmatical part to checking every 8 pitch more accuratly
#		- modify check_track_coloring_and_offset for supporting tool different output format. 
#		- standard_cell_region_horizontal_shrink_factor from -0.5 to 0
#	2020/01/21
#		- rollback FB9 creation setting: chipfinishing.standard_cell_region_horizontal_shrink_factor from 0 to -0.5
#		- temporarily remove boundary insertion checking (PR.F.4)
#		- temporarily remove boundary misalignment checking (PR.F.5)
#	2020/03/16
#		- modify all proc naming to dfp_*
#	2020/03/30
#		- update set_boundary_cell_rules setting to align latest DFP ref. flow and training slide
#			inside_horizontal_abutment_cells, min_vertical_jog, min_horizontal_jog, min_vertical_separation, min_horizontal_separation
#	2020/04/17
#		- remove place.legalize.color_shift_layers checking in dfp_print_setting_table
#--------------------------------------------------------------------------------------------
suppress_message SEL-004
set dfp_cell_height 240
set dfp_cell_type 0
#set dfp_M0_track_first_mask "mask_two"
#set dfp_M0_track_offset "0"
#set dfp_M1_track_first_mask "mask_one"
#set dfp_M1_track_offset "0.0285"
#set dfp_M2_track_first_mask "mask_one"
#set dfp_M2_track_offset "0.020"
#set dfp_M3_track_first_mask "mask_one"
#set dfp_M3_track_offset "0"

#   dfp_first_track_mask 	"no_flip is_flip"
set dfp_first_track_mask(0) "mask_one mask_two"
set dfp_first_track_mask(1) "mask_one mask_one"
set dfp_first_track_mask(2) "mask_two mask_two"
set dfp_first_track_mask(3) "mask_one mask_one"
set dfp_first_track_offset(0) "0 0"
set dfp_first_track_offset(1) "0.0285 0.0285"
set dfp_first_track_offset(2) "0.020 0.020"
set dfp_first_track_offset(3) "0 0"
#--------------------------------------------------------------------------------------------
#	Defining Procedures
#--------------------------------------------------------------------------------------------
proc dfp_check_m0_track {} {
	dfp_check_track 0 Y
	redirect -variable layer_info {report_tracks -layer M0}
	set M0_offset_1 0.04
	set M0_offset_2	0.04
	set M0_offset_3	0.04
	set M0_offset_4	0.06
	set M0_offset_5	0.06
	set M0_offset_6	0.04
	set M0_offset_7	0.04
	set M0_offset_8	0.04
	set M0_offset_9	0.06
	set S1 [exec echo $layer_info | grep M0 | awk {{ print $3}} |  awk {NR == 1 {old = $1; next} {print old -$1; old = $1}} | awk  {NR == 1}]
	set S2 [exec echo $layer_info | grep M0 | awk {{ print $3}} |  awk {NR == 1 {old = $1; next} {print old -$1; old = $1}} | awk  {NR == 2}]
	set S3 [exec echo $layer_info | grep M0 | awk {{ print $3}} |  awk {NR == 1 {old = $1; next} {print old -$1; old = $1}} | awk  {NR == 3}]
	set S4 [exec echo $layer_info | grep M0 | awk {{ print $3}} |  awk {NR == 1 {old = $1; next} {print old -$1; old = $1}} | awk  {NR == 4}]
	set S5 [exec echo $layer_info | grep M0 | awk {{ print $3}} |  awk {NR == 1 {old = $1; next} {print old -$1; old = $1}} | awk  {NR == 5}]
	set S6 [exec echo $layer_info | grep M0 | awk {{ print $3}} |  awk {NR == 1 {old = $1; next} {print old -$1; old = $1}} | awk  {NR == 6}]
	set S7 [exec echo $layer_info | grep M0 | awk {{ print $3}} |  awk {NR == 1 {old = $1; next} {print old -$1; old = $1}} | awk  {NR == 7}]
	set S8 [exec echo $layer_info | grep M0 | awk {{ print $3}} |  awk {NR == 1 {old = $1; next} {print old -$1; old = $1}} | awk  {NR == 8}]
	set S9 [exec echo $layer_info | grep M0 | awk {{ print $3}} |  awk {NR == 1 {old = $1; next} {print old -$1; old = $1}} | awk  {NR == 9}]
	if { $M0_offset_1 == $S1 && $M0_offset_2 == $S2 && $M0_offset_3 == $S3 && $M0_offset_4 == $S4 && $M0_offset_5 == $S5 && \
	$M0_offset_6 == $S6 && $M0_offset_7 == $S7 && $M0_offset_8 == $S8 && $M0_offset_9 == $S9 } {
		puts "\[DFP Checker INFO\] M0 further checking... Correct! M0 track create with correct offset"
	} else {
		puts "\[DFP Checker INFO\] M0 further checking... Warning! M0 track create with wrong offset"
	}
}
proc dfp_check_track {{layer ""} {dir ""}} {

	global dfp_first_track_mask
	global dfp_first_track_offset

	if {$layer==""||$dir==""} {
		return;
	}

	set is_flip 0
	set site_orientation [ get_attribute -q [get_site_rows -first_row -quiet] site_orientation]
	set orientation [ get_attribute -q [get_site_rows -first_row -quiet] orientation]
	if {$site_orientation!=$orientation} {
		set is_flip 1
	}
	set mask [lindex $dfp_first_track_mask($layer) $is_flip]
	set offset [lindex $dfp_first_track_offset($layer) $is_flip]		
	
	redirect -variable layer_info {report_first_track_line -layer M$layer -dir $dir -relative_to core_area}
	set layer_exist [catch {exec echo $layer_info | grep "No track"}]
	if {$layer_exist==0} {
		puts "\[DFP Checker INFO\] Warning! M$layer tracks are missing"
	} else {
		set offset_line [exec echo $layer_info | grep relative]
        regexp {[.0-9]+} $offset_line layer_offset
		set mask_line [exec echo $layer_info | grep mask]
        regexp {mask_\S+} $mask_line layer_mask
		#set layer_mask [exec echo $layer_info | grep mask | awk {{print $4}}]
		#set layer_offset [exec echo $layer_info | grep relative | awk {{print $6}}]
		if {$layer_mask!=$mask || $layer_offset!=$offset} {
			puts "\[DFP Checker INFO\] Warning! First M$layer track inside core should be $mask with $offset nm offset to core"
			puts "\[DFP Checker INFO\] M$layer current setting: mask: $layer_mask offset: $layer_offset"
		} else {
			puts "\[DFP Checker INFO\] Correct! M$layer track create correctly"
		}
	}
}
proc dfp_check_track_coloring_and_offset {} {
	puts "****************************************************"
	puts "*      Start checking N6.PR.F.1 and N6.PR.F.2      *"
	puts "****************************************************"
	puts "\[DFP Checker INFO\] For this item, please use ICC2 version newer than P-2019.03-SP3-T-20190730"
	#dfp_check_m0_track
	dfp_check_track 1 X
	dfp_check_track 2 Y
	#dfp_check_track 3 X
}
proc dfp_check_odd_site_row {} {
	puts "**************************************"
	puts "*      Start checking N6.PR.F.3      *"
	puts "**************************************"
	set scount [get_attr [index_collection [get_site_rows *] 0] site_count]
	if {[expr $scount % 2]!=1} {
		puts "\[DFP Checker INFO\] Warning! Row sites count is even: $scount, which should be odd sites for even poly"
	} else {
		puts "\[DFP Checker INFO\] Correct! Row sites count is odd: $scount"
	}
}
proc dfp_check_boundary_wo_lr {} {
	puts "**************************************"
	puts "*      Start checking N6.PR.F.4      *"
	puts "**************************************"
	global dfp_cell_height
	global dfp_cell_type
	set boundary_list [get_attr [get_cells -hierarchical -filter "ref_name=~BOUNDARY*BWP${dfp_cell_height}*"] ref_name]
	if {[llength $boundary_list]==0} {
		puts "\[DFP Checker INFO\] Warning! Boundary cell library is missing"
		return
	} 	
	set vt_cell [lindex $boundary_list 0]
	set type_index1 [string first ${dfp_cell_height}H $vt_cell]
	set type_index2 [string length $vt_cell]
	set dfp_cell_type [string range $vt_cell $type_index1 [expr $type_index2-1]]
	for {set i 0} {$i<[llength $boundary_list]} {incr i} {
		set index_name [lindex $boundary_list $i]
		if {![string match *${dfp_cell_type} $index_name]} {
			puts "\[DFP Checker INFO\] Warning! Design use more than 1 cell type for boundary cells, checker will skip further checking"
			puts "\[DFP Checker INFO\] e.g. $vt_cell and $index_name have different cell type (please check gate length or poly pitch)"
			return
		}
	}
	puts "\[DFP Checker INFO\] Correct! Design use only 1 cell type for boundary cells: $dfp_cell_type"
	puts "\[DFP Checker INFO\] Start checking insertion setting..."
	#set vt_type ULVT
	# ICC2 must follow the following sequence.
	set nrow [sort_collection -descending [get_lib_cells -quiet */BOUNDARY*NROW*BWP${dfp_cell_type}] {width}]
	set prow [sort_collection -descending [get_lib_cells -quiet */BOUNDARY*PROW*BWP${dfp_cell_type}] {width}]	
	set_boundary_cell_rules \
		-top_boundary_cells     "$nrow" \
		-bottom_boundary_cells  "$prow" \
        -left_boundary_cell               "*/BOUNDARYLEFTBWP${dfp_cell_type}" \
        -right_boundary_cell              "*/BOUNDARYRIGHTBWP${dfp_cell_type}" \
        -top_right_outside_corner_cell    "*/BOUNDARYNCORNERBWP${dfp_cell_type}" \
        -bottom_right_outside_corner_cell "*/BOUNDARYPCORNERBWP${dfp_cell_type}" \
        -top_left_outside_corner_cell     "*/BOUNDARYNCORNERBWP${dfp_cell_type}" \
        -bottom_left_outside_corner_cell  "*/BOUNDARYPCORNERBWP${dfp_cell_type}" \
        -top_right_inside_corner_cells    "*/BOUNDARYNINCORNERBWP${dfp_cell_type}" \
        -bottom_right_inside_corner_cells "*/BOUNDARYPINCORNERBWP${dfp_cell_type}" \
        -top_left_inside_corner_cells     "*/BOUNDARYNINCORNERBWP${dfp_cell_type}" \
        -bottom_left_inside_corner_cells  "*/BOUNDARYPINCORNERBWP${dfp_cell_type}" \
        -top_left_inside_horizontal_abutment_cells		"*/BOUNDARYNROWLGAPBWP${dfp_cell_type}" \
        -top_right_inside_horizontal_abutment_cells 	"*/BOUNDARYNROWRGAPBWP${dfp_cell_type}" \
        -bottom_left_inside_horizontal_abutment_cells	"*/BOUNDARYPROWLGAPBWP${dfp_cell_type}" \
        -bottom_right_inside_horizontal_abutment_cells	"*/BOUNDARYPROWRGAPBWP${dfp_cell_type}" \
		-mirror_left_inside_corner_cell \
		-mirror_left_outside_corner_cell \
		-segment_parity {horizontal_odd vertical_even} \
		-min_vertical_jog 0.48 \
		-min_horizontal_jog 0.798 \
		-min_vertical_separation 2.4 \
		-min_horizontal_separation 2.907 \
		-add_standard_cell_region

	check_boundary_cells
	puts "\n\[DFP Checker INFO\] Start checking if Error messages in \[Continuity report\] is due to CPODE.L.2 prevention..."
	set l_waive_list [get_attr [get_cells -filter "ref_name==BOUNDARYLEFTCLBWP${dfp_cell_type}"] boundary_bbox]
	set r_waive_list [get_attr [get_cells -filter "ref_name==BOUNDARYRIGHTCLBWP${dfp_cell_type}"] boundary_bbox]
	puts "\[DFP Checker INFO\] If the error bbox in \"Continuity report\" is covered by following bbox, you could waive them:"
	foreach itr $l_waive_list {
		puts "$itr"
	}
	foreach itr $r_waive_list {
		puts "$itr"
	}
}
proc dfp_check_boundary {} {
	puts "**************************************"
	puts "*      Start checking N6.PR.F.4      *"
	puts "**************************************"
	puts "\[DFP Checker INFO\] For this item, please check before boundary cell swapping"
	global dfp_cell_height
	global dfp_cell_type
	set CL_count [sizeof_collection [get_cells -hierarchical -filter "ref_name=~BOUNDARY*CLBWP*"]]
	if {$CL_count!=0} {
		puts "\[DFP Checker INFO\] Warning! Boundary cell swapping have done. Checker would skip insertion setting"
		return 
	}
	set boundary_list [get_attr [get_cells -hierarchical -filter "ref_name=~BOUNDARY*BWP${dfp_cell_height}*"] ref_name]
	if {[llength $boundary_list]==0} {
		puts "\[DFP Checker INFO\] Warning! Boundary cell library is missing"
		return
	} 	
	set vt_cell [lindex $boundary_list 0]
	set type_index1 [string first ${dfp_cell_height}H $vt_cell]
	set type_index2 [string length $vt_cell]
	set dfp_cell_type [string range $vt_cell $type_index1 [expr $type_index2-1]]
	for {set i 0} {$i<[llength $boundary_list]} {incr i} {
		set index_name [lindex $boundary_list $i]
		if {![string match *${dfp_cell_type} $index_name]} {
			puts "\[DFP Checker INFO\] Warning! Design use more than 1 cell type for boundary cells, checker will skip further checking"
			puts "\[DFP Checker INFO\] e.g. $vt_cell and $index_name have different cell type (please check gate length or poly pitch)"
			return
		}
	}
	puts "\[DFP Checker INFO\] Correct! Design use only 1 cell type for boundary cells: $dfp_cell_type"
	puts "\[DFP Checker INFO\] Start checking insertion setting..."
	#set vt_type ULVT
	# ICC2 must follow the following sequence.
	set nrow [sort_collection -descending [get_lib_cells -quiet */BOUNDARY*NROW*BWP${dfp_cell_type}] {width}]
	set prow [sort_collection -descending [get_lib_cells -quiet */BOUNDARY*PROW*BWP${dfp_cell_type}] {width}]	
	set_boundary_cell_rules \
		-top_boundary_cells     "$nrow" \
		-bottom_boundary_cells  "$prow" \
        -left_boundary_cell               "*/BOUNDARYLEFTBWP${dfp_cell_type}" \
        -right_boundary_cell              "*/BOUNDARYRIGHTBWP${dfp_cell_type}" \
        -top_right_outside_corner_cell    "*/BOUNDARYNCORNERBWP${dfp_cell_type}" \
        -bottom_right_outside_corner_cell "*/BOUNDARYPCORNERBWP${dfp_cell_type}" \
        -top_left_outside_corner_cell     "*/BOUNDARYNCORNERBWP${dfp_cell_type}" \
        -bottom_left_outside_corner_cell  "*/BOUNDARYPCORNERBWP${dfp_cell_type}" \
        -top_right_inside_corner_cells    "*/BOUNDARYNINCORNERBWP${dfp_cell_type}" \
        -bottom_right_inside_corner_cells "*/BOUNDARYPINCORNERBWP${dfp_cell_type}" \
        -top_left_inside_corner_cells     "*/BOUNDARYNINCORNERBWP${dfp_cell_type}" \
        -bottom_left_inside_corner_cells  "*/BOUNDARYPINCORNERBWP${dfp_cell_type}" \
        -top_left_inside_horizontal_abutment_cells "*/BOUNDARYNROWRGAPBWP${dfp_cell_type}" \
        -top_right_inside_horizontal_abutment_cells "*/BOUNDARYNROWRGAPBWP${dfp_cell_type}" \
        -bottom_left_inside_horizontal_abutment_cells "*/BOUNDARYPROWRGAPBWP${dfp_cell_type}" \
        -bottom_right_inside_horizontal_abutment_cells "*/BOUNDARYPROWRGAPBWP${dfp_cell_type}" \
		-mirror_left_inside_corner_cell \
		-mirror_left_outside_corner_cell \
		-segment_parity {horizontal_odd vertical_even} \
		-min_vertical_jog 0.72 \
		-min_horizontal_jog 0.9 \
		-min_vertical_separation 1.14 \
		-min_horizontal_separation 8.0 \
		-add_standard_cell_region
	check_boundary_cells
	puts "\n\[DFP Checker INFO\] Start checking if Error messages in \[Continuity report\] is due to CPODE.L.2 prevention..."
	set l_waive_list [get_attr [get_cells -filter "ref_name==BOUNDARYLEFTCLBWP${dfp_cell_type}"] boundary_bbox]
	set r_waive_list [get_attr [get_cells -filter "ref_name==BOUNDARYRIGHTCLBWP${dfp_cell_type}"] boundary_bbox]
	puts "\[DFP Checker INFO\] If the error bbox in \"Continuity report\" is covered by following bbox, you could waive them:"
	foreach itr $l_waive_list {
		puts "$itr"
	}
	foreach itr $r_waive_list {
		puts "$itr"
	}
}
proc dfp_check_boundary_misalignment {} {
	puts "**************************************"
	puts "*      Start checking N6.PR.F.5      *"
	puts "**************************************"
	global dfp_cell_height
	global dfp_cell_type
	set boundary_list [get_attr [get_cells -hierarchical -filter "ref_name=~BOUNDARY*BWP${dfp_cell_height}*"] ref_name]
	if {[llength $boundary_list]==0} {
		puts "\[DFP Checker INFO\] Warning! Boundary cell library is missing"
		return
	} 	
	set vt_cell [lindex $boundary_list 0]
	set type_index1 [string first ${dfp_cell_height}H $vt_cell]
	set type_index2 [string length $vt_cell]
	set dfp_cell_type [string range $vt_cell $type_index1 [expr $type_index2-1]]
	for {set i 0} {$i<[llength $boundary_list]} {incr i} {
		set index_name [lindex $boundary_list $i]
		if {![string match *${dfp_cell_type} $index_name]} {
			puts "\[DFP Checker INFO\] Warning! Design use more than 1 cell type for boundary cells, checker will skip further checking"
			puts "\[DFP Checker INFO\] e.g. $vt_cell and $index_name have different cell type (please check gate length or poly pitch)"
			return
		}
	}
	puts "\[DFP Checker INFO\] Correct! Design use only 1 cell type for boundary cells: $dfp_cell_type"
	puts "\[DFP Checker INFO\] Start checking boundary cell misalignment for CPODE.L.2 prevention..."
	set l_list [get_attr [get_cells -filter "ref_name==BOUNDARYLEFTBWP${dfp_cell_type}"] bbox]
	set r_list [get_attr [get_cells -filter "ref_name==BOUNDARYRIGHTBWP${dfp_cell_type}"] bbox]
#	set lx_list ""
#	set rx_list ""
#	set ly_list ""
#	set ry_list ""
	array set boundary_array {}
	foreach itr $l_list {
#		lappend lx_list [lindex [lindex $itr 0] 0]
#		lappend ly_list [lindex [lindex $itr 0] 1]
		if {[info exist boundary_array([lindex [lindex $itr 0] 0])]} {
			lappend boundary_array([lindex [lindex $itr 0] 0]) [lindex [lindex $itr 0] 1]
		} else {
			set boundary_array([lindex [lindex $itr 0] 0]) [list [lindex [lindex $itr 0] 1]]
		}
	}
	foreach itr $r_list {
#		lappend rx_list [lindex [lindex $itr 0] 0]
#		lappend ry_list [lindex [lindex $itr 0] 1]
		if {[info exist boundary_array([lindex [lindex $itr 0] 0])]} {
			lappend boundary_array([lindex [lindex $itr 0] 0]) [lindex [lindex $itr 0] 1]
		} else {
			set boundary_array([lindex [lindex $itr 0] 0]) [list [lindex [lindex $itr 0] 1]]
		}
	}
	set err_count 0
	foreach {key} [array name boundary_array] {
		#puts "\[DEBUG\] x: $key length: [llength $boundary_array($key)]"
		lsort -dictionary $boundary_array($key)
		set start_y	[lindex $boundary_array($key) 0]
		set cumulative_y 0
		for {set i 0} {$i < [expr [llength $boundary_array($key)] - 1]} {incr i} {
			if {[expr abs([lindex $boundary_array($key) $i+1]-[lindex $boundary_array($key) $i] - 0.24)] < 0.000001} {
				incr cumulative_y
			} else {
				set start_y	[lindex $boundary_array($key) $i+1]
				set cumulative_y 0				
			}
			if {$cumulative_y == 124} {
				puts "\[DFP Checker INFO\] Warning! There exist CPODE.L.2 violation around x-axis: $key y-axis: from $start_y to [lindex $boundary_array($key) $i+1]"
				incr err_count
				break
			}
		}
	}
	if {$err_count==0} {
		puts "\[DFP Checker INFO\] Correct! There exist CPODE.L.2 prevention in boundary insertion"
	}
}
proc dfp_check_m1_pg {} {
	puts "**************************************"
	puts "*      Start checking N6.PR.F.7      *"
	puts "**************************************"
	set m1_pitch [get_attr [get_layers M1] pitch]
	set m1_pg_shape [get_shapes -q -of_objects M1 -filter "net_type==power||net_type==ground"]
	set m1_pg_llx ""
	set m1_pg_llx_error ""
	foreach_in_collection itr $m1_pg_shape {
		lappend m1_pg_llx [lindex [lindex [get_attr $itr bbox] 0] 0]
	}
	set m1_pg_llx [lsort -real -unique $m1_pg_llx]
	for {set i 1} {$i < [llength $m1_pg_llx]} {incr i} {
		#if {[expr [lindex $m1_pg_llx $i] - [lindex $m1_pg_llx $i-1] - ($m1_pitch*8)] > 0.000001} 
		if {[expr [lindex $m1_pg_llx $i]-[lindex $m1_pg_llx $i-1]-(round(([lindex $m1_pg_llx $i]-[lindex $m1_pg_llx $i-1])/($m1_pitch*8))*($m1_pitch*8))] > 0.0000001} {
			lappend m1_pg_llx_error [list [lindex $m1_pg_llx $i-1] [lindex $m1_pg_llx $i]]
		}
	}
	if {[llength $m1_pg_llx_error]!=0} {
		puts "\[DFP Checker INFO\] Warning! M1 PG are not compatible with TSMC std cell"		
		puts "\[DFP Checker INFO\] First violation happend at x-axis: [lindex $m1_pg_llx_error 0]"
	} else {
		puts "\[DFP Checker INFO\] Correct! M1 PG are compatible with TSMC std cell"		
	}
}
proc dfp_print_setting_table {} {
    puts "**************************************"                                                                                                                                                                                            
    puts "*      Start checking N6.PR.F.8      *"
    puts "**************************************"
#*** N6.PR.P.1 ***
	set fp_check1 [get_app_option_value -name place.legalize.color_shift_layers]
	if {$fp_check1==""} {set fp_check1 "not configured"}
#*** N6.PR.R.2
	set r_check1 [get_app_option_value -name route.detail.optimize_for_shift_via]
	redirect -variable ignored_rpt {report_ignored_layers}
#*** N6.PR.R.1
	set minLayer [exec echo $ignored_rpt | grep "Min Routing Layer" | awk {{print $4}}]
	#set minLayerno [regexp -all -inline -- {[0-9]+} $minLayer]
	redirect -variable check_node {set_technology -node 6 -report_only}
#*** N6.PR.F.8
	set node_exist [catch {exec echo $check_node | grep "technology_node="}]
	if {$node_exist==0} {
		set node [exec echo $check_node | grep "technology_node=" | awk -F "=" {{print $2}}]
	}
#*** N6.PR.F.7
	set h_factor [get_app_option_value -name chipfinishing.standard_cell_region_horizontal_shrink_factor]
	set v_factor [get_app_option_value -name chipfinishing.standard_cell_region_vertical_shrink_factor]

	puts "Option Setting:"
#	puts "---------------------------------------------------------------------------------------------------------------------------"
	puts "-------------------------------------------------------------------------------------------------------------------------------------------------------"
	puts [format "%-60s%30s%30s%30s" "Option" "Expectation" "Current Setting" "checking code"]
	puts "-------------------------------------------------------------------------------------------------------------------------------------------------------"
#	puts "---------------------------------------------------------------------------------------------------------------------------"
	puts [format "%-60s%30s%30s%30s" "chipfinishing.standard_cell_region_horizontal_shrink_factor"	"-0.5"	$h_factor "N6.PR.F.6"]
	puts [format "%-60s%30s%30s%30s" "chipfinishing.standard_cell_region_vertical_shrink_factor"	"0.5"	$v_factor "N6.PR.F.6"]
	puts [format "%-60s%30s%30s%30s" "set_technology -node"	"6"	$node "N6.PR.F.8"]
#	puts [format "%-60s%30s%30s%30s" "place.legalize.color_shift_layers"	"M1 M2"	$fp_check1 "N6.PR.P.1"]
	puts [format "%-60s%30s%30s%30s" "set_ignored_layers -min_routing_layer"	"M0"	$minLayer "N6.PR.R.1"]
	puts [format "%-60s%30s%30s%30s" "route.detail.optimize_for_shift_via"	"true"	$r_check1 "N6.PR.R.2"]
}

proc dfp_check_fb_region {} {
	puts "**************************************"
	puts "*      Start checking N6.PR.F.6      *"
	puts "**************************************"
	set guide_list [get_attr [get_routing_guides] routing_guide_type]
	foreach itr $guide_list {
		if {$itr=="standard_cell_region"} {
			puts "\[DFP Checker INFO\] Correct! \"standard_cell_region\" exist in routing guide"
			return
		}
	}
	puts "\[DFP Checker INFO\] Warning! There is no \"standard_cell_region\" in routing guide"
}

proc dfp_check_M0_dummy {} {
	puts "**************************************"
	puts "*      Start checking N6.PR.D.1      *"
	puts "**************************************"
	set check1 [sizeof_collection [get_shapes -filter "layer_name==M0:active_fill"]]
	if {$check1!=0} {
		puts "\[DFP Checker INFO\] Correct! There exist M0 dummy in design"
	} else {
		puts "\[DFP Checker INFO\] Warning! There is not any M0 dummy in design"
	}
}
#--------------------------------------------------------------------------------------------
#	Defining Mega Procedures
#--------------------------------------------------------------------------------------------
proc dfp_check_floorplan {} {
	dfp_check_track_coloring_and_offset
#	dfp_check_odd_site_row
#	dfp_check_boundary
#	dfp_check_boundary_misalignment
	dfp_check_fb_region
	dfp_check_m1_pg
	dfp_print_setting_table
}
proc dfp_check_placement {} {
	dfp_print_setting_table
}
proc dfp_check_routing {} {
	dfp_print_setting_table
}
proc dfp_check_design_finish {} {
	dfp_check_M0_dummy
	dfp_print_setting_table
}
proc check_yz {} {
	dfp_check_floorplan
	dfp_check_M0_dummy
}

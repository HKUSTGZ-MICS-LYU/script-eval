## Clock NDR for 1X1Xa1Ya5Y2Z
remove_routing_rules -all
create_routing_rule CLK_Trunk \
-driver_taper_distance 0 \
-widths   {M0 0.020 M1 0.037 M2 0.020 M3 0.024 M4 0.038 M5 0.076 M6 0.076 M7 0.076 M8 0.076 M9 0.076 M10 0.360 M11 0.360 } \
-spacings {M0 0.020 M1 0.020 M2 0.020 M3 0.020 M4 0.038 M5 0.095 M6 0.095 M7 0.095 M8 0.095 M9 0.095 M10 0.360 M11 0.360 } \
-snap_to_track

create_routing_rule CLK_Leaves -default_reference_rule \
-driver_taper_distance 0 \
-widths   {M0 0.020 M1 0.037 M2 0.020 M3 0.024 M4 0.038 M5 0.038 M6 0.038 M7 0.038 M8 0.038 M9 0.038 M10 0.360 M11 0.360 } \
-spacings {M0 0.020 M1 0.020 M2 0.020 M3 0.020 M4 0.038 M5 0.038 M6 0.038 M7 0.038 M8 0.038 M9 0.038 M10 0.360 M11 0.360 } \
-snap_to_track

set_clock_routing_rule -rule CLK_Trunk  -min_routing_layer M5 -max_routing_layer M9 -net_type root
set_clock_routing_rule -rule CLK_Trunk  -min_routing_layer M5 -max_routing_layer M9 -net_type internal
set_clock_routing_rule -rule CLK_Leaves -min_routing_layer M1 -max_routing_layer M9 -net_type sink

set_clock_cell_spacing -lib_cells [get_lib_cells */*CKN*] -x_spacing 1 -y_spacing 1
set_clock_cell_spacing -lib_cells [get_lib_cells */*CKB*] -x_spacing 1 -y_spacing 1


set sh_continue_on_error true

set_attribute [get_lib_cells -quiet *_svt*/*] threshold_voltage_group SVT
set_threshold_voltage_group_type -type normal_vt {SVT}
set_attribute [get_lib_cells -quiet *_lvt*/*] threshold_voltage_group LVT
set_attribute [get_lib_cells -quiet *_ulvt*/*] threshold_voltage_group ULVT
set_threshold_voltage_group_type -type low_vt {LVT ULVT}

#For optimization
set_lib_cell_purpose -include {optimization power} [get_lib_cells */*]

#For hold time fixing
set_dont_touch [get_lib_cells {*/DELAD1BWP240H8P57CPDLVT */DELBD1BWP240H8P57CPDLVT */DELCD1BWP240H8P57CPDLVT */DELDD1BWP240H8P57CPDLVT}] false
set_lib_cell_purpose -exclude hold [get_lib_cells */*]
set_lib_cell_purpose -include hold [get_lib_cells {*/DELAD1BWP240H8P57CPDLVT */DELBD1BWP240H8P57CPDLVT */DELCD1BWP240H8P57CPDLVT */DELDD1BWP240H8P57CPDLVT}]

#For TIE cell
set_dont_touch [get_lib_cells *ulvt*/TIE*] false
set_attribute  [get_lib_cells *ulvt*/TIE*] dont_use false

#Dont use gate array functional cells
set_lib_cell_purpose -include none [get_lib_cells */DEL* */DCCK* */CK* */G* */*D24* */*D32* ]

#For CTS
set_lib_cell_purpose -exclude cts [get_lib_cells */*]
set_dont_touch [get_lib_cells {*/CKND8BWP240H8P57CPDULVT */CKND12BWP240H8P57CPDULVT */CKND16BWP240H8P57CPDULVT}] false
set_lib_cell_purpose -include none [get_lib_cells {*/CKND8BWP240H8P57CPDULVT */CKND12BWP240H8P57CPDULVT */CKND16BWP240H8P57CPDULVT}]
set_lib_cell_purpose -include cts [get_lib_cells {*/CKND8BWP240H8P57CPDULVT */CKND12BWP240H8P57CPDULVT */CKND16BWP240H8P57CPDULVT}]
set_dont_touch [get_lib_cells {*/CKBD8BWP240H8P57CPDULVT */CKBD12BWP240H8P57CPDULVT */CKBD16BWP240H8P57CPDULVT}] false
set_lib_cell_purpose -include none [get_lib_cells {*/CKBD8BWP240H8P57CPDULVT */CKBD12BWP240H8P57CPDULVT */CKBD16BWP240H8P57CPDULVT}]
set_lib_cell_purpose -include cts [get_lib_cells {*/CKBD8BWP240H8P57CPDULVT */CKBD12BWP240H8P57CPDULVT */CKBD16BWP240H8P57CPDULVT}]
set_dont_touch [get_lib_cells {*/CKLNQD5BWP240H8P57CPDULVT */CKLNQD6BWP240H8P57CPDULVT */CKLNQD8BWP240H8P57CPDULVT}] false
set_lib_cell_purpose -include none [get_lib_cells {*/CKLNQD5BWP240H8P57CPDULVT */CKLNQD6BWP240H8P57CPDULVT */CKLNQD8BWP240H8P57CPDULVT}]
set_lib_cell_purpose -include cts [get_lib_cells {*/CKLNQD5BWP240H8P57CPDULVT */CKLNQD6BWP240H8P57CPDULVT */CKLNQD8BWP240H8P57CPDULVT}]

#Dont use scan cells
set_lib_cell_purpose -include none [get_lib_cells */S*]

set tieCell [get_lib_cells */TIE*]
foreach_in_collection item $tieCell {
  remove_attribute $item dont_use
  remove_attribute $item dont_touch
}

set sh_continue_on_error false




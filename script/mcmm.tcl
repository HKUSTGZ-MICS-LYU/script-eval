read_parasitic_tech -layermap ${NXTGRD_MAP} -tlup ${NXTGRD_MAX_FILE} -name maxTLU
read_parasitic_tech -layermap ${NXTGRD_MAP} -tlup ${NXTGRD_NOM_FILE} -name nomTLU
read_parasitic_tech -layermap ${NXTGRD_MAP} -tlup ${NXTGRD_MIN_FILE} -name minTLU

remove_corners   -all
remove_modes     -all
remove_scenarios -all

create_corner Fast
create_corner Typical
create_corner Slow

set_parasitics_parameters -early_spec minTLU -late_spec  minTLU -corners {Fast}
set_parasitics_parameters -early_spec nomTLU -late_spec  nomTLU -corners {Typical}
set_parasitics_parameters -early_spec maxTLU -late_spec  maxTLU -corners {Slow}

create_mode  FUNC
current_mode FUNC

create_scenario -mode FUNC -corner Fast    -name FUNC_Fast
create_scenario -mode FUNC -corner Typical -name FUNC_Typical
create_scenario -mode FUNC -corner Slow    -name FUNC_Slow

set scenarios [get_attribute [get_scenarios ] name]

foreach scenario ${scenarios} {
    current_scenario ${scenario}

    create_clock -period ${CLOCK_PERIOD} -name clk [get_ports clk]

    set_clock_uncertainty -setup 0.1 [get_clocks clk]
    set_clock_transition -rise 0.1 [get_clocks clk]
    set_clock_transition -fall 0.1 [get_clocks clk]

    set_input_delay 0.1 -clock clk [get_ports load]
    set_driving_cell -lib_cell BUFFD10BWP240H8P57CPDSVT [get_ports load]
    set_input_delay 0.1 -clock clk [get_ports state_in]
    set_driving_cell -lib_cell BUFFD10BWP240H8P57CPDSVT [get_ports state_in]

    set_output_delay 0.1 -clock clk [get_ports done]
    set_output_delay 0.1 -clock clk [get_ports state_out]
}

current_corner Fast
current_scenario FUNC_Fast
set_operating_conditions ${PVT_FF}

current_corner Typical
current_scenario FUNC_Typical
set_operating_conditions ${PVT_TT}

current_corner Slow
current_scenario FUNC_Slow
set_operating_conditions ${PVT_SS}

set_scenario_status FUNC_Fast    -setup false -hold true  -leakage_power false -dynamic_power true  -max_transition false  -max_capacitance true   -active true
set_scenario_status FUNC_Typical -all -active true
set_scenario_status FUNC_Slow    -setup true  -hold false -leakage_power true  -dynamic_power true  -max_transition true   -max_capacitance false  -active true

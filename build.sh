#!/bin/bash
set -Exeuo pipefail

eval_commit=$(git describe --dirty --always)
scrypt_commit=$1
clock_freq=$2

echo Building scrypt commit $scrypt_commit, clock $clock_freq MHz, eval commit $eval_commit



# clone and checkout
build_dir=${eval_commit}_${scrypt_commit}_${clock_freq}

mkdir -p build
cd build
if [ -e "$build_dir" ] ; then
    echo Rebuilding
    rm -rf "$build_dir"
fi
git clone https://github.com/cysic-labs/scrypt ${build_dir}
cd ${build_dir}
git checkout $scrypt_commit

mkdir -p build/{log,rpt,out,db}
cd build
echo -n $clock_freq > target_MHz

clock_period=$(printf '%f' $(echo "scale=4; 1000/$clock_freq" | bc))

# load tools
module load vcs/W-2024.09-SP2 verdi/W-2024.09-SP2 fusioncompiler/W-2024.09-SP3 icvalidator/W-2024.09-SP4 prime/W-2024.09-SP4
# simulate the design first
vcs -full64 -R -debug_acc+all -debug_region=verilog+lib+cell -sverilog -top salsa8d_tb \
	-l ./log/sim_rtl.log \
	+define+T=$clock_period \
	../../../tb/salsa8d_tb.sv \
	../rtl/common.sv \
	../rtl/salsa8d.sv

# run fc
fc_shell -no_log -f ../../../script/read_rtl.tcl | tee ./log/read_rtl.log
fc_shell -no_log -f ../../../script/floorplan.tcl | tee ./log/floorplan.log
fc_shell -no_log -f ../../../script/placement.tcl | tee ./log/placement.log
fc_shell -no_log -f ../../../script/cts.tcl | tee ./log/cts.log
fc_shell -no_log -f ../../../script/route.tcl | tee ./log/route.log
fc_shell -no_log -f ../../../script/chipfinish.tcl | tee ./log/chipfinish.log

# # generate deposit file
# sed -i 's/ /\n/g' ./out/salsa8d.no_reset_reg_list && sed -r 's/(.*)/$deposit(dut_i.\1, 0);/g' ./out/salsa8d.no_reset_reg_list | sed 's/\//./g' > deposit.v

# netlist simulation
vcs -full64 -R -debug_acc+all -debug_region=verilog+lib+cell -sverilog -top salsa8d_tb \
	-l ./log/sim_netlist.log \
	-sdfretain \
	+neg_tchk \
	-negdelay \
	-diag=sdf:verbose \
	+sdfverbose \
	+no_notifier \
	+define+SDF \
	+define+T=$clock_period \
	../../../tb/salsa8d_tb.sv \
	./out/salsa8d.v.sta \
	/nfs/data/foundry/tsmc/tsmc6/TSMCHOME/digital/Front_End/verilog/tcbn06_bwph240l8p57cpd_base_lvt_100a/tcbn06_bwph240l8p57cpd_base_lvt.v \
	/nfs/data/foundry/tsmc/tsmc6/TSMCHOME/digital/Front_End/verilog/tcbn06_bwph240l8p57cpd_base_svt_100a/tcbn06_bwph240l8p57cpd_base_svt.v \
	/nfs/data/foundry/tsmc/tsmc6/TSMCHOME/digital/Front_End/verilog/tcbn06_bwph240l8p57cpd_base_ulvt_100a/tcbn06_bwph240l8p57cpd_base_ulvt.v

# get start & end time
grep CUT log/sim_netlist.log | awk '{ print $2 - 0, $3 - 0 }' > stet
# get cycles/op
cycles_per_op=$(grep CUT log/sim_netlist.log | awk "{ print \$3 - \$2 \" / $clock_period\" }" | bc)

# power analysis
pt_shell -file ../../../script/ppower.tcl | tee ./log/ppower.log
# get power (W)
power_in_w=$(cat ./rpt/power.total_power)

# stat calc
hashes_per_sec=$(echo "$clock_freq * 1000000 / (1024 * $cycles_per_op + 1024 * ($cycles_per_op + 1))" | bc)
J_per_MH=$(echo "scale=4; $power_in_w * 1000000 / $hashes_per_sec" | bc)

printf 'lat: %d\nfreq: %d MHz\npower: %f W\nperf: %d H/s\n%.4f J/MH\n' $cycles_per_op $clock_freq $power_in_w $hashes_per_sec $J_per_MH | tee summary

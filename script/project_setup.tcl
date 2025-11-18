set TECH_ROOT 			""
set LIB_ROOT 			""
set SCRIPT_DIR			../../../script
set LOGS_DIR			./log
set REPORTS_DIR			./rpt
set OUTPUTS_DIR			./out
set DATABASE_DIR		./db

################################################################################
###	Design setting
################################################################################
# read target_MHz
set target_MHz_f [open "./target_MHz" r]
set target_MHz [read $target_MHz_f]
close $target_MHz_f

set design_name_f [open "./design_name" r]
set design_name [read $design_name_f]
close $design_name_f

################################################################################
### Backend Dse Config
################################################################################
set group_f [open "./backend_dse" r]
set group [read $group_f]
source ${SCRIPT_DIR}/backend_dse.tcl
set params [load_config $group]
puts "utilization: [dict get $params utilization]"
################################################################################

###########################################################################
set UTIL				"[dict get $params utilization]"
set CLOCK_PERIOD		[expr 1000.0 / $target_MHz]
set DESIGN_NAME        	"${design_name}" 
set DESIGN_LIBRARY		"${DATABASE_DIR}/${DESIGN_NAME}.U${UTIL}.nlib"
set SDC_FILE                    ""
set DEF_FILE                    ""
set UPF_FILE 					""
set ADDITIONAL_FLOORPLAN_FILE 	""
set PLACE_PIN_FILE 				""
set CLOCK_NDR_RULE_FILE 		"${SCRIPT_DIR}/CLK_NDR_1X1Xa1Ya5Y2Z.tcl"

# for PG scripts
set TCL_PG_CREATION_FILE 		"${SCRIPT_DIR}/N6-PG-H240-20190731-11M-1X1Xa1Ya5Y2Z-32CPP-icc2.tcl"
set TCL_TRACK_CREATION_FILE 	"${SCRIPT_DIR}/N6-track-H240-20190731-11M-1X1Xa1Ya5Y2Z-icc2.tcl"

set MCMM_FILE			${SCRIPT_DIR}/mcmm.tcl
set MAX_ROUTING_LAYER		M11
set CELL_USAGE_FILE		${SCRIPT_DIR}/set_lib_cell_purpose.tcl
set STD_CELL_TYPE		H240CPODE
set TARGET_SKEW 		0.1

set boundary_offset_x			1.5105
set boundary_offset_y			1.5600

set BOUNDARY_NROW 			"BOUNDARY*NROW?BWP*H8P*CPDSVT"
set BOUNDARY_PROW 			"BOUNDARY*PROW?BWP*H8P*CPDSVT"
set BOUNDARY_LEFT			"BOUNDARYLEFTBWP240H8P57CPDSVT"
set BOUNDARY_RIGHT 			"BOUNDARYRIGHTBWP240H8P57CPDSVT"
set BOUNDARY_NCORNER 			"BOUNDARYNCORNERBWP240H8P57CPDSVT"
set BOUNDARY_PCORNER 			"BOUNDARYPCORNERBWP240H8P57CPDSVT"
set BOUNDARY_NINCORNER 			"BOUNDARYNINCORNERBWP240H8P57CPDSVT"
set BOUNDARY_PINCORNER 			"BOUNDARYPINCORNERBWP240H8P57CPDSVT"
set BOUNDARY_NGAP_LEFT 			"BOUNDARYNROWLGAPBWP240H8P57CPDSVT"
set BOUNDARY_NGAP_RIGHT 		"BOUNDARYNROWRGAPBWP240H8P57CPDSVT"
set BOUNDARY_PGAP_LEFT 			"BOUNDARYPROWLGAPBWP240H8P57CPDSVT"
set BOUNDARY_PGAP_RIGHT 		"BOUNDARYPROWRGAPBWP240H8P57CPDSVT"
set BOUNDARY_REPLACE_LEFT 		"BOUNDARYLEFTCLBWP240H8P57CPDSVT"
set BOUNDARY_REPLACE_RIGHT 		"BOUNDARYRIGHTCLBWP240H8P57CPDSVT"

set TAP_CELL 				"TAPCELLBWP240H8P57CPDSVT"

################################################################################
###	Tech file and library setting
################################################################################
set TECH_FILE 			"/nfs/data/foundry/tsmc/tsmc6/apr/PRTF_ICC2_6nm_001_Syn_V10b/PR_tech/Synopsys/TechFile/Standard/VHV/PRTF_ICC2_N6_11M_1X1Xa1Ya5Y2Z_UTRDL_M1P57_M2P40_M3P44_M4P76_M5P76_M6P76_M7P76_M8P76_M9P76_H240.10b.tf"
set ANTENNA_RULE_FILE	"/nfs/data/foundry/tsmc/tsmc6/apr/PRTF_ICC2_6nm_001_Syn_V10b/PR_tech/Synopsys/SCM/PRTF_ICC2_N6_11M_Antenna.10b.tcl"
set DFM_TCL_FILE 		"/nfs/data/foundry/tsmc/tsmc6/apr/PRTF_ICC2_6nm_001_Syn_V10b/PR_tech/Synopsys/script/PRTF_ICC2_N6_DFM_via_swap_reference_command.10b.tcl"
################################################################################
### Needs to be modified
################################################################################
set NXTGRD_PATH     "/nfs/data/foundry/tsmc/tsmc6/rc_tech/starrc/RC_Star-RCXT_cln6_1p11m_1x1xa1ya5y2z_mim_ut-alrdl_DPT_5corners_1.0p1a"
set NXTGRD_MIN_FILE "${NXTGRD_PATH}/rcbest/Tech/rcbest_CCbest_T/cln6_1p11m_1x1xa1ya5y2z_mim_ut-alrdl_rcbest_CCbest_T.nxtgrd"
set NXTGRD_NOM_FILE "${NXTGRD_PATH}/typical/Tech/typical/cln6_1p11m_1x1xa1ya5y2z_mim_ut-alrdl_typical.nxtgrd"
set NXTGRD_MAX_FILE "${NXTGRD_PATH}/rcworst/Tech/rcworst_CCworst_T/cln6_1p11m_1x1xa1ya5y2z_mim_ut-alrdl_rcworst_CCworst_T.nxtgrd"



set NXTGRD_MAP 			"/nfs/data/foundry/tsmc/tsmc6/apr/PRTF_ICC2_6nm_001_Syn_V10b/PR_tech/Synopsys/StarRCMap/PRTF_ICC2_N6_starrc_11M_1X1Xa1Ya5Y2Z.10b.map"
set WRITE_GDS_LAYER_MAP_FILE 	"/nfs/data/foundry/tsmc/tsmc6/apr/PRTF_ICC2_6nm_001_Syn_V10b/PR_tech/Synopsys/GdsOutMap_ICC2/PRTF_ICC2_N6_gdsout_11M_1X_h_1Xa_v_1Ya_h_5Y_vhvhv_2Z.10b.map"

set REFERENCE_LIBRARY           "/nfs/data/foundry/tsmc/tsmc6/TSMCHOME/digital/Back_End/ndm/tcbn06_bwph240l8p57cpd_base_svt_100a/tcbn06_bwph240l8p57cpd_base_svt_physicalonly.ndm \ 
/nfs/data/foundry/tsmc/tsmc6/TSMCHOME/digital/Back_End/ndm/tcbn06_bwph240l8p57cpd_base_lvt_100a/tcbn06_bwph240l8p57cpd_base_lvt_physicalonly.ndm \
/nfs/data/foundry/tsmc/tsmc6/TSMCHOME/digital/Back_End/ndm/tcbn06_bwph240l8p57cpd_base_ulvt_100a/tcbn06_bwph240l8p57cpd_base_ulvt_physicalonly.ndm \
/nfs/data/foundry/tsmc/tsmc6/TSMCHOME/digital/Back_End/ndm/tcbn06_bwph240l8p57cpd_mb_svt_100a/tcbn06_bwph240l8p57cpd_mb_svt_physicalonly.ndm \
/nfs/share/home/tongliu/processordataset/sram/ndm/ts5n7lvta32x22m4wbzhocp.ndm \
/nfs/share/home/tongliu/processordataset/sram/ndm/ts5n7lvta32x23m4wbzhocp.ndm \
/nfs/share/home/tongliu/processordataset/sram/ndm/ts5n7lvta512x17m4wbzhocp.ndm \
/nfs/share/home/tongliu/processordataset/sram/ndm/ts1n7hslvta1024x17m4wbzhocp.ndm \
/nfs/share/home/tongliu/processordataset/sram/ndm/ts1n7hslvta1024x64m4wbzhocp.ndm \
/nfs/share/home/tongliu/processordataset/sram/ndm/ts1n7hslvta256x32m2wbzhocp.ndm \
/nfs/share/home/tongliu/processordataset/sram/ndm/ts1n7hslvta512x32m2wbzhocp.ndm \
/nfs/share/home/tongliu/processordataset/sram/ndm/ts1n7hslvta512x8m2wbzhocp.ndm \
/nfs/share/home/tongliu/processordataset/sram/ndm/ts1n7hslvta64x21m2wbzhocp.ndm \
/nfs/share/home/tongliu/processordataset/sram/ndm/ts1n7hslvta64x22m2wbzhocp.ndm \
/nfs/share/home/tongliu/processordataset/sram/ndm/ts6n7lvtb16x56m2wbzhocp.ndm \
/nfs/share/home/tongliu/processordataset/sram/ndm/ts6n7lvtb16x64m2wbzhocp.ndm \
/nfs/share/home/tongliu/processordataset/sram/ndm/ts6n7lvtb256x64m2wbzhocp.ndm \
/nfs/share/home/tongliu/processordataset/sram/ndm/ts6n7lvtb512x64m2wbzhocp.ndm
"
set PLACEMENT_CONSTRAINT        ""
set RENAME_CELL_FILE           	"" 


################################################################################
###	Misc setting
################################################################################
set WORK_DIR               	[getenv PWD]
set SEARCH_PATH				"./"
set NUM_CORE				32

set REPORT_QOR					true
set REPORT_QOR_REPORT_POWER		true


#############################
### 	Other setting 	  ###
#############################

set DFP_CHECKER 	"${SCRIPT_DIR}/N6_database_checker_20200417.tcl"
set tCIC_CHECKER 	""

##################################################
## Please do not change the following variables ##
##################################################
set READ_RTL_BLOCK_NAME	read_rtl	;# Name of the block to be saved for ReadRTL.tcl
set FLOORPLAN_BLOCK_NAME	floorplan	;# Name of the block to be saved for Floorplan.tcl
set PLACEMENT_BLOCK_NAME	placement	;# Name of the block to be saved for Placement.tcl
set CTS_BLOCK_NAME		cts		;# Name of the block to be saved for CTS.tcl
set ROUTE_BLOCK_NAME		route		;# Name of the block to be saved for Route.tcl
set CHIP_FINISH_BLOCK_NAME	chipfinish	;# Name of the block to be saved for Chipfinish.tcl

set_host_options -max_cores ${NUM_CORE}

set PVT_FF  "ffgnp_0p825v_125c_cbest_CCbest_T"
set PVT_TT  "tt_0p75v_85c_typical"
set PVT_SS  "ssgnp_0p675v_m40c_cworst_CCworst_T"

set DB_FF   "/nfs/data/foundry/tsmc/tsmc6/TSMCHOME/digital/Front_End/timing_power_noise/CCS/tcbn06_bwph240l8p57cpd_base_svt_100a/tcbn06_bwph240l8p57cpd_base_svt${PVT_FF}_ccs.db /nfs/data/foundry/tsmc/tsmc6/TSMCHOME/digital/Front_End/timing_power_noise/CCS/tcbn06_bwph240l8p57cpd_base_lvt_100a/tcbn06_bwph240l8p57cpd_base_lvt${PVT_FF}_ccs.db /nfs/data/foundry/tsmc/tsmc6/TSMCHOME/digital/Front_End/timing_power_noise/CCS/tcbn06_bwph240l8p57cpd_base_ulvt_100a/tcbn06_bwph240l8p57cpd_base_ulvt${PVT_FF}_ccs.db"
set DB_TT   "/nfs/data/foundry/tsmc/tsmc6/TSMCHOME/digital/Front_End/timing_power_noise/CCS/tcbn06_bwph240l8p57cpd_base_svt_100a/tcbn06_bwph240l8p57cpd_base_svt${PVT_TT}_ccs.db /nfs/data/foundry/tsmc/tsmc6/TSMCHOME/digital/Front_End/timing_power_noise/CCS/tcbn06_bwph240l8p57cpd_base_lvt_100a/tcbn06_bwph240l8p57cpd_base_lvt${PVT_TT}_ccs.db /nfs/data/foundry/tsmc/tsmc6/TSMCHOME/digital/Front_End/timing_power_noise/CCS/tcbn06_bwph240l8p57cpd_base_ulvt_100a/tcbn06_bwph240l8p57cpd_base_ulvt${PVT_TT}_ccs.db"
set DB_SS   "/nfs/data/foundry/tsmc/tsmc6/TSMCHOME/digital/Front_End/timing_power_noise/CCS/tcbn06_bwph240l8p57cpd_base_svt_100a/tcbn06_bwph240l8p57cpd_base_svt${PVT_SS}_ccs.db /nfs/data/foundry/tsmc/tsmc6/TSMCHOME/digital/Front_End/timing_power_noise/CCS/tcbn06_bwph240l8p57cpd_base_lvt_100a/tcbn06_bwph240l8p57cpd_base_lvt${PVT_SS}_ccs.db /nfs/data/foundry/tsmc/tsmc6/TSMCHOME/digital/Front_End/timing_power_noise/CCS/tcbn06_bwph240l8p57cpd_base_ulvt_100a/tcbn06_bwph240l8p57cpd_base_ulvt${PVT_SS}_ccs.db"

set PVT_SRAM_FF "ffgnp_0p825v_125c_cbest_ccbest"
set PVT_SRAM_TT "ttt_0p750v_85c_typical"
set PVT_SRAM_SS "ssgnp_0p675v_m40c_cworst_ccworst_t"

set SRAM_FF "/nfs/share/home/tongliu/processordataset/sram/ts5n7lvta32x22m4wbzhocp${PVT_SRAM_FF}.db"
set SRAM_TT "/nfs/share/home/tongliu/processordataset/sram/ts5n7lvta32x22m4wbzhocp${PVT_SRAM_TT}.db"
set SRAM_SS "/nfs/share/home/tongliu/processordataset/sram/ts5n7lvta32x22m4wbzhocp${PVT_SRAM_SS}.db"

set_app_var link_library "${DB_FF} ${DB_TT} ${DB_SS} "

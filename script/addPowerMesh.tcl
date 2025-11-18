#################################################################
# ICC2 脚本
#################################################################

# 假设当前已经在 design library 中打开了 block
# set_current_block [get_blocks <your_block_name>]

##################
## 1. 添加布线阻塞 (Add Blockage)
##################
create_routing_blockage -boundary {0 0 2000 158}   -layers {M4 M5 M6 M7} -allow_pg_nets true -name "IOPG_rtBLK_bot"
create_routing_blockage -boundary {0 0 160 2000}    -layers {M4 M5 M6 M7} -allow_pg_nets true -name "IOPG_rtBLK_left"
create_routing_blockage -boundary {0 1842 2000 2000} -layers {M4 M5 M6 M7} -allow_pg_nets true -name "IOPG_rtBLK_top"
create_routing_blockage -boundary {1840 0 2000 2000} -layers {M4 M5 M6 M7} -allow_pg_nets true -name "IOPG_rtBLK_right"


################
## 2. 定义电源网络策略 (Define Power Mesh Strategy)
################

# 清理已有的 PG 对象，对应 Innovus 的 "deleteAllPowerPreroutes"
remove_pg_objects -all

# 创建一个新的 PG 策略
create_pg_strategy main_pg_strategy

#--- 定义标准单元的电源轨连接方式 (对应 Innovus 的 sroute) ---#
create_pg_std_cell_conn_pattern std_cell_rail_conn \
    -nets {VDD VSS} \
    -layers {M1}
add_to_pg_strategy main_pg_strategy -pattern std_cell_rail_conn

#--- 定义 RDL 层电源条样式 (对应 Innovus 的 addStripe RDL) ---#
create_pg_rectilinear_pattern rdl_pattern \
    -nets {VSS VDD} \
    -direction horizontal \
    -layer RDL \
    -width {35} \
    -spacing {10} \
    -pitch 90 \
    -offset 4
add_to_pg_strategy main_pg_strategy -pattern rdl_pattern

#--- 定义 T4M2 层电源条样式 (对应 Innovus 的 addStripe T4M2) ---#
create_pg_rectilinear_pattern t4m2_pattern \
    -nets {VSS VDD} \
    -direction vertical \
    -layer T4M2 \
    -width {8} \
    -spacing {2} \
    -pitch 20 \
    -offset 4
add_to_pg_strategy main_pg_strategy -pattern t4m2_pattern

#--- 定义 MET5 层电源条样式 (对应 Innovus 的 addStripe MET5) ---#
create_pg_rectilinear_pattern m5_pattern \
    -nets {VSS VDD} \
    -direction horizontal \
    -layer M5 \
    -width {1} \
    -spacing {5} \
    -pitch 12 \
    -offset 0.5
add_to_pg_strategy main_pg_strategy -pattern m5_pattern

#--- 定义 MET4 层电源条样式 (对应 Innovus 的 addStripe MET4) ---#
create_pg_rectilinear_pattern m4_pattern \
    -nets {VSS VDD} \
    -direction vertical \
    -layer M4 \
    -width {1} \
    -spacing {5} \
    -pitch 12 \
    -offset 0.5
add_to_pg_strategy main_pg_strategy -pattern m4_pattern

#--- (可选) 转换 memory 的 PG 定义 ---#
# set inst_mem [get_cells -hierarchical -filter "ref_name =~ S55NLLG1PH*"]
# 如果需要为特定实例创建 PG，可以为其创建单独的策略和 pattern，并使用 -boundary 选项


############################################
## 3. 编译并生成电源网络 (Compile Power Mesh)
############################################
#
# 这个命令会执行所有之前定义的 pattern，创建电源条，
# 并自动添加过孔（Vias）进行连接。
# 它同时完成了 Innovus 中 addStripe, sroute, editPowerVia 的工作。
#
compile_pg -strategies main_pg_strategy


###############################
## 4. 删除布线阻塞 (Delete Blockage)
###############################
# 对应 Innovus 的 "deleteRouteBlk"
remove_routing_blockages [get_routing_blockages {IOPG_rtBLK_bot IOPG_rtBLK_left IOPG_rtBLK_top IOPG_rtBLK_right}]

# 如果不想通过名字删除，也可以删除所有 routing blockage
# remove_routing_blockages [get_routing_blockages]
######backend dse config
proc load_config {group_name} {
    switch -- $group_name {
        1 {
            # 为组 '1' 生成的配置
            return [dict create \
            {utilization} {55} \
            {fp_shape} {R} \
            {side_ratio} {1 1}
        ]
        }
        default {
            # 如果请求的组名不存在，返回错误
            return -code error "错误：未知的配置组 '\$group_name'。"
        }
    }
}
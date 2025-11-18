#!/bin/csh

set total = 200        # 总任务数
set max_parallel = 50   # 最大并行数
set current = 0         # 起始任务编号
set lock_dir = "/nfs/share/home/tongliu/processordataset/script-eval/lock1600"  # 锁目录（使用PID防冲突）
set log_file = "/nfs/share/home/tongliu/processordataset/script-eval/parallele-1600.log"  # 日志文件
# 初始化日志系统
echo "========== 任务监控日志 ==========" > $log_file
echo "总任务数: $total" >> $log_file
echo "最大并行: $max_parallel" >> $log_file
echo "=================================" >> $log_file

# 创建锁目录
mkdir -p ${lock_dir}

# 主控制循环
while ($current < $total)
    # 统计有效锁数量

    set active_locks = `find $lock_dir -type d -name "*.lock" | wc -l`
    #if ("$active_locks" == "") set active_locks = 0
    #echo "$active_locks 锁已激活，当前任务: $current"
    # 当锁数量未达上限时启动新任务
    if ($active_locks < $max_parallel) then
        @ needed = $max_parallel - $active_locks
        echo "需要启动 $needed 个新任务"
        while ($needed > 0 && $current < $total)
            # 创建任务锁
            set task_lock = "${lock_dir}/task_${current}.lock"
            mkdir -p $task_lock  # 原子操作创建锁
            (echo "[START] 任务 $current " >> $log_file ; bsub -n 4 -Is ./build2.sh RocketTile $current 1600 1 ; rm -rf $task_lock ; echo "[END]   任务 $current " >> $log_file ) &
            @ current++
            @ needed--
        end
    else
        sleep 0.5  # 当锁满载时短暂休眠
    endif
end

# 等待最后一批任务完成
wait
rm -rf ${lock_dir} # 清理锁目录
echo "All Done (0-$total)" 

#!/system/bin/sh
# Wait..
sleep 30
# Virtual memory tweaks
stop perfd
echo '30' > /proc/sys/vm/swappiness
echo '0' > /sys/module/lowmemorykiller/parameters/enable_adaptive_lmk
echo '80' > /proc/sys/vm/overcommit_ratio
echo '400' > /proc/sys/vm/vfs_cache_pressure
echo '24300' > /proc/sys/vm/extra_free_kbytes
echo '128' > /proc/sys/kernel/random/read_wakeup_threshold
echo '256' > /proc/sys/kernel/random/write_wakeup_threshold
echo '1024' > /sys/block/mmcblk0/queue/read_ahead_kb
echo '0' > /sys/block/mmcblk0/queue/iostats
echo '1' > /sys/block/mmcblk0/queue/add_random
echo '1024' > /sys/block/mmcblk1/queue/read_ahead_kb
echo '0' > /sys/block/mmcblk1/queue/iostats
echo '1' > /sys/block/mmcblk1/queue/add_random
echo '4096' > /proc/sys/vm/min_free_kbytes
echo '0' > /proc/sys/vm/oom_kill_allocating_task
echo '90' > /proc/sys/vm/dirty_ratio
echo '70' > /proc/sys/vm/dirty_background_ratio
# Adding 500MB of zRAM
#  swapoff /dev/block/zram0 > /dev/null 2>&1
#  echo '1' > /sys/block/zram0/reset
#  echo '0' > /sys/block/zram0/disksize
#  echo '1' > /sys/block/zram0/max_comp_streams
#  echo '524288000' > /sys/block/zram0/disksize
#  mkswap /dev/block/zram0 > /dev/null 2>&1
#  swapon /dev/block/zram0 > /dev/null 2>&1
exit 0

#!/system/bin/sh
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# Busybox
if [ -e /su/xbin/busybox ]; then
	BB=/su/xbin/busybox;
else if [ -e /sbin/busybox ]; then
	BB=/sbin/busybox;
else
	BB=/system/xbin/busybox;
fi;
fi;

# Mount
$BB mount -t rootfs -o remount,rw rootfs;
$BB mount -o remount,rw /system;
$BB mount -o remount,rw /data;
$BB mount -o remount,rw /;

# Set KNOX to 0x0 on running /system
/sbin/resetprop -n ro.boot.warranty_bit "0"
/sbin/resetprop -n ro.warranty_bit "0"

# Fix Safetynet flags
/sbin/resetprop -n ro.boot.veritymode "enforcing"
/sbin/resetprop -n ro.boot.verifiedbootstate "green"
/sbin/resetprop -n ro.boot.flash.locked "1"
/sbin/resetprop -n ro.boot.ddrinfo "00000001"

# Fix Samsung Related Flags
/sbin/resetprop -n ro.fmp_config "1"
/sbin/resetprop -n ro.boot.fmp_config "1"
/sbin/resetprop -n sys.oem_unlock_allowed "0"

# MTweaks: Make internal storage directory
OKM_PATH=/data/.okm
if [ ! -d $OKM_PATH ]; then
	$BB mkdir $OKM_PATH;
fi;
$BB chmod 0777 $OKM_PATH;
$BB chown 0.0 $OKM_PATH;

# MTweaks: Delete backup directory
$BB rm -rf $OKM_PATH/bk;

# MTweaks: Make backup directory.
$BB mkdir $OKM_PATH/bk;
$BB chmod 0777 $OKM_PATH/bk;
$BB chown 0.0 $OKM_PATH/bk;

# MTweaks: Save original voltages
#$BB cat /sys/devices/system/cpu/cpufreq/mp-cpufreq/cluster1_volt_table > $OKM_PATH/bk/cpuCl1_stock_voltage
#$BB cat /sys/devices/system/cpu/cpufreq/mp-cpufreq/cluster0_volt_table > $OKM_PATH/bk/cpuCl0_stock_voltage
#$BB cat /sys/devices/14ac0000.mali/volt_table > $OKM_PATH/bk/gpu_stock_voltage
#$BB chmod -R 755 $OKM_PATH/bk/*;

# Deep Sleep fix by @Chainfire (from SuperSU)
for i in `ls /sys/class/scsi_disk/`; do
cat /sys/class/scsi_disk/$i/write_protect 2>/dev/null | grep 1 >/dev/null
if [ $? -eq 0 ]; then
echo 'temporary none' > /sys/class/scsi_disk/$i/cache_type
fi
done

# SELinux Permissive / Enforcing Patch
# 0 = Permissive, 1 = Enforcing
$BB chmod 777 /sys/fs/selinux/enforce
echo "0" > /sys/fs/selinux/enforce
$BB chmod 640 /sys/fs/selinux/enforce

# Stock Settings
echo interactive > /sys/devices/system/cpu/cpu4/cpufreq/scaling_governor
echo interactive > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
echo cfq > /sys/block/sda/queue/scheduler
echo cfq > /sys/block/mmcblk0/queue/scheduler
echo bic > /proc/sys/net/ipv4/tcp_congestion_control

# Customisations


# Unmount
$BB mount -t rootfs -o remount,rw rootfs;
$BB mount -o remount,ro /system;
$BB mount -o remount,rw /data;
$BB mount -o remount,ro /;


#!/sbin/sh
# Config Check script by djb77

mount /dev/block/platform/13540000.dwmmc0/by-name/USERDATA /data

# Variables
config=/data/media/0/OxygenKernel/config

# If config backup is present, alert installer
if [ -e $config/oxygenkernel-backup.prop ];then
  echo "install=1" > /tmp/aroma/backup.prop
fi

exit 10




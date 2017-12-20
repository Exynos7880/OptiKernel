#!/sbin/sh
# Config Restore script by djb77

mount /dev/block/platform/13540000.dwmmc0/by-name/USERDATA /data

# Variables
config=/data/media/0/OxygenKernel/config

# Copy backed up config files to /tmp/aroma
cp -f $config/* /tmp/aroma

exit 10

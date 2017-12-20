#!/sbin/sh

rm -rf /data/app/me.phh.superuser* /data/data/me.phh.superuser* /data/su /cache/.supersu /data/.supersu /magisk /data/magisk 
rm -rf /data/app/eu.chainfire.supersu* /data/data/eu.chainfire.supersu* /.subackup /sutmp /supersu /su
rm -f /cache/su.img /cache/SuperSU.apk /data/stock_boot_*.img.gz /data/su.img /data/SuperSU.apk /sbin/magic_mask.sh /sbin/launch_daemonsu.sh

cd /data
chmod 777 *.img
chmod 777 *.info
chmod 777 *.sh
rm -f *.img
rm -f *.info
rm -f *.pid
rm -f *.sh

exit 10

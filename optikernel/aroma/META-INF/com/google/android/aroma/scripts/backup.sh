#!/sbin/sh
# Config Backup script by djb77

mount /dev/block/platform/13540000.dwmmc0/by-name/USERDATA /data

# Variables
config=/data/media/0/OxygenKernel/config

# Check if TGP folder exists on Internal Memory, if not, it is created
if [ ! -d /data/media/0/OxygenKernel ];then
  mkdir /data/media/0/OxygenKernel
  chmod 777 /data/media/0/OxygenKernel
fi

# Check if config folder exists, if it does, delete it 
if [ -d $config-backup ];then
  rm -rf $config-backup
fi

# Check if config folder exists, if it does, ranme to backup
if [ -d $config ];then
  mv -f $config $config-backup
fi

# Check if config folder exists, if not, it is created
if [ ! -d $config ];then
  mkdir $config
  chmod 777 $config
fi

# Copy files from /tmp/aroma to backup location
cp -f /tmp/aroma/* $config

# Delete any files from backup that are not .prop files
find $config -type f ! -iname "*.prop" -delete

# Remove unwanted .prop files from the backup
cd $config
for delete_prop in *.prop 
do
  if grep "item" "$delete_prop"; then
    rm -f $delete_prop
  fi
  if grep "selected" "$delete_prop"; then
    rm -f $delete_prop
  fi
  if grep "install=0" "$delete_prop"; then
    rm -f $delete_prop
  fi 
done

exit 10

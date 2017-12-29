#!/bin/bash
#
# Optkernel Kernel Build Script By @Siddhant Naik 
# Do Not Use Without My Permission!!
# (C) @GhaithCraft

##############
# Parameters #
##############
ROOT_DIR=$(pwd)
KERNEL_NAME='OptiKernel'
ARCHITECTURE=arm64
TOOLCHAIN=/home/ghaith/android/Toolchains/UBERTC-aarch64-linux-android-6.0-kernel-2e6398ac9e86/bin/aarch64-linux-android-
ANDROID=N
BUILD_DIR=$ROOT_DIR/optikernel
ZIP_DIR=$BUILD_DIR/zip
AIK_DIR=$BUILD_DIR/Android-Image-Kitchen
RAMDISK_DIR=$BUILD_DIR/ramdisk

#############################   #
# Device Specific Functions #   # Add support for devices by creating functions in the following pattern
#############################   #

a7_2017() #Device 1
{
	DEVICE='A7_2017'
	DEFCONFIG=Optkernel_a7y17lte_defconfig
	DTSFILES="exynos7880-a7y17lte_eur_open_00 exynos7880-a7y17lte_eur_open_01"
}

a5_2017()  #Device 2
{
	DEVICE='A5_2017'
	DEFCONFIG=Optkernel_a5y17lte_defconfig
	DTSFILES="exynos7880-a5y17lte_eur_open_00 exynos7880-a5y17lte_eur_open_01"
}

###########################
# Setup Build Environment #
###########################

printf '\033[8;50;150t'
NUM_CPUS=`grep -c ^processor /proc/cpuinfo`
export ARCH=$ARCHITECTURE
export CROSS_COMPILE=$TOOLCHAIN
export ANDROIDVERSION=$ANDROID
DATE=$(date +%d' '%b' '%Y)

#################
# Setup Colours #
#################

RED="\033[0;31m"
GREEN="\033[1;32m"
DEFAULT="\033[0m"

#############
# Functions #
#############

clean_residue()
{
	echo -e $GREEN"Cleaning Residuals\n"$DEFAULT
	rm -r $AIK_DIR/ramdisk
	rm -r $AIK_DIR/split_img
	rm -rf $AIK_DIR/ramdisk-new.cpio.gz
	rm -r $ZIP_DIR/META-INF
}

clean_junk()
{
	echo -e $GREEN"Cleaning Previous Build Junk\n"$DEFAULT
	rm -rf $BUILD_DIR/*log
	rm -rf $ZIP_DIR/z*
	rm -rf $ZIP_DIR/*.zip
	rm -rf $ZIP_DIR/boot.img
	rm -rf $RAMDISK_DIR/*/split_img/boot.img-zImage
	rm -rf $RAMDISK_DIR/*/split_img/boot.img-dtb
	rm -rf $ZIP_DIR/Optkernel/anykernel2/anykernel2.zip
}

clean_dir()
{
	echo -e $RED"Cleaning Directory\n"$DEFAULT
	make clean && make mrproper
	clean_junk
}

build()
{
	KERNEL_VERSION=$(<$BUILD_DIR/version/$DEVICE)
	echo -e "\n==============================================================================================================================================="
	echo " Device      =   $DEVICE "
	echo " Defconfig   =   $DEFCONFIG "
	echo " Version     =   $KERNEL_VERSION "
	echo -e "===============================================================================================================================================\n"
	echo -e $GREEN"Starting Build Process for $DEVICE\n"$DEFAULT
sleep 5
	clean_junk
	build_kernel
	build_anykernel
	build_zip
}

build_kernel()
{
	# Setup Kernel Defconfig
	echo -e $GREEN"Setting Up Defconfig $DEFCONFIG\n"$DEFAULT
	echo
	make $DEFCONFIG
	sed -i "s;##VERSION##;$KERNEL_VERSION;" .config;
	
	# Build Image
	echo -e $GREEN"\nStarting To Build Image\n"$DEFAULT
	time make -j$NUM_CPUS 2>&1 |tee $BUILD_DIR/build_kernel.log
	
	# Check If Kernel Is Built
	if [ -e $ROOT_DIR/arch/arm64/boot/Image ]; then
		echo -e $GREEN"Kernel Sussfully Built\n"$DEFAULT
	else
		echo -e $RED"Kernel Build Failed\n"$DEFAULT
		read -p "Press any key to exit " option
		case "$option" in
			*)
				exit
				;;
		esac
	fi
	echo -e $GREEN"Starting To Build Image\n"$DEFAULT

	# Build DTB
	mkdir -p $ROOT_DIR/arch/arm64/boot/dtb && cd $ROOT_DIR/arch/arm64/boot/dtb && rm -rf *
	echo -e $GREEN"Starting To Build DTB\n"$DEFAULT
	for dts in $DTSFILES; do
		echo "=> Processing: ${dts}.dts"
		${CROSS_COMPILE}cpp -nostdinc -undef -x assembler-with-cpp -I "$ROOT_DIR/include" "$ROOT_DIR/arch/arm64/boot/dts/${dts}.dts" > "${dts}.dts"
		echo "=> Generating: ${dts}.dtb"
		$ROOT_DIR/scripts/dtc/dtc -p 0 -i "$ROOT_DIR/arch/arm64/boot/dts" -O dtb -o "${dts}.dtb" "${dts}.dts"
	done
	$ROOT_DIR/scripts/dtbTool/dtbTool -o "$ROOT_DIR/arch/arm64/boot/dtb.img" -d "$ROOT_DIR/arch/arm64/boot/dtb/" -s 2048
	echo -e $GREEN"DTB Generated\n"$DEFAULT
}

build_anykernel()
{
	echo -e $GREEN"Building AnyKernel Zip File\n"$DEFAULT
	cd $BUILD_DIR/anykernel2
	zip -gq anykernel2.zip -r * -x "*~"
	mv anykernel2.zip $ZIP_DIR/alpahbetkernel/anykernel2/anykernel2.zip
}

build_zip()
{
	# Build Ramdisk && boot.img
	echo -e $GREEN"Building boot.img\n"$DEFAULT
	mv $ROOT_DIR/arch/arm64/boot/Image $RAMDISK_DIR/$DEVICE/split_img/boot.img-zImage
	mv $ROOT_DIR/arch/arm64/boot/dtb.img $RAMDISK_DIR/$DEVICE/split_img/boot.img-dtb
	cp -r $RAMDISK_DIR/$DEVICE/* $AIK_DIR
	cd $AIK_DIR
	find . -name \.placeholder -type f -delete
	./repackimg.sh
	echo SEANDROIDENFORCE >> image-new.img
	mv image-new.img $ZIP_DIR/boot.img
	echo 

	# Append Version Info
	cp -r $BUILD_DIR/aroma/META-INF $ZIP_DIR/META-INF
	sed -i "s;###DATE###;$DATE;" $ZIP_DIR/META-INF/com/google/android/aroma-config;
	sed -i "s;###DEVICE###;$DEVICE;" $ZIP_DIR/META-INF/com/google/android/aroma-config;
	sed -i "s;###VERSION###;$KERNEL_VERSION;" $ZIP_DIR/META-INF/com/google/android/aroma-config;
	
	# Build Zip File
	echo -e $GREEN"Building Zip File\n"$DEFAULT
	cd $ZIP_DIR
	ZIPNAME=$KERNEL_NAME-$DEVICE-v$KERNEL_VERSION.zip
	zip -gq $ZIPNAME -r * -x "*~"
	mv -f $ZIPNAME $BUILD_DIR/$ZIPNAME
	cd $ROOT_DIR
	
	# Check If Zip Is Built
	if [ -e $BUILD_DIR/$ZIPNAME ]; then
		echo -e $GREEN"Kernel Build Finished Successfully\n"$DEFAULT
	else
		echo -e $RED"Zip Build Failed\n"$DEFAULT
	fi
	
	# Clean AIK Directory
	clean_residue
}

################
# Main Program #
################
clear
echo
echo "==============================================================================================================================================="
echo "                                                   $KERNEL_NAME Build Menu" 
echo "                                                          $DATE"
echo "==============================================================================================================================================="
echo 
echo "	  	      0  = Clean Directory             |     l  = Open Build_kernel.log"
echo "		      1  = Build Kernel for A7_2017    |" 
echo "		      2  = Build Kernel for A5_2017    |"
echo 
echo -e "===============================================================================================================================================\n"
read -p "Select an option " option
case "$option" in
	0)
		clean_dir
		;;
	1)
		clear
		a7_2017
		build
		;;
	2)
		clear
		a5_2017
		build
		;;
	l)
		gedit $BUILD_DIR/build_kernel.log
		. build.sh
		;;
esac

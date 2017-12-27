# Optikernel

![Optikernel Logo](https://github.com/Exynos7880/OptiKernel/blob/build/optikernel/logo.png?raw=true)

A Custom Kernel for Samsung Galaxy A7 / A5 2017.

The main purpose of this Kernel is to have a stock-like Kernel that runs on A7 and A5 2017
variants, but capable of running A5/A7 2017 and Ported Firmwares.


Currently supporting A7/A5 2017 / S8 Port / NFE ROMS But N8 Port Coming Soon.


* XDA A7/A5 2017 Forum: Coming Soon ...


Compiled using my own built custom toolchain

* URL: https://github.com/djb77/aarch64-cortex_a53-linux-gnueabi

## How to use
Adjust the toolchain path in build.sh and Makefile to match the path on your system. 

Run build.sh with the following options, doesn't matter what order keep and silent are in.

-	**./build.sh 0** will perform Clean Workspace
-	**./build.sh 1** will perform Build Optikernel boot.img + zip for A7 2017
-	**./build.sh 2** will perform Build Optikernel boot.img + zip for A5 2017

When finished, the new files and logs will be created in the output directory.

If Java is installed, the .zip file will be signed.


## Credit and Thanks to the following:
- [Samsung Open Source Release Center](http://opensource.samsung.com) for the Source code
- [The Linux Kernel Archive](https://www.kernel.org) for the Linux Patches
- @osm0sis for [Android Image Kitchen](https://github.com/osm0sis/Android-Image-Kitchen/tree/AIK-Linux) and [anykernel2](https://github.com/osm0sis/AnyKernel2)
- @Tkkg1994 for all his help and numerous code samples from his source
- @Chainfire for the Deep Sleep Fix from SuperSU
- @morogoku for MTweaks and lots of help and commits


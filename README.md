# OptiKernel 

A Custom Kernel for Samsung Galaxy A7/5 2017
The main purpose of this Kernel is to have a stock-like Kernel that runs on SM-A720F $ A520F

## How to use
- Adjust the toolchain path in build.sh and Makefile to match the path on your system. 
- Run build.sh and follow the prompts, alternatively you can use a command line:

-	./build.sh 0  will perform Clean Workspace
-	./build.sh 1  will perform Build FlashKernel boot.img + zip for A7 2017
-	./build.sh 2  will perform Build FlashKernel boot.img + zip for A5 2017

  IE:   ./build.sh 1

- When finished, the new .img or .zip file will be created in the build directory.


## Credit and Thanks to the following:
- Samsung Open Source Release Center for the Source code (http://opensource.samsung.com)

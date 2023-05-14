#!/bin/bash

# Bash Color
green='\033[01;32m'
red='\033[01;31m'
blink_red='\033[05;31m'
restore='\033[0m'

clear

# Number of parallel jobs to run
THREAD="-j$(nproc)"

# Toolchains
TOOLCHAINS_PATH="$HOME/kernel-env/tools"

# Proton Clang
CLANG_PATH="$TOOLCHAINS_PATH/clang-aosp"

# GCC 4.9
GCC_PATH="$TOOLCHAINS_PATH/gcc"

# Path to executables in Clang toolchain
CLANG_BIN="$CLANG_PATH/bin"

# 64-bit GCC toolchain prefix
GCC64_PREFIX="$TOOLCHAINS_PATH/gcc-64/bin/aarch64-linux-android-"

# 32-bit GCC toolchain prefix
GCC32_PREFIX="$TOOLCHAINS_PATH/gcc-32/bin/arm-linux-androideabi-"

# Setup variables
export LD_LIBRARY_PATH="$CLANG_BIN/../lib:$CLANG_BIN/../lib64:$LD_LIBRARY_PATH"
export PATH="$CLANG_BIN:$PATH"
export CROSS_COMPILE="$GCC64_PREFIX"
export CROSS_COMPILE_ARM32="$GCC32_PREFIX"
export CLANG_TRIPLE="aarch64-linux-gnu-"

# Setup Clang flags
CLANG_FLAGS="CC=clang AR=llvm-ar NM=llvm-nm OBJCOPY=llvm-objcopy OBJDUMP=llvm-objdump STRIP=llvm-strip"

# Kernel Details
DEFCONFIG="platina_user_defconfig"

# Paths
KERNEL_DIR=`pwd`

function make_kernel {
    echo
    make O=out $CLANG_FLAGS $DEFCONFIG
    make O=out $CLANG_FLAGS savedefconfig
    make O=out $CLANG_FLAGS $THREAD
}

DATE_START=$(date +"%s")

echo -e "${green}"
echo "-----------------"
echo "Making Kernel:"
echo "-----------------"
echo -e "${restore}"

export ARCH=arm64
export SUBARCH=arm64
export KBUILD_BUILD_USER=zhhhhh
export KBUILD_BUILD_HOST=Mac-Pro
echo

make_kernel

echo -e "${green}"
echo "-------------------"
echo "Build Completed in:"
echo "-------------------"
echo -e "${restore}"

DATE_END=$(date +"%s")
DIFF=$(($DATE_END - $DATE_START))
echo "Time: $(($DIFF / 60)) minute(s) and $(($DIFF % 60)) seconds."
echo

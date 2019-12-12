#! /usr/bin/bash

. ./prepare.sh

# Cross Compiler
CROSS_COMPILE=$ANDROID_ROOT/prebuilts/gcc/linux-x86/aarch64/aarch64-linux-android-4.9/bin/aarch64-linux-android-
CROSS_COMPILE=/data/gcc-linaro-7.4.1-2019.02-x86_64_aarch64-linux-gnu/bin/aarch64-linux-gnu-

# Build command
BUILD_ARGS="CROSS_COMPILE=\"/usr/bin/ccache $CROSS_COMPILE\""

COMPILER_NAME=gcc

# source shared parts
. ./build_shared.sh

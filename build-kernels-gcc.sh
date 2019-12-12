#! /usr/bin/bash

. ./prepare.sh

# Cross Compiler
CROSS_COMPILE=$ANDROID_ROOT/prebuilts/gcc/linux-x86/aarch64/aarch64-linux-android-4.9/bin/aarch64-linux-android-
# Build command
BUILD_ARGS="CROSS_COMPILE=\"$CROSS_COMPILE\""

COMPILER_NAME=gcc

# source shared parts
. ./build_shared.sh

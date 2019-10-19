cd ../../../..
ANDROID_ROOT=$(pwd)

# Cross Compiler
GCC_CC=$ANDROID_ROOT/prebuilts/gcc/linux-x86/aarch64/aarch64-linux-android-4.9/bin/aarch64-linux-android-
CLANG_CC=$ANDROID_ROOT/prebuilts/clang/host/linux-x86/clang-r353983c/bin/clang

# Build command
BUILD="make O=$KERNEL_TMP ARCH=arm64 CC=$CLANG_CC CLANG_TRIPLE=aarch64-linux-gnu CROSS_COMPILE=$GCC_CC -j$(nproc)"

# source shared parts
. "$OLDPWD"/build_shared.sh

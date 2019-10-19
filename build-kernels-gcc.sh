cd ../../../..

# Cross Compiler
CROSS_COMPILE=$ANDROID_ROOT/prebuilts/gcc/linux-x86/aarch64/aarch64-linux-android-4.9/bin/aarch64-linux-android-
# Build command
BUILD="make O=$KERNEL_TMP ARCH=arm64 CROSS_COMPILE=$CROSS_COMPILE -j$(nproc)"

# source shared parts
. "$OLDPWD"/build_shared.sh

cd ../../../..
export ANDROID_ROOT=$(pwd)
export KERNEL_TOP=$ANDROID_ROOT/kernel/sony/msm-4.14
export KERNEL_TMP=$ANDROID_ROOT/out/kernel-414-clang

# Cross Compiler
export GCC_CC=$ANDROID_ROOT/prebuilts/gcc/linux-x86/aarch64/aarch64-linux-android-4.9/bin/aarch64-linux-android-
export CLANG_CC=$ANDROID_ROOT/prebuilts/clang/host/linux-x86/clang-r353983c/bin/clang

# Mkdtimg tool
export MKDTIMG=$ANDROID_ROOT/prebuilts/misc/linux-x86/libufdt/mkdtimg


# Check if mkdtimg tool exists
if [ ! -f $MKDTIMG ]; then
    echo "mkdtimg: File not found!"
    echo "Building mkdtimg"
    export ALLOW_MISSING_DEPENDENCIES=true
    make mkdtimg
fi

LOIRE="suzu kugo blanc"
TONE="dora kagura keyaki"
YOSHINO="lilac maple poplar"
NILE="discovery pioneer voyager"
GANGES="kirin mermaid"
TAMA="akari apollo akatsuki"
KUMANO="bahamut griffin"

PLATFORMS="loire tone yoshino nile ganges tama kumano"

cd $KERNEL_TOP/kernel

echo "================================================="
echo "Your Environment:"
echo "ANDROID_ROOT: ${ANDROID_ROOT}"
echo "KERNEL_TOP  : ${KERNEL_TOP}"
echo "KERNEL_TMP  : ${KERNEL_TMP}"

for platform in $PLATFORMS; do \

case $platform in
loire)
    DEVICE=$LOIRE;
    DTBO="false";;
tone)
    DEVICE=$TONE;
    DTBO="false";;
yoshino)
    DEVICE=$YOSHINO;
    DTBO="false";;
nile)
    DEVICE=$NILE;
    DTBO="false";;
ganges)
    DEVICE=$GANGES;
    DTBO="false";;
tama)
    DEVICE=$TAMA;
    DTBO="true";;
kumano)
    DEVICE=$KUMANO;
    DTBO="true";;
esac

for device in $DEVICE; do \
    DEVICE_TMP=$KERNEL_TMP/${device}-clang
    ret=$(mkdir -p ${DEVICE_TMP} 2>&1);
    if [ ! -d ${DEVICE_TMP} ] ; then
        echo "Check your environment";
        echo "ERROR: ${ret}";
        exit 1;
    fi

    # Build command
    BUILD="make O=$DEVICE_TMP ARCH=arm64 CC=$CLANG_CC CLANG_TRIPLE=aarch64-linux-gnu CROSS_COMPILE=$GCC_CC -j$(nproc)"

    # Copy prebuilt kernel
    CP_BLOB="cp $DEVICE_TMP/arch/arm64/boot/Image.gz-dtb $KERNEL_TOP/common-kernel/kernel-dtb"

    echo "================================================="
    echo "Platform -> ${platform} :: Device -> $device"
    ret=$(${BUILD} aosp_$platform"_"$device\_defconfig 2>&1);
    case "$ret" in
        *"error"*|*"ERROR"*) echo "ERROR: $ret"; exit 1;;
    esac

    echo "The build may take up to 10 minutes. Please be patient ..."
    echo "Building new kernel image ..."
    LOG_FILE=$KERNEL_TMP/build_log_${device}_clang
    echo "Logging to $LOG_FILE"
    $BUILD >$LOG_FILE 2>&1;

    echo "Copying new kernel image ..."
    ret=$(${CP_BLOB}-${device} 2>&1);
    case "$ret" in
        *"error"*|*"ERROR"*) echo "ERROR: $ret"; exit 1;;
    esac
    if [ $DTBO = "true" ]; then
        $MKDTIMG create $KERNEL_TOP/common-kernel/dtbo-$device\.img `find $DEVICE_TMP/arch/arm64/boot/dts -name "*.dtbo"`
    fi
done
done

echo "================================================="
echo "Clean up environment"
echo "Done!"
unset ANDROID_ROOT
unset KERNEL_TOP
unset KERNEL_CFG
unset KERNEL_TMP

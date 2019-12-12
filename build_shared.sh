# exit on any error
set -e

ANDROID_ROOT="$PWD"
LOIRE="suzu kugo blanc"
TONE="dora kagura keyaki"
YOSHINO="lilac maple poplar"
NILE="discovery pioneer voyager"
GANGES="kirin mermaid"
TAMA="akari apollo akatsuki"
KUMANO="bahamut griffin"

PLATFORMS="loire tone yoshino nile ganges tama kumano"

# Mkdtimg tool
MKDTIMG=$ANDROID_ROOT/prebuilts/misc/linux-x86/libufdt/mkdtimg
# Copy prebuilt kernel
CP_BLOB="cp $KERNEL_TMP/arch/arm64/boot/Image.gz-dtb $KERNEL_TOP/common-kernel/kernel-dtb"

KERNEL_TOP=$ANDROID_ROOT/kernel/sony/msm-4.14
KERNEL_TMP=$ANDROID_ROOT/out/kernel-414/$COMPILER_NAME

# Check if mkdtimg tool exists
if [ ! -f "$MKDTIMG" ]; then
    echo "Prebuilt mkdtimg $MKDTIMG not found!"
    export MKDTIMG=$ANDROID_ROOT/out/host/linux-x86/bin/mkdtimg
    if [ ! -f "$MKDTIMG" ]; then
        echo "mkdtimg: File not found!"
        echo "Building mkdtimg"
        export ALLOW_MISSING_DEPENDENCIES=true
        make mkdtimg
    fi
fi

cd "$KERNEL_TOP"/kernel

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
        rm -rf ${KERNEL_TMP}
        mkdir -p ${KERNEL_TMP}

        echo "================================================="
        echo "Platform -> ${platform} :: Device -> $device"
        ${BUILD} aosp_"$platform"_"$device"_defconfig

        echo "The build may take up to 10 minutes. Please be patient ..."
        echo "Building new kernel image ..."
        LOG_FILE="$KERNEL_TMP/build_log_$device"
        echo "Logging to $LOG_FILE"
        $BUILD >"$LOG_FILE" 2>&1;

        echo "Copying new kernel image ..."
        "${CP_BLOB}-${device}"

        if [ $DTBO = "true" ]; then
            $MKDTIMG create "$KERNEL_TOP/common-kernel/dtbo-$device.img" "$(find "$KERNEL_TMP"/arch/arm64/boot/dts -name "*.dtbo")"
        fi
    done
done


echo "================================================="
echo "Clean up environment"
echo "Done!"

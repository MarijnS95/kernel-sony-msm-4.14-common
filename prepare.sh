#! /usr/bin/bash

if [ -z "$ANDROID_BUILD_TOP" ]; then
    ANDROID_ROOT=$(realpath ../../../..)
    echo "ANDROID_BUILD_TOP not set, guessing root at $ANDROID_ROOT"
else
    ANDROID_ROOT="$ANDROID_BUILD_TOP"
fi

export USE_CCACHE=1
export CCACHE_DIR="$HOME/.aosp-ccache"
export CCACHE_COMPRESS=1

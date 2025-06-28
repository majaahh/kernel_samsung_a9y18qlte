#!/bin/bash

# Toolchain/GCC
PREV_PATH="$(realpath ..)"
GCC_DIR="$PREV_PATH/gcc"
CURRENT_PATH="$(pwd)"
if [ ! -d "$GCC_DIR" ]; then
    echo "Cloning GCC 4.9"
    git clone --depth=1 -j$(nproc --all) "https://github.com/LineageOS/android_prebuilts_gcc_linux-x86_aarch64_aarch64-linux-android-4.9" "$GCC_DIR"
fi
export PATH="$GCC_DIR/bin:$PATH"

# Variables
export KBUILD_BUILD_USER="$USER"
export KBUILD_BUILD_HOST="$HOSTNAME"
export CROSS_COMPILE=aarch64-linux-android-
export ARCH=arm64
export SUBARCH=arm64
export HEADER_ARCH=arm64
DEFCONFIG=a9y18qlte_defconfig
ZIP="Kernel-a9y18qlte-$(date +%Y%m%d-%H%M).zip"
BUILDS_DIR="$(pwd)/builds"

# Compile
make -j$(nproc --all) O=out $DEFCONFIG
make -j$(nproc --all) ARCH=arm64 O=out SUBARCH=arm64 O=out \
    CC=${GCC_DIR}/bin/aarch64-linux-android-gcc \
    LD=${GCC_DIR}/bin/aarch64-linux-android-ld.bfd \
    AR=${GCC_DIR}/bin/aarch64-linux-android-ar \
    AS=${GCC_DIR}/bin/aarch64-linux-android-as \
    NM=${GCC_DIR}/bin/aarch64-linux-android-nm \
    OBJCOPY=${GCC_DIR}/bin/aarch64-linux-android-objcopy \
    OBJDUMP=${GCC_DIR}/bin/aarch64-linux-android-objdump \
    STRIP=${GCC_DIR}/bin/aarch64-linux-android-strip \
    CROSS_COMPILE=${GCC_DIR}/bin/aarch64-linux-android-

if [ -d "ak3" ]; then
    mv "out/arch/arm64/boot/Image.gz-dtb" "ak3"
    cd "ak3"
    [ ! -d "$BUILDS_DIR" ] && mkdir -p "$BUILDS_DIR"
    zip -r9 -q "$BUILDS_DIR/$ZIP" * -x .git .github README.md
    rm -f "Image.gz-dtb"
    cd "$CURRENT_PATH"
fi

#!/bin/bash

# Variables
DEFCONFIG=a9y18qlte_defconfig
ARCHIVE="Kernel-a9y18qlte-$(date +%Y%m%d-%H%M)"
BUILD_DIR="$(pwd)/build"
BUILD_OUT="$BUILD_DIR/out"
OUT="$(pwd)/out"
TOOLS_DIR="$(pwd)/tools"
AK3="$(pwd)/ak3"
PREV_PATH="$(realpath ..)"
CLANG_DIR="$PREV_PATH/clang"
CURRENT_PATH="$(pwd)"
MKBOOTIMG="$TOOLS_DIR/mkbootimg"
[[ ! -d "$BUILD_OUT" ]] && mkdir -p $BUILD_OUT
[[ ! -d "$CLANG_DIR" ]] && \
    git clone --depth=1 -j$(nproc --all) "https://github.com/vijaymalav564/vortex-clang.git" "$CLANG_DIR"

# Exports
export KBUILD_BUILD_USER="$USER"
export KBUILD_BUILD_HOST="$HOSTNAME"
export ARCH=arm64
export SUBARCH=arm64
export HEADER_ARCH=arm64
export PATH="$CLANG_DIR/bin:$PATH"

# Compile
make -j$(nproc --all) O=$OUT $DEFCONFIG
make -j$(nproc --all) O=$OUT \
    CC=clang \
    LLVM_DIS=llvm-dis AR=llvm-ar NM=llvm-nm LD=ld.lld OBJDUMP=llvm-objdump STRIP=llvm-strip \
    CLANG_TRIPLE=aarch64-linux-gnu- \
    CROSS_COMPILE=aarch64-linux-gnu-

[[ ! -f "$AK3/anykernel.sh" ]] && \
    git submodule update --init -f -q --checkout --recursive

CMDLINE="console=null androidboot.hardware=qcom user_debug=31 msm_rtb.filter=0x37 ehci-hcd.park=3 lpm_levels.sleep_disabled=1 sched_enable_hmp=1 sched_enable_power_aware=1 service_locator.enable=1 swiotlb=1 firmware_class.path=/vendor/firmware_mnt/image"

"$MKBOOTIMG" \
    --base 0x00000000 \
    --board SRPRI18A007 \
    --cmdline "$CMDLINE" \
    --header_version 0 \
    --kernel "$OUT/arch/arm64/boot/Image.gz-dtb" \
    --kernel_offset 0x00008000 \
    --os_patch_level 2022-06 \
    --os_version 10.0.0 \
    --pagesize 4096 \
    --ramdisk "$BUILD_DIR/ramdisk" \
    --ramdisk_offset 0x02000000 \
    --second_offset 0x00f00000 \
    --tags_offset 0x01e00000 \
    -o "$BUILD_OUT/boot.img"

if [[ ! -f "$BUILD_OUT/boot.img" ]]; then
    echo "boot.img build failed"
    exit 1
fi

cp -fa "$BUILD_OUT/boot.img" "$AK3/boot.img"
(
cd "ak3"
tar cf "$BUILD_OUT/$ARCHIVE.tar" "boot.img"
zip -r9 -q "$BUILD_OUT/$ARCHIVE.zip" * -x .git .github README.md
rm -f "boot.img"
)

#!/bin/bash
set -e
echo "[*] Build Script for Nintendo Switch"
cd "$(dirname "$0")"
mkdir -p build
cd build
rm -rf supertux2.nro supertux2.elf control.nacp
echo "[*] Configuring" 

if [ $DEVKITPRO = "" ]; then
    echo "Please set DEVKITPRO to your devkitPro installation"
    exit 1
fi

$DEVKITPRO/devkitA64/bin/aarch64-none-elf-cmake -DSWITCH=ON -DCMAKE_TOOLCHAIN_FILE="${DEVKITPRO}/cmake/Switch.cmake" ../neo

echo "[*] Building"
make -j$(nproc) # I paid for the whole CPU, I'm gonna use the whole CPU.

echo "[*] Creating NACP"
COMMIT=$(git rev-parse --short HEAD)
nacptool --create "SuperTux2" "SuperTux Team" "dev-${COMMIT}" control.nacp
echo "[*] Creating NRO"
elf2nro supertux2.elf supertux2.nro --nacp=control.nacp --icon=../data/images/engine/icons/supertux-256x256.png

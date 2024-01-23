# Builds the entire OS into an ISO
export OS_IMG=build/os.iso

rm -rf build
mkdir build

# First, builds bootloader
export BOOTLOADER=out/true_boot.bin
export NEW_BOOTLOADER_LOC=../build/boot.bin

cd bootloader
make
mv $BOOTLOADER $NEW_BOOTLOADER_LOC
make clean

cd ..

# Then builds the kernel
export KERNEL=out/kernel.bin
export NEW_KERNEL_LOC=../build/kernel.bin

cd kernel
make
mv $KERNEL $NEW_KERNEL_LOC
make clean

# Finally, creates the final OS image

cat $NEW_BOOTLOADER_LOC $NEW_KERNEL_LOC > ../$OS_IMG

cd ..

truncate -s1440K $OS_IMG

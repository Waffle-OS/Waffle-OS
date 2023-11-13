BOOT_SRC = src/bootloader/boot.asm
BOOT_BIN = out/boot.img
KERNEL_BIN = out/kernel.sys 
KERNEL_SRC = src/kernel.asm

build:
	nasm -f bin ${BOOT_SRC} -o ${BOOT_BIN}
	truncate --size=1474560 ${BOOT_BIN}

run:
	qemu-system-x86_64 -hda ${BOOT_BIN}
	
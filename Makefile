BOOT_SRC = bootloader/boot.asm
BOOT_BIN = out/boot.bin
KERNEL_ENTRY = kernel/entry.asm
KERNEL_SRC = kernel/main.c
ENTRY_ELF = out/entry.o
KERNEL_ELF = out/main.o
KERNEL_BIN = out/main.bin
OS_IMG = out/os.img

build: out/
	nasm -f bin ${BOOT_SRC} -o ${BOOT_BIN}
	nasm -f elf32 ${KERNEL_ENTRY} -o ${ENTRY_ELF}
	i686-elf-gcc -ffreestanding -m32 -g -c ${KERNEL_SRC} -o ${KERNEL_ELF}
	i686-elf-ld -Ttext 0x8200 --oformat binary ${ENTRY_ELF} ${KERNEL_ELF} -o ${KERNEL_BIN}
	cat ${BOOT_BIN} ${KERNEL_BIN} > ${OS_IMG} 
	truncate --size=1474560 ${OS_IMG}

run:
	qemu-system-x86_64 -hda ${OS_IMG}

out/:
	mkdir out
	
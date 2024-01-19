BOOT_SRC := boot.asm
EXBOOT_SRC := exboot.asm

BOOT_BIN := out/boot.bin
EXBOOT_BIN := out/exboot.bin

FINAL_BOOT := out/true_boot.bin

all: build

build: out/
	nasm -f bin ${BOOT_SRC} -o ${BOOT_BIN}
	nasm -f bin ${EXBOOT_SRC} -o ${EXBOOT_BIN}
	cat ${BOOT_BIN} ${EXBOOT_BIN} > ${FINAL_BOOT}

out/:
	mkdir out

clean:
	rm -rf out

# Is meant to be used to test the bootloader before it jumps to kernel.
run: build
	truncate -s1440K ${FINAL_BOOT}
	qemu-system-x86_64 -hda ${FINAL_BOOT} -no-reboot 

.PHONY: build run

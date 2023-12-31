all:

BOOT_SRC := bootloader/boot.asm
BOOT_BIN := out/boot.bin
KERNEL_ENTRY := kernel/entry.asm 
KERNEL_SRC := kernel/main.c drivers/vga/tty.c drivers/vga/cursor.c drivers/interrupts/pic.c drivers/terminal/terminal.c
KERNEL_OBJ := $(foreach file, ${KERNEL_SRC}, out/$(basename $(notdir ${file})).o)	
ENTRY_OBJ := out/entry.o
KERNEL_BIN := out/main.bin
OS_IMG := out/os.img

target = out/$(patsubst %.s,%.o,$(notdir ${1}))
obj.c :=

define obj
  $(call target,${1}) : ${1} | out
  obj$(suffix ${1}) += $(call target,${1})
endef


define SOURCES
  $(foreach src,${1},$(eval $(call obj,${src})))
endef

$(eval $(call SOURCES, ${KERNEL_SRC}))

all: out/ ${obj.c} build 

${obj.c} : % :
	i686-elf-gcc -m32 -ffreestanding -g -c -o $(basename $@).o $^ -Wall -Wextra -O4

run:
	qemu-system-x86_64 -hda ${OS_IMG}
	
out/:
	mkdir out

build: bootloader
	nasm -f elf32 -o ${ENTRY_OBJ} ${KERNEL_ENTRY}
	i686-elf-ld -Ttext 0x8200 --oformat binary ${ENTRY_OBJ} ${KERNEL_OBJ} -o ${KERNEL_BIN}
	cat ${BOOT_BIN} ${KERNEL_BIN} > ${OS_IMG} 
	truncate --size=1474560 ${OS_IMG}

bootloader:
	nasm -f bin ${BOOT_SRC} -o ${BOOT_BIN}

clean:
	rm -rf out

.PHONY: bootloader kernel_other
	
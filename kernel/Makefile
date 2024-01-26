
# A lot of this stuff was copied from stack overflow
# If you wanna make the build process better, please do
# (I am terrible at it)

CC := i686-elf-gcc
LD := i686-elf-ld
KERNEL_BIN := out/kernel.bin
KERNEL_SRC := main.c kutils/panic.c serial/serial.c serial/terminal.c \
interrupts/pic.c
KERNEL_ENTRY := entry.asm


KERNEL_OBJ := $(foreach file, ${KERNEL_SRC}, out/$(basename $(notdir ${file})).o)	
ENTRY_OBJ := out/entry.o

target = out/$(patsubst %.s,%.o,$(notdir ${1}))
obj.c :=

all: build

define obj
  $(call target,${1}) : ${1} | out
  obj$(suffix ${1}) += $(call target,${1})
endef


define SOURCES
  $(foreach src,${1},$(eval $(call obj,${src})))
endef

$(eval $(call SOURCES, ${KERNEL_SRC}))


${obj.c} : % :
	${CC} -m32 -ffreestanding -c -o $(basename $@).o $^ -Wall -Wextra -O1

build: out/ ${obj.c}
	nasm -f elf32 -o ${ENTRY_OBJ} ${KERNEL_ENTRY}
	${LD} -T kernel.ld ${KERNEL_OBJ}

out/:
	mkdir out

clean:
	rm -rf out

.PHONY: build

%define MAGIC_NUM 0x534D4150

; The beginning of the stage 2 bootloader
stage2:
.get_mmap:
        clc
        mov     EAX, 0xE820
        xor     EBX, EBX
        mov     ECX, 24
        mov     EDX, MAGIC_NUM
        mov     DI, 0x500
        int     0x15
        jc      .mmap_error
.mmap_loop:
        or      EBX, EBX
        jz      load_kernel
        mov     EAX, 0xE820
        mov     EDX, MAGIC_NUM
        add     DI, 24
        mov     ECX, 24
        int     0x15
        jmp     .mmap_loop
.mmap_error:
        mov     SI, mmap_error_msg
        call    puts
        jmp     $

mmap_error_msg:         db 'Unable to obtain memory map.', NEWL, 0
        
load_kernel:
        clc
        mov     AH, 0x42
        mov     DL, [drive_num]
        mov     SI, kernel_lba_packet
        int     0x13
        jnc     enter32

.load_error:
        mov     SI, load_error_msg
        call    puts
        jmp     $

load_error_msg:         db 'Unable to load kernel', NEWL, 0

kernel_lba_packet:
        .size:          db 0x10
        .reserved:      db 0
        .blocks:        dw 20
        .offset:        dw 0x9000
        .segment:       dw 0
        .low_address:   dd 4                    ; Low 32 bits of address
        .high_address:  dw 0                    ; High 16 bits of address
        .null:          dw 0



enter32:
        ; Loading GDT
        cli
        lgdt    [gdt_start.desc]

        mov     EAX, CR0
        or      EAX, 1
        mov     CR0, EAX
        

        jmp     0x08:main32

        hlt



%include "bootloader/misc/gdt.asm"

[BITS 32]

main32:
        mov     AH, 0x07
        mov     AL, 'H'
        mov     EDX, 0xb8000
        mov     [EDX], AX

        jmp     0x9000
        
        hlt

times (512*4)-($-$$) db 0

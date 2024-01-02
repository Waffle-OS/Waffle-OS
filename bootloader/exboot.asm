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
        jmp     $

enter32:
        ; Loading GDT
        cli
        lgdt    [gdt_data.desc]

        mov     EAX, CR0
        or      EAX, 1
        mov     CR0, EAX

        jmp     main32

        hlt



%include "bootloader/misc/gdt.asm"

[BITS 32]

main32:
        mov     AH, 0x07
        mov     AL, 'H'
        mov     EDX, 0xb8000
        mov     [EDX], AX

        jmp     0x8200
        
        hlt

times (512*4)-($-$$) db 0

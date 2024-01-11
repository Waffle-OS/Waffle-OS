%define MAGIC_NUM 0x534D4150
%define MMAP_LOC 0x5000
%define PD_LOC 0x0000_1000
%define KERNEL_SECTORS 64
%define KERNEL_SIZE (KERNEL_SECTORS*512)
%define KERNEL_LOC 0xC010_0000

; The beginning of the stage 2 bootloader
stage2:
.get_mmap:
        clc
        mov     EAX, 0xE820
        xor     EBX, EBX
        mov     ECX, 24
        mov     EDX, MAGIC_NUM
        mov     DI, MMAP_LOC
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
        


kernel_lba_packet:
        .size:          db 0x10
        .reserved:      db 0
        .blocks:        dw KERNEL_SECTORS
        .buffer:        dd 0x0000_1000
        .low_address:   dd 12                   ; Low 32 bits of address
        .high_address:  dw 0                    ; High 16 bits of address
        .null:          dw 0


pd_lba_packet:
        .size:          db 0x10
        .reserved:      db 0
        .blocks:        dw 8
        .buffer:        dd 0x0000_9000
        .low_address:   dd 5                    ; Low 32 bits of address
        .high_address:  dw 0                    ; High 16 bits of address
        .null:          dw 0



load_kernel:
        clc
        mov     AH, 0x42
        mov     DL, [drive_num]
        mov     SI, kernel_lba_packet
        int     0x13
        jnc     load_pd

.load_error:
        mov     SI, load_error_msg
        call    puts
        jmp     $

load_error_msg:         db 'Unable to load kernel', NEWL, 0
load_error_msg2:        db 'Unable to load page directory', NEWL, 0

load_pd:
        mov     AH, 0x42
        mov     DL, [drive_num]
        mov     SI, pd_lba_packet
        int     0x13
        jnc     enter32

.load_error:
        mov     SI, load_error_msg2
        call    puts
        jmp     $



enter32:
        ; Loading GDT
        cli
        lgdt    [gdt_start.desc]

        mov     EAX, CR0
        or      EAX, 1
        mov     CR0, EAX
        

        jmp     0x08:start_paging

        hlt



%include "bootloader/misc/gdt.asm"

[BITS 32]

move_kernel:
        mov     EAX, 0x100000
        mov     EDI, 0x1000

.loop:
        cmp     EDI, 0x1000+KERNEL_SIZE
        je      start_paging
        mov     EBX, [EDI]
        mov     [EAX], EBX
        add     EDI, 32
        add     EAX, 32
        jmp     .loop

start_paging:

.init_pd:

        mov     EAX, 0x9000
        mov     CR3, EAX

        mov     ebx, cr4  
        or      ebx, 0x00000010                 ; Set PSE
        mov     cr4, ebx       
        
        mov     EBX, CR0
        or      EBX, 0x80000000                 ; Set PG
        mov     CR0, EBX

        mov     AH, 0x0F
        mov     AL, 'H'
        mov     [0xb8000], AX
        jmp     $


times (512*4)-($-$$) db 0

PAGE_DIR:
        dd 0b010011011
        times (0x300*3-1) db 0
        dd 0b110001011
        times (0x400) db 0

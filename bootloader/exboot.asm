[ORG 0x7e00]
[BITS 16]

;----------
; EXTENDED BOOTLOADER
;----------
ex_boot:
        mov     [drive_num], DL
        jmp     get_mmap

%include "misc/gdt.asm"
drive_num: db 0
%include "misc/tty.asm"


;----------
; GETTING MEMORY MAP
;----------
%define MAGIC_NUM 0x534D4150
%define MMAP_LOC 0x5000
get_mmap:
        clc
        mov     EAX, 0xE820
        mov     EBX, 0
        mov     DI, MMAP_LOC                     
        mov     ECX, 24
        mov     EDX, MAGIC_NUM
        int     0x15
        jc      .error
        add     DI, 24

.loop:
        or      EBX, EBX
        jz      .finish
        mov     EAX, 0xE820
        mov     ECX, 24
        mov     EDX, MAGIC_NUM
        int     0x15
        add     DI, 24
        jmp    .loop

.finish:
        mov     [0x500], ECX                    ; Memory map info stored at 0x500
        jmp     load_kernel 

.error:
        mov     SI, get_mmap_msg
        call    puts
        jmp     $

get_mmap_msg: db 'Unable to obtain memory map.', NEWL, 0


;----------
; LOADING THE KERNEL
;----------
%define KERNEL_SECTORS 64
%define KERNEL_SIZE (KERNEL_SECTORS*512)
load_kernel:
        ; Load the kernel
        mov     AH, 0x42
        mov     DL, [drive_num]
        mov     SI, kernel_lba_packet
        int     0x13
        jnc     enter32

.failed_load:
        mov     SI, failed_load_msg
        call    puts
        jmp     $

failed_load_msg: db 'Unable to load kernel from disk.', NEWL, 0

kernel_lba_packet:
        .size:          db 0x10
        .reserved:      db 0
        .blocks:        dw KERNEL_SECTORS
        .offset:        dw 0
        .segment:       dw 0x1000
        .low_address:   dd 4                    ; Low 32 bits of address
        .high_address:  dw 0                    ; High 16 bits of address
        .null:          dw 0


;----------
; ENTERING PROTECTED MODE
;----------
enter32:
        ; Enter protected mode
        cli
        lgdt    [gdt_start.desc]
        mov     EAX, CR0
        or      EAX, 1
        mov     CR0, EAX
        jmp     0x08:move_kernel


;----------
; PROTECTED MODE
;----------
[BITS 32]

;----------
; MOVING THE KERNEL
;----------
%define KERNEL_LOC 0x100000
%define KERNEL_LOAD_LOC 0x10000
move_kernel:
        cld
        xor     AX, AX
        mov     DS, AX
        mov     ES, AX
        mov     AX, [0x10000+KERNEL_SIZE-2]      ; Word used to check if kernel was successfully loaded
        mov     ESI, 0x10000
        mov     EDI, 0x100000
        mov     ECX, KERNEL_SIZE/4

        rep     movsd
        
.check:
        ; Check that the kernel was successfully moved
        cmp     AX, [0x100000+KERNEL_SIZE-2]
        je      enable_paging

.error:
        mov     word [0xB8000], word 0x0F30     ; A black and white 0
        jmp     $

;----------
; ENABLING PAGING
;----------
%define PD_LOC 0x0000_1000
enable_paging:
        jmp     $


[ORG 0x7c00]
[BITS 16]
%define NEWL 13, 10
%define VID_MEM 0xb8000
%define CODE_SEG gdt_data.code-gdt_data
%define DATA_SEG gdt_data.data-gdt_data

;=============================
;                            |
; BOOT SECTOR                |
;                            |
;=============================

start:  jmp     enter32

;=============================
;                            |
; FAT data                   |
;                            |
;=============================

FAT12:
        db      "MSWIN4.1"              ; OEM identifier
        dw      0x0200                  ; Bytes per sector (all numbers are in their big endian forms, because nasm converts them to little endian)
        db      0x01                    ; Sectors per cluster
        dw      0x0005                  ; Reserved sectors (for kernel)
        db      0x02                    ; Number of FATs
        dw      0x00e0                  ; Root directory entries (not sure what they are)
        dw      0x0b40                  ; Total sectors in the logical volume
        db      0xf0                    ; Media descriptor type
        dw      0x0009                  ; Sectors per fat
        dw      0x0012                  ; Sectors per track
        dw      0x0002                  ; Heads on the disk
        dw      0x0000, 0x0000          ; Number of hidden sectors
        dw      0x0000, 0x0000          ; Number of large sectors
        db      0x00                    ; Drive number (value in DL)
        db      0x00                    ; NT flag
        db      0x29                    ; Signature
        dw      0xe4d7, 0x1585          ; Volume serial ID (I just copied what mkfs.fat put)
        db      "  RANDOM OS"           ; Volume label string
        db      "FAT12   "              ; System identifier (useless)

;=============================
;                            |
; Enters 32 bit mode         |
;                            |
;=============================

enter32:
        ; Setting up the GDT

        cli
        lgdt    [gdt_data.desc]

        mov     eax, cr0
        or      eax, 1
        mov     cr0, eax

        jmp     CODE_SEG:main           ; Clears instruction pipeline

.halt:
        hlt

;=============================
;                            |
; GDT data                   |
;                            |
;=============================

gdt_data:
        .null:
                dq 0
        .code:
                dw 0xffff
                dw 0
                db 0
                db 10011010b
                db 11001111b
                db 0
        .data:
                dw 0xffff
                dw 0
                db 0
                db 10010010b
                db 11001111b
                db 0
.end:

.desc:
        dw .end - gdt_data - 1
        dd gdt_data

[BITS 32]

;=============================
;                            |
; The majority of the code   |
;                            |
;=============================

main:
        mov     al, 'H'
        mov     ah, 0x0f

        mov     [VID_MEM], ax

        hlt


;=============================
;                            |
; Boot signature             |
;                            |
;=============================

times 510-($-$$) db 0              
dw 0xaa55

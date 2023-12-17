%define CODE_SEG gdt_data.code-gdt_data
%define DATA_SEG gdt_data.data-gdt_data
;=============================
;                            |
; The majority of the code   |
;                            |
;=============================

enter32:
        ; Reading kernel from disk
        xor     AX, AX
        mov     ES, AX
        mov     AH, 0x02                ; Tells BIOS we are reading using CHS addressing
        mov     AL, 8                   ; Number of sectors
        mov     BX, 0x8200              ; Location to put read data
        mov     CH, 0                   ; Cylinder to read from
        mov     CL, 4                   ; Sector to start reading from
        mov     DH, 0                   ; Head number
        mov     DL, [drive_num]         ; Drive number
        int     0x13                    ; BIOS handler for disk access

        jnc     enter32.load_gdt

        mov     AH, 0x0e
        mov     AL, 'B'
        int     0x10
.halt:
        jmp $

.load_gdt:
        ; Loading GDT
        cli
        lgdt    [gdt_data.desc]

        mov     EAX, CR0
        or      EAX, 1
        mov     CR0, EAX

        jmp     CODE_SEG:main32

        hlt

;=============================
;                            |
; GDT data                   |
;                            |
;=============================

%include "src/bootloader/misc/gdt.asm"

[BITS 32]

main32:
        mov     AH, 0x07
        mov     AL, 'H'
        mov     EDX, 0xb8000
        mov     [EDX], AX

        jmp     0x8200
        
        hlt

times 1536-($-$$) db 0

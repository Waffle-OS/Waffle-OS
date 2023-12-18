[ORG 0x7c00]
[BITS 16]


;=============================
;                            |
; BOOT SECTOR                |
;                            |
;=============================

start:  jmp     main16

drive_num:      db 0

;=============================
;                            |
; Enters 32 bit mode         |
;                            |
;=============================

main16:
        mov     [drive_num], DL

        ; Setting up stack
        xor     AX, AX
	mov     SP, 0x7C00
        mov     BP, SP

        mov     AH, 0x00
	mov     AL, 0x03
	int     0x10

        xor     AX, AX
        mov     ES, AX                  ; Clearing ES as int 0x10 uses ES:BX
        mov     AH, 0x02                ; Tells BIOS we are reading using CHS addressing
        mov     AL, 2                   ; Number of sectors
        mov     BX, 0x7e00              ; Location to put read data
        mov     CH, 0                   ; Cylinder to read from
        mov     CL, 2                   ; Sector to start reading from
        mov     DH, 0                   ; Head number
        mov     DL, [drive_num]         ; Drive number
        int     0x13                    ; BIOS handler for disk access

        jnc     0x7e00

        ; Very descriptive error message
        mov     AH, 0x0e
        mov     AL, 'A'
        int     0x10

.halt:
        jmp     $


;=============================
;                            |
; Boot signature             |
;                            |
;=============================

times 510-($-$$) db 0              
dw 0xaa55

%include "bootloader/exboot.asm"

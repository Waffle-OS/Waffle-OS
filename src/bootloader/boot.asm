[ORG 0x7c00]
%define NEWL 13, 10

;;;;;;;;;;  ;;;;;;;;;;
;
;;   FIRST SECTOR   ;;
;
;;;;;;;;;;  ;;;;;;;;;;

start:  jmp     main

FAT12:
        db      "MSWIN4.1"      ; OEM identifier
        dw      0x0200          ; Bytes per sector (all numbers are in their big endian forms, because nasm converts them to little endian)
        db      0x01            ; Sectors per cluster
        dw      0x002           ; Reserved sectors (for rest of boot loader)
        db      0x02            ; Number of FATs
        dw      0x00e0          ; Root directory entries (not sure what they are)
        dw      0x0b40          ; Total sectors in the logical volume
        db      0xf0            ; Media descriptor type
        dw      0x0009          ; Sectors per fat
        dw      0x0012          ; Sectors per track
        dw      0x0002          ; Heads on the disk
        dw      0x0000, 0x0000  ; Number of hidden sectors
        dw      0x0000, 0x0000  ; Number of large sectors
        db      0x00            ; Drive number (value in DL)
        db      0x00            ; NT flag
        db      0x29            ; Signature
        dw      0xe4d7, 0x1585  ; Volume serial ID (I just copied what mkfs.fat put)
        db      "RANDOM OS  "   ; Volume label string
        db      "FAT12   "      ; System identifier (useless)



data:   
    BOOT_DISK:  db      0
    DONE:       db      "done!", NEWL, 0
    FAILED:     db      "failed.", NEWL, 0
    ERROR_MES:  db      "Fatal error occured. Please restart computer.", 0
    START_MES:  db      "Bootloader started... ", NEWL, 0
    STACK_MES:  db      "Stack initialised...", NEWL, 0
    LOAD_MESG:  db      "Loading extended bootloader... ", 0

main:
        ; setting up the stack

        xor     ax, ax                          
        mov     es, ax
        mov     ds, ax
        mov     bp, 0x8000
        mov     sp, bp

        ; Showing boot messages

        mov     ah, 0
        mov     al, 3
        int     0x10
        call getch
        mov     al, ah
        call putch
        mov     si, START_MES
        call puts
        mov     si, STACK_MES
        call puts
        mov     si, LOAD_MESG
        call puts
        mov     [BOOT_DISK], dl

        ; reading the disk

        mov     ah, 2                   ; code to read from disk
        mov     al, 1                   ; number of sectors to read
        mov     ch, 0                   ; cylinder
        mov     dh, 0                   ; head
        mov     cl, 2                   ; sector
        mov     dl, [BOOT_DISK]         ; drive
        mov     bx, 0x7e00              ; where to place the read data in memory (es:bx)
        int     0x13
        jc      .error                  ; in case of failure

        mov     si, DONE
        call puts
        call getch
        mov     dx, 0x604
        mov     ax, 0x2000
        out     dx, ax                  ; Shutdowns the PC (only works when emulating on qemu)

        
        
.halt:
        jmp     $
.error:
        mov     si, FAILED
        call puts
        mov     si, ERROR_MES
        call puts
        jmp     .halt

%include "src/bootloader/ttystr.asm"

;
;; boot signature
;
times 510-($-$$) db 0              
dw 0xaa55

;;;;;;;;;;  ;;;;;;;;;;
;
;;  OTHER SECTORS   ;;
;
;;;;;;;;;;  ;;;;;;;;;;

times 512 db 'h'

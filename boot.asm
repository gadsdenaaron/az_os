[bits 16]
[org 0x7C00]

xor  ax, ax
mov  ds, ax
mov  es, ax
mov [BOOT_DRIVE], dl ; BIOS stores our boot drive in DL , so it ’s
; best to remember this for later.

mov  ax, 0x07E0
cli
mov  ss, ax 
mov  sp, 0x1200
sti

mov bx , 0x1000 ; Load 5 sectors to 0x0000 (ES ):0x9000 (BX)
mov dh , 15 ; from the boot disk.
mov dl , [BOOT_DRIVE]
call disk_load

mov bx , HELLO_MSG ; Use BX as a parameter to our function , so
call print_string ; we can specify the address of a string.
mov bx , GOODBYE_MSG
call print_string
mov dx, [HELLO_MSG]
call print_hex

jmp $ ; Hang

;Some important helper functions
%include "disk_load.asm"
%include "print_string.asm"
%include "print_hex.asm"


;Global variables
BOOT_DRIVE: 
db 0

HELLO_MSG:
db "Hello , World !", 0 ; <-- null terminated strings

GOODBYE_MSG:
db "Goodbye !", 0

; Boot sector padding
times 510 -( $ - $$ ) db 0
dw 0xaa55


times 15*256 dw 0xdada

; This is a main file
; Defines
%define BOOTLOADER_EXECUTE_POSITION 0x7C00 ; Some dude woke up and thought that this was the perfect place that a bootloader should execute
%define MAGIC_NUMBER 0xAA55 ; Marks as bootable
%define HARD_DISK 1 << 7

; BOOTSECTOR ;
org BOOTLOADER_EXECUTE_POSITION

jmp boot
err: ; TODO: Make this actually an error function
    jmp hang

hang:
    jmp hang

boot:
    ; Now we load what we wrote
    mov ah, 0x02 ; Read sectors into memory
    mov al, (code_end-code_begin)/512
    mov ch, 0x0 ; Low eight bits of cylinder number
    mov cl, 2 << 0 ; Sector number 2 set into bits 0-5
    or  cl, 0 << 6 ; Cylinder high order bits of 0 set into bit 6 and 7

    mov dh, 0x0 ; Drive head
    mov dl, HARD_DISK

    ; Boundaries
    push ax
    mov ax, cs
    mov es, ax ; es cannot be set static values so it has to be set by a register
    pop ax
    mov bx, main
    ; Boundaries

    int 0x13
    jc err
    jmp main

    times 510 - ($ - $$) db 0
    dw MAGIC_NUMBER
; BOOTSECTOR ;

code_begin:
main:
    jmp exec
    ; Will not be executed
    %include "include/stdio.asm"
    message db "Hello BIOS!",0 ; 0 is ending string character

    exec:
        mov bx, message ; Holds the adress of the message
        call print_string
        jmp hang

    ; Make it so this takes up an entire sector
    times ((($-$$)/512+1)*512) nop 
code_end:

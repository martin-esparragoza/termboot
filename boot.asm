; This is a main file
; Defines
%define BOOTLOADER_EXECUTE_POSITION 0x7C00 ; Some dude woke up and thought that this was the perfect place that a bootloader should execute
%define MAGIC_NUMBER 0xAA55 ; Marks as bootable
%define SECTOR_SIZE 512
%define HARD_DISK 1 << 7
%define INPUT_BUFFER_SIZE 10 ; 128
%define PROMPT "Termboot >>> "

; BOOTSECTOR ;
org BOOTLOADER_EXECUTE_POSITION
cld

jmp boot
err: ; TODO: Make this actually an error function
    jmp hang

hang:
    jmp hang

boot:
    ; Now we load what we wrote
    mov ah, 0x02 ; Read sectors into memory
    ; al = sectors to read
    mov al, (code_end-code_begin)/SECTOR_SIZE
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

    times 510-($-$$) nop
    dw MAGIC_NUMBER
; BOOTSECTOR ;

code_begin:
main:
    jmp exec
    ; Will not be executed (includes)
    %include "include/stdio.asm"
    %include "include/string.asm"
    %include "commands/test.asm"

    msg db PROMPT, 0
    buf times INPUT_BUFFER_SIZE db 0

    exec:
        mov bx, msg
        call print_string
        mov bx, buf
        mov dx, INPUT_BUFFER_SIZE
        call get_string

        ; Execute commands based on input ;
        ; bx regster already has the get_string output
        mov di, test_keyword
        call strcmp
        jz test_exec
        ; Execute commands based on input ;

        jmp exec


    ; TODO: Fix this because its not creating the right amount of bytes (no problem just unoptimized)
    times ((($-$$)/SECTOR_SIZE+1)*SECTOR_SIZE) nop ; Make it so this is a full sector on the disk so we can read it
code_end:

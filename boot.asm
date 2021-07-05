; This is a main file
%define BOOLOADER_EXECUTE_POSITION 0x7C00 ; Some dude woke up and thought that this was the perfect place that a bootloader should execute
%define MAGIC_NUMBER 0xAA55 ; Marks as bootable


cli ; Stop interupts
org BOOLOADER_EXECUTE_POSITION 

mov bx, message ; Holds the adress of the message
call print_string
jmp hang

section.text:
    %include "include/util.asm"

section.bss:
    message db "Hello BIOS!",0 ; 0 is ending string character

; Create the bootsector and put the "Magic Byte" at the end
times 510-($-$$) db 0
dw MAGIC_NUMBER

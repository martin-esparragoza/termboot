; NOTE section.text

hang:
    jmp hang

print_char:
    mov ah, 0x0E
    int 0x10
    ret

print_string:
    mov al, [bx] ; BIOS prints out whatever is in al register
    call print_char
    inc bx ; Move to the next point in the string

    or al, al
    jz EOF

    jmp print_string

EOF: ; No not end of file, end of function
    ret

print_char: ; Input: al
    mov ah, 0x0E
    int 0x10
    ret

print_string: ; Input: Start of string in bx reg (unsafe and ends with 0 to terminate string)
    mov al, [bx] ; BIOS prints out whatever is in al register
    call print_char
    inc bx ; Move to the next point in the string

    or al, al
    jz EOF

    jmp print_string

get_char: ; Output: ah
    mov ah, 0x00
    int 0x16
    mov ah, al

; misc
EOF: ; No not end of file, end of function
    ret

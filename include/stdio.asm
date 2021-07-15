print_char: ; Input: al
    mov ah, 0x0E
    int 0x10
    ret

print_string: ; Input: Start of string in bx reg (unsafe and ends with 0 to terminate string)
    mov al, [bx] ; BIOS prints out whatever is in al register
    call print_char
    inc bx ; Move to the next point in the string

    or al, al
    jz end_print_string

    jmp print_string

get_char: ; Output: ah
    mov ah, 0x00
    int 0x16
    mov ah, al
    ret

get_string: ; IO: bx (input: should be string buffer)
    mov dx, bx ; This will be used to store where bx's origin is

    loop:
        call get_char
        ; push ax
        ; mov al, ah
        ; call print_char
        ; pop ax
        mov [bx], ah
        inc bx

        cmp ah, 13
        jz end_get_string

        jmp loop

end_get_string:
    mov ah, 0
    mov [bx], ah
    mov bx, dx
    ret

end_print_string:
    ret

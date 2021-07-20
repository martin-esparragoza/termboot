print_char: ; Input: al
    mov ah, 0x0E
    int 0x10

    cmp al, 13
    jz print_newline

    ret

print_string: ; Input: Start of string in bx reg (unsafe and ends with 0 to terminate string)
    mov al, [bx] ; BIOS prints out whatever is in al register

    cmp al, 0
    jz end_print_string

    call print_char
    inc bx ; Move to the next point in the string

    jmp print_string

get_char: ; Output: ah
    mov ah, 0x00
    int 0x16
    ; Interupt 16 returns in ah register so lets just set it to al
    mov ah, al
    ret

get_string: ; IO: bx (input: should be string buffer) I: di (buflen)
    mov dx, bx ; This will be used to store where bx's origin is

    loop:
        call get_char
        ; Check if exceeding buffer size
        push bx
        add bx, 2 ; \n and \0 character
        sub bx, dx
        cmp bx, di
        pop bx
        jnge next
        call get_string_exceed_buffer

        next:
            mov [bx], ah ; Set in buffer
            inc bx ; Move to next point in string

            ; Push to stack because this will clobber the ax register
            push ax
            mov al, ah
            call print_char
            pop ax

            cmp ah, 13
            jz end_get_string

            jmp loop

; misc (NOT MEANT TO BE USER CALLED)
print_newline:
    push ax
    mov al, 10 ; Carrige return character
    call print_char
    pop ax
    ret

end_get_string: ; Function is just for adding 0 at the end of the string and setting bx to the start
    mov ah, 0
    mov [bx], ah
    mov bx, dx
    ret

get_string_exceed_buffer:
    mov ah, 13
    ret

end_print_string:
    ret

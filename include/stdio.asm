%define NEWLINE 13
%define LINE_RETURN 10
%define BACKSPACE 8

print_char: ; Input: al
    mov ah, 0x0E
    int 0x10

    cmp al, NEWLINE
    jz print_char_newline

    ret

print_string: ; Input: Start of string in bx reg (unsafe and ends with 0 to terminate string)
    mov al, [bx] ; BIOS prints out whatever is in al register

    cmp al, 0
    jz print_string_end

    call print_char
    inc bx ; Move to the next point in the string

    jmp print_string

get_char: ; Output: ah
    mov ah, 0x00
    int 0x16
    ; Interupt 16 returns in ah register so lets just set it to al
    mov ah, al
    ret

get_string: ; IO: bx (input: should be string buffer) I: dx (buflen)
    mov di, 0 ; Index

    loop:
        call get_char
        ; check if exceeding buffer size
        push di
        add di, 2 ; \n and \0
        cmp di, dx
        pop di
        jnge get_string_next
        call get_string_exceed_buffer

        get_string_next:
            cmp ah, BACKSPACE
            jz get_string_backspace

            mov [bx+di], ah ; Set in buffer
            inc di

            ; Push to stack because this will clobber the ax register
            push ax
            mov al, ah
            call print_char
            pop ax

            cmp ah, NEWLINE
            jz get_string_end

            jmp loop

; misc (NOT MEANT TO BE USER CALLED)
print_char_newline:
    push ax
    mov al, LINE_RETURN ; Line return character
    call print_char
    pop ax
    ret

print_string_end:
    ret

get_string_end: ; Add 0 at end
    mov ah, 0
    mov [bx+di], ah
    ret

get_string_backspace:
    cmp di, 0
    jnz get_string_backspace_exec
    jmp loop

    get_string_backspace_exec:
        dec di
        mov ah, 0
        mov [bx+di], ah

        ; Now remove previously printed character
        mov al, BACKSPACE
        call print_char
        mov al, 0
        call print_char
        mov al, BACKSPACE
        call print_char
        jmp loop

get_string_exceed_buffer:
    mov ah, NEWLINE
    ret

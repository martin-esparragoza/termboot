strcmp: ; Input: di: str1 bx: str2 Output: zero flag
    mov al, [di]
    cmp al, [bx]
    jnz exit_strcmp

    cmp al, 0 ; If string terminate && two characters of strings are matching
    jz exit_strcmp

    inc di
    inc bx
    jmp strcmp
    exit_strcmp:
        ret

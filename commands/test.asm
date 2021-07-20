test_keyword db "test",13,0
test_msg db "Test!", 13, 0

test_exec:
    pusha
    mov bx, test_msg
    call print_string
    popa
    jmp exec

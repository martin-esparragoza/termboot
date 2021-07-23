example_keyword db "example",13,0
example_msg db "Example!", 13, 0

example_exec:
    pusha
    mov bx, example_msg
    call print_string
    popa
    jmp exec

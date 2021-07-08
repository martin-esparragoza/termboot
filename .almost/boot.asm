; This is a main file
; Defines
%define BOOTLOADER_EXECUTE_POSITION 0x7C00 ; Some dude woke up and thought that this was the perfect place that a bootloader should execute
%define MAGIC_NUMBER 0xAA55 ; Marks as bootable
%define SECTOR_SIZE 512
%define ONE_CYLINDER 512*10
%define CYLINDERS_TO_READ 1 ; Starts counting at 0
%define DISK 7 ; Hard disk


; BOOTSECTOR ;

org BOOTLOADER_EXECUTE_POSITION
cli
cld


; Load rest of the disk ;
mov ah, 0x02 ; (MODE) Read sectors into memory
mov al, (ONE_CYLINDER*CYLINDERS_TO_READ)/SECTOR_SIZE
mov ch, CYLINDERS_TO_READ-1
mov cl, 2 ; Read from after the boot sector
mov dh, CYLINDERS_TO_READ-1
mov dl, (1 << DISK)

push ax
mov ax, cs
mov es, ax
pop ax
mov bx, jump

call dump_regs

int 0x13
pushf
call dump_regs
popf
pushf
pushf
mov ah,14
mov al,"("
int 0x10
pop ax
call print_all_ax
mov al,")"
mov ah,14
int 0x10
popf
jc oops

    mov cx,256 / 2
all_of_it:
    mov ax,[bx]
    call print_all_ax
    mov al," "
    mov ah,14
    int 0x10
    inc bx
    inc bx
    dec cx
    jnz all_of_it


jmp jump
err:
    mov al, "B"
    mov ah, 0x0E
    int 0x10
    jmp err
; Load rest of the disk ;

print_hex_byte:
    push ax
    and ax,0xf
    cmp ax,10
    jb not_hex
    add ax,'A'-'0'-10
not_hex:
    add ax,'0'
    mov ah,14
    int 0x10
    pop ax
    ret

print_all_ax:
    rol ax,4
    call print_hex_byte
    rol ax,4
    call print_hex_byte
    rol ax,4
    call print_hex_byte
    rol ax,4
    call print_hex_byte
    ret

dump_regs:
    push ax
    call print_all_ax
    mov al,"-"
    mov ah,14
    int 0x10
    mov ax,bx
    call print_all_ax
    mov al,"-"
    mov ah,14
    int 0x10
    mov ax,cx
    call print_all_ax
    mov al,"-"
    mov ah,14
    int 0x10
    mov ax,dx
    call print_all_ax
    mov al,":"
    mov ah,14
    int 0x10
    pop ax
    ret

oops:
stall: jmp stall


times 510 - ($ - $$) db 0
dw MAGIC_NUMBER

; BOOTSECTOR ;


jump:
    mov bx, message ; Holds the adress of the message
    call print_string
    jmp hang

    section.text:
        %include "include/stdio.asm"


    section.bss:
        message db "Hello BIOS!",0 ; 0 is ending string character


    dw 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27
    dw 0x1111,0x2222,0x3333


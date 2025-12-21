section .data
    clr db 27,"[2J",27,"[H"
    clr_len equ $ - clr
    pos db 27,"[00;00H"
    pos_len equ $ - pos
    ball db "O"
    delay dq 0, 50000000

section .bss
    x resb 1
    y resb 1
    dx resb 1
    dy resb 1

section .text
    global _start

_start:
    mov byte [x], 5
    mov byte [y], 5
    mov byte [dx], 1
    mov byte [dy], 1

.loop:
    mov rax, 1
    mov rdi, 1
    mov rsi, clr
    mov rdx, clr_len
    syscall

    xor rax, rax
    mov al, [y]
    mov bl, 10
    div bl
    add al, '0'
    add ah, '0'
    mov [pos+2], al
    mov [pos+3], ah
    
    xor rax, rax
    mov al, [x]
    mov bl, 10
    div bl
    add al, '0'
    add ah, '0'
    mov [pos+5], al
    mov [pos+6], ah

    mov rax, 1
    mov rdi, 1
    mov rsi, pos
    mov rdx, pos_len
    syscall

    mov rax, 1
    mov rdi, 1
    mov rsi, ball
    mov rdx, 1
    syscall

    mov rax, 35
    mov rdi, delay
    xor rsi, rsi
    syscall

    mov al, [x]
    add al, [dx]
    mov [x], al
    cmp al, 1
    jle .flip_x
    cmp al, 40
    jge .flip_x
    jmp .move_y

.flip_x:
    neg byte [dx]

.move_y:
    mov al, [y]
    add al, [dy]
    mov [y], al
    cmp al, 1
    jle .flip_y
    cmp al, 20
    jge .flip_y
    jmp .loop

.flip_y:
    neg byte [dy]
    jmp .loop

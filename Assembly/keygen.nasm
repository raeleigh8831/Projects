; you could use a simpler logic to be honest

section .data
    seed dq 0xDEADBEEFCAFEBABE
    charset db "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
    newline db 10

section .bss
    buffer resb 17

section .text
    global _start

_start:
    mov r12, 16
.gen_16:
    lea rdi, [buffer]
    mov rcx, 16
.gen_key:
    push rcx
    call .next_rand
    xor rdx, rdx
    mov rcx, 62
    div rcx
    mov al, [charset + rdx]
    pop rcx
    stosb
    loop .gen_key

    mov byte [rdi], 10
    mov rax, 1
    mov rdi, 1
    mov rsi, buffer
    mov rdx, 17
    syscall

    dec r12
    jnz .gen_16

    mov rax, 60
    xor rdi, rdi
    syscall

.next_rand:
    mov rax, [seed]
    mov rdx, rax
    shl rdx, 13
    xor rax, rdx
    mov rdx, rax
    shr rdx, 7
    xor rax, rdx
    mov rdx, rax
    shl rdx, 17
    xor rax, rdx
    mov [seed], rax
    ret

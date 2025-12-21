section .text
    global _start

_start:
    jmp .get_payload

.decoder:
    pop rsi
    lea rdi, [rsi]
    mov rcx, payload_len
    mov al, 0xAA

.loop:
    xor byte [rdi], al
    inc rdi
    loop .loop

    jmp rsi

.get_payload:
    call .decoder

payload:
    db 0x62, 0x6b, 0x6b, 0x6b, 0x6b, 0x6b, 0x6b, 0x6b ; XORed data example
    payload_len equ $ - payload

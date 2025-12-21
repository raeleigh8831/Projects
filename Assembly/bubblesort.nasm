section .text
global bubble_sort

bubble_sort:
    push rbp
    mov rbp, rsp
    
    dec rsi
    js .done

.outer_loop:
    xor r8, r8
    xor r9, r9

.inner_loop:
    mov eax, [rdi + r9 * 4]
    mov edx, [rdi + r9 * 4 + 4]
    
    cmp eax, edx
    jle .no_swap
    
    mov [rdi + r9 * 4], edx
    mov [rdi + r9 * 4 + 4], eax
    mov r8, 1

.no_swap:
    inc r9
    cmp r9, rsi
    jl .inner_loop
    
    test r8, r8
    jz .done
    
    dec rsi
    jnz .outer_loop

.done:
    pop rbp
    ret

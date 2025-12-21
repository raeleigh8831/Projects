%if 0
    ============================================================
    HOW IT WORKS (THE LOGIC)
    
    While LCGs use the formula $X_{n+1} = (aX_n + c) \pmod m$, 
    Xorshift manipulates the bit patterns directly to produce 
    a period of $2^{64}-1$.

    1. SHIFT LEFT 13: Spreads lower bits to higher positions.
    2. SHIFT RIGHT 7: Spreads higher bits back down.
    3. SHIFT LEFT 17: Final mix so every bit influences others.
    4. STATE: The seed must never be zero.

    This should be faster.
    ============================================================
%endif

section .data
    seed dq 0x123456789ABCDEF1

section .text
    global next_rand

next_rand:
    mov rax, [seed]
    
    ; Step 1: Shift Left 13
    mov rdx, rax
    shl rdx, 13
    xor rax, rdx
    
    ; Step 2: Shift Right 7
    mov rdx, rax
    shr rdx, 7
    xor rax, rdx
    
    ; Step 3: Shift Left 17
    mov rdx, rax
    shl rdx, 17
    xor rax, rdx
    
    mov [seed], rax
    ret

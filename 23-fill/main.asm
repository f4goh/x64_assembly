section .data
    arr: dq 0,0,0
    arr_len equ ($ - arr) / 8
    cpy: times 3 dq 0
   

section .text
    global _start

_start:
    lea rdi, arr
    mov rcx,0
    mov rdx,10
loop:
    mov [rdi + rcx*8],rdx
    add rdx,10
    inc rcx
    cmp rcx, arr_len
    jne loop

    mov r10, [arr + (0*8)]
    mov r11, [arr + (1*8)]
    mov r12, [arr + (2*8)]

    lea rsi, arr        ; Charge dans RSI l'adresse du tableau source "arr"
    lea rdi, cpy        ; Charge dans RDI l'adresse du tableau destination "cpy"
    mov rcx, arr_len    ; Met dans RCX le nombre d'éléments à copier
    cld                 ; Clear Direction Flag → incrémente RSI et RDI après chaque copie
    rep movsq           ; Copie RCX blocs de 8 octets de [RSI] vers [RDI]

    mov r13, [cpy + (0*8)]
    mov r14, [cpy + (1*8)]
    mov r15, [cpy + (2*8)]



    ; exit(0)
    mov rax, 60
    xor rdi, rdi
    syscall


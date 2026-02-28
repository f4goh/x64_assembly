section .data
    src: db 'abc'
    src_len equ $ - src
    dst: db 'abc'
    match: db -1
   
section .text
    global _start

_start:
    lea rsi, src            ; RSI = adresse de la première chaîne (src)
    lea rdi, dst            ; RDI = adresse de la seconde chaîne (dst)

    mov rcx, src_len        ; RCX = nombre d’octets à comparer

    cld                     ; Direction Flag = 0 → RSI et RDI seront incrémentés

    repe cmpsb              ; Compare [RSI] et [RDI], répète tant que égalité (ZF=1) et RCX > 0

    jnz differ              ; Si ZF=0 → différence trouvée avant la fin
    mov byte [match], 1     ; Sinon → chaînes identiques sur src_len octets
    jmp finish              ; Saute à la fin

differ:
    mov byte [match], 0     ; Une différence a été détectée

finish:
    mov dl, [match]         ; Charge le résultat (1=égal, 0=différent) dans DL

    ; exit(0)
    mov rax, 60
    xor rdi, rdi
    syscall



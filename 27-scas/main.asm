section .data
    src: db 'abc'
    src_len equ $ - src
    found: db -1
   
section .text
    global _start

_start:
    xor rax, rax            ; RAX = 0
    mov al, 'b'             ; AL = caractère recherché ('b')
    lea rdi, src            ; RDI = adresse de la chaîne src (zone à scanner)
    mov rcx, src_len        ; RCX = nombre d’octets à examiner

    cld                     ; Direction Flag = 0 → RDI sera incrémenté après chaque comparaison

    repne scasb             ; Compare AL avec [RDI], répète tant que ≠ et RCX > 0

    jnz absent              ; Si ZF=0 après la boucle → caractère non trouvé
    mov byte [found], 1     ; Sinon → caractère trouvé, on met found = 1
    jmp finish              ; Saute à la fin

absent:
    mov byte [found], 0     ; Caractère absent → found = 0

finish:
    mov dl, [found]         ; Charge la valeur de found dans DL

    ; exit(0)
    mov rax, 60
    xor rdi, rdi
    syscall



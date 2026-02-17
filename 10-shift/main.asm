section .data
    unum: db 10011001b      ; 153 en non signé (0x99)
    sneg: db 10011001b      ; -103 en signé (même bit pattern 0x99)
    snum: db 00110011b      ; 51 en non signé (0x33)

section .text
    global _start

_start:
    xor rcx, rcx            ; RCX = 0 → CL = 0, CH = 0
    xor rdx, rdx            ; RDX = 0 → DL = 0
    xor r8,  r8             ; R8  = 0 → R8B = 0

    mov cl,  [unum]         ; CL = 10011001b = 153 (non signé)
    mov dl,  [sneg]         ; DL = 10011001b = -103 si interprété en signé
    mov r8b, [snum]         ; R8B = 00110011b = 51

    ; --- Décalages ---
    ; SHR = décalage logique → remplit avec des 0
    shr cl, 2               ; CL >> 2 logique
                            ; 10011001b → 00100110b = 38

    ; SAR = décalage arithmétique → conserve le bit de signe
    sar dl, 2               ; DL >> 2 arithmétique
                            ; DL = 10011001b (négatif)
                            ; devient 11100110b = -26

    ; SAR sur R8 (64 bits) → étend le signe de R8B dans tout R8
    sar r8, 2               ; R8B = 00110011b (positif)
                            ; donc R8 >> 2 = 000000...00001100b = 12

    ; exit(0)
    mov rax, 60
    xor rdi, rdi
    syscall


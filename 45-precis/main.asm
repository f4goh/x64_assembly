;----------------------------------------------------------
;Titre : Explication de movaps et movapd avec exemple NASM
;----------------------------------------------------------

;Contexte :
;- On utilise deux instructions SSE / SSE2 pour le calcul sur flottants :
;    1. movaps : charge 128 bits depuis la mémoire dans un registre XMM (float)
;    2. movapd : charge 128 bits depuis la mémoire dans un registre XMM (double)
; Les deux instructions exigent que la mémoire soit alignée sur 16 octets


;Analyse détaillée :

;1. movaps xmm0, [nums]
;   - movaps = move aligned packed single-precision (32-bit floats)
;   - Charge 4 floats de nums dans xmm0
;   - nums = [1.5, 2.5, 3.5, 3.1416]
;   - xmm0 après l'instruction : [1.5, 2.5, 3.5, 3.1416]

;2. movapd xmm1, [dubs]
;   - movapd = move aligned packed double-precision (64-bit floats)
;   - Charge 2 doubles de dubs dans xmm1
;   - dubs = [1.5, 3.14126535897932]
;   - xmm1 après l'instruction : [1.5, 3.14126535897932]

;Note :
;- movaps pour floats (32-bit), movapd pour doubles (64-bit)
;- Les deux instructions requièrent que l'adresse mémoire soit alignée sur 16 octets
;- Si la mémoire n’est pas alignée, utiliser movups/movupd (unaligned)

;----------------------------------------------------------
;Résumé :
;Instruction           | Effet
;----------------------|-------------------------------------
;movaps xmm0,[nums]    | Charge 4 floats (128 bits) depuis nums dans xmm0
;movapd xmm1,[dubs]    | Charge 2 doubles (128 bits) depuis dubs dans xmm1
;xmm0 / xmm1           | Contiennent maintenant les valeurs des tableaux respectifs


section .data
    nums dd 1.5,2.5,3.5,3.1416       ; 4 floats 32-bit (single precision)
    dubs dq 1.5,3.14126535897932     ; 2 doubles 64-bit (double precision)


section .text
global _start

_start:

    ;----------------------------------------------------------
    ; Chargement des données SIMD alignées
    ;----------------------------------------------------------
    movaps xmm0, [nums]    ; Charger 128 bits depuis nums (4×32-bit floats)
                            ; xmm0 = [1.5, 2.5, 3.5, 3.1416]

    movapd xmm1, [dubs]    ; Charger 128 bits depuis dubs (2×64-bit doubles)
                            ; xmm1 = [1.5, 3.14126535897932]

    ; exit(0)
    mov rax, 60
    xor rdi, rdi
    syscall

;----------------------------------------------------------
;Titre : Exemple SSE vectoriel float + SIMD saturé (byte)
;----------------------------------------------------------

;Contexte :
;- On combine des instructions SSE pour les flottants et SIMD pour les entiers :
;    1. movaps : charge 4 floats 32-bit alignés dans un XMM
;    2. psubsb : soustraction saturée élément par élément sur bytes signés
; - Les instructions SIMD agissent sur tous les éléments du registre XMM ou du tableau en parallèle
; - movaps exige que l'adresse mémoire soit alignée sur 16 octets
; - psubsb agit sur 16 octets simultanément (XMM = 128 bits)

;----------------------------------------------------------
;Analyse détaillée :

;1. movaps xmm0, [nums]
;   - Charge 16 octets depuis nums dans xmm0
;   - nums = [50,50,...,50] (16 fois)
;   - xmm0 après instruction : [50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50]

;2. psubsb xmm0, [tons]
;   - Soustraction saturée de bytes signés
;   - xmm0[i] = saturate(xmm0[i] - tons[i], -128..127)
;   - tons = [100,100,...,100] (16 fois)
;   - Calcul : chaque élément 50 - 100 = -50 (dans la plage, pas de saturation)
;   - xmm0 après instruction : [-50,-50,...,-50]

;3. psubsb xmm0, [tons] (encore)
;   - Soustraction saturée
;   - Calcul : -50 - 100 = -150 → saturé à -128
;   - xmm0 après instruction : [-128,-128,...,-128]

;----------------------------------------------------------
;Résumé :
;Instruction           | Effet
;----------------------|-------------------------------------
;movaps xmm0,[nums]    | Charge 16 octets depuis nums dans xmm0
;psubsb xmm0,[tons]    | Soustraction saturée byte par byte : xmm0[i] = saturate(xmm0[i] - tons[i], -128..127)
;Résultat final xmm0   | [-128, -128, ..., -128]

section .data
    nums times 16 db 50    ; 16 octets init à 50
    tons times 16 db 100   ; 16 octets init à 100

section .text
global _start

_start:

    movaps xmm0, [nums]     ; Charger 16 octets depuis nums dans xmm0
    psubsb xmm0, [tons]     ; Soustraction saturée de chaque octet
    psubsb xmm0, [tons]     ; Soustraction saturée répétée

    ; exit(0)
    mov rax, 60
    xor rdi, rdi
    syscall


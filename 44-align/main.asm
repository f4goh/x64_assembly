
;----------------------------------------------------------
;Titre : Explication de movdqa et psubd avec exemple NASM
;----------------------------------------------------------

;Contexte :
;- On utilise deux instructions SSE2 :
;    1. movdqa : charge 128 bits depuis la mémoire dans un registre XMM
;    2. psubd  : soustrait 4 entiers 32-bit empaquetés (packed) entre deux registres XMM


;Analyse détaillée :

;1. movdqa xmm0, [nums0]
;   - movdqa = move double quadword aligned (128 bits)
;   - Charge les 4 entiers 32-bit de nums0 dans xmm0
;   - nums0 = 1,2,3,4
;   - xmm0 après l'instruction : [1,2,3,4]

;2. movdqa xmm1, [nums1]
;   - Charge les 4 entiers 32-bit de nums1 dans xmm1
;   - nums1 = 5,5,5,5
;   - xmm1 après l'instruction : [5,5,5,5]

;3. psubd xmm0, xmm1
;   - psubd = packed subtract dword (32-bit integers)
;   - Soustrait chaque entier 32-bit de xmm1 à l’entier correspondant de xmm0
;   - Calcul :
;       1 - 5 = -4
;       2 - 5 = -3
;       3 - 5 = -2
;       4 - 5 = -1
;   - xmm0 après l'instruction : [-4,-3,-2,-1]


;----------------------------------------------------------
;Résumé :
;Instruction           | Effet
;----------------------|-------------------------------------
;movdqa xmm0,[nums0]   | Charge 128 bits (4*32-bit) depuis nums0 dans xmm0
;movdqa xmm1,[nums1]   | Charge 128 bits (4*32-bit) depuis nums1 dans xmm1
;psubd xmm0,xmm1       | Soustraction SIMD : xmm0 = xmm0 - xmm1
;Résultat final xmm0   | [-4,-3,-2,-1]



section .data
    nums0 dd 1,2,3,4        ; 4 entiers 32 bits (16 octets au total)

    snag db 100             ; 1 octet quelconque placé ici volontairement
                            ; Il casse potentiellement l’alignement mémoire
                            ; (après nums0 on est aligné sur 16 bytes,
                            ; mais ajouter 1 octet décale l’adresse suivante)

    align 16                ; Force l’alignement de l’adresse suivante
                            ; sur une frontière de 16 octets
                            ;
                            ; Pourquoi ?
                            ; movdqa exige une adresse alignée sur 16 bytes.
                            ; Sans alignement correct :
                            ; -> exception possible (General Protection Fault)
                            ; -> ou comportement invalide selon CPU

    nums1 dd 5,5,5,5        ; 4 entiers 32 bits (16 octets)
                            ; Grâce à align 16, nums1 est garanti
                            ; d’être correctement aligné pour movdqa


section .text
global _start

_start:

    ;----------------------------------------------------------
    ; Chargement des données et soustraction SIMD
    ;----------------------------------------------------------
    movdqa xmm0, [nums0]    ; Charger 128 bits (4×32-bit) depuis nums0 dans xmm0
                            ; xmm0 = [1, 2, 3, 4]

    movdqa xmm1, [nums1]    ; Charger 128 bits (4×32-bit) depuis nums1 dans xmm1
                            ; xmm1 = [5, 5, 5, 5]

    psubd xmm0, xmm1        ; Soustraction packed 32-bit :
                            ; xmm0 = xmm0 - xmm1
                            ; Calcul :
                            ; 1 - 5 = -4
                            ; 2 - 5 = -3
                            ; 3 - 5 = -2
                            ; 4 - 5 = -1
                            ; Résultat final xmm0 = [-4, -3, -2, -1]


    ; exit(0)
    mov rax, 60
    xor rdi, rdi
    syscall


;----------------------------------------------------------
;Titre : Explication de movdqa et paddd avec exemple NASM
;----------------------------------------------------------

;Contexte :
;- On utilise deux instructions SSE2 :
;    1. movdqa : charge 128 bits depuis la mémoire dans un registre XMM
;    2. paddd : additionne 4 entiers 32-bit empaquetés (packed) entre un registre XMM et la mémoire


;Analyse détaillée :

;1. movdqa xmm0, [nums0]
;   - movdqa = move double quadword aligned (128 bits)
;   - Charge les 4 entiers 32-bit de nums0 dans xmm0
;   - nums0 = 1,2,3,4
;   - xmm0 après l'instruction : [1,2,3,4]

;2. paddd xmm0, [nums1]
;   - paddd = packed add dword (32-bit integers)
;   - Additionne chaque entier 32-bit de xmm0 avec l’entier correspondant de nums1
;   - nums1 = 1,3,5,7
;   - Calcul :
;       1 + 1 = 2
;       2 + 3 = 5
;       3 + 5 = 8
;       4 + 7 = 11
;   - xmm0 après l'instruction : [2,5,8,11]


;----------------------------------------------------------
;Résumé :
;Instruction           | Effet
;----------------------|-------------------------------------
;movdqa xmm0,[nums0]   | Charge 128 bits (4*32-bit) depuis nums0 dans xmm0
;paddd xmm0,[nums1]    | Additionne 4 entiers 32-bit : xmm0 = xmm0 + nums1
;Résultat final xmm0   | [2,5,8,11]



section .data
    nums0 dd 1,2,3,4        ; variables 32 bits
    nums1 dd 1,3,5,7        ; variables 32 bits



section .text
global _start

_start:

    ;----------------------------------------------------------
    ; Charge 128 bits depuis nums0 dans xmm0 et additionne les valeurs entières avec nums1
    ;----------------------------------------------------------
    movdqa xmm0, [nums0]    ; Charger 128 bits (4*32-bit) depuis nums0 dans xmm0
    paddd xmm0, [nums1]     ; Additionner 4 entiers 32-bit : xmm0 = xmm0 + nums1
                             ; Résultat attendu : xmm0 = [2,5,8,11]

    ; exit(0)
    mov rax, 60
    xor rdi, rdi
    syscall

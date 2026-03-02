;----------------------------------------------------------
;Titre : Explication de movss et instructions SSE scalar (float)
;----------------------------------------------------------

;Contexte :
;- On utilise des instructions SSE pour le calcul sur flottants 32-bit (single precision) :
;    1. movss : charge ou stocke un float (32-bit) depuis/vers la mémoire
;    2. addss, subss, mulss, divss : opérations arithmétiques sur 1 float dans XMM
;      (scalar single-precision float, 32-bit)
; Les opérations ne concernent que le premier élément du registre XMM
; Les autres éléments restent inchangés


;Analyse détaillée :

;1. movss xmm0, [num]
;   - movss = move scalar single-precision float
;   - Charge le float 32-bit depuis num dans le premier élément de xmm0
;   - xmm0 après instruction : [16.0, ? , ? , ?] (les 3 autres floats restent inchangés)

;2. movss xmm1, [factor]
;   - Charge le float 32-bit depuis factor dans xmm1
;   - xmm1 après instruction : [2.5, ? , ? , ?]

;3. addss xmm0, xmm1
;   - Additionne le float du premier élément de xmm1 au premier élément de xmm0
;   - xmm0 = 16.0 + 2.5 = 18.5

;4. mulss xmm0, xmm1
;   - Multiplie le premier élément de xmm0 par le premier élément de xmm1
;   - xmm0 = 18.5 * 2.5 = 46.25

;5. subss xmm0, xmm1
;   - Soustrait le premier élément de xmm1 au premier élément de xmm0
;   - xmm0 = 46.25 - 2.5 = 43.75

;6. divss xmm0, xmm1
;   - Divise le premier élément de xmm0 par le premier élément de xmm1
;   - xmm0 = 43.75 / 2.5 = 17.5

;Note :
;- Seul le premier float de chaque registre est modifié
;- Les autres éléments du XMM restent inchangés

;----------------------------------------------------------
;Résumé :
;Instruction           | Effet
;----------------------|-------------------------------------
;movss xmm0,[num]      | Charge 1 float depuis num dans xmm0[0]
;movss xmm1,[factor]   | Charge 1 float depuis factor dans xmm1[0]
;addss xmm0,xmm1       | xmm0[0] += xmm1[0]
;mulss xmm0,xmm1       | xmm0[0] *= xmm1[0]
;subss xmm0,xmm1       | xmm0[0] -= xmm1[0]
;divss xmm0,xmm1       | xmm0[0] /= xmm1[0]
;xmm0[0] final         | 17.5 (après toute la séquence)


section .data
    num dd 16.0          ; 1 float 32-bit
    factor dd 2.5        ; 1 float 32-bit


section .text
global _start

_start:

    movss xmm0, [num]     ; Charger num dans xmm0[0]
    movss xmm1, [factor]  ; Charger factor dans xmm1[0]

    addss xmm0,xmm1       ; xmm0[0] = xmm0[0] + xmm1[0]
    mulss xmm0,xmm1       ; xmm0[0] = xmm0[0] * xmm1[0]
    subss xmm0,xmm1       ; xmm0[0] = xmm0[0] - xmm1[0]
    divss xmm0,xmm1       ; xmm0[0] = xmm0[0] / xmm1[0]

    ; exit(0)
    mov rax, 60
    xor rdi, rdi
    syscall


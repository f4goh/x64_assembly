;----------------------------------------------------------
;Titre : Exemple FMA scalar sur floats (SSE / XMM)
;----------------------------------------------------------

;Contexte :
;- On utilise les instructions FMA (Fused Multiply-Add) scalar single-precision (32-bit) :
;    1. vfmadd132ss / vfmadd213ss / vfmadd231ss
;       - Effectuent a*b + c sur le **premier float** d’un registre XMM
;       - Les autres éléments du XMM restent inchangés
; - movss sert à charger un seul float dans le premier élément d’un XMM
; - Les registres XMM sont utilisés ici en mode scalar pour la précision simple (32-bit float)

;----------------------------------------------------------
;Analyse détaillée :

;1. movss xmm0, [numA]
;   - Charge le float 32-bit depuis numA dans xmm0[0]
;   - xmm0 après instruction : [2.0, ?, ?, ?]

;2. movss xmm1, [numB]
;   - Charge le float 32-bit depuis numB dans xmm1[0]
;   - xmm1 après instruction : [8.0, ?, ?, ?]

;3. movss xmm2, [numC]
;   - Charge le float 32-bit depuis numC dans xmm2[0]
;   - xmm2 après instruction : [5.0, ?, ?, ?]

;4. vfmadd132ss xmm0,xmm1,xmm2
;   - Calcule xmm0[0] = xmm0[0]*xmm1[0] + xmm2[0]
;   - Résultat : 2.0*8.0 + 5.0 = 21.0
;   - Les autres éléments de xmm0 restent inchangés

;5. movss xmm0, [numA]
;   - Recharge xmm0[0] avec numA pour la prochaine instruction FMA

;6. vfmadd213ss xmm0,xmm1,xmm2
;   - Calcule xmm0[0] = xmm1[0]*xmm0[0] + xmm2[0]
;   - Opérandes permutées selon le code 213 pour la multiplication avant l'addition

;7. movss xmm0, [numA]
;   - Recharge xmm0[0] avec numA pour la prochaine instruction FMA

;8. vfmadd231ss xmm0,xmm1,xmm2
;   - Calcule xmm0[0] = xmm1[0]*xmm2[0] + xmm0[0]
;   - Opérandes permutées selon le code 231

;Note :
;- Seul le **premier float** du registre XMM est modifié
;- Les instructions FMA scalar permettent d’optimiser a*b + c en une seule instruction

;----------------------------------------------------------
;Résumé :
;Instruction                 | Effet
;----------------------------|-------------------------------------
;movss xmm0,[numA]           | Charge 1 float depuis numA dans xmm0[0]
;movss xmm1,[numB]           | Charge 1 float depuis numB dans xmm1[0]
;movss xmm2,[numC]           | Charge 1 float depuis numC dans xmm2[0]
;vfmadd132ss xmm0,xmm1,xmm2  | xmm0[0] = xmm0[0]*xmm1[0] + xmm2[0]
;vfmadd213ss xmm0,xmm1,xmm2  | xmm0[0] = xmm1[0]*xmm0[0] + xmm2[0]
;vfmadd231ss xmm0,xmm1,xmm2  | xmm0[0] = xmm1[0]*xmm2[0] + xmm0[0]


section .data
    numA dd 2.0          ; 8 floats 32-bit
    numB dd 8.0          ; 8 floats 32-bit
    numC dd 5.0          ; 8 floats 32-bit


section .text
global _start

_start:

    movss xmm0, [numA]        ; Charge le float 32-bit depuis numA dans xmm0[0]
                               ; xmm0 = [numA, ?, ?, ?] (les autres éléments du XMM restent inchangés)

    movss xmm1, [numB]        ; Charge le float 32-bit depuis numB dans xmm1[0]
                               ; xmm1 = [numB, ?, ?, ?]

    movss xmm2, [numC]        ; Charge le float 32-bit depuis numC dans xmm2[0]
                               ; xmm2 = [numC, ?, ?, ?]

     vfmadd132ss xmm0,xmm1,xmm2 ; Effectue xmm0[0] = xmm0[0] * xmm1[0] + xmm2[0]
                               ; Premier float du XMM modifié, les autres restent inchangés
                               ; Explication rapide : 1*3 + 2 → xmm0 = xmm0 * xmm1 + xmm2
                               ; Résultat : xmm0[0] = numA * numB + numC

    movss xmm0, [numA]        ; Recharge xmm0[0] avec numA pour la prochaine instruction FMA

    vfmadd213ss xmm0,xmm1,xmm2 ; Effectue xmm0[0] = xmm1[0] * xmm0[0] + xmm2[0]
                               ; Premier float du XMM modifié
                               ; Explication rapide : 2*1 + 3 → xmm0 = xmm1 * xmm0 + xmm2
                               ; Résultat : xmm0[0] = numB * numA + numC

    movss xmm0, [numA]        ; Recharge xmm0[0] avec numA pour la prochaine instruction FMA

    vfmadd231ss xmm0,xmm1,xmm2 ; Effectue xmm0[0] = xmm1[0] * xmm2[0] + xmm0[0]
                               ; Premier float du XMM modifié
                               ; Explication rapide : 2*3 + 1 → xmm0 = xmm1 * xmm2 + xmm0
                               ; Résultat : xmm0[0] = numB * numC + numA


    ; exit(0)
    mov rax, 60
    xor rdi, rdi
    syscall

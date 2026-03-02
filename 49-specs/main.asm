;----------------------------------------------------------
;Titre : Exemple SSE vectoriel float + SIMD saturé / min/max / round / moyenne
;----------------------------------------------------------

;Contexte :
;- On combine des instructions SSE pour les floats et SIMD pour les entiers :
;    1. movdqa : charge 128 bits (16 octets) alignés depuis la mémoire dans un XMM
;    2. maxps / minps : calcul du maximum ou minimum élément par élément sur 4 floats
;    3. roundps : arrondi des floats élément par élément selon le mode choisi
;    4. pavgw : moyenne arrondie de mots non-signés (16-bit) sur 8 éléments
; - Les instructions SIMD agissent sur tous les éléments du registre XMM ou du tableau en parallèle
; - movdqa exige que l'adresse mémoire soit alignée sur 16 octets
; - pavgw agit sur 16-bit × 8 éléments simultanément (XMM = 128 bits)

;----------------------------------------------------------
;Analyse détaillée :

;1. movdqa xmm1, [nums1]
;   - Charge 4 floats depuis nums1 dans xmm1
;   - nums1 = [44.5, 58.25, 32.6, 19.8]
;   - xmm1 après instruction : [44.5, 58.25, 32.6, 19.8]

;2. movdqa xmm2, [nums2]
;   - Charge 4 floats depuis nums2 dans xmm2
;   - nums2 = [22.7, 73.2, 66.15, 12.3]
;   - xmm2 après instruction : [22.7, 73.2, 66.15, 12.3]

;3. maxps xmm1, xmm2
;   - Calcul du maximum élément par élément
;   - xmm1[i] = max(xmm1[i], xmm2[i])
;   - Résultat : [44.5, 73.2, 66.15, 19.8]

;4. movdqa xmm1, [nums1] ; recharger nums1
;5. minps xmm1, xmm2
;   - Calcul du minimum élément par élément
;   - xmm1[i] = min(xmm1[i], xmm2[i])
;   - Résultat : [22.7, 58.25, 32.6, 12.3]

;6. roundps xmm1, xmm1, 00b
;   - Arrondit chaque float de xmm1 selon le mode 00b (round to nearest)
;   - xmm1 après instruction : [23.0, 58.0, 33.0, 12.0]

;7. roundps xmm2, xmm2, 00b
;   - Arrondit chaque float de xmm2 selon le mode 00b
;   - xmm2 après instruction : [23.0, 73.0, 66.0, 12.0]

;8. pavgw xmm1, xmm2
;   - Moyenne arrondie de mots (16-bit) élément par élément
;   - xmm1[i] = floor((xmm1[i] + xmm2[i] + 1)/2) pour chaque élément
;   - xmm1 après instruction : résultat intermédiaire de la moyenne arrondie

;----------------------------------------------------------
;Résumé :
;Instruction           | Effet
;----------------------|-------------------------------------
;movdqa xmm1,[nums1]   | Charge 4 floats depuis nums1 dans xmm1
;movdqa xmm2,[nums2]   | Charge 4 floats depuis nums2 dans xmm2
;maxps xmm1,xmm2       | xmm1[i] = max(xmm1[i], xmm2[i])
;minps xmm1,xmm2       | xmm1[i] = min(xmm1[i], xmm2[i])
;roundps xmm1,xmm1     | Arrondi chaque float de xmm1
;roundps xmm2,xmm2     | Arrondi chaque float de xmm2
;pavgw xmm1,xmm2       | Moyenne arrondie de mots non-signés (16-bit)

section .data
    nums1 dd 44.5,58.25,32.6,19.8          ; 4 floats 32-bit
    nums2 dd 22.7,73.2,66.15,12.3          ; 4 floats 32-bit

section .text
global _start

_start:

    movdqa xmm1, [nums1]     ; Charger 4 floats depuis nums1
    movdqa xmm2, [nums2]     ; Charger 4 floats depuis nums2
    maxps xmm1,xmm2          ; Maximum élément par élément

    movdqa xmm1, [nums1]     ; Recharger nums1
    minps xmm1,xmm2          ; Minimum élément par élément

    roundps xmm1,xmm1,00b    ; Arrondi nearest pour xmm1
    roundps xmm2,xmm2,00b    ; Arrondi nearest pour xmm2

    pavgw xmm1,xmm2          ; Moyenne arrondie de mots 16-bit

    ; exit(0)
    mov rax, 60
    xor rdi, rdi
    syscall


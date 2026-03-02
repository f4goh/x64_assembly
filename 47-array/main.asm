;----------------------------------------------------------
;Titre : Explication des instructions SSE vectorielles (float/double)
;----------------------------------------------------------

;Contexte :
;- On utilise des instructions SSE / SSE2 pour le calcul vectoriel sur flottants :
;    1. movaps : charge ou stocke 4 floats 32-bit (single precision) alignés dans un XMM
;    2. movapd : charge ou stocke 2 doubles 64-bit (double precision) alignés dans un XMM
;    3. divps : division élément par élément de 4 floats (packed single)
;    4. divpd : division élément par élément de 2 doubles (packed double)
; - Les instructions opèrent sur tous les éléments du registre XMM simultanément (SIMD)
; - Les adresses mémoire doivent être alignées sur 16 octets pour movaps/movapd

;----------------------------------------------------------
;Analyse détaillée :

;1. movaps xmm0, [nums]
;   - Charge 4 floats depuis nums dans xmm0
;   - nums = [12.5, 25.0, 37.5, 50.0]
;   - xmm0 après instruction : [12.5, 25.0, 37.5, 50.0]

;2. movaps xmm1, [numf]
;   - Charge 4 floats depuis numf dans xmm1
;   - numf = [2.0, 3.0, 4.0, 5.0]
;   - xmm1 après instruction : [2.0, 3.0, 4.0, 5.0]

;3. divps xmm0, xmm1
;   - Division packed single-precision
;   - xmm0[i] = xmm0[i] / xmm1[i] pour i = 0..3
;   - Calcul :
;       12.5 / 2.0 = 6.25
;       25.0 / 3.0 ≈ 8.3333
;       37.5 / 4.0 = 9.375
;       50.0 / 5.0 = 10.0
;   - xmm0 après instruction : [6.25, 8.3333, 9.375, 10.0]

;4. movapd xmm2, [dubs]
;   - Charge 2 doubles depuis dubs dans xmm2
;   - dubs = [12.5, 25.0]
;   - xmm2 après instruction : [12.5, 25.0]

;5. movapd xmm3, [dubf]
;   - Charge 2 doubles depuis dubf dans xmm3
;   - dubf = [2.0, 3.0]
;   - xmm3 après instruction : [2.0, 3.0]

;6. divpd xmm2, xmm3
;   - Division packed double-precision
;   - xmm2[i] = xmm2[i] / xmm3[i] pour i = 0..1
;   - Calcul :
;       12.5 / 2.0 = 6.25
;       25.0 / 3.0 ≈ 8.3333
;   - xmm2 après instruction : [6.25, 8.3333]

;----------------------------------------------------------
;Résumé :
;Instruction           | Effet
;----------------------|-------------------------------------
;movaps xmm0,[nums]    | Charge 4 floats (32-bit) depuis nums dans xmm0
;movaps xmm1,[numf]    | Charge 4 floats (32-bit) depuis numf dans xmm1
;divps xmm0,xmm1       | Divise chaque float de xmm0 par xmm1 élément par élément
;movapd xmm2,[dubs]    | Charge 2 doubles (64-bit) depuis dubs dans xmm2
;movapd xmm3,[dubf]    | Charge 2 doubles (64-bit) depuis dubf dans xmm3
;divpd xmm2,xmm3       | Divise chaque double de xmm2 par xmm3 élément par élément

section .data
    nums dd 12.5,25.0,37.5,50.0          ; 4 floats 32-bit (single precision)
    numf dd 2.0,3.0,4.0,5.0              ; 4 floats 32-bit
    dubs dq 12.5,25.0                     ; 2 doubles 64-bit
    dubf dq 2.0,3.0                       ; 2 doubles 64-bit

section .text
global _start

_start:

    movaps xmm0, [nums]     ; Charger 4 floats depuis nums dans xmm0
    movaps xmm1, [numf]     ; Charger 4 floats depuis numf dans xmm1
    divps xmm0,xmm1         ; Division SIMD float

    movapd xmm2, [dubs]     ; Charger 2 doubles depuis dubs dans xmm2
    movapd xmm3, [dubf]     ; Charger 2 doubles depuis dubf dans xmm3
    divpd xmm2,xmm3         ; Division SIMD double

    ; exit(0)
    mov rax, 60
    xor rdi, rdi
    syscall

;----------------------------------------------------------
;Titre : Exemple AVX vectoriel float avec opérations arithmétiques
;----------------------------------------------------------

;Contexte :
;- On utilise des instructions AVX pour le calcul vectoriel sur floats 32-bit :
;    1. vmovaps : charge 128/256 bits alignés depuis la mémoire dans un registre YMM
;    2. vaddps / vsubps / vmulps / vdivps : opérations arithmétiques élément par élément
;       sur 8 floats simultanément (SIMD)
; - Toutes les instructions agissent sur tous les éléments du registre en parallèle
; - Les adresses mémoire doivent être alignées sur 32 octets pour YMM (vmovaps)

;----------------------------------------------------------
;Analyse détaillée :

;1. vmovaps ymm1, [vec1]
;   - Charge 8 floats depuis vec1 dans ymm1
;   - vec1 = [1.0,2.0,3.0,4.0,5.0,6.0,7.0,8.0]
;   - ymm1 après instruction : [1,2,3,4,5,6,7,8]

;2. vmovaps ymm2, [vec2]
;   - Charge 8 floats depuis vec2 dans ymm2
;   - vec2 = [8.0,7.0,6.0,5.0,4.0,3.0,2.0,1.0]
;   - ymm2 après instruction : [8,7,6,5,4,3,2,1]

;3. vmulps ymm0, ymm1, ymm2
;   - Multiplication élément par élément
;   - ymm0[i] = ymm1[i] * ymm2[i]
;   - Résultat : [8,14,18,20,20,18,14,8]

;4. vaddps ymm0, ymm1, ymm2
;   - Addition élément par élément
;   - ymm0[i] = ymm1[i] + ymm2[i]
;   - Résultat : [9,9,9,9,9,9,9,9]

;5. vsubps ymm0, ymm2, ymm1
;   - Soustraction élément par élément
;   - ymm0[i] = ymm2[i] - ymm1[i]
;   - Résultat : [7,5,3,1,-1,-3,-5,-7]

;6. vdivps ymm0, ymm2, ymm1
;   - Division élément par élément
;   - ymm0[i] = ymm2[i] / ymm1[i]
;   - Résultat : [8,3.5,2,1.25,0.8,0.5,0.2857,0.125]

;----------------------------------------------------------
;Résumé :
;Instruction           | Effet
;----------------------|-------------------------------------
;vmovaps ymm1,[vec1]   | Charge 8 floats depuis vec1 dans ymm1
;vmovaps ymm2,[vec2]   | Charge 8 floats depuis vec2 dans ymm2
;vmulps ymm0,ymm1,ymm2 | Multiplication élément par élément
;vaddps ymm0,ymm1,ymm2 | Addition élément par élément
;vsubps ymm0,ymm2,ymm1 | Soustraction élément par élément
;vdivps ymm0,ymm2,ymm1 | Division élément par élément

section .data
    vec1 dd 1.0,2.0,3.0,4.0,5.0,6.0,7.0,8.0          ; 8 floats 32-bit
    vec2 dd 8.0,7.0,6.0,5.0,4.0,3.0,2.0,1.0          ; 8 floats 32-bit

section .text
global _start

_start:

    vmovaps ymm1, [vec1]     ; Charger 8 floats depuis vec1
    vmovaps ymm2, [vec2]     ; Charger 8 floats depuis vec2
    
    vmulps ymm0, ymm1, ymm2  ; Multiplication SIMD
    vaddps ymm0, ymm1, ymm2  ; Addition SIMD
    vsubps ymm0, ymm2, ymm1  ; Soustraction SIMD
    vdivps ymm0, ymm2, ymm1  ; Division SIMD

    ; exit(0)
    mov rax, 60
    xor rdi, rdi
    syscall

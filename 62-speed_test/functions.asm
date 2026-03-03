;pour la fonction appel en cpp DoRun(float*,float*,int); 

section .note.GNU-stack                  ; indique que la pile n’est pas exécutable

section .text
    global DoRun

; Arguments :
; a -> rdi (float* 4 éléments)
; b -> rsi (float* 4 éléments)
; n -> edx (int)
; Retour -> void

DoRun:
    mov ecx, edx          ; copie n (3e argument) dans ecx
                          ; ecx servira de compteur de boucle
loop:
    movaps xmm0, [rdi]    ; recharge les 4 floats de 'a' à chaque itération
                          ; (lecture mémoire)

    movaps xmm1, [rsi]    ; recharge les 4 floats de 'b'
                          ; (lecture mémoire)

    mulps xmm0, xmm1      ; multiplication SIMD :
                          ; xmm0[i] = xmm0[i] * xmm1[i]
                          ; traite 4 floats en parallèle

    movaps [rdi], xmm0    ; écrit le résultat dans le tableau 'a'
                          ; (écriture mémoire)

    dec ecx               ; décrémente le compteur

    jnz loop              ; si ecx != 0, retourne au label loop

    ret                   ; retour à l'appelant (C++)

;version optimisée
;DoRun:
;    mov ecx, edx
;    movaps xmm0, [rdi]
;    movaps xmm1, [rsi]

;    loop:
;        mulps xmm0, xmm1
;        dec ecx
;        jnz loop

;    movaps [rdi], xmm0
;    ret



;----------------------------------------------------------
; Macro : factorial
; Paramètre :
;   %1 = nombre constant connu à l’assemblage
;
; Retour :
;   la macro renvoie directement la valeur (utilisable dans une instruction)
;----------------------------------------------------------
%macro factorial 1
    %assign _factor %1
    %assign _result 1

    %rep 1000
        %if _factor <= 1
            %exitrep
        %endif
        %assign _result _result*_factor
        %assign _factor _factor-1
    %endrep

    %assign factorial_value _result   ; renvoie la valeur dans un assign temporaire
%endmacro

section .text
global _start

_start:

    ; Calcul à l’assemblage et utilisation directe
    factorial 4
    mov rax, factorial_value   ; rax = 24

    factorial 5
    mov rbx, factorial_value   ; rbx = 120

    ; exit(0)
    mov rax, 60
    xor rdi, rdi
    syscall

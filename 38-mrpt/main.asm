;----------------------------------------------------------
; Macro : rpt
; Paramètres :
;   %1 = registre
;   %2 = nombre de répétitions (constante)
;
; Rôle :
;   Répète l'instruction INC registre %2 fois
;----------------------------------------------------------
%macro rpt 2
    %rep %2
        inc %1
    %endrep
%endmacro

;----------------------------------------------------------
; Macro : itr
; Paramètres :
;   %1 = registre destination
;   %2 = valeur initiale (num)
;
; Logique :
;   count = num
;   Tant que count <= 100 :
;       count += 27
;       mov reg, count
;       si count est pair → sortir de la macro
;----------------------------------------------------------
%macro itr 2
    %assign count %2

    %rep 1000
        %if count > 100
            %exitrep
        %endif

        %assign count count+27
        mov %1, count

        %if (count % 2) = 0
            %exitrep
        %endif
    %endrep
%endmacro



section .text
    global _start

_start:

    mov rax,10
    mov rcx,10
    rpt rax,10
    itr rcx,10


    ; exit(0)
    mov rax, 60            ; numéro de syscall pour exit (Linux x86-64)
    xor rdi, rdi           ; code de retour 0
    syscall                ; appel système pour terminer le programme



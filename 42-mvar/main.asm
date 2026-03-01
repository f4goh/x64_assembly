;----------------------------------------------------------
; Macro : sumArgs
; Paramètres :
;   arglist = liste de nombres (constant connus à l’assemblage)
;
; Logique :
;   sum = 0
;   i = 0
;   Pour chaque argument de arglist :
;       i = i + 1
;       sum = sum + argument
;   À la fin :
;       rcx = i (nombre d’arguments)
;       valeur renvoyée = sum
;
; Remarque :
;   Cette macro fonctionne uniquement avec des constantes connues à l’assemblage
;----------------------------------------------------------
%macro sumArgs 1-*

    ; initialisation
    %assign _sum 0
    %assign _count 0

    ; pour chaque argument
    %rep %0
        %assign _count _count + 1
        %assign _sum _sum + %1
        %rotate 1
    %endrep

    ; stocker temporairement les valeurs
    %assign sumArgs_value _sum
    %assign sumArgs_count _count

%endmacro

section .text
global _start

_start:

    ; calcul de la somme
    sumArgs 1,2,3,4         ; sumArgs_value = 10, sumArgs_count = 4
    mov rax, sumArgs_value  ; rax = 10
    mov rcx, sumArgs_count  ; rcx = 4


    ; exit(0)
    mov rax, 60
    xor rdi, rdi
    syscall

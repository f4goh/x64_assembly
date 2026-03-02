;----------------------------------------------------------
; main.asm : Affiche "Hello world!" et la valeur entière 456
; https://www.mgaillard.fr/2024/09/20/printf-assembly-linux.html
; https://portal.cs.umbc.edu/help/nasm/sample_64.shtml
; ps aux | grep -i edb
; dans edb le breakpoint à l'adresse main est automatiquement ajouté
;----------------------------------------------------------
BITS 64       ; On travaille en mode 64-bit

section .data
    messageHello db "Hello world!", 10,0     ; Chaîne de caractères + saut de ligne + terminaison nulle
    messageNumber db 'Number = %d', 10, 0   ; Chaîne de format pour printf avec entier
    value dd 456                             ; Entier 32-bit à afficher

section .note.GNU-stack                       ; Indique au linker que la pile n’est pas exécutable

global main                                  ; point d'entrée visible par GCC/LD
extern printf                                ; fonction printf de la libc

section .text

main:
        push        rbp                      ; sauvegarde du registre de base pour la pile (stack frame)
        
        mov         rdi, messageHello        ; premier argument de printf : adresse de la chaîne
        xor         rax, rax                 ; pour les appels variadiques en x86_64, rax = 0
        call        printf                   ; appel à printf pour afficher "Hello world!"

        mov         rdi, messageNumber       ; premier argument pour printf : chaîne de format
        mov         rsi, [value]            ; second argument : valeur entière à afficher
        xor         rax, rax                 ; rax = 0 pour printf 
        call        printf                   ; appel à printf pour afficher "Number = 456"

        pop         rbp                      ; restauration du registre de base (fin du stack frame)

       ; exit(0)
        mov         rax, 0                   ; code retour 0 (normal)
        ret                                  ; retour au programme appelant


; La première ligne : BITS 64; indique à NASM que nous travaillons sur une architecture 64 bits.  
; Cela évite plusieurs erreurs de surlignage syntaxique dans VS Code.

; Comme nous lions avec gcc et non ld, le point d'entrée n'est pas _start mais main,  
; comme la fonction int main() en C.  
; Nous déclarons donc notre fonction main avec global main,  
; nous configurons la pile avec push rbp et pop rbp,  
; et nous retournons zéro avec mov rax, 0 et ret.

; L'appel à printf() se fait comme en C.  
; Le premier argument est un pointeur vers la chaîne terminée par zéro "Hello, World!\n",  
; donc on le place dans rdi avec mov rdi, message.  
; Selon la convention d'appel Linux pour les fonctions avec arguments variables,  
; le registre RAX contient le nombre d'arguments flottants.  
; Comme nous ne passons pas de nombres flottants, RAX doit être égal à zéro.  
; On le remet à zéro avec xor rax, rax.

; Lors du linkage avec gcc, l'option -no-pie est utilisée  
; pour éviter une erreur de linkage concernant les exécutables indépendants de la position.  
; Et l'option -lc indique à gcc de linker avec la bibliothèque C.



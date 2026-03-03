; sudo apt install yad
; https://doc.ubuntu-fr.org/yad_yet_another_dialog
; test_yad_main.asm
BITS 64               ; mode 64-bit

section .data
    yad_path db "/usr/bin/yad",0         ; chemin complet vers l’exécutable YAD
    yad_arg1 db "--info",0               ; premier argument : type de boîte "info"
    yad_arg2 db "--text=Hello World",0  ; deuxième argument : texte affiché dans la boîte

section .bss
    argv resq 4       ; tableau de 4 pointeurs pour execve : {yad_path, arg1, arg2, NULL}

section .note.GNU-stack                  ; indique que la pile n’est pas exécutable

section .text
    global main
    extern environ                         ; variable libc contenant l’environnement actuel

main:
    ; --- Préparer argv pour execve ---
    lea rax, [yad_path]                    ; charger l’adresse de yad_path
    mov [argv], rax                        ; argv[0] = yad_path
    lea rax, [yad_arg1]                    ; charger l’adresse de yad_arg1
    mov [argv+8], rax                      ; argv[1] = --info
    lea rax, [yad_arg2]                    ; charger l’adresse de yad_arg2
    mov [argv+16], rax                     ; argv[2] = --text="Hello World"
    mov qword [argv+24], 0                 ; argv[3] = NULL pour terminer le tableau

    ; --- Appeler execve("/usr/bin/yad", argv, environ) ---
    mov rax, 59                             ; numéro du syscall execve
    lea rdi, [yad_path]                     ; premier argument : chemin de l’exécutable
    lea rsi, [argv]                         ; deuxième argument : tableau argv
    mov rdx, [environ]                      ; troisième argument : tableau envp
    syscall                                 ; exécuter YAD

    ; --- Si execve échoue, retourner 1 depuis main ---
    mov eax, 1                              ; code retour 1
    ret                                      ; retour au programme appelant

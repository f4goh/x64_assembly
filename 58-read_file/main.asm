section .data
    filename db "texte.txt",0        ; nom du fichier

section .bss
    buffer resb 256                  ; buffer pour lire le contenu
    bufsize equ 256                  ; taille du buffer

section .text
    global _start

_start:

    ; -------------------------
    ; open("texte.txt", O_RDONLY)
    ; -------------------------
    mov rax, 2          ; syscall open
    lea rdi, [filename] ; rdi = nom du fichier
    mov rsi, 0          ; rsi = O_RDONLY = 0
    xor rdx, rdx        ; rdx = ignoré pour la lecture
    syscall             ; appel système
    mov r12, rax        ; sauvegarde fd (file descriptor dans rax)
    cmp rax, 0
    jl  exit_program    ; si erreur ouverture, sortir

read_loop:
    ; -------------------------
    ; read(fd, buffer, bufsize)
    ; -------------------------
    mov rax, 0          ; syscall read
    mov rdi, r12        ; fd
    lea rsi, [buffer]   ; adresse du buffer
    mov rdx, bufsize    ; lit jusqu’à 256 octets dans buffer
    syscall             ; appel système
    cmp rax, 0
    jle close_file      ; si rax=0 → fin de fichier

    ; -------------------------
    ; write(1, buffer, rax)
    ; -------------------------
    mov rdi, 1          ; stdout
    mov rsi, buffer     ; adresse du buffer
    mov rdx, rax        ; nombre d’octets lus
    mov rax, 1          ; syscall write
    syscall             ; écrit exactement le nombre d’octets lus sur stdout

    jmp read_loop       ; boucle jusqu’à ce que read retourne 0 → fin de fichier

close_file:
    ; -------------------------
    ; close(fd)
    ; -------------------------
    mov rax, 3          ; syscall close
    mov rdi, r12        ; fd
    syscall             ; nettoyage propre du fd

exit_program:
    ; -------------------------
    ; exit(0)
    ; -------------------------
    mov rax, 60         ; syscall exit
    xor rdi, rdi        ; code retour = 0
    syscall             ; sortie du programme

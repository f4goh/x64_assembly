global main

; ===== ncurses =====
extern initscr
extern endwin
extern refresh
extern keypad
extern noecho
extern cbreak

extern start_color
extern init_pair

extern newwin
extern box
extern wrefresh
extern mvwprintw
extern werase

extern wattron
extern wattroff
extern wgetch

; ===== constantes =====
%define COLOR_PAIR(n) (n << 8)

%define KEY_UP    259
%define KEY_DOWN  258
%define KEY_LEFT  260
%define KEY_RIGHT 261

section .data
    title  db "Fenetre ncurses ASM", 0
    player db "@", 0

section .bss
    win resq 1

section .text
main:
    ; ===== alignement ABI =====
    sub rsp, 8

    ; ===== init ncurses =====
    call initscr
    call cbreak
    call noecho

    ; ===== couleurs =====
    call start_color
    mov rdi, 1          ; pair 1
    mov rsi, 1          ; COLOR_RED
    mov rdx, 0          ; COLOR_BLACK
    xor eax, eax
    call init_pair

    ; ===== créer fenêtre =====
    mov rdi, 10         ; hauteur
    mov rsi, 30         ; largeur
    mov rdx, 5          ; y
    mov rcx, 10         ; x
    call newwin
    mov [win], rax

    ; ===== activer keypad SUR LA FENÊTRE =====
    mov rdi, [win]
    mov rsi, 1
    call keypad

    ; ===== dessiner cadre =====
    mov rdi, [win]
    xor rsi, rsi
    xor rdx, rdx
    call box

    mov rdi, [win]
    call wrefresh

    ; ===== position joueur =====
    mov r12, 5          ; y
    mov r13, 15         ; x

.loop:
    ; effacer fenêtre
    mov rdi, [win]
    call werase

    ; redessiner cadre
    mov rdi, [win]
    xor rsi, rsi
    xor rdx, rdx
    call box

    ; couleur ON (sur la fenêtre)
    mov rdi, [win]
    mov rsi, COLOR_PAIR(1)
    call wattron

    ; afficher joueur
    mov rdi, [win]
    mov rsi, r12
    mov rdx, r13
    mov rcx, player
    xor rax, rax
    call mvwprintw

    ; couleur OFF
    mov rdi, [win]
    mov rsi, COLOR_PAIR(1)
    call wattroff

    ; refresh fenêtre
    mov rdi, [win]
    call wrefresh

    ; ===== lire touche (SUR LA FENÊTRE) =====
    mov rdi, [win]
    call wgetch

    cmp eax, 'q'
    je .exit

    cmp eax, KEY_UP
    je .up
    cmp eax, KEY_DOWN
    je .down
    cmp eax, KEY_LEFT
    je .left
    cmp eax, KEY_RIGHT
    je .right
    jmp .loop

.up:
    dec r12
    jmp .loop
.down:
    inc r12
    jmp .loop
.left:
    dec r13
    jmp .loop
.right:
    inc r13
    jmp .loop

.exit:
    call endwin
    add rsp, 8
    xor eax, eax
    ret

section .note.GNU-stack noalloc noexec nowrite progbits


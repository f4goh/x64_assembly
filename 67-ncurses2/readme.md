# NCURSES EN ASSEMBLEUR (NASM x86-64)

## Compilation

Pour compiler le programme assembleur utilisant ncurses :

nasm -f elf64 main.asm -o main.o
gcc -no-pie main.o -o main -lncurses

## 1) Installation de NCURSES (Debian / Ubuntu)

Installer la librairie et les headers :

sudo apt update
sudo apt install libncurses-dev

Vérifier l’installation :

ls /usr/include/ncurses.h
ldconfig -p | grep ncurses

## 2) Principe de NCURSES

ncurses est une bibliothèque C permettant :
- L'affichage texte avancé
- La gestion clavier
- Les couleurs
- Les fenêtres
- Le rafraîchissement optimisé

Important : ncurses est conçue pour fonctionner avec un programme C. En ASM, il faut définir main et pas _start ; GCC gère le runtime.

## 3) Rappel ABI System V AMD64 (passage des paramètres)

En Linux x86-64, les 6 premiers arguments sont passés dans :
- 1er argument → RDI
- 2e argument → RSI
- 3e argument → RDX
- 4e argument → RCX
- 5e argument → R8
- 6e argument → R9

Valeur de retour → RAX

Important pour fonctions variadiques (ex : mvprintw) : EAX doit contenir 0 avant l’appel.

## 4) Exemple expliqué

global main
extern initscr
extern mvprintw
extern refresh
extern getch
extern endwin

section .data
    msg db "Hello ncurses depuis NASM !", 0

section .text
main:
    sub rsp, 8           ; alignement de la stack
    call initscr          ; initialise ncurses
    mov rdi, 5            ; y
    mov rsi, 10           ; x
    mov rdx, msg          ; pointeur vers chaîne
    xor eax, eax          ; obligatoire pour fonction variadique
    call mvprintw         ; affiche le message
    call refresh          ; met à jour l’écran physique
    call getch            ; attend une touche
    call endwin           ; quitte ncurses proprement
    add rsp, 8
    xor eax, eax          ; return 0
    ret

Pourquoi sub rsp, 8 ? L’ABI impose que RSP soit aligné sur 16 octets avant un call. GCC entre dans main avec un stack désaligné de 8 octets.

## 5) Fonctions ncurses les plus utiles

Initialisation :
- initscr()
- endwin()
- noecho()
- cbreak()
- keypad(stdscr, TRUE)
- curs_set(0)

Affichage :
- printw()
- mvprintw(y, x, ...)
- addch()
- mvaddch(y, x, ch)
- clear()
- refresh()

Clavier :
- getch()

Couleurs :
- start_color()
- init_pair(id, fg, bg)
- attron(COLOR_PAIR(id))
- attroff(COLOR_PAIR(id))

Fenêtres :
- newwin(h, w, y, x)
- box(win, 0, 0)
- wrefresh(win)

## 6) Exemple minimal avec options utiles

extern noecho
extern cbreak
extern keypad

call initscr
call noecho
call cbreak

; activation clavier spécial
mov rdi, 0
mov rsi, 1
call keypad

## 7) Points importants en ASM

1. Toujours aligner la stack avant call
2. Mettre xor eax, eax pour les fonctions variadiques
3. Déclarer les fonctions avec extern
4. Utiliser global main
5. Compiler avec GCC pour linker ncurses

## 8) Erreurs courantes

Erreur : multiple definition of _start  
Cause : utilisation de _start au lieu de main

Erreur : undefined reference to main  
Cause : GCC attend une fonction main

## 9) Structure type d’un programme ncurses en ASM

1. initscr  
2. Configuration (noecho, cbreak, keypad...)  
3. Boucle principale  
4. refresh  
5. getch  
6. endwin  
7. return 0

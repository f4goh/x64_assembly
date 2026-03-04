# NCURSES EN ASSEMBLEUR (NASM x86-64)

Compilation type :

nasm -f elf64 main.asm -o main.o
gcc -no-pie main.o -o main -lncurses


============================================================
1) INSTALLATION DE NCURSES (DEBIAN / UBUNTU)
============================================================

Installer la librairie et les headers :

sudo apt update
sudo apt install libncurses-dev

Vérifier l’installation :

ls /usr/include/ncurses.h
ldconfig -p | grep ncurses


============================================================
2) PRINCIPE DE NCURSES
============================================================

ncurses est une bibliothèque C permettant :
- l'affichage texte avancé
- la gestion clavier
- les couleurs
- les fenêtres
- le rafraîchissement optimisé

IMPORTANT :
ncurses est conçue pour fonctionner avec un programme C.
Donc en ASM :
- on définit "main"
- PAS "_start"
- on laisse GCC gérer le runtime


============================================================
3) RAPPEL ABI SYSTEM V AMD64 (PASSAGE DES PARAMÈTRES)
============================================================

En Linux x86-64, les 6 premiers arguments sont passés dans :

RDI → 1er argument
RSI → 2e
RDX → 3e
RCX → 4e
R8  → 5e
R9  → 6e

Valeur de retour → RAX

IMPORTANT pour fonctions variadiques (ex: mvprintw) :
EAX doit contenir 0 avant l’appel.


============================================================
4) TON EXEMPLE EXPLIQUÉ
============================================================

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
    sub rsp, 8


Pourquoi "sub rsp, 8" ?

L’ABI impose que RSP soit aligné sur 16 octets avant un call.
GCC entre dans main avec un stack désaligné de 8.
On corrige donc avec "sub rsp, 8".


------------------------------------------------------------
initscr()
------------------------------------------------------------

call initscr

Aucun paramètre.
Initialise le mode ncurses.


------------------------------------------------------------
mvprintw(y, x, msg)
------------------------------------------------------------

mov rdi, 5      ; y
mov rsi, 10     ; x
mov rdx, msg    ; pointeur vers chaîne
xor eax, eax    ; obligatoire (fonction variadique)
call mvprintw

Equivalent C :
mvprintw(5, 10, "Hello ...");


------------------------------------------------------------
refresh()
------------------------------------------------------------

call refresh

Met à jour l’écran physique.


------------------------------------------------------------
getch()
------------------------------------------------------------

call getch

Attend une touche.
Retour dans RAX.


------------------------------------------------------------
endwin()
------------------------------------------------------------

call endwin

Quitte proprement ncurses.


------------------------------------------------------------
Fin du programme
------------------------------------------------------------

add rsp, 8
xor eax, eax
ret

Retourne 0 au système.


============================================================
5) FONCTIONS NCURSES LES PLUS UTILES
============================================================

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


============================================================
6) EXEMPLE MINIMAL AVEC OPTIONS UTILES
============================================================

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


============================================================
7) POINTS IMPORTANTS EN ASM
============================================================

1) Toujours aligner la stack avant call.
2) Mettre xor eax, eax pour les fonctions variadiques.
3) Déclarer les fonctions avec "extern".
4) Utiliser "global main".
5) Compiler avec GCC pour linker ncurses.


============================================================
8) ERREURS COURANTES
============================================================

Erreur :
multiple definition of _start

Cause :
utilisation de "_start" au lieu de "main".

Erreur :
undefined reference to main

Cause :
GCC attend une fonction main.


============================================================
9) STRUCTURE TYPE D’UN PROGRAMME NCURSES EN ASM
============================================================

1) initscr
2) configuration (noecho, cbreak, keypad...)
3) boucle principale
4) refresh
5) getch
6) endwin
7) return 0




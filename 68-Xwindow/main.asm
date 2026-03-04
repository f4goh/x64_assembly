; ------------------------------------------------------------
; Compilation :
; nasm -f elf64 rectangle.asm -o rectangle.o
; gcc -no-pie rectangle.o -o rectangle -lX11
;
; Programme :
; - ouvre une connexion X11
; - crée une fenêtre 400x300
; - dessine un rectangle rouge lors d’un événement Expose
; - quitte quand on appuie sur la barre d’espace
; ------------------------------------------------------------

; =========================
; Fonctions X11 externes
; =========================

extern XOpenDisplay
extern XDefaultScreen
extern XDefaultRootWindow
extern XBlackPixel
extern XWhitePixel
extern XCreateSimpleWindow
extern XMapWindow
extern XCreateGC
extern XSetForeground
extern XFillRectangle
extern XFlush
extern XSelectInput
extern XNextEvent
extern XLookupKeysym
extern XCloseDisplay

; =========================
; Constantes
; =========================

section .data
    width           equ 400        ; largeur fenêtre
    height          equ 300        ; hauteur fenêtre
    red             equ 0xff0000   ; couleur rouge RGB

    ; Types d'événements X11
    KeyPress        equ 2
    Expose          equ 12

    ; Masques d’événements
    KeyPressMask    equ 1
    ExposureMask    equ (1 << 15)

    XK_space        equ 32         ; keycode barre d'espace

; =========================
; Zone mémoire pour XEvent
; =========================

section .bss
    xevent  resb 192               ; union XEvent (taille suffisante)

section .note.GNU-stack            ; pile non exécutable

; =========================
; Code
; =========================

section .text
    global main

main:
    sub rsp, 8                     ; alignement ABI System V (obligatoire)

    ; ------------------------------------------------------------
    ; Ouvrir la connexion au serveur X
    ; Display* dpy = XOpenDisplay(NULL);
    ; ------------------------------------------------------------

    xor rdi, rdi                   ; argument NULL
    call XOpenDisplay
    test rax, rax
    jz .exit                       ; si échec → quitter
    mov r12, rax                   ; r12 = Display*

    ; ------------------------------------------------------------
    ; int screen = XDefaultScreen(dpy);
    ; ------------------------------------------------------------

    mov rdi, r12
    call XDefaultScreen
    mov r13d, eax                  ; r13d = screen number

    ; ------------------------------------------------------------
    ; Window root = XDefaultRootWindow(dpy);
    ; ------------------------------------------------------------

    mov rdi, r12
    call XDefaultRootWindow
    mov r14, rax                   ; r14 = root window

    ; ------------------------------------------------------------
    ; Pixel noir
    ; unsigned long black = XBlackPixel(dpy, screen);
    ; ------------------------------------------------------------

    mov rdi, r12
    mov rsi, r13
    call XBlackPixel
    mov r15d, eax                  ; r15d = black pixel

    ; ------------------------------------------------------------
    ; Pixel blanc
    ; unsigned long white = XWhitePixel(dpy, screen);
    ; ------------------------------------------------------------

    mov rdi, r12
    mov rsi, r13
    call XWhitePixel
    mov r11d, eax                  ; r11d = white pixel

    ; ------------------------------------------------------------
    ; Création de la fenêtre
    ;
    ; Window win = XCreateSimpleWindow(
    ;   dpy, root,
    ;   0, 0,
    ;   width, height,
    ;   border_width,
    ;   border_color,
    ;   background_color
    ; );
    ; ------------------------------------------------------------

    mov rdi, r12                   ; dpy
    mov rsi, r14                   ; root
    xor rdx, rdx                   ; x = 0
    xor rcx, rcx                   ; y = 0
    mov r8d, width                 ; largeur
    mov r9d, height                ; hauteur

    ; paramètres supplémentaires passés sur la pile (ABI)
    sub rsp, 32
    mov qword [rsp+24], 1          ; border width
    mov qword [rsp+16], r15        ; border color
    mov qword [rsp+8], r11         ; background color
    call XCreateSimpleWindow
    add rsp, 32

    mov rbx, rax                   ; rbx = Window

    ; ------------------------------------------------------------
    ; Sélection des événements :
    ; KeyPress + Expose
    ; ------------------------------------------------------------

    mov rdi, r12
    mov rsi, rbx
    mov edx, KeyPressMask | ExposureMask
    call XSelectInput

    ; ------------------------------------------------------------
    ; Afficher la fenêtre à l’écran
    ; ------------------------------------------------------------

    mov rdi, r12
    mov rsi, rbx
    call XMapWindow

    ; ------------------------------------------------------------
    ; Création du Graphics Context
    ; GC gc = XCreateGC(dpy, win, 0, NULL);
    ; ------------------------------------------------------------

    xor rdx, rdx
    xor rcx, rcx
    mov rdi, r12
    mov rsi, rbx
    call XCreateGC
    mov r14, rax                   ; r14 = GC

    ; ------------------------------------------------------------
    ; Définir couleur de dessin
    ; XSetForeground(dpy, gc, red);
    ; ------------------------------------------------------------

    mov rdi, r12
    mov rsi, r14
    mov edx, red
    call XSetForeground

; ==========================================================
; Boucle principale d’événements
; ==========================================================

.loop:
    ; XNextEvent(dpy, &xevent);
    mov rdi, r12
    lea rsi, [rel xevent]
    call XNextEvent

    ; Si événement Expose → dessiner
    cmp dword [xevent], Expose
    je .draw

    ; Si événement KeyPress → tester la touche
    cmp dword [xevent], KeyPress
    jne .loop

    ; XLookupKeysym((XKeyEvent*)&xevent, 0);
    ; XEvent est une union → XKeyEvent commence à l’offset 0
    lea rdi, [rel xevent]
    xor rsi, rsi
    call XLookupKeysym

    ; Si barre d’espace → quitter
    cmp eax, XK_space
    jne .loop

    jmp .quit

; ==========================================================
; Dessin du rectangle
; ==========================================================

.draw:
    ; XFillRectangle(dpy, win, gc, 50, 50, 200, 100);

    mov rdi, r12                   ; dpy
    mov rsi, rbx                   ; win
    mov rdx, r14                   ; gc
    mov ecx, 50                    ; x
    mov r8d, 50                    ; y
    mov r9d, 200                   ; largeur

    sub rsp, 8                     ; 7e argument sur pile
    mov dword [rsp], 100           ; hauteur
    call XFillRectangle
    add rsp, 8

    ; Forcer affichage immédiat
    mov rdi, r12
    call XFlush

    jmp .loop

; ==========================================================
; Sortie propre
; ==========================================================

.quit:
    mov rdi, r12
    call XCloseDisplay             ; fermer connexion X

.exit:
    add rsp, 8                     ; restaurer stack
    xor eax, eax                   ; return 0
    ret

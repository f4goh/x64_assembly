;nasm -f elf64 main.asm -o main.o
;gcc main.o -o main -lraylib -ldl -lm -lpthread

global main

; Fonctions externes de Raylib utilisées
extern InitWindow
extern SetTargetFPS
extern BeginDrawing
extern ClearBackground
extern DrawCircle
extern EndDrawing
extern WindowShouldClose
extern CloseWindow

section .note.GNU-stack                  ; indique que la pile n’est pas exécutable

section .data
    windowTitle db "Hello from Raylib & x64 Asm :)", 0  ; titre de la fenêtre
    circleRadius dd 15.0                                ; rayon du cercle (float)

section .text

main:
    push rbp
    mov rbp, rsp
    ; sauvegarde de l'ancien base pointer pour la fonction main

    ; -----------------------------
    ; Initialisation de la fenêtre
    ; -----------------------------
    ; InitWindow(512, 512, windowTitle)
    mov rdi, 512                 ; largeur
    mov rsi, 512                 ; hauteur
    lea rdx, [rel windowTitle]   ; pointeur vers le titre
    call InitWindow

    ; SetTargetFPS(60)
    mov rdi, 60                  ; fps cible
    call SetTargetFPS

mainLoop:
    ; -----------------------------
    ; Début du dessin pour chaque frame
    ; -----------------------------
    call BeginDrawing

    ; ClearBackground(BLACK)
    ; ARGB = 0xff000000 -> noir opaque
    mov edi, 0xff000000
    call ClearBackground

    ; Initialisation de la position du cercle
    mov r15d, 448                ; position X initiale (512-64)

circleLoop:
    ; -----------------------------
    ; Dessiner un cercle
    ; -----------------------------
    ; DrawCircle(int x, int y, float radius, Color color)
    mov edi, r15d                ; x
    mov esi, 256                 ; y (milieu de la fenêtre)
    movss xmm0, [rel circleRadius] ; rayon (float) dans xmm0
    mov edx, 0xff0080ff          ; couleur (ARGB, ici jaune/rose)
    call DrawCircle

    sub r15d, 64                 ; décaler x de 64 pixels
    jnz circleLoop               ; répéter tant que r15d != 0

    ; -----------------------------
    ; Fin du dessin de la frame
    ; -----------------------------
    call EndDrawing

    ; -----------------------------
    ; Vérification si la fenêtre doit se fermer
    ; -----------------------------
    call WindowShouldClose        ; retourne 1 si fermeture demandée
    test eax, eax
    jz mainLoop                  ; si 0, continuer la boucle principale

    ; -----------------------------
    ; Fermeture de la fenêtre et fin du programme
    ; -----------------------------
    call CloseWindow

    mov eax, 0                   ; code de retour 0
    leave                         ; restore rbp, rsp
    ret


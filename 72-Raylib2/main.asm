;nasm -f elf64 main.asm -o main.o
;gcc main.o -o main -lraylib -ldl -lm -lpthread -no-pie

global main

; Fonctions externes Raylib utilisées
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
    windowTitle db "Raylib x64 ASM Animation", 0  ; titre de la fenêtre
    circleRadius dd 20.0              ; rayon du cercle (float)
    circleSpeed dd 4.0                ; vitesse du cercle (float)
    screenWidth  equ 512               ; largeur de la fenêtre
    screenHeight equ 512               ; hauteur de la fenêtre

section .text

main:
    push rbp                            ; sauvegarder l'ancien frame pointer
    mov rbp, rsp                        ; établir un nouveau frame pointer

    ; -------------------------
    ; Initialiser la fenêtre
    ; -------------------------
    mov rdi, screenWidth                ; largeur
    mov rsi, screenHeight               ; hauteur
    lea rdx, [rel windowTitle]          ; adresse du titre
    call InitWindow                      ; appel à InitWindow(width, height, title)

    ; Définir le nombre de FPS cibles
    mov rdi, 60                          ; 60 FPS
    call SetTargetFPS

    ; -------------------------
    ; Position et direction initiales du cercle
    ; -------------------------
    mov eax, 50             ; position X initiale
    mov [posX], eax
    mov eax, 1              ; direction initiale (1 = droite, -1 = gauche)
    mov [dir], eax

mainLoop:
    ; -------------------------
    ; Début de la phase de dessin
    ; -------------------------
    call BeginDrawing

    ; Effacer l'écran avec la couleur noire (ARGB)
    mov edi, 0xff000000
    call ClearBackground

    ; Charger la position et la direction actuelles
    mov eax, [posX]         ; posX
    mov ecx, [dir]          ; direction

    ; Dessiner le cercle
    mov edi, eax            ; coordonnée X
    mov esi, 256            ; coordonnée Y (milieu de l'écran)
    movss xmm0, [rel circleRadius]   ; rayon (float dans xmm0)
    mov edx, 0xffff0000     ; couleur rouge ARGB
    call DrawCircle

    call EndDrawing         ; fin de la phase de dessin

    ; -------------------------
    ; Mise à jour de la position
    ; -------------------------
    mov eax, [posX]         ; charger posX
    mov ecx, [dir]          ; charger direction
    movss xmm0, [rel circleSpeed]   ; vitesse
    cvtss2si eax, xmm0      ; convertir float en int
    imul eax, ecx           ; appliquer la direction
    add eax, [posX]         ; nouvelle position
    mov [posX], eax         ; sauvegarder la nouvelle position

    ; -------------------------
    ; Détection des collisions avec les bords
    ; -------------------------
    cmp eax, 0              ; si posX <= 0
    jle .bounce
    cmp eax, screenWidth    ; si posX >= largeur écran
    jge .bounce
    jmp .checkClose

.bounce:
    ; Inverser la direction du cercle
    mov eax, [dir]
    neg eax
    mov [dir], eax

.checkClose:
    ; Vérifier si la fenêtre doit se fermer
    call WindowShouldClose
    test eax, eax           ; eax = 0 -> fenêtre ouverte
    jz mainLoop             ; tant que fenêtre ouverte, boucle

    ; -------------------------
    ; Fermeture propre de la fenêtre
    ; -------------------------
    call CloseWindow

    mov eax, 0
    leave
    ret

; -------------------------
; Variables temporaires
; -------------------------
section .bss
    posX resd 1             ; position X du cercle
    dir  resd 1             ; direction du cercle (1 ou -1)



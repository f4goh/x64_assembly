# Raylib en Assembleur NASM (x86-64)

Ce README explique comment utiliser **Raylib** en assembleur pour créer une fenêtre graphique et dessiner un cercle, basé sur un exemple fonctionnel en NASM.

---

## 1. Installation de Raylib

Installer les dépendances nécessaires pour Linux (Ubuntu/Debian) :

```bash
sudo apt update
sudo apt install libasound2-dev libx11-dev libxrandr-dev libxi-dev libgl1-mesa-dev libglu1-mesa-dev libxcursor-dev libxinerama-dev libwayland-dev libxkbcommon-dev
sudo apt install cmake
```

Cloner et compiler Raylib :

```bash
git clone https://github.com/raysan5/raylib.git raylib
cd raylib
mkdir build && cd build
cmake ..
make
sudo make install
sudo ldconfig
```

Compiler les exemples fournis par Raylib :

```bash
cd ../examples
cmake -DCUSTOMIZE_BUILD=ON -DBUILD_EXAMPLES=ON ..
make
```

Après cela, les librairies et headers sont installés dans `/usr/local/lib` et `/usr/local/include`.

---

## 2. Fonctions Raylib les plus courantes pour ASM

| Fonction            | Description |
| ------------------  | ----------- |
| `InitWindow(width, height, title)` | Crée une fenêtre graphique avec le titre spécifié. |
| `SetTargetFPS(fps)` | Définit le nombre d’images par seconde pour la boucle principale. |
| `BeginDrawing()`    | Commence le dessin pour une frame. |
| `ClearBackground(color)` | Efface l’écran avec la couleur donnée. |
| `DrawCircle(x, y, radius, color)` | Dessine un cercle à l’écran avec la couleur et le rayon spécifiés. |
| `EndDrawing()`      | Termine le dessin pour la frame. |
| `WindowShouldClose()` | Retourne vrai si l’utilisateur ferme la fenêtre. |
| `CloseWindow()`     | Ferme proprement la fenêtre et libère les ressources. |

---

## 3. Passage des paramètres en ASM (System V AMD64)

En assembleur Linux 64 bits, les **6 premiers arguments** d’une fonction C sont passés dans :

| Argument | Registre |
| -------- | -------- |
| 1er      | RDI      |
| 2e       | RSI      |
| 3e       | RDX      |
| 4e       | RCX      |
| 5e       | R8       |
| 6e       | R9       |

Pour les arguments flottants (`float`) ou `Color` en SSE, utiliser les registres `XMM0`, `XMM1`, etc.  
Toujours aligner la pile à 16 octets avant les appels (`sub rsp, 8` ou `sub rsp, 16`).

---

## 4. Exemple en ASM avec ton code fourni

```asm
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
```

---

## 5. Compilation et linkage

```bash
nasm -f elf64 main.asm -o main.o
gcc main.o -o main -lraylib -ldl -lm -lpthread
./main
```

- La fenêtre s’ouvre et dessine plusieurs cercles sur fond noir.  
- La boucle principale continue tant que l’utilisateur ne ferme pas la fenêtre.

---

## 6. Points importants

1. Toujours aligner la pile avant un `call` à 16 octets pour respecter l’ABI System V.  
2. Les fonctions qui prennent des `float` ou des structures (`Color`) utilisent `xmm` pour les floats.  
3. `WindowShouldClose` retourne `1` si la fenêtre a été fermée.  
4. `ClearBackground` et `DrawCircle` utilisent un `Color` codé sur 32 bits ARGB.  

---
# PIE (Position Independent Executable) en Linux

## Qu'est-ce que PIE ?

**PIE** signifie **Position Independent Executable**, c’est-à-dire un exécutable indépendant de son emplacement en mémoire. Contrairement aux exécutables classiques qui sont chargés à une adresse fixe, un exécutable PIE peut être chargé à n’importe quelle adresse mémoire à l’exécution.

### Avantages de PIE

- Sécurité renforcée : facilite l’ASLR (Address Space Layout Randomization), qui rend plus difficile l’exploitation des failles de type buffer overflow.
- Compatibilité moderne : la plupart des distributions Linux récentes compilent par défaut les exécutables en PIE.

### Inconvénients pour l’assembleur

- Les accès directs à des variables globales ou aux sections `.bss`/`.data` ne fonctionnent plus si on utilise les adresses absolues.
- Exemple non compatible PIE : `mov eax, [posX]  ; erreur en PIE`
- Exemple compatible PIE : `mov eax, [rel posX]  ; accès relatif à RIP, fonctionne avec PIE`

> En assembleur x86-64, `rel` indique que l’adresse de la variable doit être calculée par rapport au registre RIP, ce qui rend l’accès indépendant de l’endroit où l’exécutable est chargé.

## Comment compiler avec ou sans PIE

1. **Sans PIE** (ancienne méthode, simple pour l’ASM) :  
`nasm -f elf64 main.asm -o main.o`  
`gcc main.o -o main -lraylib -ldl -lm -lpthread -no-pie`  
- `-no-pie` désactive le PIE.  
- Toutes les références directes aux variables globales fonctionnent.

2. **Avec PIE** (méthode moderne et sécurisée) :  
- Ajouter `rel` pour toutes les variables globales : `mov eax, [rel posX] ; correct pour PIE` et `mov [rel posX], eax`  
- Lier normalement (sans `-no-pie`) :  
`gcc main.o -o main -lraylib -ldl -lm -lpthread`  
- Compatible avec les distributions modernes et l’ASLR activé.

## Résumé

| Option    | Avantages                             | Inconvénients                             |
|----------|--------------------------------------|-------------------------------------------|
| Sans PIE | Simple à coder en ASM, accès direct aux variables globales | Moins sécurisé, fixe en mémoire |
| Avec PIE | Plus sécurisé, compatible avec ASLR   | Doit utiliser `[rel var]` pour les variables globales |

> En assembleur moderne, il est recommandé d’utiliser `[rel ...]` pour toutes les variables globales si tu souhaites que ton programme soit compatible avec PIE et les systèmes Linux récents.


## Références

- [Raylib documentation](https://www.raylib.com/)  
- [Raylib GitHub](https://github.com/raysan5/raylib)


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
;gcc main.o -o main -lraylib -ldl -lm -lpthread

global main

extern InitWindow
extern SetTargetFPS
extern BeginDrawing
extern ClearBackground
extern DrawCircle
extern EndDrawing
extern WindowShouldClose
extern CloseWindow

section .note.GNU-stack                  ; pile non exécutable

section .data
    windowTitle db "Hello from Raylib & x64 Asm :)", 0
    circleRadius dd 15.0

section .text

main:
    push rbp
    mov rbp, rsp

    ; InitWindow(512, 512, windowTitle)
    mov rdi, 512
    mov rsi, 512
    lea rdx, [rel windowTitle]
    call InitWindow

    ; SetTargetFPS(60)
    mov rdi, 60
    call SetTargetFPS

mainLoop:

    call BeginDrawing

    ; ClearBackground(BLACK) -> couleur 0xff000000
    mov edi, 0xff000000
    call ClearBackground

    mov r15d, 448             ; position initiale du cercle en x

circleLoop:
    ; DrawCircle(x, y, radius, color)
    mov edi, r15d             ; x
    mov esi, 256              ; y
    movss xmm0, [rel circleRadius]
    mov edx, 0xff0080ff       ; couleur cercle
    call DrawCircle

    sub r15d, 64
    jnz circleLoop

    call EndDrawing

    call WindowShouldClose
    test eax, eax
    jz mainLoop

    call CloseWindow

    mov eax, 0
    leave
    ret
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

## Références

- [Raylib documentation](https://www.raylib.com/)  
- [Raylib GitHub](https://github.com/raysan5/raylib)


# X11 en Assembleur NASM (x86-64)

Ce README explique comment utiliser **X11** en assembleur à partir d’un exemple fonctionnel de dessin d’un rectangle et de gestion d’événements clavier.

---

## 1. Vérification et installation de X11

Pour compiler et lier un programme X11 en ASM, il faut les headers et la librairie de développement X11.

Vérifier que la librairie est installée :

ls /usr/include/X11/Xlib.h

Si elle n’existe pas, installer :

sudo apt update
sudo apt install libx11-dev

---

## 2. Fonctions X11 utiles

| Fonction              | Description                                                |
| --------------------- | ---------------------------------------------------------- |
| `XOpenDisplay`        | Ouvre la connexion au serveur X.                           |
| `XDefaultScreen`      | Retourne l’écran par défaut.                               |
| `XDefaultRootWindow`  | Retourne la fenêtre racine.                                |
| `XBlackPixel`         | Retourne la couleur noire par défaut.                      |
| `XWhitePixel`         | Retourne la couleur blanche par défaut.                    |
| `XCreateSimpleWindow` | Crée une fenêtre simple avec taille, position et couleurs. |
| `XMapWindow`          | Affiche la fenêtre sur l’écran.                            |
| `XCreateGC`           | Crée un Graphics Context pour le dessin.                   |
| `XSetForeground`      | Définit la couleur de dessin.                              |
| `XFillRectangle`      | Dessine un rectangle.                                      |
| `XFlush`              | Force l’affichage immédiat.                                |
| `XSelectInput`        | Définit les événements que la fenêtre va recevoir.         |
| `XNextEvent`          | Attend et récupère le prochain événement.                  |
| `XLookupKeysym`       | Traduit un événement clavier en KeySym.                    |
| `XCloseDisplay`       | Ferme proprement la connexion au serveur X.                |

---

## 3. Passage des paramètres en ASM (System V AMD64)

En assembleur x86-64 Linux, les 6 premiers arguments d’une fonction C sont passés dans ces registres :

| Argument | Registre |
| -------- | -------- |
| 1er      | RDI      |
| 2e       | RSI      |
| 3e       | RDX      |
| 4e       | RCX      |
| 5e       | R8       |
| 6e       | R9       |

Les arguments supplémentaires sont passés sur la pile. Pour les fonctions variadiques, EAX doit souvent être mis à zéro avant l’appel (ex: `printf`), mais ce n’est pas nécessaire pour X11.

### Exemple : création d’une fenêtre

; XCreateSimpleWindow(dpy, root, x, y, width, height, border_width, border_color, background_color)  
mov rdi, r12          ; dpy  
mov rsi, r14          ; root  
xor rdx, rdx          ; x = 0  
xor rcx, rcx          ; y = 0  
mov r8d, width        ; width  
mov r9d, height       ; height  

sub rsp, 32           ; arguments supplémentaires sur pile  
mov qword [rsp+24], 1     ; border width  
mov qword [rsp+16], r15   ; border color  
mov qword [rsp+8], r11    ; background color  
call XCreateSimpleWindow  
add rsp, 32  

### Exemple : gestion de la touche espace

; XLookupKeysym((XKeyEvent*)&xevent, 0)  
lea rdi, [rel xevent] ; adresse de XEvent  
xor rsi, rsi          ; index = 0  
call XLookupKeysym  

> Note : `XEvent` est une union, donc `XKeyEvent` commence à offset 0. Ne pas ajouter d’offset incorrect sinon segmentation fault.

---

## 4. Compilation et linkage

Commande typique pour assembler et lier le programme `main.asm` :

nasm -f elf64 main.asm -o main.o  
gcc -no-pie main.o -o main -lX11  

- `-f elf64` : format 64 bits pour Linux  
- `-no-pie` : désactive Position Independent Executable  
- `-lX11` : lie la librairie X11

---

## 5. Structure type d’un programme X11 en ASM

1. Ouvrir la connexion au serveur X : `XOpenDisplay`.  
2. Obtenir écran et fenêtre racine : `XDefaultScreen`, `XDefaultRootWindow`.  
3. Créer la fenêtre : `XCreateSimpleWindow`.  
4. Sélectionner les événements à traiter : `XSelectInput`.  
5. Créer le Graphics Context : `XCreateGC`.  
6. Définir couleur de dessin : `XSetForeground`.  
7. Boucle principale :  
   - `XNextEvent`  
   - Dessiner si `Expose`  
   - Quitter si touche spécifique détectée via `XLookupKeysym`  
8. Fermer proprement : `XCloseDisplay`.

---

## 6. Points importants

- Toujours **aligner la pile** avant un `call` (RSP % 16 = 0).  
- `XEvent` est une union, attention aux offsets.  
- Restaurer RSP avant `ret`.  
- Vérifier que `XOpenDisplay` ne retourne pas NULL.

---

## 7. Ressources

- [Xlib Programming Manual](https://tronche.com/gui/x/xlib/)  
- [X11 Documentation sur manpages](https://www.x.org/releases/current/doc/libX11/libX11/libX11.html)


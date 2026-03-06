# x64_assembly

[asm_tutorial](https://sonictk.github.io/asm_tutorial/)

# x86-64 Registers

![registers](./images/regs.png)


## General Purpose Registers (A, B, C, D)

```
 63                31            15        7        0
 +------------------+------------+--------+--------+
 |       RAX        |    EAX     |   AX   | AH | AL |
 +------------------+------------+--------+--------+

 +------------------+------------+--------+--------+
 |       RBX        |    EBX     |   BX   | BH | BL |
 +------------------+------------+--------+--------+

 +------------------+------------+--------+--------+
 |       RCX        |    ECX     |   CX   | CH | CL |
 +------------------+------------+--------+--------+

 +------------------+------------+--------+--------+
 |       RDX        |    EDX     |   DX   | DH | DL |
 +------------------+------------+--------+--------+
```

---

# 64-bit Mode Only Registers (R8–R15)

```
 63                31            15        7        0
 +------------------+------------+--------+--------+
 |        R8        |    R8D     |  R8W   |  R8B   |
 +------------------+------------+--------+--------+

 +------------------+------------+--------+--------+
 |        R9        |    R9D     |  R9W   |  R9B   |
 +------------------+------------+--------+--------+

 +------------------+------------+--------+--------+
 |       R10        |   R10D     | R10W   | R10B   |
 +------------------+------------+--------+--------+

 +------------------+------------+--------+--------+
 |       R11        |   R11D     | R11W   | R11B   |
 +------------------+------------+--------+--------+

 +------------------+------------+--------+--------+
 |       R12        |   R12D     | R12W   | R12B   |
 +------------------+------------+--------+--------+

 +------------------+------------+--------+--------+
 |       R13        |   R13D     | R13W   | R13B   |
 +------------------+------------+--------+--------+

 +------------------+------------+--------+--------+
 |       R14        |   R14D     | R14W   | R14B   |
 +------------------+------------+--------+--------+

 +------------------+------------+--------+--------+
 |       R15        |   R15D     | R15W   | R15B   |
 +------------------+------------+--------+--------+
```

---

# Special Purpose Registers

```
 +------------------+
 |       RIP        |  Instruction Pointer
 +------------------+

 +------------------+
 |       RSP        |  Stack Pointer
 +------------------+

 +------------------+
 |       RBP        |  Base Pointer
 +------------------+

 +------------------+
 |       RSI        |  Source Index
 +------------------+

 +------------------+
 |       RDI        |  Destination Index
 +------------------+
```

---

# RFLAGS Register

```
 63                                                   0
 +-----------------------------------------------------+
 |                     RFLAGS                          |
 +-----------------------------------------------------+

 Important Flags

 CF  Carry Flag
 PF  Parity Flag
 AF  Auxiliary Carry Flag
 ZF  Zero Flag
 SF  Sign Flag
 TF  Trap Flag
 IF  Interrupt Enable Flag
 DF  Direction Flag
 OF  Overflow Flag
```

---

# Register Summary Table

| Register | Purpose |
|--------|--------|
| RAX | Accumulator (math, return values) |
| RBX | Base register |
| RCX | Counter (loops, shifts) |
| RDX | Data register |
| RSI | Source index (string ops) |
| RDI | Destination index |
| RBP | Base pointer (stack frame) |
| RSP | Stack pointer |
| RIP | Instruction pointer |
| R8–R15 | Additional general registers (64-bit mode) |


---

# Stack Layout Example

```
High Address
+-------------------+
| Function args     |
+-------------------+
| Return Address    |
+-------------------+
| Old RBP           |
+-------------------+
| Local Variables   |
+-------------------+
Low Address
```

---

# Quick Notes

- Writing to a **32-bit register (EAX)** clears the upper 32 bits of **RAX**.
- Stack grows **downwards** in memory.
- `RIP` cannot be accessed directly like general registers.
- `RFLAGS` stores CPU status flags used by conditional jumps.

# Compiler et exécuter `main.asm` avec NASM et un Makefile

Ce projet utilise **NASM** pour assembler le code et **ld** pour créer l'exécutable.

Le fichier `Makefile` fourni automatise ces étapes.

---

# 1. Prérequis

Vous devez avoir installés :

- **nasm** (assembleur)
- **ld** (linker GNU, généralement fourni avec `binutils`)
- **make**

### Vérifier l'installation

```bash
nasm -v
ld -v
make -v
```

Si une commande n'existe pas :

### Ubuntu / Debian

```bash
sudo apt install nasm build-essential
```

### Arch Linux

```bash
sudo pacman -S nasm base-devel
```

### Fedora

```bash
sudo dnf install nasm make gcc
```

---

# 2. Structure du projet

Exemple de dossier :

```
project/
│
├── main.asm
└── Makefile
```

---

# 3. Contenu du Makefile

```make
ASM = nasm
ASMFLAGS = -f elf64 -g -F dwarf

LD = ld
LDFLAGS = 

all: main

main: main.o
	$(LD) -o main main.o $(LDFLAGS)

main.o: main.asm
	$(ASM) $(ASMFLAGS) main.asm -o main.o

clean:
	rm -f *.o main
```

---

# 4. Explication du Makefile

## Assembleur

```
ASM = nasm
```

Utilise **NASM** comme assembleur.

---

## Flags d'assemblage

```
ASMFLAGS = -f elf64 -g -F dwarf
```

Signification :

| Option | Description |
|------|------|
| `-f elf64` | génère un objet ELF 64-bit pour Linux |
| `-g` | ajoute les symboles de debug |
| `-F dwarf` | format de debug utilisé par gdb |

---

## Linker

```
LD = ld
```

Utilise **ld** pour créer l'exécutable.

---

## Règle par défaut

```
all: main
```

Quand on exécute :

```bash
make
```

`make` construit la cible **main**.

---

## Création de l'exécutable

```
main: main.o
	$(LD) -o main main.o $(LDFLAGS)
```

Cette règle signifie :

1. si `main.o` existe
2. alors `ld` crée l'exécutable `main`

Commande réelle exécutée :

```bash
ld -o main main.o
```

---

## Assemblage

```
main.o: main.asm
	$(ASM) $(ASMFLAGS) main.asm -o main.o
```

Si `main.asm` change :

```
nasm -f elf64 -g -F dwarf main.asm -o main.o
```

Cela produit :

```
main.o
```

qui est un **fichier objet ELF64**.

---

## Nettoyage

```
clean:
	rm -f *.o main
```

Commande :

```bash
make clean
```

supprime :

```
main.o
main
```

---

# 5. Compilation

Dans le dossier contenant `Makefile` et `main.asm` :

```bash
make
```

Étapes exécutées :

```
nasm -f elf64 -g -F dwarf main.asm -o main.o
ld -o main main.o
```

Résultat :

```
main
```

qui est l'exécutable.

---

# 6. Vérifier que le programme est exécutable

```bash
ls -l main
```

Exemple :

```
-rwxr-xr-x 1 user user 9000 main
```

Le `x` indique que le fichier est **exécutable**.

Si nécessaire :

```bash
chmod +x main
```

---

# 7. Exécuter le programme

```bash
./main
```

Le `./` indique au shell d'exécuter le fichier dans le dossier courant.

---

# 8. Exemple minimal de `main.asm`

```asm
section .data
msg db "Hello x86-64", 10
len equ $ - msg

section .text
global _start

_start:

    mov rax, 1
    mov rdi, 1
    mov rsi, msg
    mov rdx, len
    syscall

    mov rax, 60
    xor rdi, rdi
    syscall
```

---

# 9. Cycle de développement

### Compiler

```bash
make
```

### Exécuter

```bash
./main
```

### Nettoyer

```bash
make clean
```

---

# 10. Résumé

| Commande | Action |
|------|------|
| `make` | compile le programme |
| `./main` | exécute le programme |
| `make clean` | supprime les fichiers générés |

---

# 11. Schéma du processus

```
main.asm
   │
   │ nasm
   ▼
main.o
   │
   │ ld
   ▼
main (exécutable)
   │
   ▼
./main
```

---

# Minimal Assembly Example

```bash
ale@ale-desktop:~/asm_linux/x64_assembly/52-hello$ ./main 
Hello world!
ale@ale-desktop:~/asm_linux/x64_assembly/52-hello$ 

```


# NASM — Déclarations de variables

## Section .data (variables initialisées)

| Directive | Taille | Description |
|------------|--------|-------------|
| db | 1 octet  | define byte |
| dw | 2 octets | define word |
| dd | 4 octets | define double word |
| dq | 8 octets | define quad word |
| dt | 10 octets | define ten bytes (float étendu x87) |

### Exemples

var8    db  10
str     db  'abc', 0

var16   dw  1000
var32   dd  100000
var64   dq  10000000000

tab8    db  1,2,3,4,5
tab32   dd  10,20,30


---

## Section .bss (variables non initialisées)

| Directive | Réserve |
|------------|----------|
| resb | bytes |
| resw | words (2 bytes) |
| resd | dwords (4 bytes) |
| resq | qwords (8 bytes) |
| rest | 10 bytes |

### Exemples

buf8    resb 16
buf16   resw 8
buf32   resd 4
buf64   resq 2


---

## Correspondance avec registres

| Taille | Registre 8/16/32/64 bits |
|----------|--------------------------|
| 8 bits   | AL |
| 16 bits  | AX |
| 32 bits  | EAX |
| 64 bits  | RAX |

---

## Particularités de `mov` sur variables

Quand on écrit dans une adresse mémoire, NASM **ne déduit pas la taille automatiquement**. 

### Exemples d’écriture en mémoire

mov byte [match], 1       ; écrit 1 octet (8 bits) à l'adresse de match 
mov word [match], 123     ; écrit 2 octets (16 bits) 
mov dword [match], 100000 ; écrit 4 octets (32 bits) 
mov qword [match], 10000000000 ; écrit 8 octets (64 bits) 

- La taille doit toujours être précisée (`byte`, `word`, `dword`, `qword`) pour éviter l'erreur : 
  operation size not specified 

### Exemples de lecture mémoire selon le registre

mov al, [match]   ; AL = 8 bits → NASM sait qu'on lit 1 octet 
mov ax, [match]   ; AX = 16 bits → NASM sait qu'on lit 2 octets 
mov eax, [match]  ; EAX = 32 bits → NASM sait qu'on lit 4 octets 
mov rax, [match]  ; RAX = 64 bits → NASM sait qu'on lit 8 octets 

### Exemples d’écriture dans un registre (taille implicite)

mov al, 100       ; AL = 8 bits 
mov ax, 100       ; AX = 16 bits 
mov eax, 100      ; EAX = 32 bits 
mov rax, 100      ; RAX = 64 bits 

---

# Calling Convention (System V - Linux/macOS)

First arguments passed in registers:

| Argument | Register |
|--------|--------|
| 1 | RDI |
| 2 | RSI |
| 3 | RDX |
| 4 | RCX |
| 5 | R8 |
| 6 | R9 |

Return value:

```
RAX

```
# Installer EDB Debugger sous Linux Mint

**EDB (Evan's Debugger)** est un débogueur graphique pour Linux similaire à **OllyDbg** sous Windows.  
Il est très utilisé pour analyser des programmes **x86 / x86-64**.

Site officiel :  
https://github.com/eteran/edb-debugger

Ce guide explique comment l’installer sous **Linux Mint**.

---

# 1. Installation via APT (méthode la plus simple)

Sous Linux Mint, `edb-debugger` est souvent disponible directement dans les dépôts.

Mettre à jour les paquets :

```bash
sudo apt update
```

Installer EDB :

```bash
sudo apt install edb-debugger
```

---

# 2. Vérifier l'installation

Vérifier que le programme est installé :

```bash
edb --version
```

ou lancer directement :

```bash
edb
```

---

# 3. Lancer EDB

Vous pouvez lancer EDB de deux façons.

### Depuis le terminal

```bash
edb
```

### Depuis le menu graphique

Menu :

```
Menu → Programming → EDB Debugger
```

---

# 4. Déboguer un programme

Exemple avec un programme compilé :

```bash
./main
```

Pour le déboguer :

```bash
edb ./main
```

Ou ouvrir le programme depuis l'interface :

```
File → Open → sélectionner l'exécutable
```

---

![edb](./images/edb.gif)

# 5. Installer les outils utiles pour le debugging

Pour un environnement complet :

```bash
sudo apt install build-essential nasm gdb
```

Cela installe :

| Outil | Utilité |
|------|------|
| gcc | compilation C |
| make | automatisation build |
| nasm | assembleur |
| gdb | debugger CLI |

---

# 6. Installation manuelle depuis GitHub (si non disponible)

Si `edb-debugger` n'est pas dans les dépôts :

Installer les dépendances :

```bash
sudo apt install git cmake build-essential qtbase5-dev libqt5svg5-dev
```

Cloner le projet :

```bash
git clone https://github.com/eteran/edb-debugger.git
```

Entrer dans le dossier :

```bash
cd edb-debugger
```

Créer un dossier de build :

```bash
mkdir build
cd build
```

Compiler :

```bash
cmake ..
make
```

Installer :

```bash
sudo make install
```

---

# 7. Vérifier que le debugger fonctionne

Lancer :

```bash
edb
```

Si l'interface graphique apparaît, l'installation est réussie.

---

# 8. Désinstallation

Si installé via apt :

```bash
sudo apt remove edb-debugger
```

Pour supprimer aussi la configuration :

```bash
sudo apt purge edb-debugger
```

---

# 9. Vérifier l'architecture du programme

EDB fonctionne avec les binaires **ELF x86 et x86-64**.

Pour vérifier un programme :

```bash
file main
```

Exemple :

```
main: ELF 64-bit LSB executable, x86-64
```

---

# 10. Exemple de workflow complet

Compiler un programme assembleur :

```bash
make
```

Lancer le debugger :

```bash
edb ./main
```

Déboguer :

```
F7 → Step Into
F8 → Step Over
F9 → Run
```

---

# 11. Commandes utiles

| Commande | Description |
|------|------|
| edb | lancer le debugger |
| edb ./programme | déboguer un programme |
| file programme | vérifier le type ELF |
| make | compiler le programme |

---

# 12. Résumé

Installation rapide :

```bash
sudo apt update
sudo apt install edb-debugger
edb
```

EDB est maintenant prêt pour analyser et déboguer vos programmes **x86 / x86-64**.


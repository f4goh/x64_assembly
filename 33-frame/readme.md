# Comprendre RSP et RBP dans la fonction `total`

## 1️⃣ RSP vs RBP

| Registre | Nom complet | Rôle principal |
|----------|------------|----------------|
| **RSP** | Stack Pointer | Pointe toujours sur le sommet de la pile. Change à chaque push/pop ou add/sub sur la pile. |
| **RBP** | Base Pointer (frame pointer) | Sert de référence fixe pour la pile d’une fonction. Permet d’accéder facilement aux arguments et variables locales. |

**Principe :**
- La pile croît vers le bas (vers des adresses plus petites). 
- RSP = sommet actuel → varie tout le temps. 
- RBP = base de la frame → constante pendant l’exécution de la fonction. 

---

## 2️⃣ Comment `total` utilise RSP et RBP

Code :

push rbp 
mov rbp, rsp 
sub rsp,16 

**Décomposition :**

1. `push rbp` → sauvegarde l’ancien RBP sur la pile 
2. `mov rbp, rsp` → RBP devient le nouveau repère pour cette fonction 
3. `sub rsp,16` → réserve 16 octets pour les variables locales 
   - `[rbp-8]` et `[rbp-16]` sont ces variables locales 
   - `[rbp+16]` correspond à l’argument passé via la pile (`push 100`) 

---

### Visualisation de la pile pendant `total`

Adresse ↑ 
+-----------------+ <- RBP + 16 → argument 100 
|      100        | 
+-----------------+ 
| return address  | <- RBP + 8 
+-----------------+ 
| old RBP         | <- RBP 
+-----------------+ 
| var locale 1    | <- RBP - 8 
+-----------------+ 
| var locale 2    | <- RBP -16 
+-----------------+ <- RSP après sub rsp,16 
Adresse ↓ 

- `[rbp+16]` → argument de la fonction 
- `[rbp-8]` et `[rbp-16]` → variables locales 

---

## 3️⃣ Pourquoi `add rsp,8` après le `call` ?

- `_start` fait `push 100` → pile augmentée de 8 octets 
- `call total` empile l’adresse de retour → RSP diminue encore 
- Après `ret` dans `total`, la pile contient encore cet argument 
- `add rsp,8` → supprime l’argument restant de la pile 

> Alternative : utiliser `pop rcx` pour dépiler l’argument si on veut récupérer sa valeur.

---

## 4️⃣ Récapitulatif du flux `total`

1. `_start` pousse l’argument → RSP diminue 
2. `call total` → empile l’adresse de retour → RSP diminue 
3. Dans `total` : 
   - `push rbp` → sauvegarde ancien RBP 
   - `mov rbp,rsp` → RBP = base frame 
   - `sub rsp,16` → réserve espace local 
4. Calcul sur les variables locales `[rbp-8]` et `[rbp-16]` 
5. `mov rsp,rbp` + `pop rbp` → restaure pile 
6. `ret` → retourne à `_start` 
7. `add rsp,8` → supprime l’argument restant 

---

💡 Astuce moderne : 
En Linux x86-64, les 6 premiers arguments sont passés par registres (`RDI, RSI, RDX, RCX, R8, R9`) → plus besoin de `push`/`add rsp` pour la majorité des fonctions.

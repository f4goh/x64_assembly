# Tableau des instructions SIMD entières avec saturation

| Instruction | Type données | Taille | Signé / Non-signé | Description | Effet sur registre XMM |
|------------|--------------|--------|-----------------|------------|-----------------------|
| paddusb    | byte         | 8-bit  | Non-signé       | Addition saturée de bytes non-signés | xmm = min(xmm + src, 255) |
| psubusb    | byte         | 8-bit  | Non-signé       | Soustraction saturée de bytes non-signés | xmm = max(xmm - src, 0) |
| paddsb     | byte         | 8-bit  | Signé           | Addition saturée de bytes signés | xmm = saturate(xmm + src, -128..127) |
| psubsb     | byte         | 8-bit  | Signé           | Soustraction saturée de bytes signés | xmm = saturate(xmm - src, -128..127) |

| paddusw    | word         | 16-bit | Non-signé       | Addition saturée de mots non-signés | xmm = min(xmm + src, 65535) |
| psubusw    | word         | 16-bit | Non-signé       | Soustraction saturée de mots non-signés | xmm = max(xmm - src, 0) |
| paddsw     | word         | 16-bit | Signé           | Addition saturée de mots signés | xmm = saturate(xmm + src, -32768..32767) |
| psubsw     | word         | 16-bit | Signé           | Soustraction saturée de mots signés | xmm = saturate(xmm - src, -32768..32767) |

| paddusd    | dword        | 32-bit | Non-signé       | Addition saturée de double words non-signés | xmm = min(xmm + src, 2^32-1) |
| psubusd    | dword        | 32-bit | Non-signé       | Soustraction saturée de double words non-signés | xmm = max(xmm - src, 0) |
| paddsd     | dword        | 32-bit | Signé           | Addition saturée de double words signés | xmm = saturate(xmm + src, -2^31..2^31-1) |
| psubsd     | dword        | 32-bit | Signé           | Soustraction saturée de double words signés | xmm = saturate(xmm - src, -2^31..2^31-1) |

| paddusq    | qword        | 64-bit | Non-signé       | Addition saturée de quad words non-signés | xmm = min(xmm + src, 2^64-1) |
| psubusq    | qword        | 64-bit | Non-signé       | Soustraction saturée de quad words non-signés | xmm = max(xmm - src, 0) |
| paddsq     | qword        | 64-bit | Signé           | Addition saturée de quad words signés | xmm = saturate(xmm + src, -2^63..2^63-1) |
| psubsq     | qword        | 64-bit | Signé           | Soustraction saturée de quad words signés | xmm = saturate(xmm - src, -2^63..2^63-1) |

---

# Notes importantes

- Toutes ces instructions utilisent **la saturation** pour éviter le débordement.  
- `padd` / `psub` classique ne saturent pas et peuvent provoquer un wrap-around.  
- `u` dans le nom (`paddusb`, `paddusw`) signifie **unsigned** (non-signé).  
- Ces instructions sont très utiles pour **le traitement d’images, audio ou tout vecteur d’entiers avec limites fixes**.  
- Elles fonctionnent sur tous les éléments du registre XMM en **parallèle SIMD**.  

# Addition saturée (Saturated Addition)

## Définition

Une **addition saturée** est une opération arithmétique où le résultat est limité à une **valeur maximale ou minimale fixe** en cas de dépassement (overflow) ou de sous-dépassement (underflow).

- Contrairement à l'addition normale, qui peut "déborder" et revenir à zéro ou produire un wrap-around, l’addition saturée **clamp** le résultat à la valeur maximale ou minimale autorisée par le type de donnée.

---

## Exemple 1 : Bytes non-signés (0 à 255)

```
x = 200
y = 100
résultat normal : 200 + 100 = 44  (overflow 8-bit)
résultat saturé : min(200 + 100, 255) = 255
```

---

## Exemple 2 : Bytes signés (-128 à 127)

```
x = 100
y = 50
résultat normal : 100 + 50 = -106 (overflow 8-bit)
résultat saturé : saturate(100 + 50, -128..127) = 127
```

---

## Utilité

- Très utilisé en **traitement d’images** (valeurs de pixels limitées entre 0 et 255) 
- Utile en **audio ou signaux** pour éviter le wrap-around et les distorsions 
- Permet des calculs SIMD sûrs sur plusieurs éléments en parallèle sans débordement

---

## Instructions SIMD qui utilisent la saturation

- `paddsb` / `psubsb` : addition / soustraction de bytes signés saturés 
- `paddusb` / `psubusb` : bytes non-signés 
- `paddsw` / `psubsw` : mots signés saturés 
- `paddusw` / `psubusw` : mots non-signés 
- et de même pour `dword` et `qword` avec les extensions AVX2



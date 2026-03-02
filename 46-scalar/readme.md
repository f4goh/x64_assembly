
# Tableau des instructions SSE/AVX scalar (float/double)

| Instruction | Type données | Taille | Description | Effet sur registre XMM |
|------------|--------------|--------|------------|-----------------------|
| movss      | float        | 32-bit | Move scalar single-precision float | Charge 1 float depuis mémoire ou registre dans xmm[0] |
| movsd      | double       | 64-bit | Move scalar double-precision float | Charge 1 double depuis mémoire ou registre dans xmm[0] |
| addss      | float        | 32-bit | Add scalar single-precision float | xmm[0] = xmm[0] + src[0] |
| addsd      | double       | 64-bit | Add scalar double-precision float | xmm[0] = xmm[0] + src[0] |
| subss      | float        | 32-bit | Subtract scalar single-precision float | xmm[0] = xmm[0] - src[0] |
| subsd      | double       | 64-bit | Subtract scalar double-precision float | xmm[0] = xmm[0] - src[0] |
| mulss      | float        | 32-bit | Multiply scalar single-precision float | xmm[0] = xmm[0] * src[0] |
| mulsd      | double       | 64-bit | Multiply scalar double-precision float | xmm[0] = xmm[0] * src[0] |
| divss      | float        | 32-bit | Divide scalar single-precision float | xmm[0] = xmm[0] / src[0] |
| divsd      | double       | 64-bit | Divide scalar double-precision float | xmm[0] = xmm[0] / src[0] |

---

# Notes importantes

- Toutes ces instructions agissent **seulement sur le premier élément** du registre XMM (`xmm[0]`). 
- Les autres éléments du registre XMM restent inchangés. 
- Les instructions `movss`/`movsd` peuvent charger depuis la mémoire ou un autre registre. 
- Les instructions `add`, `sub`, `mul`, `div` existent aussi en versions **packed** (`addps`, `addpd`) pour traiter plusieurs éléments en parallèle. 
- L’alignement mémoire n’est pas strict pour scalar (`movss`/`movsd`), mais il est conseillé d’aligner sur 16 octets pour des raisons de performance. 


# Tableau des instructions SSE SIMD / Scalar

| Instruction | Type données | Scalar / Packed | Taille | Description | Effet sur registre XMM |
|------------|--------------|----------------|--------|------------|-----------------------|
| minss      | float        | Scalar         | 32-bit | Minimum entre deux floats scalaires | xmm0[0] = min(xmm0[0], src[0]) ; les autres éléments restent inchangés |
| minps      | float        | Packed         | 128-bit | Minimum élément par élément de 4 floats | xmm0[i] = min(xmm0[i], src[i]) pour i = 0..3 |
| minpd      | double       | Packed         | 128-bit | Minimum élément par élément de 2 doubles | xmm0[i] = min(xmm0[i], src[i]) pour i = 0..1 |
| maxss      | float        | Scalar         | 32-bit | Maximum entre deux floats scalaires | xmm0[0] = max(xmm0[0], src[0]) ; les autres restent inchangés |
| maxps      | float        | Packed         | 128-bit | Maximum élément par élément de 4 floats | xmm0[i] = max(xmm0[i], src[i]) pour i = 0..3 |
| maxpd      | double       | Packed         | 128-bit | Maximum élément par élément de 2 doubles | xmm0[i] = max(xmm0[i], src[i]) pour i = 0..1 |
| roundss    | float        | Scalar         | 32-bit | Arrondi du float scalaire selon un mode | xmm0[0] = round(xmm0[0]) ; autres inchangés |
| roundps    | float        | Packed         | 128-bit | Arrondi élément par élément de 4 floats | xmm0[i] = round(xmm0[i]) pour i = 0..3 |
| roundpd    | double       | Packed         | 128-bit | Arrondi élément par élément de 2 doubles | xmm0[i] = round(xmm0[i]) pour i = 0..1 |
| pavgb      | byte         | Packed         | 128-bit | Moyenne arrondie de bytes non-signés | xmm0[i] = floor((xmm0[i] + src[i] + 1) / 2) pour i = 0..15 |
| pavgw      | word         | Packed         | 128-bit | Moyenne arrondie de mots non-signés | xmm0[i] = floor((xmm0[i] + src[i] + 1) / 2) pour i = 0..7 |

---

# Notes importantes

- **Scalar** → seule la première valeur du registre XMM est affectée. 
- **Packed** → toutes les valeurs du registre sont affectées en SIMD (parallèle). 
- `min` / `max` → utile pour sélection du plus petit / plus grand élément. 
- `round` → arrondit selon le mode défini par l’instruction (nearest, down, up, trunc). 
- `pavgb` / `pavgw` → moyennes entières arrondies, très utilisées en **traitement d’images** ou **pixels**. 
- Toutes ces instructions sont SIMD-friendly et travaillent sur tous les éléments simultanément pour le packed.


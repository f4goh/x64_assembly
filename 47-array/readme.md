# Tableau des instructions SSE/AVX vectorielles (packed float/double)

| Instruction | Type données | Taille | Description | Effet sur registre XMM |
|------------|--------------|--------|------------|-----------------------|
| movaps     | float        | 128-bit | Move aligned packed single-precision float | Charge 4 floats depuis mémoire ou registre dans xmm |
| movapd     | double       | 128-bit | Move aligned packed double-precision float | Charge 2 doubles depuis mémoire ou registre dans xmm |
| addps      | float        | 128-bit | Add packed single-precision float | Addition élément par élément : xmm = xmm + src |
| addpd      | double       | 128-bit | Add packed double-precision float | Addition élément par élément : xmm = xmm + src |
| subps      | float        | 128-bit | Subtract packed single-precision float | Soustraction élément par élément : xmm = xmm - src |
| subpd      | double       | 128-bit | Subtract packed double-precision float | Soustraction élément par élément : xmm = xmm - src |
| mulps      | float        | 128-bit | Multiply packed single-precision float | Multiplication élément par élément : xmm = xmm * src |
| mulpd      | double       | 128-bit | Multiply packed double-precision float | Multiplication élément par élément : xmm = xmm * src |
| divps      | float        | 128-bit | Divide packed single-precision float | Division élément par élément : xmm = xmm / src |
| divpd      | double       | 128-bit | Divide packed double-precision float | Division élément par élément : xmm = xmm / src |

---

# Notes importantes

- Ces instructions traitent **tous les éléments du registre XMM en parallèle** (4 floats ou 2 doubles). 
- Les instructions `movaps` / `movapd` exigent que la mémoire soit **alignée sur 16 octets**. 
- Pour les données non alignées, utiliser `movups` / `movupd`. 
- Les versions scalar (`addss` / `addsd`) ne touchent qu’un seul élément (le premier). 
- Ces instructions sont la base du **SIMD** pour le calcul vectoriel en flottant. 

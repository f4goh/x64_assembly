# Topo des instructions FMA (AVX/AVX2/AVX-512)

| Instruction        | Type de données        | Effet / Formule élémentaire (SIMD ou scalar)                     | Remarques |
|-------------------|----------------------|-----------------------------------------------------------------|-----------|
| vfmadd132ss        | Scalar float 32-bit  | xmm0 = xmm1 * xmm2 + xmm0                                        | Premier float modifié, les autres restent inchangés |
| vfmadd132sd        | Scalar float 64-bit  | xmm0 = xmm1 * xmm2 + xmm0                                        | Premier double modifié |
| vfmadd132ps        | Packed float 32-bit  | xmm0[i] = xmm1[i] * xmm2[i] + xmm0[i] pour i=0..3                | SIMD 4 floats |
| vfmadd132pd        | Packed float 64-bit  | xmm0[i] = xmm1[i] * xmm2[i] + xmm0[i] pour i=0..1                | SIMD 2 doubles |

| vfmadd213ss        | Scalar float 32-bit  | xmm0 = xmm0 * xmm1 + xmm2                                        | Premier float modifié |
| vfmadd213sd        | Scalar float 64-bit  | xmm0 = xmm0 * xmm1 + xmm2                                        | Premier double modifié |
| vfmadd213ps        | Packed float 32-bit  | xmm0[i] = xmm0[i] * xmm1[i] + xmm2[i] pour i=0..3                | SIMD 4 floats |
| vfmadd213pd        | Packed float 64-bit  | xmm0[i] = xmm0[i] * xmm1[i] + xmm2[i] pour i=0..1                | SIMD 2 doubles |

| vfmadd231ss        | Scalar float 32-bit  | xmm0 = xmm1 * xmm2 + xmm0                                        | Premier float modifié |
| vfmadd231sd        | Scalar float 64-bit  | xmm0 = xmm1 * xmm2 + xmm0                                        | Premier double modifié |
| vfmadd231ps        | Packed float 32-bit  | xmm0[i] = xmm1[i] * xmm2[i] + xmm0[i] pour i=0..3                | SIMD 4 floats |
| vfmadd231pd        | Packed float 64-bit  | xmm0[i] = xmm1[i] * xmm2[i] + xmm0[i] pour i=0..1                | SIMD 2 doubles |

**Remarques générales :**
- Les instructions FMA effectuent toujours `mul + add` en un seul cycle, ce qui réduit les erreurs d’arrondi.
- XYZ dans `vfmaddXYZ` indique la permutation des opérandes pour le calcul `a*b + c`.
- `ss` et `sd` = scalar (1 élément), `ps` et `pd` = packed/SIMD (4 floats ou 2 doubles pour XMM).



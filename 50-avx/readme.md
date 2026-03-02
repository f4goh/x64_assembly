# Tableau des instructions AVX SIMD (float / double)

| Instruction | Type données | Scalar / Packed | Taille | Description | Effet sur registre YMM/ZMM |
|------------|--------------|----------------|--------|------------|---------------------------|
| vmovps     | float        | Packed         | 128/256-bit | Move packed single-precision float | Charge ou stocke 4/8 floats dans un registre YMM/XMM |
| vaddps     | float        | Packed         | 128/256-bit | Addition élément par élément | ymm0[i] = ymm0[i] + src[i] pour i = 0..3/7 |
| vaddpd     | double       | Packed         | 128/256-bit | Addition élément par élément | ymm0[i] = ymm0[i] + src[i] pour i = 0..1/3 |
| vsubps     | float        | Packed         | 128/256-bit | Soustraction élément par élément | ymm0[i] = ymm0[i] - src[i] |
| vsubpd     | double       | Packed         | 128/256-bit | Soustraction élément par élément | ymm0[i] = ymm0[i] - src[i] |
| vmulps     | float        | Packed         | 128/256-bit | Multiplication élément par élément | ymm0[i] = ymm0[i] * src[i] |
| vmulpd     | double       | Packed         | 128/256-bit | Multiplication élément par élément | ymm0[i] = ymm0[i] * src[i] |
| vdivps     | float        | Packed         | 128/256-bit | Division élément par élément | ymm0[i] = ymm0[i] / src[i] |
| vdivpd     | double       | Packed         | 128/256-bit | Division élément par élément | ymm0[i] = ymm0[i] / src[i] |

---

# Notes importantes

- Les instructions **VMOV, VADD, VSUB, VMUL, VDIV** sont la version AVX des instructions SSE pour floats/doubles. 
- **vmovps** peut charger ou stocker des **XMM (128-bit) ou YMM (256-bit)**. 
- `vaddps` / `vsubps` / `vmulps` / `vdivps` → opèrent sur **float 32-bit** en SIMD. 
- `vaddpd` / `vsubpd` / `vmulpd` / `vdivpd` → opèrent sur **double 64-bit** en SIMD. 
- AVX permet **256-bit** (YMM) pour traiter 8 floats ou 4 doubles en parallèle, tandis que SSE est limité à 128-bit. 
- Les registres **ZMM (AVX-512)** étendent encore ces opérations à 512-bit. 

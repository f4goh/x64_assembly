| Saut | Nom                            | Condition pour que le saut soit effectué |
|------|--------------------------------|-------------------------------------------|
| jz   | Jump if Zero (saut si zéro)    | ZR = 1 (résultat précédent égal à zéro)   |
| jnz  | Jump if Not Zero               | ZR = 0 (résultat précédent ≠ zéro)        |
| jc   | Jump if Carry                  | CY = 1 (retenue / emprunt)                |
| jnc  | Jump if Not Carry              | CY = 0 (pas de retenue)                   |
| jo   | Jump if Overflow               | OV = 1 (dépassement signé)                |
| jno  | Jump if Not Overflow           | OV = 0 (pas de dépassement signé)         |
| js   | Jump if Sign                   | PL = 1 (bit de signe = 1 → négatif)       |
| jns  | Jump if Not Sign               | PL = 0 (bit de signe = 0 → positif)       |


| Saut | Nom du saut (français)                 | Condition (flag et état) pour que le saut soit effectué |
|------|-----------------------------------------|----------------------------------------------------------|
| jg   | Jump if Greater (strictement >)         | ZR = 0 **et** PL = OV                                    |
| jnle | Jump if Not Less or Equal               | ZR = 0 **et** PL = OV (identique à JG)                   |
| jge  | Jump if Greater or Equal (≥)            | PL = OV                                                  |
| jnl  | Jump if Not Less                        | PL = OV (identique à JGE)                                |
| jl   | Jump if Less (<)                        | PL ≠ OV                                                  |
| jnge | Jump if Not Greater or Equal            | PL ≠ OV (identique à JL)                                 |
| jle  | Jump if Less or Equal (≤)               | ZR = 1 **ou** PL ≠ OV                                    |
| jng  | Jump if Not Greater                     | ZR = 1 **ou** PL ≠ OV (identique à JLE)                  |


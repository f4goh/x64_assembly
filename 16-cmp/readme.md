| Saut | Nom du saut (français)                 | Condition (flag et état) pour que le saut soit effectué |
|------|-----------------------------------------|----------------------------------------------------------|
| je   | Jump if Equal (saut si égal)            | ZR = 1 (résultat précédent égal à zéro)                  |
| jne  | Jump if Not Equal                        | ZR = 0 (résultat ≠ zéro)                                 |
| ja   | Jump if Above (non signé)                | CY = 0 **et** ZR = 0                                     |
| jnbe | Jump if Not Below or Equal (non signé)   | CY = 0 **et** ZR = 0 (identique à JA)                    |
| jae  | Jump if Above or Equal (non signé)       | CY = 0                                                   |
| jnb  | Jump if Not Below (non signé)            | CY = 0 (identique à JAE)                                 |
| jb   | Jump if Below (non signé)                | CY = 1                                                   |
| jnae | Jump if Not Above or Equal (non signé)   | CY = 1 (identique à JB)                                  |
| jbe  | Jump if Below or Equal (non signé)       | CY = 1 **ou** ZR = 1                                     |
| jna  | Jump if Not Above (non signé)            | CY = 1 **ou** ZR = 1 (identique à JBE)                   |


# AION-Roblox Implementation Bridge 🌀🌉🎮

Este documento formaliza como transformar a Arqueologia Digital do **AION** em realidade no **Roblox Studio**.

## 1. Fluxo de Dados (Data Flow)
1. **AION/EZ-Studios**: Gera o arquivo `genesis_map_seed.json` (o DNA Digital).
2. **Roblox Bridge**: O script `RobloxMapaModule.lua` lê este JSON.
3. **NEO-ARK**: O mundo é construído peça por peça no servidor Roblox.

---

## 2. Como Importar as Sementes (Seeds)
Para levar o DNA escavado para o jogo:
- Copie o conteúdo de `ez-studios-core/content/seeds/genesis_map_seed.json`.
- No Roblox Studio, crie um **ModuleScript** chamado `WorldSeed` dentro de `ReplicatedStorage`.
- Cole o JSON no formato de tabela Luau.

---

## 3. Conexão de Sistemas
| Origem | Destino (Roblox) | Função |
| :--- | :--- | :--- |
| `aion-core` | `WorldSeed` Module | Define a estética e complexidade. |
| `scripts/` | `ServerScriptService` | Processa comandos e economia. |
| `assets/` | `Decals / ImageLabels` | Aplica as texturas da Grade ao mundo. |

## 4. Próxima Etapa: A Sincronização
Para continuar a criação:
1. Abra o **Roblox Studio**.
2. Arraste a pasta `scripts` para o seu local de desenvolvimento.
3. Use as texturas da pasta `assets` para pintar os blocos gerados pelo seu **Painel de Comando**.

---
**Protocolo Symbeon Ativado. A ponte está estável.** 🕶️🏛️🚀

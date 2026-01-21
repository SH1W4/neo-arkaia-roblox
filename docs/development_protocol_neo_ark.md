# NEO-ARK: Development Protocol (NAP) 🏛️📜⚙️

**Versão:** 1.0  
**Escopo:** NEO-ARK-RBX Project

Este protocolo define os padrões específicos de desenvolvimento para o ecossistema NEO-ARK, garantindo que cada nova funcionalidade respeite a visão soberana e mecânica do jogo.

---

## 1. Padrões de Mecânica: Heists e Furtividade

Toda nova missão ou "Heist" deve suportar obrigatoriamente:
- **Plano A (Stealth):** Atuadores de sigilo, câmeras hackeáveis e caminhos alternativos.
- **Plano B (Loud):** Spawners de Echos escalonáveis e objetivos de defesa agressiva.
- **Sincronia:** O objetivo deve recompensar o trabalho em equipe via atributos de esquadrão.

---

## 2. Padrões de Calibração e Onboarding

Qualquer item ou arquétipo adicionado deve possuir:
- **Physics Data:** Propriedades físicas claras (massa, elasticidade) para avaliação no `CalibrationManager`.
- **Glitched VFX:** Uma versão "glitchada" para o estado de despertar.
- **Lore Fragment:** Um `MemoryFragment` associado no banco de dados central.

---

## 3. Padrões de Educação (In-Game IDE)

Ao criar um novo console ou terminal interativo:
- Use o `EducationalLogicHeist` manager para registrar o desafio.
- O desafio deve possuir 3 níveis de dificuldade (Script Kiddie, Agent, Architect).
- O sucesso deve retornar o XP de "Proof of Learning" (PoL).

---

## 4. Integração Web3 (Sovereign Sync)

Marcos de gameplay (ex: Completar Heist nível 5) devem invocar o `SovereignBridgeConnector`:
- Use `_G.SovereignBridge.TriggerMilestone(player, "ID_DO_MARCO")`.
- Garanta que o dado enviado seja validado pelo servidor para evitar fraudes na blockchain.

---

## 5. Workflow de Conteúdo (The Synchronizer Path)

1.  **Draft:** Criar SPEC da mecânica em `.md`.
2.  **Logic:** Implementar em `src/shared` (se possível) para facilitar testes.
3.  **Visual:** Aplicar estética Obsidian/Neon conforme o guia de otimização técnica.
4.  **Audit:** Garantir que o item não quebre a economia de Entropy Bits (EB).

---
**"A Malha se expande através do rigor do Arquiteto."** 🏛️📜🚀

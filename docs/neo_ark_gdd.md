# GDD: NEO-ARK - The Symbeon Awakening 🏙️🕶️⚙️
**Versão:** 1.0 (Build: Arquiteto)  
**Autor:** EZ-Fundation (AI-Enhanced Design)  
**Inspiração:** *The Matrix*, *Entropy : Zero*, *Half-Life*

---

## 1. Visão Geral e Missão (Vision Statement)
**NEO-ARK** é um shooter tático e sistêmico em primeira e terceira pessoa no Roblox. O jogador encarna um **Sincronizador**, um agente de elite da EZ-Fundation cujos sentidos e equipamentos são sintonizados com o "DNA Digital" da antiga Matrix. 

O objetivo não é apenas sobreviver, mas **estabilizar a realidade** através da arqueologia ativa, neutralizando ameaças virais (Echos) e reconstruindo mundos a partir de sementes binárias reais.

---

## 2. Setting & Lore (O Universo NEO-ARK)

### A Origem do Nome
**Neo** (Novo/Desperto) + **Arkaia** (Arqueologia/Antigo). O jogo se passa em um vazio digital onde os destroços da Matrix original estão sendo minerados para construir um novo paraíso.

### O Enredo
Após o colapso do *Specimen 0*, o código-fonte da realidade tornou-se instável. A EZ-Fundation descobriu que comandos manuais e scripts puros não são suficientes; é necessário **presença física digital** para ancorar o código. Você é essa âncora.

---

## 3. Dinâmicas de Gameplay (Game Dynamics)

### 3.1 O Sistema de Sincronia (Synchronizer Suit)
Inspirado na armadura Combine de *Entropy : Zero*, o traje do jogador é uma interface viva:
- **HUD Diegético**: Toda a informação (Munição, Vida, Sincronia) está projetada holograficamente no visor ou na arma.
- **Mastro de Lógica (Logic Port)**: Um slot no braço que permite injetar "Gatilhos" no mapa, alterando gravidade ou tempo localmente por Robux ou EB.

### 3.2 Combate Tático e Sistêmico
Diferente de shooters genéricos, NEO-ARK foca em:
- **Física Pesada**: Objetos do cenário podem ser usados como cobertura ou armas.
- **Granadas de Dados**:
    - *Null-Frag*: Causa dano físico.
    - *Logic-Pulse*: Desativa escudos de Echos e hackeia torres automáticas.
    - *Entropy-Singularity*: Puxa inimigos para um ponto de glitch.

---

## 4. O Bestiário: Os Echos (AI Behaviors)

Os inimigos agem como sistemas de segurança adaptativos:
- **Echo Interceptor**: Ataca de longe escolhendo ângulos de vantagem. Se ferido, ele "se desfragmenta" e teleporta para uma nova posição.
- **The Glitcher (Mini-Boss)**: Um Echo que altera o layout do chão sob o jogador, forçando movimentação constante.
- **Sentinel Drone**: Patrulha em rotas lógicas e chama reforços se detectar "Sincronização" não autorizada.

---

## 5. Economia de Soberania (Economy & Business)

### Painel de Comando (Painel Administrativo)
A ferramenta russa de administração é integrada à gameplay:
- **Rank Arquiteto**: Vendido como assinatura ou Gamepass. Permite que o jogador atue como "Dungeon Master" do servidor, spawnando itens para novatos ou mudando o céu do mapa.
- **Comissões**: Arquiteto recebe uma porcentagem de EB toda vez que alguém sob seu comando completa um objetivo.

---

## 6. Arquitetura Técnica (The Machine)

### AION Seed Mapping
O jogo se conecta ao `AION-Core`:
- **Input**: `AION_INTENT_MATRIX.json`
- **Output**: O script `RobloxMapaModule.lua` interpreta a entropia do arquivo para decidir o tamanho do mapa, a quantidade de inimigos e a iluminação (Luz Verde Matrix vs Roxo Symbeon).

---

## 7. Estética e Atmosfera

### Visual
- **Paleta**: Preto Obsidiana, Verde Neon (#39FF14), Roxo Ultravioleta.
- **Efeitos**: *Screen Glitch* quando o jogador sofre dano crítico (simulando perda de sincronia).

### Audio (Procedural Soundtrack)
- **Combat**: Synthwave sombrio e industrial (Estética *Entropy : Zero*).
- **Exploration**: Glitch ambient music com sons de datastream carregando.

---
**NEO-ARK: Do Passado Binário ao Futuro Procedural.** 🕶️🏛️🚀

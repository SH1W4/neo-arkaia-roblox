# NEO-ARK: The Symbeon Awakening 🎮🕶️🌌

## 1. O Enredo (Lore)
Em um futuro onde a **EZ-Fundation** resgatou o DNA da Grade Primordial, você joga como um **Sincronizador**. 
- **O Conflito**: Os Echos (vírus de código antigo) tentam deletar a realidade procedural.
- **A Missão**: Usar o **Terminal Symbeon** para reescrever o mundo em tempo real e estabilizar os setores gerados pelo AION.

---

## 2. Galeria de Assets (Assets Variados)

### 🖼️ Painel de Comando (Painel Administrativo)
Design de elite para criadores, inspirado no terminal do AION.
![Admin Panel Mockup](C:/Users/João/.gemini/antigravity/brain/d5b4c61c-ffbd-41e0-bf45-4fd89c517f42/neo_arkaia_ui_panel_mockup_1768825728629.png)

*Veja a especificação técnica completa em [painel_comando_spec.md](file:///C:/Users/João/.gemini/antigravity/brain/d5b4c61c-ffbd-41e0-bf45-4fd89c517f42/painel_comando_spec.md).*

### 🖥️ Interface (UI)
- **Tema**: *Console Noir*. 
- **Botões**: Bordas angulares de 45 graus com brilho verde (Neon Glow).
- **HUD**: Um "Medidor de Sincronia" (Substituto da barra de vida).

---

## 3. Logica de Economia e Gamepass (Luau)

### Recursos:
- **Entropy Bits (EB)**: Moeda de farm (obtida ao coletar fragmentos de código).
- **DNA (IDNA)**: Moeda Premium/Rara (obtida em eventos de colapso).

### Gamepasses Sugeridos:
| Nome | ID (Mockup) | Efeito |
| :--- | :--- | :--- |
| **Hierophant Access** | 10001 | Comandos ilimitados no Terminal e Multiplicador 2x de EB. |
| **Sovereign Vision** | 10002 | Vê inimigos e itens raros através das paredes (Estética Prime-Grid). |

---

## 4. O Terminal Monetizado (Código Luau)

Este script deve ser colocado no **ServerScriptService** para processar comandos pagos:

```lua
-- MONETIZED TERMINAL HANDLER
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TerminalCommand = Instance.new("RemoteEvent", ReplicatedStorage)
TerminalCommand.Name = "ExecuteSymbeonCommand"

local COMMAND_PRICES = {
    ["boost_speed"] = 50,    -- Preço em Entropy Bits
    ["reality_warp"] = 500,  -- Preço alto ou Requer Gamepass
}

TerminalCommand.OnServerEvent:Connect(function(player, command)
    local stats = player:WaitForChild("leaderstats")
    local eb = stats.EntropyBits
    
    if command == "reality_warp" then
        -- Verifica Gamepass do Hierofante (ID Mock)
        local hasPass = game:GetService("MarketplaceService"):UserOwnsGamePassAsync(player.UserId, 10001)
        
        if hasPass or eb.Value >= COMMAND_PRICES[command] then
            if not hasPass then eb.Value -= COMMAND_PRICES[command] end
            -- EFEITO: Mudar gravidade ou spawnar item lendário
            workspace.Gravity = 10 
            print("Reality Warped by " .. player.Name)
        end
    end
end)
```

## 5. Assets Variados (Texturas Prontas)

### Chão Isomórfico (Circuitry Seamless)
![Floor Texture](C:/Users/João/.gemini/antigravity/brain/d5b4c61c-ffbd-41e0-bf45-4fd89c517f42/neo_arkaia_floor_texture_seamless_1768825753832.png)

### Parede de Código (Data Rain Seamless)
![Wall Texture](C:/Users/João/.gemini/antigravity/brain/d5b4c61c-ffbd-41e0-bf45-4fd89c517f42/neo_arkaia_wall_data_rain_seamless_1768825769541.png)

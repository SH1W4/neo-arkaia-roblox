# Painel de Comando Symbeon: Spec & Logic 🖥️🔐💎

O **Painel de Comando** (ou *Symbeon Admin*) é a ferramenta definitiva para criadores e jogadores VIP em NEO-ARK. Ele é projetado para ser vendido como um **Developer Product** ou **Gamepass** dentro de servidores públicos ou privados.

## 1. Níveis de Acesso (Permissions)
- **Operador (Free)**: Acesso a comandos de teleporte básico e visualização de status.
- **Sincronizador (Gamepass)**: Acesso a comandos de spawn de itens comuns e cura.
- **Arquiteto (Admin/Developer)**: Controle total sobre a gravidade, tempo, spawn de NPCs e "Reality Warp".

---

## 2. Comandos do Painel (Monetizáveis)

| Comando | Nível Req. | Custo (EB) | Descrição |
| :--- | :--- | :--- | :--- |
| `:set_gravity` | Arquiteto | 0 | Altera a gravidade de todo o servidor. |
| `:spawn_boss` | Arquiteto | 1000 | Spawna um Echo Boss no setor atual. |
| `:clean_log` | Sincronizador | 50 | Limpa o log de entropia do jogador. |
| `:fly` | Sincronizador | 0 | Ativa modo de voo (Sovereign Flight). |

---

## 3. Implementação Luau (Admin Panel Core)

Este script lida com a verificação de permissões e execução de comandos via GUI:

```lua
-- PAINEL DE COMANDO CORE
local MarketplaceService = game:GetService("MarketplaceService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local PASS_ID_ARQUITETO = 10001 -- ID do Gamepass
local PASS_ID_SINCRONIZADOR = 10002

local CommandEvent = Instance.new("RemoteEvent")
CommandEvent.Name = "SymbeonAdminCommand"
CommandEvent.Parent = ReplicatedStorage

CommandEvent.OnServerEvent:Connect(function(player, command, target)
    local hasArchitect = MarketplaceService:UserOwnsGamePassAsync(player.UserId, PASS_ID_ARQUITETO)
    local hasSync = MarketplaceService:UserOwnsGamePassAsync(player.UserId, PASS_ID_SINCRONIZADOR)
    
    if command == "world_gravity" and hasArchitect then
        workspace.Gravity = tonumber(target) or 196.2
        print("Admin Command: Gravity set to " .. target)
    elseif command == "heal" and (hasSync or hasArchitect) then
        local char = player.Character
        if char and char:FindFirstChild("Humanoid") then
            char.Humanoid.Health = char.Humanoid.MaxHealth
        end
    end
end)
```

## 4. Design Visual (UI)
- **Janela Transparente**: Estilo "Glassmorphism" com bordas neon verde.
- **Input de Comando**: Estilo terminal `/`.
- **Lista de Jogadores**: Mostra quem tem o cargo de "Arquiteto" no servidor.

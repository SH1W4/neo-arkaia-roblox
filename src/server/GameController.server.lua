-- ==========================================
-- NEO-ARK: GAME CONTROLLER (MAIN ORCHESTRATOR)
-- EZ-FUNDATION | Protocol Symbeon
-- ==========================================

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Importar sistemas (Caminhos ajustados para nova estrutura)
local RepStorage = game:GetService("ReplicatedStorage")
local SharedModules = RepStorage:WaitForChild("NeoArkaia_Shared"):WaitForChild("Modules")

local DataStoreManager = require(script.Parent:WaitForChild("DataStoreManager"))
local HeistSystem = require(script.Parent:WaitForChild("CrossServerHeist"))
local EconomyManager = require(script.Parent:WaitForChild("EconomyManager"))
local FortificationSystem = require(script.Parent:WaitForChild("Fortification"))

local CombatSystem = require(SharedModules:WaitForChild("CombatSystem"))
local ItemSystem = require(SharedModules:WaitForChild("ItemSystem"))
local VFXController = require(SharedModules:WaitForChild("VFXController"))

local GameController = {}

-- 1. INICIALIZAR JOGO PARA JOGADOR
function GameController:InitializePlayer(player)
    print("🕶️ [GAME]: Inicializando jogador " .. player.Name)
    
    -- Nota: HUD agora é inicializado via StarterPlayerScripts automaticamente
    -- mas podemos disparar eventos iniciais se necessário.
    
    -- Configurar economia inicial
    EconomyManager:InitializePlayerEconomy(player)
    
    -- Configurar Personagem (Física Cyberpunk)
    player.CharacterAdded:Connect(function(character)
        local humanoid = character:WaitForChild("Humanoid")
        
        -- Calibragem de Movimento NEO-ARK
        humanoid.WalkSpeed = 24 -- Padrão Roblox: 16
        humanoid.JumpPower = 60 -- Padrão Roblox: 50
        humanoid.UseJumpPower = true
        
        task.wait(1)
        VFXController:CreateDataTrail(character)
        VFXController:SpawnEffect(character.HumanoidRootPart.Position)
    end)
    
    -- Se o jogador já tiver personagem (logins rápidos)
    if player.Character then
        task.spawn(function()
            local hum = player.Character:WaitForChild("Humanoid")
            hum.WalkSpeed = 24
            hum.JumpPower = 60
        end)
    end
end

-- 2. LOOP DE COMPILAÇÃO (SERVIDOR)
function GameController:StartCompilationLoop()
    while true do
        task.wait(60) -- A cada minuto
        
        -- Simular compilação de item raro
        local progress = math.random(10, 90)
        HeistSystem:BroadcastCompilation("Lâmina Binária", progress, game.JobId)
    end
end

-- 3. CONFIGURAR EVENTOS DE COMBATE
function GameController:SetupCombatEvents()
    -- Evento de disparo
    local fireEvent = Instance.new("RemoteEvent")
    fireEvent.Name = "FireWeapon"
    fireEvent.Parent = ReplicatedStorage
    
    fireEvent.OnServerEvent:Connect(function(player, weaponType, targetPosition)
        CombatSystem:FireWeapon(player, weaponType, targetPosition)
    end)
    
    -- Evento de granada
    local grenadeEvent = Instance.new("RemoteEvent")
    grenadeEvent.Name = "ThrowGrenade"
    grenadeEvent.Parent = ReplicatedStorage
    
    grenadeEvent.OnServerEvent:Connect(function(player, grenadeType, targetPosition)
        CombatSystem:ThrowGrenade(player, grenadeType, targetPosition)
    end)
end

-- 4. INICIALIZAR SERVIDOR
function GameController:Initialize()
    print("🏛️ [NEO-ARK]: Servidor iniciado - JobID: " .. game.JobId)
    
    -- Configurar eventos
    self:SetupCombatEvents()
    
    -- Iniciar loop de compilação
    task.spawn(function()
        self:StartCompilationLoop()
    end)
    
    -- Conectar jogadores
    Players.PlayerAdded:Connect(function(player)
        self:InitializePlayer(player)
    end)
end

-- INICIALIZAR AUTOMATICAMENTE
GameController:Initialize()

return GameController

-- ==========================================
-- NEO-ARK: CROSS-SERVER HEIST SYSTEM
-- EZ-FUNDATION | Protocol Symbeon
-- ==========================================

local MessagingService = game:GetService("MessagingService")
local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")

local HeistSystem = {}

-- 1. CONFIGURAÇÕES
local HEIST_TOPIC = "NeoArkaia_HeistAlert"
local COMPILATION_TOPIC = "NeoArkaia_Compilation"

-- 2. INICIAR INCURSÃO (HEIST)
function HeistSystem:InitiateHeist(attackerPlayer, targetServerID)
    print("🚨 [HEIST]: Iniciando incursão no servidor " .. targetServerID)
    
    -- Enviar alerta global
    local message = {
        Type = "HeistAlert",
        AttackerName = attackerPlayer.Name,
        TargetServer = targetServerID,
        Timestamp = os.time()
    }
    
    MessagingService:PublishAsync(HEIST_TOPIC, message)
    
    -- Teleportar atacante
    local placeId = game.PlaceId
    TeleportService:TeleportAsync(placeId, {attackerPlayer}, {
        ServerJobId = targetServerID
    })
end

-- 3. BROADCAST DE COMPILAÇÃO
function HeistSystem:BroadcastCompilation(itemName, progress, serverID)
    local message = {
        Type = "CompilationProgress",
        ItemName = itemName,
        Progress = progress,
        ServerID = serverID,
        Timestamp = os.time()
    }
    
    MessagingService:PublishAsync(COMPILATION_TOPIC, message)
end

-- 4. ESCUTAR ALERTAS DE HEIST
function HeistSystem:ListenForHeists(callback)
    MessagingService:SubscribeAsync(HEIST_TOPIC, function(message)
        local data = message.Data
        if data.Type == "HeistAlert" then
            callback(data)
        end
    end)
end

-- 5. ESCUTAR FEED DE COMPILAÇÃO
function HeistSystem:ListenForCompilations(callback)
    MessagingService:SubscribeAsync(COMPILATION_TOPIC, function(message)
        local data = message.Data
        if data.Type == "CompilationProgress" then
            callback(data)
        end
    end)
end

-- 6. VERIFICAR SE SERVIDOR É ALVO
function HeistSystem:IsTargetServer(targetServerID)
    return game.JobId == targetServerID
end

return HeistSystem

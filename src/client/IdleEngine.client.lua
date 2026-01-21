-- ==========================================
-- NEO-ARK: PASSIVE YIELD ENGINE (LUAU)
-- EZ-FUNDATION | Protocol Symbeon
-- ==========================================

local DataStoreService = game:GetService("DataStoreService")
local PlayerDataStore = DataStoreService:GetDataStore("NeoArkaia_PlayerEconomy_v1")

local MAX_OFFLINE_TIME = 43200 -- 12 Horas em segundos
local REVENUE_PER_SECOND = 0.5 -- Exemplo de rendimento base

game.Players.PlayerAdded:Connect(function(player)
    local leaderstats = player:WaitForChild("leaderstats")
    local eb = leaderstats:WaitForChild("EntropyBits")
    
    local success, data = pcall(function()
        return PlayerDataStore:GetAsync(tostring(player.UserId))
    end)
    
    if success and data and data.LastLogin then
        local currentTime = os.time()
        local timeDelta = currentTime - data.LastLogin
        
        -- Aplica o Cap
        local actualEarningTime = math.min(timeDelta, MAX_OFFLINE_TIME)
        local totalEarned = math.floor(actualEarningTime * (data.CurrentRPS or REVENUE_PER_SECOND))
        
        if totalEarned > 0 then
            eb.Value += totalEarned
            print("💰 [SYMBEON-ECONOMY]: " .. player.Name .. " ganhou " .. totalEarned .. " EB offline.")
            -- Emitir sinal para UI de "Welcome Back"
        end
    end
end)

game.Players.PlayerRemoving:Connect(function(player)
    local eb = player.leaderstats.EntropyBits
    local currentRPS = player:GetAttribute("CurrentRPS") or REVENUE_PER_SECOND
    
    local saveData = {
        LastLogin = os.time(),
        EntropyBits = eb.Value,
        CurrentRPS = currentRPS
    }
    
    pcall(function()
        PlayerDataStore:SetAsync(tostring(player.UserId), saveData)
    end)
end)

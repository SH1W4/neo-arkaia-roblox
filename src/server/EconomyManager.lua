-- ==========================================
-- NEO-ARK: ECONOMY MANAGER (LUAU)
-- EZ-FUNDATION | Protocol Symbeon
-- ==========================================

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local DataStoreService = game:GetService("DataStoreService")

local EconomyManager = {}

-- CONFIGURAÇÕES DA ECONOMIA
local MARKET_TAX = 0.10 -- 10% de taxa no mercado negro
local BASE_RPS = 0.5

-- 1. FUNÇÃO DE TRANSAÇÃO SEGURA
function EconomyManager:ProcessPurchase(player, cost, currencyType)
    local leaderstats = player:FindFirstChild("leaderstats")
    if not leaderstats then return false end
    
    local balance = leaderstats:FindFirstChild(currencyType)
    if balance and balance.Value >= cost then
        balance.Value -= cost
        print("✅ [ECONOMY]: " .. player.Name .. " gastou " .. cost .. " " .. currencyType)
        return true
    end
    
    return false
end

-- 2. FUNÇÃO DE RECOMPENSA (FAUCET)
function EconomyManager:AwardCurrency(player, amount, currencyType, source)
    local leaderstats = player:FindFirstChild("leaderstats")
    if not leaderstats then return end
    
    local balance = leaderstats:FindFirstChild(currencyType)
    if balance then
        balance.Value += amount
        print("💰 [ECONOMY]: " .. player.Name .. " recebeu " .. amount .. " " .. currencyType .. " via " .. source)
    end
end

-- 3. CALCULO DE TAXA DE MERCADO
function EconomyManager:CalculateNetProfit(salePrice)
    local tax = math.floor(salePrice * MARKET_TAX)
    return salePrice - tax, tax
end

-- 4. ESCALONAMENTO DE NÍVEL (SOVEREIGNTY LEVEL)
function EconomyManager:GetNextUpgradeCost(currentLevel)
    return math.floor(5000 * (1.5 ^ (currentLevel - 1)))
end

-- 5. INTERFACE PARA O SERVIDOR
local EconomyEvent = Instance.new("RemoteFunction", ReplicatedStorage)
EconomyEvent.Name = "EconomyRequest"

EconomyEvent.OnServerInvoke = function(player, action, params)
    if action == "BuyUpgrade" then
        local currentLevel = player:GetAttribute("SovereigntyLevel") or 1
        local cost = EconomyManager:GetNextUpgradeCost(currentLevel)
        
        if EconomyManager:ProcessPurchase(player, cost, "EntropyBits") then
            player:SetAttribute("SovereigntyLevel", currentLevel + 1)
            -- Aumentar RPS após upgrade
            local currentRPS = player:GetAttribute("CurrentRPS") or BASE_RPS
            player:SetAttribute("CurrentRPS", currentRPS * 1.2)
            return true
        end
    end
    return false
end

return EconomyManager

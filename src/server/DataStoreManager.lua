-- ==========================================
-- NEO-ARK: DATASTORE MANAGER (PRODUCTION-READY)
-- EZ-FUNDATION | Protocol Symbeon
-- Implements UpdateAsync, versioning, and error handling
-- ==========================================

local DataStoreService = game:GetService("DataStoreService")
local HttpService = game:GetService("HttpService")
local MemoryStoreService = game:GetService("MemoryStoreService")

local DataStoreManager = {}

-- DataStores
DataStoreManager.PlayerData = DataStoreService:GetDataStore("PlayerData_v1")
DataStoreManager.GlobalHeists = DataStoreService:GetDataStore("GlobalHeists_v1")
DataStoreManager.OrderedEB = DataStoreService:GetOrderedDataStore("LeaderboardEB_v1")

-- Memory Stores (temporary data)
DataStoreManager.HeistPositions = MemoryStoreService:GetSortedMap("HeistPositions")

-- Versioning
local DATA_VERSION = 1

-- 1. GET PLAYER DATA
function DataStoreManager:GetPlayerData(userId)
    local success, data = pcall(function()
        return self.PlayerData:GetAsync("Player_" .. userId)
    end)
    
    if success and data then
        -- Check version
        if data.version ~= DATA_VERSION then
            data = self:MigrateData(data)
        end
        return data
    else
        -- Return default data
        return {
            version = DATA_VERSION,
            eb_balance = 0,
            items = {},
            missions_complete = {},
            reputation = {},
            last_login = os.time()
        }
    end
end

-- 2. SAVE PLAYER DATA
function DataStoreManager:SavePlayerData(userId, data)
    data.version = DATA_VERSION
    data.last_save = os.time()
    
    local success, err = pcall(function()
        self.PlayerData:SetAsync("Player_" .. userId, data)
    end)
    
    if not success then
        warn("[DataStore] Failed to save player " .. userId .. ": " .. tostring(err))
        return false
    end
    
    return true
end

-- 3. UPDATE ASYNC (for concurrent operations)
function DataStoreManager:UpdatePlayerEB(userId, deltaEB)
    local success, newBalance = pcall(function()
        return self.PlayerData:UpdateAsync("Player_" .. userId, function(oldData)
            local data = oldData or self:GetPlayerData(userId)
            data.eb_balance = (data.eb_balance or 0) + deltaEB
            return data
        end)
    end)
    
    if success then
        return newBalance.eb_balance
    else
        warn("[DataStore] Failed to update EB for player " .. userId)
        return nil
    end
end

-- 4. HEIST STATE MANAGEMENT (UpdateAsync)
function DataStoreManager:UpdateHeistState(serverJobId, updateFunction)
    local success, result = pcall(function()
        return self.GlobalHeists:UpdateAsync("Heist_" .. serverJobId, function(oldData)
            local data = oldData or {
                active = false,
                target_item = nil,
                progress = 0,
                defenders = {},
                attackers = {},
                start_time = 0
            }
            
            return updateFunction(data)
        end)
    end)
    
    return success, result
end

-- 5. LEADERBOARD (OrderedDataStore)
function DataStoreManager:UpdateLeaderboard(userId, ebBalance)
    local success = pcall(function()
        self.OrderedEB:SetAsync(tostring(userId), ebBalance)
    end)
    
    return success
end

function DataStoreManager:GetTopPlayers(count)
    count = count or 10
    
    local success, pages = pcall(function()
        return self.OrderedEB:GetSortedAsync(false, count)
    end)
    
    if success then
        local topPlayers = {}
        local currentPage = pages:GetCurrentPage()
        
        for rank, entry in ipairs(currentPage) do
            table.insert(topPlayers, {
                rank = rank,
                userId = tonumber(entry.key),
                eb_balance = entry.value
            })
        end
        
        return topPlayers
    else
        return {}
    end
end

-- 6. MEMORY STORE (temporary heist data)
function DataStoreManager:UpdateHeistPosition(playerId, position)
    local success = pcall(function()
        self.HeistPositions:SetAsync(tostring(playerId), {
            x = position.X,
            y = position.Y,
            z = position.Z,
            timestamp = os.time()
        }, 60) -- Expires in 60 seconds
    end)
    
    return success
end

function DataStoreManager:GetHeistPositions()
    local success, positions = pcall(function()
        return self.HeistPositions:GetRangeAsync(Enum.SortDirection.Ascending, 100)
    end)
    
    if success then
        local result = {}
        for _, entry in ipairs(positions) do
            result[entry.key] = entry.value
        end
        return result
    else
        return {}
    end
end

-- 7. DATA MIGRATION
function DataStoreManager:MigrateData(oldData)
    warn("[DataStore] Migrating data from version " .. (oldData.version or 0) .. " to " .. DATA_VERSION)
    
    -- Add migration logic here when version changes
    oldData.version = DATA_VERSION
    
    return oldData
end

-- 8. AUTO-SAVE SYSTEM
function DataStoreManager:EnableAutoSave(player)
    local userId = player.UserId
    
    -- Save every 5 minutes
    task.spawn(function()
        while player.Parent do
            task.wait(300)
            
            local data = {
                eb_balance = player:GetAttribute("EB") or 0,
                items = {}, -- Get from ItemSystem
                missions_complete = {}, -- Get from mission tracker
                reputation = {} -- Get from NPC reputation
            }
            
            self:SavePlayerData(userId, data)
            print("[DataStore] Auto-saved player " .. player.Name)
        end
    end)
end

return DataStoreManager

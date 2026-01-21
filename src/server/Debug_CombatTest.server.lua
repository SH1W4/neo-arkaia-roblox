-- ==========================================
-- NEO-ARK: DEBUG COMBAT TEST
-- Spawns a dummy and gives weapons for testing
-- ==========================================

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")

local BOSS_ROOM_POS = Vector3.new(64, 5, 16) -- Calculated from Map X=16, Y=4

local function spawnDummy()
    local dummy = game.Workspace:FindFirstChild("CombatDummy")
    if dummy then dummy:Destroy() end

    -- Create a simple R6 Dummy (Box style)
    dummy = Instance.new("Model")
    dummy.Name = "CombatDummy"
    
    local humanoid = Instance.new("Humanoid")
    humanoid.MaxHealth = 100
    humanoid.Health = 100
    humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.Viewer
    humanoid.Parent = dummy
    
    local root = Instance.new("Part")
    root.Name = "HumanoidRootPart"
    root.Size = Vector3.new(2, 2, 1)
    root.Position = BOSS_ROOM_POS
    root.Anchored = true
    root.Transparency = 0.5
    root.Color = Color3.fromRGB(255, 0, 0) -- Red target
    root.Parent = dummy
    
    local head = Instance.new("Part")
    head.Name = "Head"
    head.Size = Vector3.new(1.2, 1.2, 1.2)
    head.Position = BOSS_ROOM_POS + Vector3.new(0, 1.5, 0)
    head.Anchored = true
    head.Color = Color3.fromRGB(255, 255, 0)
    head.Parent = dummy
    
    dummy.PrimaryPart = root
    dummy.Parent = game.Workspace
    
    print("🥊 [DEBUG] Combat Dummy spawned at Boss Room.")
end

local function equipPlayer(player)
    task.wait(2) -- Wait for character load
    
    -- Mock Weapon Tool (Scythe)
    local scythe = Instance.new("Tool")
    scythe.Name = "⚔️ TEST SCYTHE" -- Changed name to be very visible
    scythe.RequiresHandle = true
    -- Adjust Grip to hold it easier
    scythe.GripPos = Vector3.new(0, -1, 0)
    scythe.GripForward = Vector3.new(-1, 0, 0)
    scythe.GripRight = Vector3.new(0, 1, 0)
    
    local handle = Instance.new("Part")
    handle.Name = "Handle"
    handle.Size = Vector3.new(0.5, 6, 0.5) -- Thinner and longer
    handle.Color = Color3.fromRGB(0, 255, 0) -- Bright Green to contrast with purple skin
    handle.Material = Enum.Material.Neon -- Glowing
    handle.Parent = scythe
    
    -- Add basic activate script
    local script = Instance.new("Script")
    script.Source = [[
        local tool = script.Parent
        tool.Activated:Connect(function()
            local char = tool.Parent
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if not hrp then return end
            
            -- Simple Hitbox
            local hitbox = Instance.new("Part")
            hitbox.Size = Vector3.new(5, 5, 5)
            hitbox.CFrame = hrp.CFrame * CFrame.new(0, 0, -3)
            hitbox.Transparency = 1
            hitbox.CanCollide = false
            hitbox.Parent = workspace
            game:GetService("Debris"):AddItem(hitbox, 0.1)
            
            local parts = workspace:GetPartsInPart(hitbox)
            for _, p in ipairs(parts) do
                if p.Parent and p.Parent:FindFirstChild("Humanoid") and p.Parent ~= char then
                    p.Parent.Humanoid:TakeDamage(10)
                    print("⚔️ HIT: " .. p.Parent.Name)
                end
            end
        end)
    ]]
    script.Parent = scythe
    
    scythe.Parent = player.Backpack
    print("⚔️ [DEBUG] Scythe equipped.")
end

-- Init
spawnDummy()
Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        equipPlayer(player)
    end)
end)

-- ==========================================
-- NEO-ARK: SECTOR FORTIFICATION SYSTEM (LUAU)
-- EZ-FUNDATION | Protocol Symbeon
-- ==========================================

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local FortificationSystem = {}

-- 1. CONFIGURAÇÕES DE DEFESA
local WALL_HEALTH = 500
local SHIELD_CONSUMPTION_RATE = 2 -- EB por segundo

-- 2. SPAWN DE PAREDE DE LOGICA
function FortificationSystem:DeployLogicWall(player, position)
    local wall = Instance.new("Part")
    wall.Name = "LogicWall"
    wall.Size = Vector3.new(10, 15, 2)
    wall.Position = position
    wall.Material = Enum.Material.Neon
    wall.Color = Color3.fromRGB(0, 0, 0) -- Preto Obsidiana
    wall.Anchored = true
    wall.Parent = workspace
    
    -- Efeito de Glow Verde
    local selection = Instance.new("SelectionBox")
    selection.Adornee = wall
    selection.Color3 = Color3.fromRGB(57, 255, 20)
    selection.Parent = wall
    
    wall:SetAttribute("Health", WALL_HEALTH)
    return wall
end

-- 3. BARREIRA DE MALHA (SHIELD)
function FortificationSystem:ToggleMeshShield(node, active)
    local shield = node:FindFirstChild("MeshShield")
    if not shield then
        shield = Instance.new("ForceField")
        shield.Name = "MeshShield"
        shield.Visible = true
        shield.Parent = node
    end
    
    node:SetAttribute("ShieldActive", active)
    print("🛡️ [FORTIFICATION]: Escudo de Malha " .. (active and "ATIVADO" or "DESATIVADO"))
end

-- 3. HONEY POT (NODE FALSO)
function FortificationSystem:DeployHoneyPot(player, position)
    local decoy = Instance.new("Part")
    decoy.Name = "HoneyPot_Node"
    decoy.Size = Vector3.new(4, 4, 4)
    decoy.Position = position
    decoy.Color = Color3.fromRGB(255, 0, 110) -- Magenta "Erro"
    decoy.Parent = workspace
    
    decoy:SetAttribute("isHoneyPot", true)
    return decoy
end

-- 4. LOGICA DE DANO E BREACH
function FortificationSystem:OnTargetDamaged(target, damage, attacker)
    local isHoneyPot = target:GetAttribute("isHoneyPot")
    
    if isHoneyPot then
        -- Punir o atacante (Honey Pot Effect)
        print("🚨 [TRAP]: Invasor atacou um Honey Pot! Aplicando Debuff.")
        if attacker and attacker.Character then
            attacker.Character.Humanoid.WalkSpeed = 8 -- Lentidão
        end
        target:Destroy()
        return
    end
    
    local health = target:GetAttribute("Health") or WALL_HEALTH
    health = health - damage
    target:SetAttribute("Health", health)
    
    if health <= 0 then
        target:Destroy()
        ReplicatedStorage.RemoteEvents.AlertBreach:FireAllClients(target.Name .. " destruído!")
    end
end

return FortificationSystem

-- ==========================================
-- NEO-ARK: COMBAT SYSTEM (WEAPONS & GRENADES)
-- EZ-FUNDATION | Protocol Symbeon
-- ==========================================

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VFXController = require(script.Parent:WaitForChild("VFXController"))

local CombatSystem = {}

-- 1. CONFIGURAÇÕES DE ARMAS
local WEAPONS = {
    PulseRifle = {
        Damage = 25,
        FireRate = 0.1,
        Range = 200,
        AmmoCapacity = 30
    },
    BinaryBlade = {
        Damage = 50,
        Range = 5,
        CoolDown = 0.5
    }
}

-- 2. CONFIGURAÇÕES DE GRANADAS
local GRENADES = {
    NullFrag = {
        Damage = 75,
        BlastRadius = 15
    },
    LogicPulse = {
        Damage = 0,
        BlastRadius = 20,
        DisableShields = true
    },
    EntropySingularity = {
        Damage = 100,
        BlastRadius = 10,
        PullForce = 5000
    }
}

-- 3. DISPARAR ARMA
function CombatSystem:FireWeapon(player, weaponType, targetPosition)
    local weaponData = WEAPONS[weaponType]
    if not weaponData then return end
    
    local character = player.Character
    if not character then return end
    
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if not rootPart then return end
    
    -- Raycast para detectar hit
    local rayOrigin = rootPart.Position
    local rayDirection = (targetPosition - rayOrigin).Unit * weaponData.Range
    
    local raycastParams = RaycastParams.new()
    raycastParams.FilterDescendantsInstances = {character}
    raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
    
    local raycastResult = workspace:Raycast(rayOrigin, rayDirection, raycastParams)
    
    if raycastResult then
        local hitPart = raycastResult.Instance
        local hitCharacter = hitPart.Parent
        
        if hitCharacter:FindFirstChild("Humanoid") then
            hitCharacter.Humanoid:TakeDamage(weaponData.Damage)
            VFXController:GlitchEffect(hitCharacter)
        end
    end
end

-- 4. LANÇAR GRANADA
function CombatSystem:ThrowGrenade(player, grenadeType, targetPosition)
    local grenadeData = GRENADES[grenadeType]
    if not grenadeData then return end
    
    -- Criar projétil visual
    local grenade = Instance.new("Part")
    grenade.Shape = Enum.PartType.Ball
    grenade.Size = Vector3.new(1, 1, 1)
    grenade.Color = Color3.fromRGB(255, 0, 110) -- Magenta
    grenade.Material = Enum.Material.Neon
    grenade.Position = player.Character.HumanoidRootPart.Position
    grenade.Parent = workspace
    
    -- Física de lançamento
    local bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.Velocity = (targetPosition - grenade.Position).Unit * 50
    bodyVelocity.MaxForce = Vector3.new(4000, 4000, 4000)
    bodyVelocity.Parent = grenade
    
    -- Explosão após 2 segundos
    task.wait(2)
    VFXController:DataGrenadeExplosion(grenade.Position, grenadeType)
    
    -- Aplicar efeitos especiais
    if grenadeType == "EntropySingularity" then
        self:ApplySingularityPull(grenade.Position, grenadeData.PullForce)
    end
    
    grenade:Destroy()
end

-- 5. EFEITO DE SINGULARIDADE (PUXAR INIMIGOS)
function CombatSystem:ApplySingularityPull(position, force)
    local region = Region3.new(position - Vector3.new(20, 20, 20), position + Vector3.new(20, 20, 20))
    
    for _, part in pairs(workspace:FindPartsInRegion3(region, nil, 100)) do
        if part.Parent:FindFirstChild("Humanoid") then
            local bodyPosition = Instance.new("BodyPosition")
            bodyPosition.Position = position
            bodyPosition.MaxForce = Vector3.new(force, force, force)
            bodyPosition.Parent = part
            
            task.wait(1)
            bodyPosition:Destroy()
        end
    end
end

return CombatSystem

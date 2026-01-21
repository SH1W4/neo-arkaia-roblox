-- ==========================================
-- NEO-ARK: VFX CONTROLLER (PARTICLES & EFFECTS)
-- EZ-FUNDATION | Protocol Symbeon
-- ==========================================

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local VFXController = {}

-- 1. EFEITO DE SPAWN (COMPILAÇÃO)
function VFXController:SpawnEffect(position)
    local particles = Instance.new("ParticleEmitter")
    particles.Texture = "rbxasset://textures/particles/smoke_main.dds"
    particles.Color = ColorSequence.new(Color3.fromRGB(123, 44, 191)) -- Ultravioleta
    particles.Size = NumberSequence.new(2)
    particles.Lifetime = NumberRange.new(1, 2)
    particles.Rate = 50
    particles.Speed = NumberRange.new(5, 10)
    particles.SpreadAngle = Vector2.new(360, 360)
    
    local part = Instance.new("Part")
    part.Position = position
    part.Anchored = true
    part.Transparency = 1
    part.CanCollide = false
    part.Parent = workspace
    
    particles.Parent = part
    
    task.wait(2)
    particles.Enabled = false
    task.wait(2)
    part:Destroy()
end

-- 2. EFEITO DE GLITCH (DANO)
function VFXController:GlitchEffect(character)
    local humanoid = character:FindFirstChild("Humanoid")
    if not humanoid then return end
    
    -- Distorção visual temporária
    for _, part in pairs(character:GetDescendants()) do
        if part:IsA("BasePart") then
            local originalSize = part.Size
            part.Size = part.Size * Vector3.new(1.2, 0.8, 1.1)
            
            task.wait(0.1)
            part.Size = originalSize
        end
    end
end

-- 3. RASTRO DE DADOS (MOVIMENTO)
function VFXController:CreateDataTrail(character)
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if not rootPart then return end
    
    local trail = Instance.new("Trail")
    trail.Color = ColorSequence.new(Color3.fromRGB(57, 255, 20)) -- Verde Neon
    trail.Transparency = NumberSequence.new(0.5)
    trail.Lifetime = 0.5
    trail.MinLength = 0.1
    
    local attachment0 = Instance.new("Attachment")
    attachment0.Parent = rootPart
    
    local attachment1 = Instance.new("Attachment")
    attachment1.Position = Vector3.new(0, -2, 0)
    attachment1.Parent = rootPart
    
    trail.Attachment0 = attachment0
    trail.Attachment1 = attachment1
    trail.Parent = rootPart
    
    return trail
end

-- 4. EXPLOSÃO DE GRANADA DE DADOS
function VFXController:DataGrenadeExplosion(position, grenadeType)
    local explosion = Instance.new("Explosion")
    explosion.Position = position
    explosion.BlastRadius = 15
    explosion.BlastPressure = 100000
    
    if grenadeType == "LogicPulse" then
        explosion.ExplosionType = Enum.ExplosionType.NoCraters
        explosion.BlastRadius = 20
    elseif grenadeType == "EntropySingularity" then
        explosion.BlastPressure = 500000
    end
    
    explosion.Parent = workspace
    
    -- Partículas adicionais
    self:SpawnEffect(position)
end

return VFXController

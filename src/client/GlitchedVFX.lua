--[[
    NEO-ARK: GlitchedVFX
    Author: EZ-Studios (Sovereign Engine)
    Description: Handles unstable visual effects for Sovereign assets.
]]

local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local GlitchedVFX = {}

-- Constants
local PULSE_SPEED = 0.1
local GLITCH_INTENSITY = 0.4

-- Glitch Effect: Randomly fluctuates transparency and color
function GlitchedVFX.ApplyGlitch(part, baseColor)
	local originalTransparency = part.Transparency
	
	RunService.RenderStepped:Connect(function()
		if not part or not part.Parent then return end
		
		-- Random Flicker
		if math.random() < 0.1 then
			part.Transparency = originalTransparency + (math.random() * GLITCH_INTENSITY)
			part.Color = baseColor:Lerp(Color3.new(1, 1, 1), math.random() * 0.5)
		else
			part.Transparency = originalTransparency
			part.Color = baseColor
		end
	end)
end

-- Pulse Effect: Smoothly oscillates neon intensity
function GlitchedVFX.ApplyPulse(part, color)
	local info = TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true)
	local target = {Transparency = 0.5}
	
	local tween = TweenService:Create(part, info, target)
	part.Color = color
	part.Material = Enum.Material.Neon
	tween:Play()
end

-- Desintegration: Spawns particles to simulate 'data decay'
function GlitchedVFX.EmitDataStream(part, color)
	local particles = Instance.new("ParticleEmitter")
	particles.Color = ColorSequence.new(color)
	particles.Size = NumberSequence.new(0.2, 0)
	particles.Lifetime = NumberRange.new(0.5, 1)
	particles.Rate = 50
	particles.Speed = NumberRange.new(2, 5)
	particles.SpreadAngle = Vector2.new(360, 360)
	particles.Texture = "rbxassetid://6030200843" -- Simple block/pixel texture
	particles.Parent = part
	
	return particles
end

return GlitchedVFX

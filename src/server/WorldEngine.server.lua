--[[
    NEO-ARK: WorldEngine
    Author: EZ-Studios (Sovereign Engine)
    Description: Procedural construction of game environments.
]]

local ServerScriptService = game:GetService("ServerScriptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Configuration
local ROOM_SIZE = 200
local VOID_COLOR = Color3.fromHex("#F5F5F5") -- Off-white
local GRID_COLOR = Color3.fromHex("#39FF14") -- Neon Green lines

local function createCalibrationChamber()
	local folder = Instance.new("Folder")
	folder.Name = "CalibrationChamber"
	folder.Parent = workspace
	
	-- The Floor (Grid)
	local floor = Instance.new("Part")
	floor.Name = "VoidFloor"
	floor.Size = Vector3.new(ROOM_SIZE, 1, ROOM_SIZE)
	floor.Position = Vector3.new(0, 499, 0)
	floor.Anchored = true
	floor.Color = VOID_COLOR
	floor.Material = Enum.Material.Glass
	floor.Reflectance = 0.2
	floor.Parent = folder
	
	-- Decorative Grid Lines (Simulated)
	for i = -ROOM_SIZE/2, ROOM_SIZE/2, 20 do
		local line = Instance.new("Part")
		line.Size = Vector3.new(ROOM_SIZE, 0.1, 0.1)
		line.Position = Vector3.new(0, 499.6, i)
		line.Anchored = true
		line.CanCollide = false
		line.Color = GRID_COLOR
		line.Material = Enum.Material.Neon
		line.Transparency = 0.8
		line.Parent = folder
		
		local lineY = line:Clone()
		lineY.Size = Vector3.new(0.1, 0.1, ROOM_SIZE)
		lineY.Position = Vector3.new(i, 499.6, 0)
		lineY.Parent = folder
	end
	
	-- Spawning interactables (Code Debris)
	for i = 1, 15 do
		local debris = Instance.new("Part")
		debris.Name = "CodeDebris_" .. i
		debris.Size = Vector3.new(math.random(2, 6), math.random(2, 6), math.random(2, 6))
		debris.Position = Vector3.new(math.random(-50, 50), 505, math.random(-50, 50))
		debris.Color = Color3.new(0.1, 0.1, 0.1)
		debris.Material = Enum.Material.Metal
		debris.Parent = folder
		
		-- Physics properties for evaluation
		local bodyForce = Instance.new("BodyForce")
		bodyForce.Force = Vector3.new(0, debris:GetMass() * workspace.Gravity * 0.8, 0) -- Low gravity feel
		bodyForce.Parent = debris
		
		-- Tag for the Evaluator
		debris:SetAttribute("IsCalibrationObject", true)
	end
	
	print("[WorldEngine] Calibration Chamber (The Malha) constructed at altitude 500.")
end

-- Initialize
createCalibrationChamber()

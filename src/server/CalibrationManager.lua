--[[
    NEO-ARK: CalibrationManager
    Author: EZ-Studios (Sovereign Engine)
    Description: Manages the immersive onboarding and archetype evaluation.
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local Events = ReplicatedStorage:WaitForChild("NeoArkaia_Shared"):WaitForChild("Events")
local Modules = ReplicatedStorage:WaitForChild("NeoArkaia_Shared"):WaitForChild("Modules")
local StartCalibrationEvent = Events:WaitForChild("StartCalibration")
local PhysicsEvaluator = require(Modules:WaitForChild("PhysicsEvaluator"))

-- Configuration
local CALIBRATION_ROOM_POSITION = Vector3.new(0, 500, 0)

-- Archetype Scoring Logic
local ARCHETYPES = PhysicsEvaluator.Archetypes

local playerScores = {}

local function initializePlayerScore(player)
	playerScores[player.UserId] = {
		[ARCHETYPES.EXECUTOR] = 0,
		[ARCHETYPES.PHANTOM] = 0,
		[ARCHETYPES.ARCHITECT] = 0,
		[ARCHETYPES.ORACLE] = 0,
		[ARCHETYPES.BROKER] = 0
	}
end

local function recordInteraction(player, archetype, value)
	if playerScores[player.UserId] then
		playerScores[player.UserId][archetype] = playerScores[player.UserId][archetype] + value
		print(string.format("[Calibration] Player %s scored %d for %s", player.Name, value, archetype))
	end
end

-- Physics Evaluator Listeners
local function onDebrisInteraction(player, debris, force)
	local archetype, reward = PhysicsEvaluator.EvaluateForce(force)
	if archetype then
		recordInteraction(player, archetype, reward)
		
		-- Visual feedback (Color change on debris)
		debris.Color = PhysicsEvaluator.GetAuraColor(archetype)
		task.delay(0.5, function() debris.Color = Color3.new(0.1, 0.1, 0.1) end)
	end
end

-- Calibration Flow
local function setupCalibrationRoom(player)
	local character = player.Character or player.CharacterAdded:Wait()
	character:SetPrimaryPartCFrame(CFrame.new(CALIBRATION_ROOM_POSITION))
	
	-- Connect to interactable objects
	for _, obj in ipairs(workspace:GetDescendants()) do
		if obj:IsA("BasePart") and obj:GetAttribute("IsCalibrationObject") then
			obj.Touched:Connect(function(otherPart)
				if otherPart:IsDescendantOf(character) then
					-- Calculate force (simulated simple velocity check)
					local force = otherPart.Velocity - obj.Velocity
					onDebrisInteraction(player, obj, force)
				end
			end)
		end
	end
	
	player:SetAttribute("InCalibration", true)
	print("[Calibration] Sensors active for " .. player.Name)
end

local function finalizeCalibration(player)
	local scores = playerScores[player.UserId]
	if not scores then return end
	
	-- Determine highest score as recommended archetype
	local recommended = ARCHETYPES.EXECUTOR
	local maxScore = -1
	
	for archetype, score in pairs(scores) do
		if score > maxScore then
			maxScore = score
			recommended = archetype
		end
	end
	
	print(string.format("[Calibration] Finalizing for %s. Recommended: %s", player.Name, recommended))
	
	-- Save to DataStore or temporary attribute
	player:SetAttribute("RecommendedArchetype", recommended)
	player:SetAttribute("InCalibration", false)
	
	-- Teleport to Node Central (SpawnLocation)
	player:LoadCharacter() 
end

-- Event Handling
StartCalibrationEvent.OnServerEvent:Connect(function(player)
	initializePlayerScore(player)
	setupCalibrationRoom(player)
	
	-- After some time or interaction, finalize (Simulated delay for now)
	task.delay(10, function()
		if player:GetAttribute("InCalibration") then
			finalizeCalibration(player)
		end
	end)
end)

Players.PlayerRemoving:Connect(function(player)
	playerScores[player.UserId] = nil
end)

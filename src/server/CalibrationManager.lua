--[[
    NEO-ARK: CalibrationManager
    Author: EZ-Studios (Sovereign Engine)
    Description: Manages the immersive onboarding and archetype evaluation.
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local Events = ReplicatedStorage:WaitForChild("NeoArkaia_Shared"):WaitForChild("Events")
local StartCalibrationEvent = Events:WaitForChild("StartCalibration")

-- Configuration
local CALIBRATION_ROOM_POSITION = Vector3.new(0, 500, 0) -- High in the sky or separate area

-- Archetype Scoring Logic
local ARCHETYPES = {
	EXECUTOR = "Executor",
	PHANTOM = "Phantom",
	ARCHITECT = "Architect",
	ORACLE = "Oracle",
	BROKER = "Broker"
}

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
-- These would be triggered by physical objects in the calibration room
local function onObjectPushed(player, force)
	if force > 50 then
		recordInteraction(player, ARCHETYPES.EXECUTOR, 10)
	else
		recordInteraction(player, ARCHETYPES.ARCHITECT, 5)
	end
end

local function onPlayerDash(player)
	recordInteraction(player, ARCHETYPES.PHANTOM, 15)
end

-- Calibration Flow
local function setupCalibrationRoom(player)
	-- In a real scenario, we'd spawn a personal room from a Template
	-- For this PoC, we just position them and set attributes
	local character = player.Character or player.CharacterAdded:Wait()
	character:SetPrimaryPartCFrame(CFrame.new(CALIBRATION_ROOM_POSITION))
	
	player:SetAttribute("InCalibration", true)
	print("[Calibration] Room setup complete for " .. player.Name)
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

--[[
    NEO-ARK: PhysicsEvaluator
    Author: EZ-Studios (Sovereign Engine)
    Description: Evaluates player 'Intent' by analyzing kinematic data and force interactions.
]]

local PhysicsEvaluator = {}

-- Thresholds
local FORCE_TRESHOLD_HEAVY = 50
local SPEED_THRESHOLD_FAST = 20
local PRECISION_WINDOW = 0.5 -- Seconds to consider a 'Precise' strike

-- Archetype Identifiers
PhysicsEvaluator.Archetypes = {
	EXECUTOR = "Executor",
	PHANTOM = "Phantom",
	ARCHITECT = "Architect",
	ORACLE = "Oracle",
	BROKER = "Broker"
}

-- Evaluation Logic
function PhysicsEvaluator.EvaluateForce(forceVector)
	local magnitude = forceVector.Magnitude
	if magnitude > FORCE_TRESHOLD_HEAVY then
		return PhysicsEvaluator.Archetypes.EXECUTOR, 10
	elseif magnitude > 10 then
		return PhysicsEvaluator.Archetypes.ARCHITECT, 5
	end
	return nil, 0
end

function PhysicsEvaluator.EvaluateDash(velocity)
	if velocity.Magnitude > SPEED_THRESHOLD_FAST then
		return PhysicsEvaluator.Archetypes.PHANTOM, 15
	end
	return nil, 0
end

function PhysicsEvaluator.EvaluateInteraction(interactionTime, sequenceCorrect)
	if sequenceCorrect then
		if interactionTime < PRECISION_WINDOW then
			return PhysicsEvaluator.Archetypes.PHANTOM, 10 -- Reflex
		else
			return PhysicsEvaluator.Archetypes.ORACLE, 10 -- Calculation
		end
	end
	return nil, 0
end

function PhysicsEvaluator.GetAuraColor(archetype)
	local colors = {
		[PhysicsEvaluator.Archetypes.ARCHITECT] = Color3.fromHex("#39FF14"),
		[PhysicsEvaluator.Archetypes.ORACLE] = Color3.fromHex("#7B2CBF"),
		[PhysicsEvaluator.Archetypes.EXECUTOR] = Color3.fromHex("#FF3131"),
		[PhysicsEvaluator.Archetypes.PHANTOM] = Color3.fromHex("#FF006E"),
		[PhysicsEvaluator.Archetypes.BROKER] = Color3.fromHex("#00F5FF"),
	}
	return colors[archetype] or Color3.new(1, 1, 1)
end

return PhysicsEvaluator

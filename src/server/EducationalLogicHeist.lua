--[[
    NEO-ARK: EducationalLogicHeist
    Author: EZ-Studios (Sovereign Engine)
    Description: Mechanics for "Logic Hacks" - teaching code through gameplay.
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

-- Challenges Database
local CHALLENGES = {
	{
		ID = "logic_01_if",
		Category = "Control Flow",
		Question = "Corrija a condição para que a porta abra apenas se tiver 10 Entropy Bits.",
		GlitchedCode = "if player.EB > 5 then open_door() end",
		TargetCode = "if player.EB >= 10 then open_door() end",
		XPReward = 500
	},
	{
		ID = "logic_02_loop",
		Category = "Loops",
		Question = "O drone deve patrulhar 5 vezes. Corrija o loop.",
		GlitchedCode = "for i = 1, 3 do patrol() end",
		TargetCode = "for i = 1, 5 do patrol() end",
		XPReward = 750
	},
	{
		ID = "logic_03_table",
		Category = "Tables",
		Question = "Acesse o 'Dano' da tabela de fragmento.",
		GlitchedCode = "local d = fragment.hp",
		TargetCode = "local d = fragment.damage",
		XPReward = 1000
	}
}

-- Logic Hack System
local function startLogicHack(player, challengeID)
	local challenge = nil
	for _, c in ipairs(CHALLENGES) do
		if c.ID == challengeID then
			challenge = c
			break
		end
	end
	
	if not challenge then return end
	
	-- In a real scenario, this would fire a RemoteEvent to the Client UI
	-- For this spec, we simulate the interaction on the Server
	print(string.format("[LogicHeist] Player %s started challenge: %s", player.Name, challenge.Category))
	print(string.format("Glitch: %s", challenge.GlitchedCode))
end

local function solveLogicHack(player, challengeID, submittedCode)
	local challenge = nil
	for _, c in ipairs(CHALLENGES) do
		if c.ID == challengeID then
			challenge = c
			break
		end
	end
	
	if not challenge then return end
	
	if submittedCode == challenge.TargetCode then
		print(string.format("[LogicHeist] SUCCESS! Player %s solved %s", player.Name, challengeID))
		
		-- Apply Rewards
		player:SetAttribute("PoL_XP", (player:GetAttribute("PoL_XP") or 0) + challenge.XPReward)
		
		-- Apply PoL Multiplier (Proof of Learning Effect)
		local currentMult = player:GetAttribute("XPMultiplier") or 1
		player:SetAttribute("XPMultiplier", currentMult + 0.05) -- +5% per successful hack
		
		return true
	else
		print(string.format("[LogicHeist] FAILURE. Player %s failed %s", player.Name, challengeID))
		return false
	end
end

-- Example usage (Connecting to a ProximityPrompt on a terminal item)
-- This would be expanded into a generic Interaction System
local function onTerminalActivated(player, terminalPart)
	local challengeID = terminalPart:GetAttribute("ChallengeID") or "logic_01_if"
	startLogicHack(player, challengeID)
end

-- Remote Integration (Placeholder for UI)
-- game.ReplicatedStorage.RemoteEvents.SubmitHack.OnServerEvent:Connect(solveLogicHack)

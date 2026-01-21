--[[
    NEO-ARK: LogicHackUI
    Author: EZ-Studios (Sovereign Engine)
    Description: Handles the visual interface for code-based puzzles.
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")
local Events = ReplicatedStorage:WaitForChild("NeoArkaia_Shared"):WaitForChild("Events")
local SubmitHackEvent = Events:WaitForChild("SubmitHack")

-- UI Configuration
local TERMINAL_COLOR = Color3.fromHex("#39FF14") -- Neon Green
local ERROR_COLOR = Color3.fromHex("#FF3131") -- Neon Red
local FONT = Enum.Font.Code

local function createLogicHackUI(challengeData)
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "LogicHackConsole"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = PlayerGui

    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.fromScale(0.6, 0.6)
    mainFrame.Position = UDim2.fromScale(0.5, 0.5)
    mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    mainFrame.BackgroundColor3 = Color3.new(0.05, 0.05, 0.05)
    mainFrame.BorderSizePixel = 2
    mainFrame.BorderColor3 = TERMINAL_COLOR
    mainFrame.Parent = screenGui

    local title = Instance.new("TextLabel")
    title.Size = UDim2.fromScale(1, 0.1)
    title.Position = UDim2.fromScale(0, 0)
    title.BackgroundTransparency = 1
    title.Text = "/// LOGIC_HACK: " .. challengeData.Category
    title.TextColor3 = TERMINAL_COLOR
    title.Font = FONT
    title.TextSize = 20
    title.Parent = mainFrame

    local questionLabel = Instance.new("TextLabel")
    questionLabel.Size = UDim2.fromScale(0.9, 0.15)
    questionLabel.Position = UDim2.fromScale(0.05, 0.15)
    questionLabel.BackgroundTransparency = 1
    questionLabel.Text = challengeData.Question
    questionLabel.TextColor3 = Color3.new(0.8, 0.8, 0.8)
    questionLabel.Font = FONT
    questionLabel.TextSize = 16
    questionLabel.TextWrapped = true
    questionLabel.Parent = mainFrame

    local codeBox = Instance.new("TextBox")
    codeBox.Size = UDim2.fromScale(0.9, 0.4)
    codeBox.Position = UDim2.fromScale(0.05, 0.35)
    codeBox.BackgroundColor3 = Color3.new(0, 0, 0)
    codeBox.TextColor3 = TERMINAL_COLOR
    codeBox.Font = FONT
    codeBox.TextSize = 18
    codeBox.TextXAlignment = Enum.TextXAlignment.Left
    codeBox.TextYAlignment = Enum.TextYAlignment.Top
    codeBox.ClearTextOnFocus = false
    codeBox.MultiLine = true
    codeBox.Text = challengeData.GlitchedCode
    codeBox.Parent = mainFrame

    local submitButton = Instance.new("TextButton")
    submitButton.Size = UDim2.fromScale(0.4, 0.1)
    submitButton.Position = UDim2.fromScale(0.3, 0.85)
    submitButton.BackgroundColor3 = TERMINAL_COLOR
    submitButton.TextColor3 = Color3.new(0, 0, 0)
    submitButton.Font = FONT
    submitButton.TextSize = 18
    submitButton.Text = "[ EXECUTE_FIX ]"
    submitButton.Parent = mainFrame

    submitButton.MouseButton1Click:Connect(function()
        local result = SubmitHackEvent:InvokeServer(challengeData.ID, codeBox.Text)
        
        if result then
            submitButton.Text = "HACK_SUCCESSFUL"
            submitButton.BackgroundColor3 = Color3.new(0, 1, 0)
            task.wait(1)
            screenGui:Destroy()
        else
            submitButton.Text = "SYNTAX_ERROR_RETRY"
            mainFrame.BorderColor3 = ERROR_COLOR
            task.delay(1, function()
                submitButton.Text = "[ EXECUTE_FIX ]"
                mainFrame.BorderColor3 = TERMINAL_COLOR
            end)
        end
    end)

    return screenGui
end

-- Global API for starting hacks
_G.StartLogicHack = function(challengeData)
    createLogicHackUI(challengeData)
end

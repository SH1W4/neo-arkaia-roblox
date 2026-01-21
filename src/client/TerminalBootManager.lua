--[[
    NEO-ARK: TerminalBootManager
    Author: EZ-Studios (Sovereign Engine)
    Description: Handles the immersive ASCII boot intro and transition.
]]

local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

-- Configuration
local BOOT_SPEED = 0.05
local GLITCH_INTENSITY = 0.1
local TERMINAL_FONT = Enum.Font.Code

-- ASCII Frames (Synchronizer Mask - Pseudo 3D Rotation)
local MASK_FRAMES = {
    -- Frame 1: Center
    [[
          _____________________
         /                     \
        /   _________________   \
       /   /                 \   \
      /   /   |   SYMBEON   |   \   \
     /   /    |____ARK_____|    \   \
     \   \                     /   /
      \   \___________________/   /
       \                         /
        \_______________________/
    ]],
    
    -- Frame 2: Slight Right
    [[
           ____________________
          /                    \
         /   _________________  \
        /   /                 \  \
       /   /   |   SYMBEON   |  \  \
      /   /    |____ARK_____|   \  \
      \   \                    /  /
       \   \__________________/  /
        \                       /
         \_____________________/
    ]],

    -- Frame 3: Slight Left
    [[
       ____________________
      /                    \
     /  _________________   \
    /  /                 \   \
   /  /   |   SYMBEON   |   \   \
  /  /    |____ARK_____|    \   \
  \  \                     /   /
   \  \___________________/   /
    \                        /
     \______________________/
    ]]
}

local SYSTEM_LOGS = {
    "> BOOTING AION_CORE V1.2.4...",
    "> LOADING VIRTUAL_VOXELS...",
    "> SYNCING CONSCIOUSNESS [98%]...",
    "> PROTOCOLO_CALIBRACAO: ATIVO",
    "> PRESSIONE [QUALQUER TECLA] PARA INJETAR"
}

-- UI Creation
local function createTerminalUI()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "TerminalBoot"
    screenGui.IgnoreGuiInset = true
    screenGui.Parent = PlayerGui

    local frame = Instance.new("Frame")
    frame.Size = UDim2.fromScale(1, 1)
    frame.BackgroundColor3 = Color3.new(0, 0, 0)
    frame.Parent = screenGui

    local maskLabel = Instance.new("TextLabel")
    maskLabel.Name = "MaskASCII"
    maskLabel.Size = UDim2.fromScale(0.8, 0.6)
    maskLabel.Position = UDim2.fromScale(0.5, 0.4)
    maskLabel.AnchorPoint = Vector2.new(0.5, 0.5)
    maskLabel.BackgroundTransparency = 1
    maskLabel.TextColor3 = Color3.fromHex("#39FF14") -- Neon Green
    maskLabel.Font = TERMINAL_FONT
    maskLabel.TextSize = 14
    maskLabel.RichText = true
    maskLabel.Text = ""
    maskLabel.Parent = frame

    local logsLabel = Instance.new("TextLabel")
    logsLabel.Name = "SystemLogs"
    logsLabel.Size = UDim2.fromScale(0.8, 0.2)
    logsLabel.Position = UDim2.fromScale(0.5, 0.8)
    logsLabel.AnchorPoint = Vector2.new(0.5, 0.5)
    logsLabel.BackgroundTransparency = 1
    logsLabel.TextColor3 = Color3.fromHex("#39FF14")
    logsLabel.Font = TERMINAL_FONT
    logsLabel.TextSize = 18
    logsLabel.Text = ""
    logsLabel.Parent = frame

    return screenGui, maskLabel, logsLabel
end

local function typewriterEffect(label, text)
    for i = 1, #text do
        label.Text = string.sub(text, 1, i)
        task.wait(BOOT_SPEED)
    end
end

local function playBootSequence()
    local gui, mask, logs = createTerminalUI()
    
    -- Phase 1: Logs
    for _, log in ipairs(SYSTEM_LOGS) do
        typewriterEffect(logs, log)
        task.wait(0.2)
    end

    -- Phase 2: ASCII Animation
    local animating = true
    task.spawn(function()
        local frameIndex = 1
        while animating do
            mask.Text = MASK_FRAMES[frameIndex]
            frameIndex = (frameIndex % #MASK_FRAMES) + 1
            
            -- Glitch effect
            if math.random() < GLITCH_INTENSITY then
                mask.TextTransparency = 0.5
                task.wait(0.05)
                mask.TextTransparency = 0
            end
            
            task.wait(0.1)
        end
    end)

    -- Phase 3: Wait for interaction
    local connection
    connection = game:GetService("UserInputService").InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Keyboard or input.UserInputType == Enum.UserInputType.MouseButton1 then
            animating = false
            connection:Disconnect()
            
            -- Stage transition
            logs.Text = "> INTRUSION AUTHORIZED. DIVING..."
            task.wait(0.5)
            
            -- Fade out and transition to 3D
            local tween = TweenService:Create(gui.Frame, TweenInfo.new(1), {BackgroundTransparency = 1})
            local tweenText = TweenService:Create(mask, TweenInfo.new(1), {TextTransparency = 1})
            local tweenLogs = TweenService:Create(logs, TweenInfo.new(1), {TextTransparency = 1})
            
            tween:Play()
            tweenText:Play()
            tweenLogs:Play()
            
            tween.Completed:Wait()
            gui:Destroy()
            
            -- Trigger server event to start Calibration
            game.ReplicatedStorage:WaitForChild("Events"):WaitForChild("StartCalibration"):FireServer()
        end
    end)
end

-- Initialize on spawn
task.wait(1)
playBootSequence()

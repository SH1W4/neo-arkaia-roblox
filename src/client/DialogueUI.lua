-- ==========================================
-- NEO-ARK: DIALOGUE UI SYSTEM
-- EZ-FUNDATION | Protocol Symbeon
-- ==========================================

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RepStorage = game:GetService("ReplicatedStorage")
local SharedModules = RepStorage:WaitForChild("NeoArkaia_Shared"):WaitForChild("Modules")
local Events = RepStorage.NeoArkaia_Shared:WaitForChild("Events")

-- Localização corrigida do InkRuntime (Shared)
local InkRuntime = require(SharedModules:WaitForChild("InkRuntime"))

-- RemoteEvents
local ShowDialogueEvent = Events:WaitForChild("ShowDialogue")
local ChoiceSelectedEvent = Events:WaitForChild("ChoiceSelected")

local DialogueUI = {}

-- 1. CRIAR UI DE DIÁLOGO
function DialogueUI:CreateDialogueUI(player)
    local playerGui = player:WaitForChild("PlayerGui")
    
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "DialogueUI"
    screenGui.ResetOnSpawn = false
    screenGui.Enabled = false
    screenGui.Parent = playerGui
    
    -- Frame Principal (Glassmorphism)
    local dialogueFrame = Instance.new("Frame")
    dialogueFrame.Name = "DialogueFrame"
    dialogueFrame.Position = UDim2.new(0.15, 0, 0.65, 0)
    dialogueFrame.Size = UDim2.new(0.7, 0, 0.3, 0)
    dialogueFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    dialogueFrame.BackgroundTransparency = 0.3
    dialogueFrame.BorderSizePixel = 0
    dialogueFrame.Parent = screenGui
    
    -- Borda Neon
    local border = Instance.new("UIStroke")
    border.Color = Color3.fromRGB(123, 44, 191) -- Ultravioleta
    border.Thickness = 2
    border.Parent = dialogueFrame
    
    -- Nome do NPC
    local npcName = Instance.new("TextLabel")
    npcName.Name = "NPCName"
    npcName.Position = UDim2.new(0.02, 0, 0.05, 0)
    npcName.Size = UDim2.new(0.3, 0, 0.15, 0)
    npcName.BackgroundTransparency = 1
    npcName.Text = "HIEROFANTE"
    npcName.TextColor3 = Color3.fromRGB(123, 44, 191)
    npcName.TextScaled = true
    npcName.Font = Enum.Font.Code
    npcName.TextXAlignment = Enum.TextXAlignment.Left
    npcName.Parent = dialogueFrame
    
    -- Texto do Diálogo
    local dialogueText = Instance.new("TextLabel")
    dialogueText.Name = "DialogueText"
    dialogueText.Position = UDim2.new(0.02, 0, 0.25, 0)
    dialogueText.Size = UDim2.new(0.96, 0, 0.4, 0)
    dialogueText.BackgroundTransparency = 1
    dialogueText.Text = ""
    dialogueText.TextColor3 = Color3.fromRGB(255, 255, 255)
    dialogueText.TextSize = 18
    dialogueText.Font = Enum.Font.Code
    dialogueText.TextXAlignment = Enum.TextXAlignment.Left
    dialogueText.TextYAlignment = Enum.TextYAlignment.Top
    dialogueText.TextWrapped = true
    dialogueText.Parent = dialogueFrame
    
    -- Container de Escolhas
    local choicesContainer = Instance.new("Frame")
    choicesContainer.Name = "ChoicesContainer"
    choicesContainer.Position = UDim2.new(0.02, 0, 0.7, 0)
    choicesContainer.Size = UDim2.new(0.96, 0, 0.25, 0)
    choicesContainer.BackgroundTransparency = 1
    choicesContainer.Parent = dialogueFrame
    
    return screenGui
end

-- 2. MOSTRAR DIÁLOGO
function DialogueUI:ShowDialogue(player, npcName, text, choices)
    local dialogueUI = player.PlayerGui:FindFirstChild("DialogueUI")
    if not dialogueUI then
        dialogueUI = self:CreateDialogueUI(player)
    end
    
    dialogueUI.Enabled = true
    
    local frame = dialogueUI.DialogueFrame
    frame.NPCName.Text = npcName
    
    -- Efeito de digitação
    self:TypewriterEffect(frame.DialogueText, text)
    
    -- Criar botões de escolha
    task.wait(text:len() * 0.02) -- Esperar digitação terminar
    self:CreateChoiceButtons(player, frame.ChoicesContainer, choices)
end

-- 3. EFEITO DE DIGITAÇÃO
function DialogueUI:TypewriterEffect(textLabel, fullText)
    textLabel.Text = ""
    
    task.spawn(function()
        for i = 1, #fullText do
            textLabel.Text = string.sub(fullText, 1, i)
            task.wait(0.02)
        end
    end)
end

-- 4. CRIAR BOTÕES DE ESCOLHA
function DialogueUI:CreateChoiceButtons(player, container, choices)
    -- Limpar escolhas anteriores
    for _, child in pairs(container:GetChildren()) do
        child:Destroy()
    end
    
    for i, choice in ipairs(choices) do
        local button = Instance.new("TextButton")
        button.Name = "Choice" .. i
        button.Size = UDim2.new(1, 0, 0, 30)
        button.Position = UDim2.new(0, 0, 0, (i - 1) * 35)
        button.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
        button.BackgroundTransparency = 0.5
        button.BorderSizePixel = 0
        button.Text = "▶ " .. choice.text
        button.TextColor3 = Color3.fromRGB(57, 255, 20) -- Verde Neon
        button.TextSize = 16
        button.Font = Enum.Font.Code
        button.TextXAlignment = Enum.TextXAlignment.Left
        button.Parent = container
        
        -- Hover effect
        button.MouseEnter:Connect(function()
            button.BackgroundColor3 = Color3.fromRGB(123, 44, 191)
        end)
        
        button.MouseLeave:Connect(function()
            button.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
        end)
        
        -- Click event
        button.MouseButton1Click:Connect(function()
            self:OnChoiceSelected(player, choice.index)
        end)
    end
end

-- 5. PROCESSAR ESCOLHA
function DialogueUI:OnChoiceSelected(player, choiceIndex)
    print("[DIALOGUE]: Enviando escolha " .. choiceIndex .. " para o servidor.")
    
    -- Notificar Servidor
    ChoiceSelectedEvent:FireServer(choiceIndex)
    
    -- Fechar UI temporariamente ou aguardar resposta
    local dialogueUI = player.PlayerGui:FindFirstChild("DialogueUI")
    if dialogueUI then
        dialogueUI.Enabled = false
    end
end

-- 6. FECHAR DIÁLOGO
function DialogueUI:CloseDialogue(player)
    local dialogueUI = player.PlayerGui:FindFirstChild("DialogueUI")
    if dialogueUI then
        dialogueUI.Enabled = false
    end
end

-- 7. INICIALIZAR EVENTOS NO CLIENTE
function DialogueUI:Initialize()
    ShowDialogueEvent.OnClientEvent:Connect(function(npcName, text, choices)
        local player = Players.LocalPlayer
        if not npcName or not text then
            self:CloseDialogue(player)
            return
        end
        self:ShowDialogue(player, npcName, text, choices)
    end)
end

DialogueUI:Initialize()

return DialogueUI

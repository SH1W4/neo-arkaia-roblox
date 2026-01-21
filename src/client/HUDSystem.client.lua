-- ==========================================
-- NEO-ARK: HUD SYSTEM (SYNCHRONIZER INTERFACE)
-- EZ-FUNDATION | Protocol Symbeon
-- ==========================================

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local HUDSystem = {}

-- 1. CRIAR HUD PARA JOGADOR
function HUDSystem:CreateHUD(player)
    local playerGui = player:WaitForChild("PlayerGui")
    
    -- Screen GUI Principal
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "SynchronizerHUD"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = playerGui
    
    -- Frame Principal (Glassmorphism)
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainHUD"
    mainFrame.Size = UDim2.new(1, 0, 1, 0)
    mainFrame.BackgroundTransparency = 1
    mainFrame.Parent = screenGui
    
    -- BARRA DE VIDA (Top Left)
    local healthBar = Instance.new("Frame")
    healthBar.Name = "HealthBar"
    healthBar.Position = UDim2.new(0.02, 0, 0.02, 0)
    healthBar.Size = UDim2.new(0.25, 0, 0.03, 0)
    healthBar.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    healthBar.BackgroundTransparency = 0.3
    healthBar.BorderSizePixel = 0
    healthBar.Parent = mainFrame
    
    local healthFill = Instance.new("Frame")
    healthFill.Name = "Fill"
    healthFill.Size = UDim2.new(1, 0, 1, 0)
    healthFill.BackgroundColor3 = Color3.fromRGB(57, 255, 20) -- Verde Neon
    healthFill.BorderSizePixel = 0
    healthFill.Parent = healthBar
    
    -- CONTADOR DE EB (Top Right)
    local ebCounter = Instance.new("TextLabel")
    ebCounter.Name = "EBCounter"
    ebCounter.Position = UDim2.new(0.73, 0, 0.02, 0)
    ebCounter.Size = UDim2.new(0.25, 0, 0.05, 0)
    ebCounter.BackgroundTransparency = 1
    ebCounter.Text = "EB: 0"
    ebCounter.TextColor3 = Color3.fromRGB(123, 44, 191) -- Ultravioleta Symbeon
    ebCounter.TextScaled = true
    ebCounter.Font = Enum.Font.Code
    ebCounter.Parent = mainFrame
    
    -- FEED DE CONVERGÊNCIA (Bottom Center)
    local convergenceFeed = Instance.new("ScrollingFrame")
    convergenceFeed.Name = "ConvergenceFeed"
    convergenceFeed.Position = UDim2.new(0.3, 0, 0.85, 0)
    convergenceFeed.Size = UDim2.new(0.4, 0, 0.12, 0)
    convergenceFeed.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    convergenceFeed.BackgroundTransparency = 0.5
    convergenceFeed.BorderSizePixel = 0
    convergenceFeed.ScrollBarThickness = 4
    convergenceFeed.Parent = mainFrame
    
    return screenGui
end

-- 2. ATUALIZAR VIDA
function HUDSystem:UpdateHealth(player, currentHealth, maxHealth)
    local hud = player.PlayerGui:FindFirstChild("SynchronizerHUD")
    if not hud then return end
    
    local healthFill = hud.MainHUD.HealthBar.Fill
    local targetSize = UDim2.new(currentHealth / maxHealth, 0, 1, 0)
    
    local tween = TweenService:Create(healthFill, TweenInfo.new(0.3), {Size = targetSize})
    tween:Play()
end

-- 3. ATUALIZAR EB
function HUDSystem:UpdateEB(player, amount)
    local hud = player.PlayerGui:FindFirstChild("SynchronizerHUD")
    if not hud then return end
    
    local ebCounter = hud.MainHUD.EBCounter
    ebCounter.Text = "EB: " .. tostring(amount)
end

-- 4. ADICIONAR ITEM AO FEED DE CONVERGÊNCIA
function HUDSystem:AddToConvergenceFeed(player, itemName, serverID, progress)
    local hud = player.PlayerGui:FindFirstChild("SynchronizerHUD")
    if not hud then return end
    
    local feed = hud.MainHUD.ConvergenceFeed
    
    local feedItem = Instance.new("TextLabel")
    feedItem.Size = UDim2.new(1, 0, 0, 30)
    feedItem.BackgroundTransparency = 1
    feedItem.Text = string.format("[Node %s] Compilando: %s (%d%%)", serverID, itemName, progress)
    feedItem.TextColor3 = Color3.fromRGB(255, 0, 110) -- Magenta
    feedItem.Font = Enum.Font.Code
    feedItem.TextScaled = true
    feedItem.Parent = feed
end

return HUDSystem

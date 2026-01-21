-- ==========================================
-- NEO-ARK: NPC INTERACTION CONTROLLER
-- EZ-FUNDATION | Protocol Symbeon
-- Conecta Ink Runtime com NPCs no mundo
-- ==========================================

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ProximityPromptService = game:GetService("ProximityPromptService")

local RepStorage = game:GetService("ReplicatedStorage")
local SharedModules = RepStorage:WaitForChild("NeoArkaia_Shared"):WaitForChild("Modules")
local Events = RepStorage.NeoArkaia_Shared:WaitForChild("Events")

local InkRuntime = require(SharedModules:WaitForChild("InkRuntime"))

-- RemoteEvents para comunicação Client-Server
local ShowDialogueEvent = Events:FindFirstChild("ShowDialogue") or Instance.new("RemoteEvent", Events)
ShowDialogueEvent.Name = "ShowDialogue"

local ChoiceSelectedEvent = Events:FindFirstChild("ChoiceSelected") or Instance.new("RemoteEvent", Events)
ChoiceSelectedEvent.Name = "ChoiceSelected"

local NPCController = {}
NPCController.activeStories = {}

-- 1. CONFIGURAR NPC COM HISTÓRIA INK
function NPCController:SetupNPC(npcModel, storyName, knotName)
    -- Criar ProximityPrompt
    local prompt = Instance.new("ProximityPrompt")
    prompt.ActionText = "Conversar"
    prompt.ObjectText = npcModel.Name
    prompt.MaxActivationDistance = 10
    prompt.Parent = npcModel.PrimaryPart or npcModel:FindFirstChild("HumanoidRootPart")
    
    -- Conectar evento
    prompt.Triggered:Connect(function(player)
        self:StartDialogue(player, npcModel.Name, storyName, knotName)
    end)
    
    print("[NPC]: " .. npcModel.Name .. " configurado com história: " .. storyName)
end

-- 2. INICIAR DIÁLOGO
function NPCController:StartDialogue(player, npcName, storyName, knotName)
    -- Carregar história compilada
    local storyJson = self:LoadStory(storyName)
    if not storyJson then
        warn("[NPC]: História não encontrada: " .. storyName)
        return
    end
    
    -- Criar runtime
    local runtime = InkRuntime.new(storyJson)
    
    -- Sincronizar variáveis do jogador
    self:SyncPlayerVariables(player, runtime)
    
    -- Iniciar história
    local result = runtime:Start(knotName)
    
    if result then
        -- Armazenar runtime ativo
        self.activeStories[player.UserId] = runtime
        
        -- Disparar evento para o Cliente mostrar a UI
        ShowDialogueEvent:FireClient(player, npcName, result.text, result.choices)
    end
end

-- 3. CARREGAR HISTÓRIA COMPILADA
function NPCController:LoadStory(storyName)
    local RepStorage = game:GetService("ReplicatedStorage")
    local storiesFolder = RepStorage:FindFirstChild("NeoArkaia_Shared") 
                          and RepStorage.NeoArkaia_Shared:FindFirstChild("Narratives")
                          and RepStorage.NeoArkaia_Shared.Narratives:FindFirstChild("Compiled")
    
    if not storiesFolder then
        warn("[NPC]: Pasta Narratives/Compiled (NeoArkaia_Shared) não encontrada!")
        return nil
    end
    
    local storyModule = storiesFolder:FindFirstChild(storyName)
    if not storyModule then
        warn("[NPC]: Módulo de história '" .. storyName .. "' não encontrado.")
        return nil
    end
    
    -- Assumindo que o módulo retorna o JSON como string
    return require(storyModule)
end

-- 4. SINCRONIZAR VARIÁVEIS DO JOGADOR
function NPCController:SyncPlayerVariables(player, runtime)
    -- Importar EconomyManager do mesmo diretório
    local EconomyManager = require(script.Parent:WaitForChild("EconomyManager"))
    local eb = EconomyManager:GetPlayerEB(player)
    
    runtime:SetVariable("eb_balance", eb)
    runtime:SetVariable("player_name", player.Name)
end

-- 5. HANDLER DE ESCOLHAS (Via RemoteEvent)
function NPCController:InitializeEvents()
    ChoiceSelectedEvent.OnServerEvent:Connect(function(player, choiceIndex)
        local runtime = self.activeStories[player.UserId]
        if not runtime then return end
        
        -- Processar escolha no Ink
        local result = runtime:ChooseChoice(choiceIndex)
        
        if result then
            -- Continuar diálogo no Cliente
            ShowDialogueEvent:FireClient(player, "Hierofante", result.text, result.choices)
            
            -- Sincronizar variáveis de volta ao jogador
            self:ApplyVariablesToPlayer(player, runtime)
        else
            -- Fim do diálogo (disparar evento vazio ou nil para fechar)
            ShowDialogueEvent:FireClient(player, nil, nil, nil)
            self.activeStories[player.UserId] = nil
        end
    end)
end

-- Inicializar escuta de eventos
NPCController:InitializeEvents()

-- 6. APLICAR VARIÁVEIS AO JOGADOR
function NPCController:ApplyVariablesToPlayer(player, runtime)
    local EconomyManager = require(script.Parent:WaitForChild("EconomyManager"))
    
    -- Atualizar EB
    local newEB = runtime:GetVariable("eb_balance")
    if newEB then
        EconomyManager:SetPlayerEB(player, newEB)
    end
    
    -- Atualizar missões
    local mission_sector7 = runtime:GetVariable("mission_sector7_active")
    if mission_sector7 ~= nil then
        player:SetAttribute("Mission_Sector7", mission_sector7)
    end
    
    -- Atualizar itens (Caminho corrigido)
    local has_binary_blade = runtime:GetVariable("has_binary_blade")
    if has_binary_blade then
        local ItemSystem = require(SharedModules:WaitForChild("ItemSystem"))
        ItemSystem:GiveItem(player, "BinaryBlade")
    end
end

-- 7. EXEMPLO DE USO
--[[
    -- No ServerScriptService:
    local NPCController = require(game.ServerScriptService.NeoArkaiaScripts.NPCController)
    
    local architectNPC = workspace.NPCs.Architect
    NPCController:SetupNPC(architectNPC, "architect_story", "meet_architect")
]]

return NPCController

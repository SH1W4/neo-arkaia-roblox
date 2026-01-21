-- ==========================================
-- NEO-ARK: INK RUNTIME (NARRATIVE ENGINE)
-- EZ-FUNDATION | Protocol Symbeon
-- ==========================================

local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local InkRuntime = {}
InkRuntime.__index = InkRuntime

-- 1. CRIAR NOVA INSTÂNCIA DE HISTÓRIA
function InkRuntime.new(storyJsonString)
    local self = setmetatable({}, InkRuntime)
    
    self.story = HttpService:JSONDecode(storyJsonString)
    self.currentKnot = nil
    self.variables = {}
    self.visitCounts = {}
    
    return self
end

-- 2. INICIAR HISTÓRIA
function InkRuntime:Start(knotName)
    knotName = knotName or "main_story"
    self.currentKnot = knotName
    return self:Continue()
end

-- 3. CONTINUAR NARRATIVA
function InkRuntime:Continue()
    if not self.currentKnot then
        return nil
    end
    
    local knot = self.story[self.currentKnot]
    if not knot then
        warn("[INK]: Knot não encontrado: " .. self.currentKnot)
        return nil
    end
    
    -- Incrementar contador de visitas
    self.visitCounts[self.currentKnot] = (self.visitCounts[self.currentKnot] or 0) + 1
    
    -- Processar texto
    local text = self:ProcessText(knot.text)
    
    -- Processar escolhas
    local choices = self:ProcessChoices(knot.choices or {})
    
    return {
        text = text,
        choices = choices,
        tags = knot.tags or {}
    }
end

-- 4. PROCESSAR TEXTO (SUBSTITUIR VARIÁVEIS)
function InkRuntime:ProcessText(text)
    if not text then return "" end
    
    -- Substituir {variable}
    text = string.gsub(text, "{(%w+)}", function(varName)
        return tostring(self.variables[varName] or "")
    end)
    
    -- Processar condicionais {condition: text}
    text = string.gsub(text, "{([^:]+):([^}]+)}", function(condition, conditionalText)
        if self:EvaluateCondition(condition) then
            return conditionalText
        else
            return ""
        end
    end)
    
    return text
end

-- 5. PROCESSAR ESCOLHAS
function InkRuntime:ProcessChoices(choicesData)
    local validChoices = {}
    
    for i, choice in ipairs(choicesData) do
        -- Verificar condição
        if not choice.condition or self:EvaluateCondition(choice.condition) then
            table.insert(validChoices, {
                index = i,
                text = choice.text,
                target = choice.target
            })
        end
    end
    
    return validChoices
end

-- 6. FAZER ESCOLHA
function InkRuntime:ChooseChoice(choiceIndex)
    local knot = self.story[self.currentKnot]
    if not knot or not knot.choices then
        return nil
    end
    
    local choice = knot.choices[choiceIndex]
    if not choice then
        warn("[INK]: Escolha inválida: " .. choiceIndex)
        return nil
    end
    
    -- Executar comandos da escolha
    if choice.commands then
        for _, cmd in ipairs(choice.commands) do
            self:ExecuteCommand(cmd)
        end
    end
    
    -- Ir para o próximo knot
    self.currentKnot = choice.target
    
    return self:Continue()
end

-- 7. AVALIAR CONDIÇÃO
function InkRuntime:EvaluateCondition(condition)
    -- Suporte básico para condições
    -- Exemplo: "eb_balance >= 5000"
    
    local var, op, value = string.match(condition, "(%w+)%s*([><=!]+)%s*(%d+)")
    
    if not var then
        -- Condição booleana simples
        return self.variables[condition] == true
    end
    
    local varValue = tonumber(self.variables[var]) or 0
    value = tonumber(value)
    
    if op == ">=" then
        return varValue >= value
    elseif op == "<=" then
        return varValue <= value
    elseif op == ">" then
        return varValue > value
    elseif op == "<" then
        return varValue < value
    elseif op == "==" then
        return varValue == value
    elseif op == "!=" then
        return varValue ~= value
    end
    
    return false
end

-- 8. EXECUTAR COMANDO
function InkRuntime:ExecuteCommand(command)
    -- Exemplo: "~ eb_balance += 2500"
    local var, op, value = string.match(command, "~%s*(%w+)%s*([+%-=]+)%s*(%d+)")
    
    if var and op and value then
        value = tonumber(value)
        
        if op == "=" then
            self.variables[var] = value
        elseif op == "+=" then
            self.variables[var] = (self.variables[var] or 0) + value
        elseif op == "-=" then
            self.variables[var] = (self.variables[var] or 0) - value
        end
        
        print("[INK]: Variável atualizada: " .. var .. " = " .. self.variables[var])
    else
        -- Comando booleano: "~ mission_active = true"
        local boolVar, boolValue = string.match(command, "~%s*(%w+)%s*=%s*(%w+)")
        if boolVar then
            self.variables[boolVar] = (boolValue == "true")
        end
    end
end

-- 9. OBTER VARIÁVEL
function InkRuntime:GetVariable(name)
    return self.variables[name]
end

-- 10. DEFINIR VARIÁVEL
function InkRuntime:SetVariable(name, value)
    self.variables[name] = value
end

return InkRuntime

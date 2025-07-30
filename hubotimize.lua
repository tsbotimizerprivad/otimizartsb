-- Menu de Otimização TSB Seguro (não toca no personagem ou controles)

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local Lighting = game:GetService("Lighting")
local Terrain = workspace:FindFirstChildOfClass("Terrain")
local UserInputService = game:GetService("UserInputService")

local gui = Instance.new("ScreenGui", PlayerGui)
gui.Name = "TSBOptMenu"
gui.ResetOnSpawn = false

-- Botão flutuante abrir menu
local openBtn = Instance.new("TextButton")
openBtn.Size = UDim2.new(0, 100, 0, 40)
openBtn.Position = UDim2.new(0, 20, 0.5, -20)
openBtn.Text = "🔧 Menu"
openBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
openBtn.TextColor3 = Color3.new(1, 1, 1)
openBtn.TextScaled = true
openBtn.Parent = gui

-- Painel principal
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 250, 0, 220)
frame.Position = UDim2.new(0, 150, 0.4, -110)
frame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
frame.Visible = false

-- Título e fechar
local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 40)
title.Position = UDim2.new(0,0,0,0)
title.Text = "Otimizar TSB"
title.TextScaled = true
title.TextColor3 = Color3.fromRGB(255,255,255)
title.BackgroundTransparency = 1

local closeBtn = Instance.new("TextButton", frame)
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -35, 0, 5)
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.fromRGB(255, 0, 0)
closeBtn.BackgroundColor3 = Color3.fromRGB(70,70,70)
closeBtn.TextScaled = true

-- Função para mover o menu (touch e mouse)
local dragging, dragInput, dragStart, startPos
local function updateInput(input)
    local delta = input.Position - dragStart
    frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
                                startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = frame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

frame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and input == dragInput then updateInput(input) end
end)

-- Funções de otimização — Só mapa, sem mexer no personagem
local function otimizarLeve()
    -- Remove partículas pesadas e trilhas
    for _, v in ipairs(workspace:GetDescendants()) do
        if v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Smoke") or v:IsA("Fire") then
            v.Enabled = false
        elseif v:IsA("Light") then
            v.Enabled = false
        elseif v:IsA("Decal") or v:IsA("Texture") then
            v.Transparency = 0.7 -- deixa mais leve, mas visível
        end
    end
    -- Reduz iluminação e sombras do mapa
    Lighting.GlobalShadows = false
    Lighting.FogEnd = 5000
    Lighting.Brightness = 1
    if Terrain then
        Terrain.WaterWaveSize = 0
        Terrain.WaterWaveSpeed = 0
        Terrain.WaterReflectance = 0
        Terrain.WaterTransparency = 0.5
    end
    -- Notificação
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "TSB",
        Text = "Otimização leve aplicada!",
        Duration = 3
    })
end

local function otimizarMedia()
    otimizarLeve()
    -- Apaga texturas e decals desnecessários
    for _, v in ipairs(workspace:GetDescendants()) do
        if v:IsA("Decal") or v:IsA("Texture") then
            v.Transparency = 1
        elseif v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Smoke") or v:IsA("Fire") then
            v.Enabled = false
        elseif v:IsA("Light") then
            v.Enabled = false
        end
    end
    -- Diminuir um pouco mais a iluminação
    Lighting.Brightness = 0.5
    Lighting.FogEnd = 2000
    -- Notificação
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "TSB",
        Text = "Otimização média aplicada!",
        Duration = 3
    })
end

local function otimizarPesada()
    otimizarMedia()
    -- Remove modelos decorativos para aumentar FPS (não toca personagem)
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("Model") and not obj:FindFirstChildWhichIsA("Humanoid") then
            local name = obj.Name:lower()
            if name:match("tree") or name:match("rock") or name:match("deco") or name:match("bush") then
                obj:Destroy()
            end
        end
    end
    -- Notificação
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "TSB",
        Text = "Otimização pesada aplicada!",
        Duration = 3
    })
end

-- Botões no menu
local btns = {
    {text="Otimização Leve", func=otimizarLeve, y=50},
    {text="Otimização Média", func=otimizarMedia, y=100},
    {text="Otimização Pesada", func=otimizarPesada, y=150},
    {text="Fechar Menu", func=function()
        frame.Visible = false
        openBtn.Visible = true
    end, y=200}
}

for _, info in ipairs(btns) do
    local b = Instance.new("TextButton", frame)
    b.Size = UDim2.new(1, -20, 0, 40)
    b.Position = UDim2.new(0, 10, 0, info.y)
    b.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    b.TextColor3 = Color3.fromRGB(255, 255, 255)
    b.Text = info.text
    b.TextScaled = true
    b.AutoButtonColor = true
    b.MouseButton1Click:Connect(info.func)
end

-- Mostrar/ocultar menu
openBtn.MouseButton1Click:Connect(function()
    frame.Visible = true
    openBtn.Visible = false
end)

closeBtn = Instance.new("TextButton", frame)
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -35, 0, 5)
closeBtn.Text = "✕"
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.TextScaled = true
closeBtn.MouseButton1Click:Connect(function()
    frame.Visible = false
    openBtn.Visible = true
end)

-- Permite mover o menu pelo mouse e toque
local dragging, dragInput, dragStart, startPos
local UserInputService = game:GetService("UserInputService")

local function updateInput(input)
    local delta = input.Position - dragStart
    frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
                                startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or
       input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = frame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

frame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or
       input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and input == dragInput then
        updateInput(input)
    end
end)

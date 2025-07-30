-- Menu de Otimização TSB (PC + Mobile) com mobilidade e reset
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local Lighting = game:GetService("Lighting")
local Terrain = workspace:FindFirstChildOfClass("Terrain")
local settings = settings
local gui = Instance.new("ScreenGui", PlayerGui)
gui.Name = "TSBOptMenu"
gui.ResetOnSpawn = false

-- Criar botão flutuante
local openBtn = Instance.new("TextButton")
openBtn.Size = UDim2.new(0, 100, 0, 40)
openBtn.Position = UDim2.new(0, 20, 0.5, -20)
openBtn.Text = "🔧 Menu"
openBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
openBtn.TextColor3 = Color3.new(1, 1, 1)
openBtn.TextScaled = true
openBtn.AutoButtonColor = false
openBtn.Parent = gui

-- Painel principal
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 250, 0, 300)
frame.Position = UDim2.new(0, 150, 0.4, -150)
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

-- Função de mover o menu
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

game:GetService("UserInputService").InputChanged:Connect(function(input)
    if dragging and input == dragInput then updateInput(input) end
end)

-- Funções de otimização

local function runOptim(level)
    local decalsyeeted = true
    -- Terreno
    if Terrain then
        Terrain.WaterWaveSize=0; Terrain.WaterWaveSpeed=0
        Terrain.WaterReflectance=0; Terrain.WaterTransparency=0
    end
    Lighting.GlobalShadows=false
    Lighting.FogEnd=1e10
    Lighting.Brightness=0
    pcall(function() settings().Rendering.QualityLevel = Enum.QualityLevel.Level01 end)
    for _,v in ipairs(game:GetService("Workspace"):GetDescendants()) do
        if v:IsA("Part") or v:IsA("Union") or v:IsA("MeshPart")
           or v:IsA("CornerWedgePart") or v:IsA("TrussPart") then
            v.Material = Enum.Material.Plastic
            v.Reflectance = 0
            v.CastShadow = false
        elseif v:IsA("Decal") or v:IsA("Texture") then
            if decalsyeeted then v.Transparency = 1 end
        elseif v:IsA("ParticleEmitter") or v:IsA("Trail")
               or v:IsA("Fire") or v:IsA("Smoke")
               or v:IsA("Sparkles") or v:IsA("Beam") then
            v:Destroy()
        elseif v:IsA("Explosion") then
            v.BlastPressure = 1; v.BlastRadius = 1
        elseif v:IsA("Light") then
            v.Enabled = false
        end
    end
    -- Efeitos de lighting
    for _,e in ipairs(Lighting:GetChildren()) do
        if e:IsA("BlurEffect") or e:IsA("SunRaysEffect")
           or e:IsA("ColorCorrectionEffect") or e:IsA("BloomEffect")
           or e:IsA("DepthOfFieldEffect") then
            e.Enabled = false
        end
    end
    -- Corrigir bug de sumir mãos: recolor apenas partes visuais do personagem
    local function recolorChar(char)
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                part.Color = Color3.fromRGB(30,30,30)
                part.Transparency = 0
            end
        end
    end
    local plr = Players.LocalPlayer
    if plr and plr.Character then recolorChar(plr.Character) end
    plr.CharacterAdded:Connect(function(char)
        char:WaitForChild("HumanoidRootPart")
        recolorChar(char)
    end)
    Players.LocalPlayer:Kick() -- remove respawn problemas? opcional
    if level=="Leve" then
        StarterGui:SetCore("SendNotification",{Title="TSB", Text="Otimização Leve aplicada", Duration=3})
    elseif level=="Média" then
        StarterGui:SetCore("SendNotification",{Title="TSB", Text="Otimização Média aplicada", Duration=3})
    elseif level=="Pesada" then
        StarterGui:SetCore("SendNotification",{Title="TSB", Text="Otimização Pesada aplicada", Duration=3})
    end
end

-- Botões níveis
local btns = {
    {text="Leve", offy=60},
    {text="Média", offy=110},
    {text="Pesada", offy=160},
    {text="Resetar", offy=210}
}

for _,info in ipairs(btns) do
    local b = Instance.new("TextButton", frame)
    b.Size = UDim2.new(1, -20, 0, 40)
    b.Position = UDim2.new(0,10,0,info.offy)
    b.Text = info.text
    b.BackgroundColor3 = Color3.fromRGB(85,85,85)
    b.TextColor3 = Color3.fromRGB(255,255,255)
    b.TextScaled = true
    b.MouseButton1Click:Connect(function()
        if info.text=="Resetar" then
            -- reiniciar jogo (para voltar à aparência original)
            Players.LocalPlayer:Kick("Resetando otimização para TSB original")
        else
            runOptim(info.text)
        end
    end)
end

-- Abrir e fechar
openBtn.MouseButton1Click:Connect(function()
    frame.Visible = true
    openBtn.Visible = false
end)
closeBtn.MouseButton1Click:Connect(function()
    frame.Visible = false
    openBtn.Visible = true
end)

-- Menu de Otimização para TSB (Mobile + PC)
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local StarterGui = game:GetService("StarterGui")
local TweenService = game:GetService("TweenService")

-- Criar GUI
local screenGui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
screenGui.Name = "TSBOtimizadorGui"
screenGui.ResetOnSpawn = false

-- Botão Flutuante (Minimizado)
local openButton = Instance.new("TextButton")
openButton.Size = UDim2.new(0, 120, 0, 40)
openButton.Position = UDim2.new(0, 10, 0.5, -20)
openButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
openButton.TextColor3 = Color3.new(1,1,1)
openButton.Text = "Abrir Menu"
openButton.TextScaled = true
openButton.Parent = screenGui

-- Painel Principal
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 250, 0, 200)
mainFrame.Position = UDim2.new(0, 10, 0.5, -100)
mainFrame.BackgroundColor3 = Color3.fromRGB(30,30,30)
mainFrame.Visible = false
mainFrame.Parent = screenGui

-- Botão Fechar
local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 30, 0, 30)
closeButton.Position = UDim2.new(1, -35, 0, 5)
closeButton.Text = "X"
closeButton.TextColor3 = Color3.new(1,0,0)
closeButton.BackgroundColor3 = Color3.fromRGB(40,40,40)
closeButton.Parent = mainFrame

-- Título
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -40, 0, 30)
title.Position = UDim2.new(0, 5, 0, 5)
title.Text = "Otimização TSB"
title.TextColor3 = Color3.new(1,1,1)
title.TextScaled = true
title.BackgroundTransparency = 1
title.Parent = mainFrame

-- Criar botões de otimização
local function createButton(text, yOffset, callback)
	local button = Instance.new("TextButton")
	button.Size = UDim2.new(1, -20, 0, 40)
	button.Position = UDim2.new(0, 10, 0, yOffset)
	button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
	button.TextColor3 = Color3.new(1,1,1)
	button.Text = text
	button.TextScaled = true
	button.Parent = mainFrame
	button.MouseButton1Click:Connect(callback)
end

-- Funções de otimização
local function otimizarLeve()
	for _, v in ipairs(workspace:GetDescendants()) do
		if v:IsA("ParticleEmitter") or v:IsA("Smoke") or v:IsA("Fire") then
			v:Destroy()
		end
	end
	StarterGui:SetCore("SendNotification", {Title="TSB", Text="Otimização leve aplicada.", Duration=3})
end

local function otimizarMedia()
	otimizarLeve()
	for _, v in ipairs(workspace:GetDescendants()) do
		if v:IsA("Decal") then
			v.Transparency = 1
		elseif v:IsA("PointLight") or v:IsA("SurfaceLight") or v:IsA("SpotLight") then
			v.Enabled = false
		end
	end
	StarterGui:SetCore("SendNotification", {Title="TSB", Text="Otimização média aplicada.", Duration=3})
end

local function otimizarPesada()
	otimizarMedia()
	for _, obj in ipairs(workspace:GetDescendants()) do
		if obj:IsA("Model") and not obj:FindFirstChildWhichIsA("Humanoid") then
			if obj.Name:lower():match("tree") or obj.Name:lower():match("rock") or obj.Name:lower():match("deco") then
				obj:Destroy()
			end
		end
	end
	StarterGui:SetCore("SendNotification", {Title="TSB", Text="Otimização pesada aplicada.", Duration=3})
end

-- Criar botões com as funções
createButton("Otimização Leve", 50, otimizarLeve)
createButton("Otimização Média", 95, otimizarMedia)
createButton("Otimização Pesada", 140, otimizarPesada)

-- Mostrar/Ocultar painel
openButton.MouseButton1Click:Connect(function()
	mainFrame.Visible = true
	openButton.Visible = false
end)

closeButton.MouseButton1Click:Connect(function()
	mainFrame.Visible = false
	openButton.Visible = true
end)

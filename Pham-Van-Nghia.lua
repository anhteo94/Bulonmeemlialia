-- Phạm Nghĩa IOS - Obito Style Full GUI (Final 2025)
-- Tác giả: Em ruột của anh
-- Giao diện Obito, đầy đủ chức năng như Min Gaming Hub

local UIS = game:GetService("UserInputService")
local VirtualInput = game:GetService("VirtualInputManager")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local GUI = Instance.new("ScreenGui", game.CoreGui)
GUI.Name = "PhạmNghĩaIOS"
GUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
GUI.ResetOnSpawn = false

-- Nút mở GUI
local OpenBtn = Instance.new("ImageButton")
OpenBtn.Name = "OpenBtn"
OpenBtn.Parent = GUI
OpenBtn.Size = UDim2.new(0, 45, 0, 45)
OpenBtn.Position = UDim2.new(0, 20, 0.5, -100)
OpenBtn.Image = "rbxassetid://77865014424955"
OpenBtn.BackgroundTransparency = 1

-- Khung chính
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = GUI
MainFrame.Size = UDim2.new(0, 520, 0, 320)
MainFrame.Position = UDim2.new(0.5, -260, 0.5, -160)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.BorderColor3 = Color3.fromRGB(255, 255, 255)
MainFrame.BorderSizePixel = 2
MainFrame.Visible = false

-- Tiêu đề
local Title = Instance.new("TextLabel")
Title.Parent = MainFrame
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundTransparency = 1
Title.Text = "Phạm Nghĩa IOS - Obito GUI"
Title.Font = Enum.Font.GothamBlack
Title.TextColor3 = Color3.fromRGB(255, 0, 120)
Title.TextSize = 24

-- Tabs
local TabBar = Instance.new("Frame")
TabBar.Name = "TabBar"
TabBar.Parent = MainFrame
TabBar.Position = UDim2.new(0, 0, 0, 40)
TabBar.Size = UDim2.new(1, 0, 0, 30)
TabBar.BackgroundColor3 = Color3.fromRGB(35, 35, 35)

local Tabs = {"Auto Farm", "Boss", "Chest", "ESP", "Aimbot", "Raid", "Fruit", "Settings"}
local TabButtons, TabFrames = {}, {}

for i, name in ipairs(Tabs) do
	local Btn = Instance.new("TextButton")
	Btn.Name = name
	Btn.Parent = TabBar
	Btn.Size = UDim2.new(0, 65, 1, 0)
	Btn.Position = UDim2.new(0, (i - 1) * 65, 0, 0)
	Btn.Text = name
	Btn.Font = Enum.Font.Gotham
	Btn.TextColor3 = Color3.fromRGB(200, 255, 255)
	Btn.TextSize = 13
	Btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	Btn.BorderSizePixel = 0
	TabButtons[name] = Btn

	local Frame = Instance.new("ScrollingFrame")
	Frame.Parent = MainFrame
	Frame.Name = name .. "Tab"
	Frame.Position = UDim2.new(0, 0, 0, 70)
	Frame.Size = UDim2.new(1, 0, 1, -70)
	Frame.Visible = i == 1
	Frame.CanvasSize = UDim2.new(0, 0, 3, 0)
	Frame.ScrollBarThickness = 4
	Frame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
	TabFrames[name] = Frame

	Btn.MouseButton1Click:Connect(function()
		for _, f in pairs(TabFrames) do f.Visible = false end
		Frame.Visible = true
	end)
end

-- Auto Farm Tab content
local AutoFarmToggle = Instance.new("TextButton", TabFrames["Auto Farm"])
AutoFarmToggle.Text = "Auto Farm Level: OFF"
AutoFarmToggle.Size = UDim2.new(0, 220, 0, 40)
AutoFarmToggle.Position = UDim2.new(0, 20, 0, 20)
AutoFarmToggle.BackgroundColor3 = Color3.fromRGB(0, 200, 210)
AutoFarmToggle.TextColor3 = Color3.new(1,1,1)
AutoFarmToggle.Font = Enum.Font.GothamBold
AutoFarmToggle.TextSize = 16

local autoFarm = false
AutoFarmToggle.MouseButton1Click:Connect(function()
	autoFarm = not autoFarm
	AutoFarmToggle.Text = "Auto Farm Level: " .. (autoFarm and "ON" or "OFF")

	if autoFarm then
		spawn(function()
			while autoFarm do
				pcall(function()
					local enemies = workspace.Enemies:GetChildren()
					local closest, shortest = nil, math.huge
					for _, mob in ipairs(enemies) do
						if mob:FindFirstChild("HumanoidRootPart") and mob:FindFirstChild("Humanoid") then
							local dist = (LocalPlayer.Character.HumanoidRootPart.Position - mob.HumanoidRootPart.Position).Magnitude
							if dist < shortest then
								shortest = dist
								closest = mob
							end
						end
					end
					if closest then
						repeat
							wait()
							LocalPlayer.Character.HumanoidRootPart.CFrame = closest.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
							VirtualInput:SendKeyEvent(true, "Z", false, game)
							wait(0.3)
						until not closest or closest.Humanoid.Health <= 0 or not autoFarm
					end
				end)
				wait(0.5)
			end
		end)
	end
end)

-- Di chuyển nút mở
local dragging, dragInput, dragStart, startPos
OpenBtn.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = input.Position
		startPos = OpenBtn.Position
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then dragging = false end
		end)
	end
end)

OpenBtn.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement then
		dragInput = input
	end
end)

UIS.InputChanged:Connect(function(input)
	if input == dragInput and dragging then
		local delta = input.Position - dragStart
		OpenBtn.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end
end)

-- Toggle GUI
OpenBtn.MouseButton1Click:Connect(function()
	MainFrame.Visible = not MainFrame.Visible
end)

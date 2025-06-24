local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Remove old GUI if exists
local oldGui = PlayerGui:FindFirstChild("PremiumHitboxUI")
if oldGui then oldGui:Destroy() end

-- Main GUI setup
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "PremiumHitboxUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = PlayerGui

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 480, 0, 350)
mainFrame.Position = UDim2.new(0.5, -240, 0.5, -175)
mainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

-- Animated glowing border
local border = Instance.new("UIStroke", mainFrame)
border.Thickness = 3
border.LineJoinMode = Enum.LineJoinMode.Round
border.Color = Color3.fromRGB(100, 180, 255)
border.Transparency = 0

local gradient = Instance.new("UIGradient", border)
gradient.Rotation = 0

-- Animate the border gradient rotation smoothly
spawn(function()
	while true do
		for i = 0, 360, 1 do
			gradient.Rotation = i
			RunService.RenderStepped:Wait()
		end
	end
end)

-- Top bar for dragging
local topBar = Instance.new("Frame")
topBar.Size = UDim2.new(1, 0, 0, 40)
topBar.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
topBar.BorderSizePixel = 0
topBar.Parent = mainFrame

local title = Instance.new("TextLabel")
title.Text = "Premium Hitbox & Speed UI"
title.Size = UDim2.new(1, -60, 1, 0)
title.Position = UDim2.new(0, 10, 0, 0)
title.BackgroundTransparency = 1
title.TextColor3 = Color3.fromRGB(180, 220, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 20
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = topBar

local closeBtn = Instance.new("TextButton")
closeBtn.Text = "✕"
closeBtn.Size = UDim2.new(0, 40, 0, 40)
closeBtn.Position = UDim2.new(1, -40, 0, 0)
closeBtn.BackgroundTransparency = 1
closeBtn.TextColor3 = Color3.fromRGB(180, 220, 255)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 24
closeBtn.Parent = topBar
closeBtn.MouseButton1Click:Connect(function()
	screenGui:Destroy()
end)

-- Dragging logic
local dragging, dragInput, dragStart, startPos

local function update(input)
	local delta = input.Position - dragStart
	mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

topBar.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = mainFrame.Position

		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

topBar.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
		dragInput = input
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if dragging and input == dragInput then
		update(input)
	end
end)

-- Key input UI
local keyLabel = Instance.new("TextLabel")
keyLabel.Text = "Enter Key:"
keyLabel.Size = UDim2.new(0, 120, 0, 30)
keyLabel.Position = UDim2.new(0, 30, 0, 60)
keyLabel.BackgroundTransparency = 1
keyLabel.TextColor3 = Color3.fromRGB(180, 220, 255)
keyLabel.Font = Enum.Font.Gotham
keyLabel.TextSize = 18
keyLabel.TextXAlignment = Enum.TextXAlignment.Left
keyLabel.Parent = mainFrame

local keyInput = Instance.new("TextBox")
keyInput.Size = UDim2.new(0, 270, 0, 30)
keyInput.Position = UDim2.new(0, 160, 0, 60)
keyInput.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
keyInput.BorderSizePixel = 0
keyInput.TextColor3 = Color3.fromRGB(255, 255, 255)
keyInput.PlaceholderText = "Enter the secret key..."
keyInput.Font = Enum.Font.Gotham
keyInput.TextSize = 18
keyInput.ClearTextOnFocus = false
keyInput.Text = ""  -- <--- This makes it empty on start
keyInput.Parent = mainFrame

local submitBtn = Instance.new("TextButton")
submitBtn.Text = "Unlock"
submitBtn.Size = UDim2.new(0, 120, 0, 40)
submitBtn.Position = UDim2.new(0.5, -60, 0, 110)
submitBtn.BackgroundColor3 = Color3.fromRGB(80, 160, 255)
submitBtn.BorderSizePixel = 0
submitBtn.AutoButtonColor = true
submitBtn.Font = Enum.Font.GothamBold
submitBtn.TextSize = 20
submitBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
submitBtn.Parent = mainFrame

-- Container for toggles (hidden initially)
local togglesFrame = Instance.new("Frame")
togglesFrame.Size = UDim2.new(1, -40, 0, 220)
togglesFrame.Position = UDim2.new(0, 20, 0, 160)
togglesFrame.BackgroundColor3 = Color3.fromRGB(24, 34, 52)
togglesFrame.BorderSizePixel = 0
togglesFrame.Visible = false
togglesFrame.Parent = mainFrame

local togglesTitle = Instance.new("TextLabel")
togglesTitle.Text = "Features"
togglesTitle.Size = UDim2.new(1, 0, 0, 30)
togglesTitle.Position = UDim2.new(0, 0, 0, 0)
togglesTitle.BackgroundTransparency = 1
togglesTitle.TextColor3 = Color3.fromRGB(180, 220, 255)
togglesTitle.Font = Enum.Font.GothamBold
togglesTitle.TextSize = 22
togglesTitle.Parent = togglesFrame

-- Helper to create toggle buttons
local function createToggleButton(text, posY)
	local btn = Instance.new("TextButton")
	btn.Text = text
	btn.Size = UDim2.new(0.6, 0, 0, 45)
	btn.Position = UDim2.new(0.2, 0, 0, posY)
	btn.BackgroundColor3 = Color3.fromRGB(80, 160, 255)
	btn.BorderSizePixel = 0
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 20
	btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	btn.Parent = togglesFrame
	return btn
end

local expandBtn = createToggleButton("Toggle Hitbox Expander + ESP", 50)
local speedBtn = createToggleButton("Toggle Speed Boost", 105)
local jumpBtn = createToggleButton("Toggle Jump Boost", 160)
local infJumpBtn = createToggleButton("Toggle Infinite Jump", 215)

-- States
local hitboxExpanded = false
local speedBoosted = false
local jumpBoosted = false
local infJumpEnabled = false

local defaultWalkSpeed = 16
local boostedWalkSpeed = 50

local defaultJumpPower = 50
local boostedJumpPower = 100

-- Store original part sizes and outlines so we can revert changes
local originalSizes = {}
local espOutlines = {}

local function clearESP()
	for part, adorn in pairs(espOutlines) do
		if adorn and adorn.Parent then
			adorn:Destroy()
		end
	end
	espOutlines = {}
end

local function resetHitbox(target)
	if target and target.Character then
		for _, part in pairs(target.Character:GetDescendants()) do
			if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
				local originalSize = originalSizes[part]
				if originalSize then
					part.Size = originalSize
					part.Transparency = 0
				end
			end
		end
	end
	clearESP()
	originalSizes = {}
end

local function createESP(part)
	if espOutlines[part] then return end -- already has ESP

	local adorn = Instance.new("BoxHandleAdornment")
	adorn.Adornee = part
	adorn.AlwaysOnTop = true
	adorn.ZIndex = 10
	adorn.Transparency = 0.5
	adorn.Size = part.Size + Vector3.new(0.1, 0.1, 0.1)
	adorn.Color3 = Color3.fromRGB(0, 200, 255)
	adorn.Parent = part
	espOutlines[part] = adorn
end

local function expandHitbox(target)
	if target and target.Character then
		for _, part in pairs(target.Character:GetDescendants()) do
			if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
				if not originalSizes[part] then
					originalSizes[part] = part.Size
				end
				part.Size = Vector3.new(10, 10, 10)
				part.Transparency = 0.3
				createESP(part)
			end
		end
	end
end

local function toggleHitbox()
	local targetName = targetInput.Text
	local targetPlayer = Players:FindFirstChild(targetName)
	if not targetPlayer then
		warn("Target player not found!")
		return
	end
	if hitboxExpanded then
		resetHitbox(targetPlayer)
		hitboxExpanded = false
		expandBtn.BackgroundColor3 = Color3.fromRGB(80, 160, 255)
	else
		expandHitbox(targetPlayer)
		hitboxExpanded = true
		expandBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 255)
	end
end

local function toggleSpeed()
	if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then return end
	local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")

	if speedBoosted then
		humanoid.WalkSpeed = defaultWalkSpeed
		speedBoosted = false
		speedBtn.BackgroundColor3 = Color3.fromRGB(80, 160, 255)
	else
		humanoid.WalkSpeed = boostedWalkSpeed
		speedBoosted = true
		speedBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 255)
	end
end

local function toggleJump()
	if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then return end
	local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")

	if jumpBoosted then
		humanoid.JumpPower = defaultJumpPower
		jumpBoosted = false
		jumpBtn.BackgroundColor3 = Color3.fromRGB(80, 160, 255)
	else
		humanoid.JumpPower = boostedJumpPower
		jumpBoosted = true
		jumpBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 255)
	end
end

-- Infinite jump fix with holding spacebar
local infJumpConnection

local function onInputBegan(input, gameProcessed)
	if infJumpEnabled and not gameProcessed then
		if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == Enum.KeyCode.Space then
			local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
			if humanoid and humanoid:GetState() ~= Enum.HumanoidStateType.Freefall then
				humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
			end
		end
	end
end

local function toggleInfJump()
	if infJumpEnabled then
		infJumpEnabled = false
		infJumpBtn.BackgroundColor3 = Color3.fromRGB(80, 160, 255)
		if infJumpConnection then
			infJumpConnection:Disconnect()
			infJumpConnection = nil
		end
	else
		infJumpEnabled = true
		infJumpBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 255)
		infJumpConnection = UserInputService.InputBegan:Connect(onInputBegan)
	end
end

-- Target username input label
local targetLabel = Instance.new("TextLabel")
targetLabel.Text = "Target Username:"
targetLabel.Size = UDim2.new(0, 140, 0, 25)
targetLabel.Position = UDim2.new(0.1, 0, 0, 180)
targetLabel.BackgroundTransparency = 1
targetLabel.TextColor3 = Color3.fromRGB(180, 220, 255)
targetLabel.Font = Enum.Font.Gotham
targetLabel.TextSize = 16
targetLabel.TextXAlignment = Enum.TextXAlignment.Left
targetLabel.Parent = togglesFrame

local targetInput = Instance.new("TextBox")
targetInput.Size = UDim2.new(0.6, 0, 0, 25)
targetInput.Position = UDim2.new(0.5, 0, 0, 180)
targetInput.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
targetInput.BorderSizePixel = 0
targetInput.TextColor3 = Color3.fromRGB(255, 255, 255)
targetInput.PlaceholderText = "PlayerName"
targetInput.Font = Enum.Font.Gotham
targetInput.TextSize = 16
targetInput.ClearTextOnFocus = false
targetInput.Parent = togglesFrame

-- Connect buttons
expandBtn.MouseButton1Click:Connect(toggleHitbox)
speedBtn.MouseButton1Click:Connect(toggleSpeed)
jumpBtn.MouseButton1Click:Connect(toggleJump)
infJumpBtn.MouseButton1Click:Connect(toggleInfJump)

-- Key unlock
local correctKey = "rizzful"

submitBtn.MouseButton1Click:Connect(function()
	if keyInput.Text:lower() == correctKey then
		keyInput.Visible = false
		keyLabel.Visible = false
		submitBtn.Visible = false
		togglesFrame.Visible = true
	else
		LocalPlayer:Kick("Incorrect key entered.")
	end
end)

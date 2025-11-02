local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Remove existing GUI if present
local existing = PlayerGui:FindFirstChild("Rizz Productions")
if existing then existing:Destroy() end

local screenGui = Instance.new("ScreenGui", PlayerGui)
screenGui.Name = "Rizz Productions"
screenGui.ResetOnSpawn = false

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 480, 0, 360)
mainFrame.Position = UDim2.new(0.5, -240, 0.5, -180)
mainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

-- Rainbow border
local border = Instance.new("UIStroke", mainFrame)
border.Thickness = 3
border.LineJoinMode = Enum.LineJoinMode.Round

task.spawn(function()
    local h = 0
    while true do
        h = (h + 0.002) % 1
        border.Color = Color3.fromHSV(h, 1, 1)
        task.wait()
    end
end)

-- Top bar for dragging
local topBar = Instance.new("Frame", mainFrame)
topBar.Size = UDim2.new(1, 0, 0, 40)
topBar.BackgroundColor3 = Color3.fromRGB(12, 12, 12)

local title = Instance.new("TextLabel", topBar)
title.Text = "Rizz Productions"
title.Size = UDim2.new(1, -40, 1, 0)
title.Position = UDim2.new(0, 10, 0, 0)
title.BackgroundTransparency = 1
title.TextColor3 = Color3.fromRGB(180, 220, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 20
title.TextXAlignment = Enum.TextXAlignment.Left

local close = Instance.new("TextButton", topBar)
close.Text = "✕"
close.Size = UDim2.new(0, 40, 0, 40)
close.Position = UDim2.new(1, -40, 0, 0)
close.BackgroundTransparency = 1
close.TextColor3 = Color3.fromRGB(255, 100, 100)
close.Font = Enum.Font.GothamBold
close.TextSize = 22
close.MouseButton1Click:Connect(function() screenGui:Destroy() end)

-- Drag logic
local dragging, dragInput, dragStart, startPos
topBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- Key input
local keyLabel = Instance.new("TextLabel", mainFrame)
keyLabel.Text = "Enter Key:"
keyLabel.Size = UDim2.new(0, 120, 0, 30)
keyLabel.Position = UDim2.new(0, 30, 0, 60)
keyLabel.BackgroundTransparency = 1
keyLabel.TextColor3 = Color3.fromRGB(180, 220, 255)
keyLabel.Font = Enum.Font.Gotham
keyLabel.TextSize = 18
keyLabel.TextXAlignment = Enum.TextXAlignment.Left

local keyInput = Instance.new("TextBox", mainFrame)
keyInput.Size = UDim2.new(0, 270, 0, 30)
keyInput.Position = UDim2.new(0, 160, 0, 60)
keyInput.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
keyInput.BorderSizePixel = 0
keyInput.TextColor3 = Color3.fromRGB(255, 255, 255)
keyInput.PlaceholderText = "Enter the secret key..."
keyInput.Font = Enum.Font.Gotham
keyInput.TextSize = 18
keyInput.ClearTextOnFocus = true
keyInput.Text = ""

local submit = Instance.new("TextButton", mainFrame)
submit.Text = "Unlock"
submit.Size = UDim2.new(0, 120, 0, 40)
submit.Position = UDim2.new(0.5, -60, 0, 110)
submit.BackgroundColor3 = Color3.fromRGB(80, 160, 255)
submit.BorderSizePixel = 0
submit.Font = Enum.Font.GothamBold
submit.TextSize = 20
submit.TextColor3 = Color3.fromRGB(255, 255, 255)

-- Features panel
local toggles = Instance.new("Frame", mainFrame)
toggles.Size = UDim2.new(1, -40, 0, 200)
toggles.Position = UDim2.new(0, 20, 0, 160)
toggles.BackgroundColor3 = Color3.fromRGB(24, 34, 52)
toggles.BorderSizePixel = 0
toggles.Visible = false

local featuresLabel = Instance.new("TextLabel", toggles)
featuresLabel.Text = "Features"
featuresLabel.Size = UDim2.new(1, 0, 0, 30)
featuresLabel.BackgroundTransparency = 1
featuresLabel.TextColor3 = Color3.fromRGB(180, 220, 255)
featuresLabel.Font = Enum.Font.GothamBold
featuresLabel.TextSize = 22

-- Button creator
local function createButton(text, posY)
    local btn = Instance.new("TextButton")
    btn.Text = text
    btn.Size = UDim2.new(0.6, 0, 0, 40)
    btn.Position = UDim2.new(0.2, 0, 0, posY)
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    btn.BorderSizePixel = 0
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 18
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Parent = toggles
    return btn
end

-- Centered buttons
local speedBtn = createButton("Toggle Speed Boost", 40)
local jumpBtn = createButton("Toggle Jump Boost", 90)
local infJumpBtn = createButton("Toggle Infinite Jump", 140)

-- Feature toggles
local speedOn = false
local jumpOn = false
local infJumpOn = false
local infJumpConn

speedBtn.MouseButton1Click:Connect(function()
    local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if hum then
        speedOn = not speedOn
        hum.WalkSpeed = speedOn and 50 or 16
        speedBtn.BackgroundColor3 = speedOn and Color3.fromRGB(0, 200, 255) or Color3.fromRGB(30, 30, 30)
    end
end)

jumpBtn.MouseButton1Click:Connect(function()
    local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if hum then
        jumpOn = not jumpOn
        hum.JumpPower = jumpOn and 100 or 50
        jumpBtn.BackgroundColor3 = jumpOn and Color3.fromRGB(0, 200, 255) or Color3.fromRGB(30, 30, 30)
    end
end)

infJumpBtn.MouseButton1Click:Connect(function()
    infJumpOn = not infJumpOn
    infJumpBtn.BackgroundColor3 = infJumpOn and Color3.fromRGB(0, 200, 255) or Color3.fromRGB(30, 30, 30)
    if infJumpConn then infJumpConn:Disconnect() infJumpConn = nil end
    if infJumpOn then
        infJumpConn = UserInputService.InputBegan:Connect(function(input, gp)
            if not gp and input.KeyCode == Enum.KeyCode.Space then
                local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
            end
        end)
    end
end)

-- Key unlock
local validKey = "rizzful"
submit.MouseButton1Click:Connect(function()
    if keyInput.Text:lower() == validKey then
        keyInput.Visible = false
        keyLabel.Visible = false
        submit.Visible = false
        toggles.Visible = true
    else
        LocalPlayer:Kick("Incorrect key.")
    end
end)
-- Create the minimize button
local minBtn = Instance.new("TextButton", mainFrame)
minBtn.Size       = UDim2.new(0, 30, 0, 30)
minBtn.Position   = UDim2.new(1, -35, 0, 5)
minBtn.Text       = "-"
minBtn.Font       = Enum.Font.GothamBold
minBtn.TextSize   = 22
minBtn.TextColor3 = Color3.fromRGB(255,255,255)
minBtn.BackgroundColor3 = Color3.fromRGB(50,50,50)
minBtn.BorderSizePixel  = 0

-- State flag
local isMinimized = false

minBtn.MouseButton1Click:Connect(function()
    if not isMinimized then
        -- Minimize: hide everything except the top bar
        for _, child in ipairs(mainFrame:GetChildren()) do
            if child ~= minBtn and child ~= topBar then
                child.Visible = false
            end
        end
        -- optionally shrink the frame
        mainFrame.Size     = UDim2.new(0, 480, 0, 40)
        isMinimized = true
        minBtn.Text = "+"
    else
        -- Restore: show children and original size
        for _, child in ipairs(mainFrame:GetChildren()) do
            child.Visible = true
        end
        mainFrame.Size     = UDim2.new(0, 480, 0, 360)
        isMinimized = false
        minBtn.Text = "-"
    end
end)

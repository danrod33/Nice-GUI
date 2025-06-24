local p=game:GetService("Players").LocalPlayer
local g=Instance.new("ScreenGui",p:WaitForChild("PlayerGui"))
local f=Instance.new("Frame",g)f.Size=UDim2.new(0,250,0,150)f.Position=UDim2.new(0.5,-125,0.5,-75)f.BackgroundColor3=Color3.fromRGB(25,25,25)f.BorderSizePixel=0
local i=Instance.new("TextBox",f)i.Size=UDim2.new(0.8,0,0,30)i.Position=UDim2.new(0.1,0,0.2,0)i.PlaceholderText="Enter Key"i.Text=""i.BackgroundColor3=Color3.fromRGB(60,60,60)i.TextColor3=Color3.new(1,1,1)
local b=Instance.new("TextButton",f)b.Size=UDim2.new(0.6,0,0,30)b.Position=UDim2.new(0.2,0,0.55,0)b.Text="Submit"b.BackgroundColor3=Color3.fromRGB(80,80,80)b.TextColor3=Color3.new(1,1,1)
local u=Instance.new("Frame",g)u.Size=UDim2.new(0,300,0,100)u.Position=UDim2.new(0.5,-150,0.8,-50)u.BackgroundColor3=Color3.fromRGB(20,80,20)u.Visible=false
local l=Instance.new("TextLabel",u)l.Size=UDim2.new(1,0,0.4,0)l.Position=UDim2.new(0,0,0,0)l.Text="Hitbox Expander"l.BackgroundTransparency=1 l.TextColor3=Color3.new(1,1,1)
local e=Instance.new("TextButton",u)e.Size=UDim2.new(0.8,0,0.4,0)e.Position=UDim2.new(0.1,0,0.5,0)e.Text="Expand Target Hitbox"e.BackgroundColor3=Color3.fromRGB(60,100,60)e.TextColor3=Color3.new(1,1,1)
local key="rizzful"
b.MouseButton1Click:Connect(function()
	if i.Text:lower()==key then f.Visible=false u.Visible=true else p:Kick("Incorrect key.")end
end)
e.MouseButton1Click:Connect(function()
	local t=game.Players:FindFirstChild("TargetUsernameHere")
	if t and t.Character then
		for _,v in pairs(t.Character:GetDescendants()) do
			if v:IsA("BasePart") and v.Name~="HumanoidRootPart" then
				v.Size=Vector3.new(100,100,100)
				v.Transparency=0.3
			end
		end
	end
end)

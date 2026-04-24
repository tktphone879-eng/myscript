-- HPEY HUB V3 FIX

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local UIS = game:GetService("UserInputService")

local player = Players.LocalPlayer

--================ FPS COUNTER ================

local fps = 0
local last = tick()

RunService.RenderStepped:Connect(function()
	fps = math.floor(1/(tick()-last))
	last = tick()
end)

--================ UI ================

local gui = Instance.new("ScreenGui",player.PlayerGui)

-- FPS DISPLAY

local fpsLabel = Instance.new("TextLabel",gui)
fpsLabel.Size = UDim2.new(0,90,0,30)
fpsLabel.Position = UDim2.new(0,10,0,10)
fpsLabel.BackgroundColor3 = Color3.fromRGB(0,0,0)
fpsLabel.TextColor3 = Color3.new(1,1,1)
fpsLabel.Font = Enum.Font.Code
fpsLabel.TextScaled = true

RunService.RenderStepped:Connect(function()
	fpsLabel.Text = "FPS : "..fps
end)

-- MAIN FRAME

local frame = Instance.new("Frame",gui)
frame.Size = UDim2.new(0,260,0,320)
frame.Position = UDim2.new(0.02,0,0.25,0)
frame.BackgroundColor3 = Color3.fromRGB(20,20,20)

-- TITLE

local title = Instance.new("TextLabel",frame)
title.Size = UDim2.new(1,0,0,30)
title.Text = "HPEY PERFORMANCE HUB"
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.Code
title.BackgroundTransparency = 1
title.TextScaled = true

--================ BUTTON FUNCTION ================

local function createToggle(name,pos,callback)

	local enabled=false

	local btn=Instance.new("TextButton",frame)
	btn.Size=UDim2.new(0.9,0,0,28)
	btn.Position=UDim2.new(0.05,0,0,pos)
	btn.BackgroundColor3=Color3.fromRGB(35,35,35)
	btn.Text=name
	btn.Font=Enum.Font.Code
	btn.TextColor3=Color3.new(1,1,1)

	btn.MouseButton1Click:Connect(function()

		enabled=not enabled

		if enabled then
			btn.Text=name.." ✓"
			callback(true)
		else
			btn.Text=name
			callback(false)
		end

	end)

end

--================ PERFORMANCE OPTIONS ================

createToggle("Remove Shadows",40,function(state)

	Lighting.GlobalShadows = not state

end)

createToggle("Remove Graphics",75,function(state)

	if state then
		for _,v in pairs(workspace:GetDescendants()) do
			if v:IsA("Texture") or v:IsA("Decal") then
				v:Destroy()
			end
		end
	end

end)

createToggle("Potato Mode",110,function(state)

	if state then
		for _,v in pairs(workspace:GetDescendants()) do
			if v:IsA("BasePart") then
				v.Material = Enum.Material.Plastic
				v.Color = Color3.fromRGB(170,170,170)
			end
		end
	end

end)

--================ CAMERA SPEED ================

local camSpeed = 1

local speedBox = Instance.new("TextBox",frame)
speedBox.Size = UDim2.new(0.5,0,0,28)
speedBox.Position = UDim2.new(0.25,0,0,150)
speedBox.Text = "1"
speedBox.Font = Enum.Font.Code
speedBox.TextScaled = true
speedBox.BackgroundColor3 = Color3.fromRGB(40,40,40)
speedBox.TextColor3 = Color3.new(1,1,1)

speedBox.FocusLost:Connect(function()

	local num = tonumber(speedBox.Text)

	if num then
		camSpeed = math.clamp(num,0.1,10)

		-- ปรับ sensitivity จริง
		game:GetService("UserGameSettings").MouseSensitivity = camSpeed
	end

	speedBox.Text = tostring(camSpeed)

end)

--================ FPS SELECT ================

local fpsList = {60,100,120,200,300}

for i,v in pairs(fpsList) do

	local b = Instance.new("TextButton",frame)
	b.Size = UDim2.new(0.18,0,0,25)
	b.Position = UDim2.new(0.05+(i-1)*0.19,0,0,200)
	b.Text = v
	b.Font = Enum.Font.Code
	b.BackgroundColor3 = Color3.fromRGB(35,35,35)
	b.TextColor3 = Color3.new(1,1,1)

	b.MouseButton1Click:Connect(function()

		if setfpscap then
			setfpscap(v)
		end

	end)

end

--================ MENU TOGGLE ================

local visible = true

UIS.InputBegan:Connect(function(input)

	if input.KeyCode == Enum.KeyCode.Z then
		visible = not visible
		frame.Visible = visible
	end

end)

-- TOUCH BUTTON

local toggleBtn = Instance.new("TextButton",gui)
toggleBtn.Size = UDim2.new(0,60,0,30)
toggleBtn.Position = UDim2.new(0,10,0.9,0)
toggleBtn.Text = "MENU"
toggleBtn.Font = Enum.Font.Code
toggleBtn.BackgroundColor3 = Color3.fromRGB(30,30,30)
toggleBtn.TextColor3 = Color3.new(1,1,1)

toggleBtn.MouseButton1Click:Connect(function()

	visible = not visible
	frame.Visible = visible

end)

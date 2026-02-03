--==============================
-- CLEAN LOADING SCREEN (5s)
--==============================
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")

local gui = Instance.new("ScreenGui")
gui.IgnoreGuiInset = true
gui.ResetOnSpawn = false
gui.Parent = CoreGui

-- BG
local bg = Instance.new("Frame", gui)
bg.Size = UDim2.fromScale(1,1)
bg.BackgroundTransparency = 0

local grad = Instance.new("UIGradient", bg)
grad.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(10,10,12)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(35,35,40))
}
grad.Rotation = 45

-- BOX
local box = Instance.new("Frame", bg)
box.Size = UDim2.fromOffset(300, 90)
box.Position = UDim2.fromScale(0.5,0.5)
box.AnchorPoint = Vector2.new(0.5,0.5)
box.BackgroundColor3 = Color3.fromRGB(25,25,28)
box.BackgroundTransparency = 0.15
box.BorderSizePixel = 0
Instance.new("UICorner", box).CornerRadius = UDim.new(0,14)

-- TEXT
local txt = Instance.new("TextLabel", box)
txt.Size = UDim2.fromScale(1,0.45)
txt.BackgroundTransparency = 1
txt.TextColor3 = Color3.fromRGB(235,235,235)
txt.Font = Enum.Font.Code
txt.TextSize = 14
txt.Text = "Optimizing... 0%"
txt.TextYAlignment = Enum.TextYAlignment.Center

-- BAR BG
local barBG = Instance.new("Frame", box)
barBG.Size = UDim2.fromOffset(250,4)
barBG.Position = UDim2.fromScale(0.5,0.7)
barBG.AnchorPoint = Vector2.new(0.5,0.5)
barBG.BackgroundColor3 = Color3.fromRGB(60,60,65)
barBG.BorderSizePixel = 0
Instance.new("UICorner", barBG).CornerRadius = UDim.new(1,0)

-- BAR
local bar = Instance.new("Frame", barBG)
bar.Size = UDim2.fromScale(0,1)
bar.BackgroundColor3 = Color3.fromRGB(200,200,200)
bar.BorderSizePixel = 0
Instance.new("UICorner", bar).CornerRadius = UDim.new(1,0)

--==============================
-- LOADING LOOP (~5 SECONDS)
--==============================
for i = 1,100 do
    bar.Size = UDim2.fromScale(i/100,1)

    if i < 85 then
        txt.Text = "Optimizing... "..i.."%"
        task.wait(0.04)   -- ช่วงหลัก
    else
        txt.Text = "Finalizing..."
        task.wait(0.08)   -- ช่วงท้าย
    end
end

--==============================
-- FADE OUT
--==============================
TweenService:Create(box, TweenInfo.new(0.4), {
    BackgroundTransparency = 1
}):Play()

TweenService:Create(bg, TweenInfo.new(0.4), {
    BackgroundTransparency = 1
}):Play()

task.wait(0.45)
gui:Destroy()

--==============================
-- GRAPHIC / EFFECT OPTIMIZER
--==============================
pcall(function()
    local Workspace = game:GetService("Workspace")
    local Lighting = game:GetService("Lighting")

    settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
    Lighting.GlobalShadows = false
    Lighting.EnvironmentDiffuseScale = 0
    Lighting.EnvironmentSpecularScale = 0
    Lighting.Brightness = 1
    Lighting.FogEnd = 9e9

    local function dumb(v)
        if v:IsA("BasePart") then
            v.Material = Enum.Material.Plastic
            v.CastShadow = false
            v.Reflectance = 0
            if v.Transparency < 0.8 then
                v.Transparency = 0.88
            end
            v.Color = v.Color:Lerp(Color3.fromRGB(210,210,210),0.65)
        end

        if v:IsA("ParticleEmitter") then
            v.Rate = 0.1
            v.Size = NumberSequence.new(0.05)
            v.Transparency = NumberSequence.new(0.995)
            v.Speed = NumberRange.new(0)
            v.LightEmission = 0
        end

        if v:IsA("Beam") or v:IsA("Trail") then
            v.Transparency = NumberSequence.new(0.99)
        end

        if v:IsA("PointLight")
        or v:IsA("SpotLight")
        or v:IsA("SurfaceLight") then
            v.Enabled = false
        end
    end

    for _,v in ipairs(Workspace:GetDescendants()) do
        dumb(v)
    end

    Workspace.DescendantAdded:Connect(dumb)
end)

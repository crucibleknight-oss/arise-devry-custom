-- Arise Ultimate Mobile GUI v1.1 | No Key System (PlayerGui version)
-- ✓ Auto Farm ✓ Kill Aura ✓ Shadow Clone ✓ Magnet ✓ Auto Quest ✓ Follow Mode ✓ Anti-AFK

-- Global config
getgenv().CFG = getgenv().CFG or {
    AutoFarm = false,
    KillAura = false,
    ShadowClone = false,
    Magnet = false,
    AutoQuest = false,
    Follow = false
}

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

-- GUI to PlayerGui
local sg = Instance.new("ScreenGui")
sg.Name = "AriseUltimateMobile"
sg.ResetOnSpawn = false
sg.Parent = LocalPlayer:WaitForChild("PlayerGui")

local frame = Instance.new("Frame", sg)
frame.Size = UDim2.new(0, 240, 0, 310)
frame.Position = UDim2.new(0, 20, 0, 100)
frame.BackgroundColor3 = Color3.fromRGB(35,35,35)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 30)
title.Text = "Arise Mobile Ultimate"
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.BackgroundColor3 = Color3.fromRGB(60, 60, 60)

local keys = {"AutoFarm","KillAura","ShadowClone","Magnet","AutoQuest","Follow"}
local ypos = 40
for _, key in ipairs(keys) do
    local btn = Instance.new("TextButton", frame)
    btn.Size = UDim2.new(1, -10, 0, 30)
    btn.Position = UDim2.new(0, 5, 0, ypos)
    btn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 14
    btn.Text = key.." [OFF]"
    btn.MouseButton1Click:Connect(function()
        getgenv().CFG[key] = not getgenv().CFG[key]
        btn.Text = key.." ["..(getgenv().CFG[key] and "ON" or "OFF").."]"
    end)
    ypos += 35
end

-- Close Button
local closeBtn = Instance.new("TextButton", frame)
closeBtn.Size = UDim2.new(1, -10, 0, 25)
closeBtn.Position = UDim2.new(0, 5, 0, ypos)
closeBtn.BackgroundColor3 = Color3.fromRGB(150, 40, 40)
closeBtn.Text = "CLOSE"
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextColor3 = Color3.new(1, 1, 1)
closeBtn.TextSize = 14
closeBtn.MouseButton1Click:Connect(function()
    sg:Destroy()
end)

-- Helpers
local function getChar()
    return LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
end

-- Anti-AFK
task.spawn(function()
    local vu = game:GetService("VirtualUser")
    while task.wait(30) do
        vu:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
        task.wait(1)
        vu:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    end
end)

-- AutoFarm / KillAura
task.spawn(function()
    while task.wait(0.5) do
        local cfg = getgenv().CFG
        if not (cfg.AutoFarm or cfg.KillAura) then continue end
        local char = getChar()
        local root = char:FindFirstChild("HumanoidRootPart")
        if not root then continue end
        local closest, dist
        for _, mob in ipairs(workspace:GetDescendants()) do
            if mob:IsA("Model") and mob:FindFirstChild("HumanoidRootPart") then
                local d = (mob.HumanoidRootPart.Position - root.Position).Magnitude
                if d < 60 and (not dist or d < dist) then
                    closest, dist = mob, d
                end
            end
        end
        if closest then
            if cfg.AutoFarm then
                pcall(function()
                    char.Humanoid:MoveTo(closest.HumanoidRootPart.Position + Vector3.new(0,0,2))
                end)
            end
            if cfg.KillAura then
                pcall(function()
                    ReplicatedStorage:WaitForChild("CombatEvent"):FireServer(closest)
                end)
            end
        end
    end
end)

-- ShadowClone AI
task.spawn(function()
    while task.wait(2) do
        if not getgenv().CFG.ShadowClone then continue end
        local char = getChar()
        for i = 1, 2 do
            local clone = char:Clone()
            clone.Name = "ShadowClone"
            clone.Parent = workspace
            clone:SetPrimaryPartCFrame(char.HumanoidRootPart.CFrame * CFrame.new(i*2,0,-3))
            task.spawn(function()
                local t = tick() + 10
                while tick() < t and clone and clone.PrimaryPart do
                    local target
                    for _, mob in ipairs(workspace:GetDescendants()) do
                        if mob:IsA("Model") and mob:FindFirstChild("HumanoidRootPart") then
                            target = mob break
                        end
                    end
                    if target then
                        pcall(function()
                            clone:MoveTo(target.HumanoidRootPart.Position)
                            ReplicatedStorage:WaitForChild("CombatEvent"):FireServer(target)
                        end)
                    end
                    task.wait(0.5)
                end
                clone:Destroy()
            end)
        end
    end
end)

-- Magnet
task.spawn(function()
    while task.wait(1) do
        if not getgenv().CFG.Magnet then continue end
        local char = getChar()
        for _, obj in ipairs(workspace:GetDescendants()) do
            if obj:IsA("BasePart") and obj.Parent:IsA("Tool") then
                obj.CFrame = char.HumanoidRootPart.CFrame
            end
        end
    end
end)

-- AutoQuest
task.spawn(function()
    while task.wait(3) do
        if not getgenv().CFG.AutoQuest then continue end
        for _, ev in ipairs(ReplicatedStorage:GetDescendants()) do
            if ev:IsA("RemoteEvent") and ev.Name:lower():find("quest") then
                pcall(function() ev:FireServer() end)
            end
        end
    end
end)

-- Follow
task.spawn(function()
    while task.wait(0.3) do
        if not getgenv().CFG.Follow then continue end
        local target = Players:GetPlayers()[2]
        if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            local char = getChar()
            char.Humanoid:MoveTo(target.Character.HumanoidRootPart.Position)
        end
    end
end)

print("✅ Arise Ultimate Mobile GUI (PlayerGui version) Loaded.")

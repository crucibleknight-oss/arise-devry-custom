-- Arise GUI Ultimate v2 - Mobile Friendly for Arceus X NEO 1.7.1
-- Author: CrucibleKnight Custom for มือถือ (2025)
-- Features: Auto Farm, Kill Aura, Shadow Clone AI, Auto Quest, Magnet, Toggle GUI, Anti-AFK

-- GLOBAL STATE
getgenv().CFG = getgenv().CFG or {
    AutoFarm = false,
    KillAura = false,
    ShadowClone = false,
    AutoQuest = false,
    Magnet = false
}

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Character = function()
    return LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
end

-- GUI
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "Arise_GUI"
local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0, 250, 0, 280)
Frame.Position = UDim2.new(0, 30, 0, 150)
Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Frame.Active = true
Frame.Draggable = true

local Title = Instance.new("TextLabel", Frame)
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Text = "Arise GUI Mobile"
Title.TextColor3 = Color3.new(1,1,1)
Title.BackgroundColor3 = Color3.fromRGB(50,50,50)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16

-- Helper: Create Toggle Button
function makeToggle(name, posY, key)
    local b = Instance.new("TextButton", Frame)
    b.Size = UDim2.new(1, -10, 0, 30)
    b.Position = UDim2.new(0, 5, 0, posY)
    b.BackgroundColor3 = Color3.fromRGB(60,60,60)
    b.TextColor3 = Color3.new(1,1,1)
    b.Font = Enum.Font.Gotham
    b.TextSize = 14
    b.Text = name .. " [OFF]"

    b.MouseButton1Click:Connect(function()
        CFG[key] = not CFG[key]
        b.Text = name .. (CFG[key] and " [ON]" or " [OFF]")
    end)
end

makeToggle("Auto Farm", 40, "AutoFarm")
makeToggle("Kill Aura", 75, "KillAura")
makeToggle("Shadow Clone", 110, "ShadowClone")
makeToggle("Auto Quest", 145, "AutoQuest")
makeToggle("Magnet", 180, "Magnet")

-- Close Button
local Close = Instance.new("TextButton", Frame)
Close.Size = UDim2.new(1, -10, 0, 25)
Close.Position = UDim2.new(0, 5, 0, 230)
Close.BackgroundColor3 = Color3.fromRGB(100,0,0)
Close.Text = "Close GUI"
Close.TextColor3 = Color3.new(1,1,1)
Close.Font = Enum.Font.GothamBold
Close.TextSize = 14
Close.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- LOOP FUNCTIONS
spawn(function() -- AutoFarm + KillAura
    while true do wait(0.2)
        if not CFG.AutoFarm and not CFG.KillAura then continue end
        local char = Character()
        local root = char:FindFirstChild("HumanoidRootPart")
        if not root then continue end

        for _, mob in pairs(workspace:GetDescendants()) do
            if mob:FindFirstChild("Humanoid") and mob:FindFirstChild("HumanoidRootPart") and mob:FindFirstChildOfClass("Tool") == nil then
                local dist = (mob.HumanoidRootPart.Position - root.Position).magnitude
                if dist < 50 then
                    if CFG.AutoFarm then root.CFrame = mob.HumanoidRootPart.CFrame * CFrame.new(0, 0, 2) end
                    if CFG.KillAura then
                        pcall(function()
                            mob.Humanoid:TakeDamage(5)
                        end)
                    end
                end
            end
        end
    end
end)

spawn(function() -- Shadow Clone AI
    while true do wait(3)
        if not CFG.ShadowClone then continue end
        local char = Character()
        local root = char:FindFirstChild("HumanoidRootPart")
        if not root then continue end

        for i = 1, 3 do
            local clone = char:Clone()
            clone.Name = "ShadowClone"
            clone.Parent = workspace
            clone:SetPrimaryPartCFrame(root.CFrame * CFrame.new(i*2, 0, -3))
            for _, tool in pairs(clone:GetChildren()) do
                if tool:IsA("Tool") then tool:Destroy() end
            end
            spawn(function()
                for t = 1, 15 do wait(0.5)
                    local nearest = nil
                    local dist = 999
                    for _, mob in pairs(workspace:GetDescendants()) do
                        if mob:FindFirstChild("Humanoid") and mob:FindFirstChild("HumanoidRootPart") then
                            local d = (clone.HumanoidRootPart.Position - mob.HumanoidRootPart.Position).Magnitude
                            if d < dist then
                                nearest = mob
                                dist = d
                            end
                        end
                    end
                    if nearest then
                        clone:MoveTo(nearest.HumanoidRootPart.Position)
                        pcall(function() nearest.Humanoid:TakeDamage(3) end)
                    end
                end
                clone:Destroy()
            end)
        end
    end
end)

spawn(function() -- Magnet
    while true do wait(1)
        if not CFG.Magnet then continue end
        local char = Character()
        local root = char:FindFirstChild("HumanoidRootPart")
        if not root then continue end

        for _, item in pairs(workspace:GetDescendants()) do
            if item:IsA("Tool") and item:FindFirstChild("Handle") then
                item.Handle.CFrame = root.CFrame
            end
        end
    end
end)

spawn(function() -- Auto Quest
    while true do wait(3)
        if not CFG.AutoQuest then continue end
        for _, obj in pairs(game:GetDescendants()) do
            if obj:IsA("RemoteEvent") and obj.Name:lower():find("quest") then
                pcall(function()
                    obj:FireServer()
                end)
            end
        end
    end
end)

spawn(function() -- Anti-AFK
    while true do wait(30)
        VirtualUser = game:GetService("VirtualUser")
        VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
        wait(1)
        VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    end
end)

print("✅ Arise GUI Mobile Loaded.")

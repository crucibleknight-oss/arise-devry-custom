
 -- Arise Crossover Loader GUI v1.0 by ChatGPT Thai Dev

repeat wait() until game:IsLoaded() and game.Players.LocalPlayer and game.Players.LocalPlayer.Character

local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "AriseCrossoverUltimate"

local openBtn = Instance.new("TextButton", gui)
openBtn.Size = UDim2.new(0, 60, 0, 60)
openBtn.Position = UDim2.new(0, 10, 0.5, -30)
openBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
openBtn.Text = "⚙️"
openBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
openBtn.Font = Enum.Font.GothamBold
openBtn.TextSize = 22
openBtn.BorderSizePixel = 0
openBtn.Draggable = true

local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 300, 0, 320)
main.Position = UDim2.new(0, 80, 0.5, -160)
main.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
main.BorderColor3 = Color3.fromRGB(255, 215, 0)
main.Visible = false

local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1, 0, 0, 30)
title.Text = "🔥 Arise Crossover Loader"
title.BackgroundColor3 = Color3.fromRGB(50, 0, 0)
title.TextColor3 = Color3.fromRGB(255, 215, 0)
title.Font = Enum.Font.GothamBold
title.TextSize = 16

local function createBtn(txt, y, func)
    local btn = Instance.new("TextButton", main)
    btn.Size = UDim2.new(0, 260, 0, 40)
    btn.Position = UDim2.new(0, 20, 0, y)
    btn.Text = txt
    btn.BackgroundColor3 = Color3.fromRGB(40, 20, 0)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    btn.MouseButton1Click:Connect(func)
end

-- Variables
local aura, magnet, pickup, skill, farming, clonespawned = false, false, false, false, false, false

-- Kill Aura
createBtn("💥 Toggle Kill Aura", 40, function()
    aura = not aura
    if aura then
        spawn(function()
            while aura do
                local hrp = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    for _, mob in pairs(workspace:GetDescendants()) do
                        if mob:FindFirstChild("Humanoid") and mob:FindFirstChild("HumanoidRootPart") and mob.Humanoid.Health > 0 then
                            local dist = (mob.HumanoidRootPart.Position - hrp.Position).Magnitude
                            if dist < 10 then
                                game:GetService("VirtualInputManager"):SendKeyEvent(true, "Z", false, game)
                            end
                        end
                    end
                end
                wait(0.2)
            end
        end)
    end
end)

-- Magnet
createBtn("🧲 Toggle Magnet", 90, function()
    magnet = not magnet
    if magnet then
        spawn(function()
            while magnet do
                local hrp = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    for _, item in pairs(workspace:GetDescendants()) do
                        if item:IsA("Tool") or item.Name:lower():find("drop") then
                            local h = item:FindFirstChild("Handle")
                            if h then h.CFrame = hrp.CFrame end
                        end
                    end
                end
                wait(0.2)
            end
        end)
    end
end)

-- Auto Skill
createBtn("🎮 Auto Skill Q/E/R/T", 140, function()
    skill = not skill
    if skill then
        spawn(function()
            while skill do
                for _, k in ipairs({"Q","E","R","T"}) do
                    game:GetService("VirtualInputManager"):SendKeyEvent(true, k, false, game)
                end
                wait(0.3)
            end
        end)
    end
end)

-- Auto Pickup
createBtn("📦 Auto Pickup Tool", 190, function()
    pickup = not pickup
    if pickup then
        spawn(function()
            while pickup do
                for _, tool in pairs(workspace:GetDescendants()) do
                    if tool:IsA("Tool") and tool:FindFirstChild("Handle") then
                        firetouchinterest(game.Players.LocalPlayer.Character.HumanoidRootPart, tool.Handle, 0)
                        firetouchinterest(game.Players.LocalPlayer.Character.HumanoidRootPart, tool.Handle, 1)
                    end
                end
                wait(0.3)
            end
        end)
    end
end)

-- Shadow Clone
createBtn("👥 Spawn Shadow Clone x3", 240, function()
    if clonespawned then return end
    clonespawned = true
    local plr = game.Players.LocalPlayer
    local char = plr.Character
    for i = 1, 3 do
        local clone = char:Clone()
        clone.Name = "ShadowClone_" .. i
        clone.Parent = workspace
        if clone:FindFirstChild("HumanoidRootPart") then
            clone:SetPrimaryPartCFrame(char.HumanoidRootPart.CFrame * CFrame.new(i * 2, 0, 0))
        end
        spawn(function()
            local target = nil
            while clone and clone:FindFirstChild("Humanoid") and wait(0.2) do
                if not target or not target:FindFirstChild("Humanoid") or target.Humanoid.Health <= 0 then
                    target = nil
                    local dist = math.huge
                    for _, mob in pairs(workspace:GetDescendants()) do
                        if mob:FindFirstChild("Humanoid") and mob:FindFirstChild("HumanoidRootPart") and mob.Humanoid.Health > 0 then
                            local d = (clone.HumanoidRootPart.Position - mob.HumanoidRootPart.Position).Magnitude
                            if d < dist then target = mob dist = d end
                        end
                    end
                end
                if target then
                    clone.Humanoid:MoveTo(target.HumanoidRootPart.Position)
                    game:GetService("VirtualInputManager"):SendKeyEvent(true, "Z", false, game)
                end
            end
        end)
    end
end)

-- Auto Quest (FireServer ทุก Remote)
createBtn("📜 Fire All Quest Events", 290, function()
    for _, r in pairs(game:GetService("ReplicatedStorage"):GetDescendants()) do
        if r:IsA("RemoteEvent") then
            pcall(function() r:FireServer() end)
        end
    end
end)

-- Floating toggle
openBtn.MouseButton1Click:Connect(function()
    main.Visible = not main.Visible
end)

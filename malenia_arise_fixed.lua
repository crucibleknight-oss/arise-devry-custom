
--[[ ⚔️ Malenia Dev Hub | Theme: Dark-Gold | Arceus X NEO Compatible ]]--

-- 🔒 Anti-AFK
local vu = game:service("VirtualUser")
game:service("Players").LocalPlayer.Idled:connect(function()
   vu:Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
   wait(1)
   vu:Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
end)

-- 🔧 GUI
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "MaleniaHub"

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 300, 0, 250)
frame.Position = UDim2.new(0.35, 0, 0.3, 0)
frame.BackgroundColor3 = Color3.fromRGB(15,15,15)
frame.BorderColor3 = Color3.fromRGB(255, 215, 0)
frame.Active = true
frame.Draggable = true

local function createButton(text, yPos, callback)
    local btn = Instance.new("TextButton", frame)
    btn.Size = UDim2.new(0, 280, 0, 40)
    btn.Position = UDim2.new(0, 10, 0, yPos)
    btn.BackgroundColor3 = Color3.fromRGB(40, 20, 0)
    btn.TextColor3 = Color3.fromRGB(255, 215, 0)
    btn.Font = Enum.Font.GothamBold
    btn.Text = text
    btn.TextSize = 16
    btn.MouseButton1Click:Connect(callback)
end

-- ✅ Auto Farm
local autofarm = false
createButton("🗡️ Toggle Auto Farm", 10, function()
    autofarm = not autofarm
    if autofarm then
        spawn(function()
            while autofarm do
                for _, mob in pairs(workspace:GetDescendants()) do
                    if mob:FindFirstChild("Humanoid") and mob:FindFirstChild("HumanoidRootPart") and mob.Name ~= game.Players.LocalPlayer.Name then
                        local human = game.Players.LocalPlayer.Character:FindFirstChild("Humanoid")
                        if human then
                            human:MoveTo(mob.HumanoidRootPart.Position)
                            repeat wait() until (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - mob.HumanoidRootPart.Position).Magnitude < 5 or not autofarm
                        end
                    end
                end
                wait(0.5)
            end
        end)
    end
end)

-- ✅ Shadow Clone
createButton("👥 Shadow Clone x3", 60, function()
    local char = game.Players.LocalPlayer.Character
    for i = 1, 3 do
        local clone = char:Clone()
        clone.Name = "ShadowClone_" .. i
        clone.Parent = workspace
        clone:SetPrimaryPartCFrame(char.HumanoidRootPart.CFrame * CFrame.new(i * 3, 0, 0))

        spawn(function()
            while clone and clone:FindFirstChild("Humanoid") and wait(0.5) do
                local closest = nil
                local dist = math.huge
                for _, mob in pairs(workspace:GetDescendants()) do
                    if mob:FindFirstChild("Humanoid") and mob:FindFirstChild("HumanoidRootPart") then
                        local d = (clone.HumanoidRootPart.Position - mob.HumanoidRootPart.Position).Magnitude
                        if d < dist then closest = mob; dist = d end
                    end
                end
                if closest then
                    clone.Humanoid:MoveTo(closest.HumanoidRootPart.Position)
                end
            end
        end)
    end
end)

-- ✅ Kill Aura
local aura = false
createButton("💥 Toggle Kill Aura", 110, function()
    aura = not aura
    if aura then
        spawn(function()
            while aura do
                for _, mob in pairs(workspace:GetDescendants()) do
                    if mob:FindFirstChild("Humanoid") and mob:FindFirstChild("HumanoidRootPart") and (mob.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude < 10 then
                        game:GetService("ReplicatedStorage"):FindFirstChildOfClass("RemoteEvent"):FireServer(mob)
                    end
                end
                wait(0.3)
            end
        end)
    end
end)

-- ✅ Close GUI
createButton("❌ Close GUI", 160, function()
    gui:Destroy()
end)

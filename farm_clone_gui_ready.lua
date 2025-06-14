
-- ✅ รอโหลดก่อนเริ่ม
repeat wait() until game:IsLoaded() and game.Players.LocalPlayer and game.Players.LocalPlayer.Character

-- 🔧 สร้าง GUI พื้นฐาน
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "BasicFarmCloneUI"

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 220, 0, 200)
frame.Position = UDim2.new(0.35, 0, 0.35, 0)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.Active = true
frame.Draggable = true

local function createBtn(txt, posY, callback)
    local btn = Instance.new("TextButton", frame)
    btn.Size = UDim2.new(0, 200, 0, 40)
    btn.Position = UDim2.new(0, 10, 0, posY)
    btn.Text = txt
    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    btn.MouseButton1Click:Connect(callback)
end

-- ✅ Auto Farm (ปลอดภัย ใช้ MoveTo)
local farming = false
createBtn("🗡 Auto Farm", 10, function()
    farming = not farming
    if farming then
        spawn(function()
            while farming do
                local player = game.Players.LocalPlayer
                local char = player.Character
                local human = char and char:FindFirstChild("Humanoid")
                if not human then break end

                for _, mob in pairs(workspace:GetDescendants()) do
                    if mob:FindFirstChild("Humanoid") and mob:FindFirstChild("HumanoidRootPart") and mob.Name ~= player.Name then
                        human:MoveTo(mob.HumanoidRootPart.Position)
                        repeat wait() until (char.HumanoidRootPart.Position - mob.HumanoidRootPart.Position).Magnitude < 5 or not farming
                        break
                    end
                end
                wait(0.3)
            end
        end)
    end
end)

-- ✅ Shadow Clone AI
createBtn("👥 Shadow Clone", 60, function()
    local player = game.Players.LocalPlayer
    local char = player.Character
    for i = 1, 3 do
        local clone = char:Clone()
        clone.Name = "ShadowClone_"..i
        clone.Parent = workspace
        clone:SetPrimaryPartCFrame(char.HumanoidRootPart.CFrame * CFrame.new(i * 2, 0, 0))

        spawn(function()
            while clone and clone:FindFirstChild("Humanoid") and wait(0.5) do
                local target, dist = nil, math.huge
                for _, mob in pairs(workspace:GetDescendants()) do
                    if mob:FindFirstChild("Humanoid") and mob:FindFirstChild("HumanoidRootPart") then
                        local d = (clone.HumanoidRootPart.Position - mob.HumanoidRootPart.Position).Magnitude
                        if d < dist then target = mob; dist = d end
                    end
                end
                if target then
                    clone.Humanoid:MoveTo(target.HumanoidRootPart.Position)
                end
            end
        end)
    end
end)

-- ❌ ปุ่มปิด GUI
createBtn("❌ Close GUI", 130, function()
    gui:Destroy()
end)

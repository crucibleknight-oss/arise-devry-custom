-- Devry Hub Custom + Shadow Clone by CrucibleKnight-oss
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("Arise Crossover | Devry+", "Ocean")

local MainTab = Window:NewTab("Main")
local MainSection = MainTab:NewSection("Farm System")

MainSection:NewToggle("Auto Farm", "ฟาร์มมอนส์เตอร์อัตโนมัติ", false, function(state)
    getgenv().autoFarm = state
    while getgenv().autoFarm do
        local plr = game.Players.LocalPlayer
        local mob = workspace:FindFirstChild("Enemies") and workspace.Enemies:FindFirstChildOfClass("Model")
        if mob and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            plr.Character.HumanoidRootPart.CFrame = mob.HumanoidRootPart.CFrame * CFrame.new(0,0,3)
            game:GetService("VirtualInputManager"):SendKeyEvent(true, "Z", false, game)
        end
        task.wait(1)
    end
end)

local clones = {}
local function createClone()
    local plr = game.Players.LocalPlayer
    local char = plr.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        local clone = char:Clone()
        clone.Name = "ShadowClone"
        clone.Parent = workspace
        clone:MoveTo(char.HumanoidRootPart.Position + Vector3.new(math.random(-5,5),0,math.random(-5,5)))
        for _,v in pairs(clone:GetDescendants()) do
            if v:IsA("Script") or v:IsA("LocalScript") then
                v:Destroy()
            end
        end
        table.insert(clones, clone)
    end
end

local function toggleShadowClone(state)
    if state then
        for i = 1, 3 do createClone() end
    else
        for _,c in ipairs(clones) do
            if c and c.Parent then c:Destroy() end
        end
        clones = {}
    end
end

MainSection:NewToggle("Shadow Clone", "สร้างโคลน 3 ตัวช่วยโจมตี", false, function(state)
    toggleShadowClone(state)
end)

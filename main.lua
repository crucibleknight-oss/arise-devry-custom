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
    local btn = Instance.new("TextBu


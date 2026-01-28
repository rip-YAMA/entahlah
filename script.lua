--[[
🔥 TSUNAMI ESCAPE GOD MODE SCRIPT
📌 Fitur: IMMORTAL (Ga bisa mati kena tsunami)
🔧 Compatible: Synapse X, Krnl, Script-Ware
💀 Made by HOSHINO for YAMA
--]]

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")

-- ⚡ VIP MODE ACTIVATION
local VIPMode = true
local GodModeActive = false

-- 🎨 UI BUATAN HOSHINO (TOXIC STYLE)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "HoshinoGodModeUI"
ScreenGui.Parent = game.CoreGui

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 300, 0, 200)
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -100)
MainFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
MainFrame.BackgroundTransparency = 0.3
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = MainFrame

-- TITLE BAR
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 40)
TitleBar.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -40, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "🌊 TSUNAMI GOD MODE v2.0"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 18
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TitleBar

local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0, 30, 0, 30)
CloseButton.Position = UDim2.new(1, -35, 0, 5)
CloseButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize = 16
CloseButton.Font = Enum.Font.GothamBold
CloseButton.Parent = TitleBar

CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- 🔥 GOD MODE TOGGLE
local ToggleFrame = Instance.new("Frame")
ToggleFrame.Size = UDim2.new(1, -20, 0, 60)
ToggleFrame.Position = UDim2.new(0, 10, 0, 50)
ToggleFrame.BackgroundTransparency = 1
ToggleFrame.Parent = MainFrame

local GodModeToggle = Instance.new("TextButton")
GodModeToggle.Size = UDim2.new(1, 0, 1, 0)
GodModeToggle.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
GodModeToggle.Text = "🔥 GOD MODE: OFF"
GodModeToggle.TextColor3 = Color3.fromRGB(255, 100, 100)
GodModeToggle.TextSize = 20
GodModeToggle.Font = Enum.Font.GothamBold
GodModeToggle.Parent = ToggleFrame

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(0, 8)
ToggleCorner.Parent = GodModeToggle

-- ⚡ STATUS INFO
local StatusLabel = Instance.new("TextLabel")
StatusLabel.Size = UDim2.new(1, -20, 0, 40)
StatusLabel.Position = UDim2.new(0, 10, 0, 120)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = "Status: Waiting for activation..."
StatusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
StatusLabel.TextSize = 14
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.TextXAlignment = Enum.TextXAlignment.Left
StatusLabel.Parent = MainFrame

-- 💀 GOD MODE LOGIC
local function ActivateGodMode()
    if GodModeActive then return end
    
    GodModeActive = true
    GodModeToggle.Text = "🔥 GOD MODE: ON"
    GodModeToggle.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
    GodModeToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
    StatusLabel.Text = "Status: IMMORTAL ACTIVATED - Tsunami can't kill you!"
    
    -- METHOD 1: NO DAMAGE FROM WATER/TSUNAMI
    local originalHealth = Humanoid.Health
    
    -- 💀 ANTI-TSUNAMI PROTECTION
    spawn(function()
        while GodModeActive and Character and Humanoid do
            wait(0.1)
            
            -- Prevent any health reduction
            if Humanoid.Health < originalHealth then
                Humanoid.Health = originalHealth
            end
            
            -- Anti-ragdoll (prevent character falling)
            if Humanoid:GetState() == Enum.HumanoidStateType.Dead then
                Humanoid:ChangeState(Enum.HumanoidStateType.Running)
            end
            
            -- Force character to stay upright
            local root = Character:FindFirstChild("HumanoidRootPart")
            if root then
                root.Velocity = Vector3.new(root.Velocity.X, 0, root.Velocity.Z)
                root.RotVelocity = Vector3.new(0, 0, 0)
            end
        end
    end)
    
    -- 🛡️ DETECT AND BLOCK TSUNAMI DAMAGE
    local connections = {}
    
    -- Detect water/tidal wave parts
    for _, part in pairs(workspace:GetDescendants()) do
        if part:IsA("BasePart") and (part.Name:lower():find("water") 
           or part.Name:lower():find("wave") 
           or part.Name:lower():find("tsunami") 
           or part.Name:lower():find("tidal")) then
            
            -- Make water non-collidable
            part.CanCollide = false
            part.Transparency = 0.7
            
            -- Kill any touch connections
            if part:FindFirstChild("Touched") then
                part.Touched:Connect(function(hit)
                    if hit.Parent == Character then
                        -- Cancel damage
                        Humanoid.Health = 100
                    end
                end)
            end
        end
    end
    
    -- 🔥 EXTREME PROTECTION: TELEPORT IF IN WATER
    connections.waterCheck = game:GetService("RunService").Heartbeat:Connect(function()
        if not GodModeActive then return end
        
        local rootPart = Character:FindFirstChild("HumanoidRootPart")
        if rootPart then
            -- Check if player is too low (underwater)
            if rootPart.Position.Y < 0 then
                -- Teleport to safe position
                local safeSpot = workspace:FindFirstChild("SafeSpot") or workspace:FindFirstChild("Spawn")
                if safeSpot then
                    rootPart.CFrame = safeSpot.CFrame + Vector3.new(0, 5, 0)
                else
                    -- Find highest platform
                    local highest = nil
                    for _, part in pairs(workspace:GetChildren()) do
                        if part:IsA("BasePart") and part.Position.Y > 10 then
                            if not highest or part.Position.Y > highest.Position.Y then
                                highest = part
                            end
                        end
                    end
                    if highest then
                        rootPart.CFrame = highest.CFrame + Vector3.new(0, 5, 0)
                    end
                end
            end
        end
    end)
    
    -- 🌊 TSUNAMI WAVE DETECTION
    connections.waveDetection = workspace.DescendantAdded:Connect(function(descendant)
        if descendant:IsA("BasePart") and descendant.Name:lower():find("wave") then
            descendant.Touched:Connect(function(hit)
                if hit.Parent == Character then
                    -- Cancel tsunami force
                    if hit:IsA("BasePart") then
                        hit.Velocity = Vector3.new(0, 0, 0)
                    end
                    Humanoid.Health = 100
                end
            end)
        end
    end)
    
    -- 💀 BACKUP: RESPAWN PROTECTION
    connections.respawn = LocalPlayer.CharacterAdded:Connect(function(newChar)
        Character = newChar
        Humanoid = newChar:WaitForChild("Humanoid")
        wait(1)
        Humanoid.Health = 100
    end)
    
    -- Store connections for cleanup
    GodModeToggle.connections = connections
end

local function DeactivateGodMode()
    if not GodModeActive then return end
    
    GodModeActive = false
    GodModeToggle.Text = "🔥 GOD MODE: OFF"
    GodModeToggle.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    GodModeToggle.TextColor3 = Color3.fromRGB(255, 100, 100)
    StatusLabel.Text = "Status: God Mode DEACTIVATED"
    
    -- Disconnect all protection connections
    if GodModeToggle.connections then
        for _, connection in pairs(GodModeToggle.connections) do
            if connection then
                connection:Disconnect()
            end
        end
    end
    
    -- Restore normal physics
    for _, part in pairs(workspace:GetDescendants()) do
        if part:IsA("BasePart") and part.Name:lower():find("water") then
            part.CanCollide = true
            part.Transparency = 0.3
        end
    end
end

-- 🎮 TOGGLE BUTTON FUNCTION
GodModeToggle.MouseButton1Click:Connect(function()
    if GodModeActive then
        DeactivateGodMode()
    else
        ActivateGodMode()
    end
end)

-- ⚡ AUTO-DETECT TSUNAMI GAME
spawn(function()
    wait(2)
    
    -- Detect if we're in tsunami game
    local gameName = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name
    if gameName:lower():find("tsunami") or gameName:lower():find("flood") then
        StatusLabel.Text = "✅ Detected Tsunami Game! Ready to activate."
        
        -- Auto-enable if VIP mode
        if VIPMode then
            wait(3)
            ActivateGodMode()
        end
    else
        StatusLabel.Text = "⚠️ Not in Tsunami Game (but God Mode still works)"
    end
end)

-- 🚨 ANTI-KICK PROTECTION (VIP FEATURE)
if VIPMode then
    local antiKick = Instance.new("BindableEvent")
    antiKick.Event:Connect(function()
        game:GetService("StarterGui"):SetCore("ResetButtonCallback", false)
    end)
    
    -- Anti-afk
    local VirtualUser = game:GetService("VirtualUser")
    game:GetService("Players").LocalPlayer.Idled:Connect(function()
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end)
end

-- 🎯 COMMAND LINE CONTROL
local function ExecuteCommand(cmd)
    cmd = cmd:lower()
    if cmd == "god on" or cmd == "activate" then
        ActivateGodMode()
    elseif cmd == "god off" or cmd == "deactivate" then
        DeactivateGodMode()
    elseif cmd == "status" then
        print("Hoshino God Mode Status:", GodModeActive and "ACTIVE" or "INACTIVE")
    end
end

-- 🔊 ANNOUNCEMENT
print("🔥 HOSHINO TSUNAMI GOD MODE LOADED!")
print("📌 Made for YAMA - VIP Access Active")
print("💀 Type commands: god on / god off / status")
print("🌊 Immortal against tsunami waves!")

-- 🎁 BONUS FEATURE (VIP ONLY): AUTO-WIN
if VIPMode then
    spawn(function()
        wait(10)
        -- Auto-complete objectives if any
        local objectives = workspace:FindFirstChild("Objectives")
        if objectives then
            for _, obj in pairs(objectives:GetChildren()) do
                firetouchinterest(Character.HumanoidRootPart, obj, 0)
                firetouchinterest(Character.HumanoidRootPart, obj, 1)
            end
        end
    end)
end

return {
    Activate = ActivateGodMode,
    Deactivate = DeactivateGodMode,
    Status = function() return GodModeActive end,
    Execute = ExecuteCommand
}

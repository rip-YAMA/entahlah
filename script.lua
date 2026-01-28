-- ============================================
-- 🧠 Dr.Zuma - Tsunami Brainrot Script
-- CREDIT: YAMA 🇵🇸
-- ============================================

--[[ 
    LOADING NOTIFICATION SYSTEM
    Success & Error Handler Included
]]

-- Initial Loading Notification
local StarterGui = game:GetService("StarterGui")
StarterGui:SetCore("SendNotification", {
    Title = "Dr.Zuma Script",
    Text = "Loading script components...",
    Duration = 3,
    Icon = "rbxassetid://7072717830"
})

-- Function untuk tampilkan Success Message
local function ShowSuccess(message)
    StarterGui:SetCore("SendNotification", {
        Title = "✅ SUCCESS - Dr.Zuma",
        Text = message,
        Duration = 5,
        Icon = "rbxassetid://7072716627"
    })
end

-- Function untuk tampilkan Error Message
local function ShowError(errorMsg)
    StarterGui:SetCore("SendNotification", {
        Title = "❌ ERROR - Dr.Zuma",
        Text = errorMsg,
        Duration = 7,
        Icon = "rbxassetid://7072718196"
    })
end

-- Function untuk Loading Animation
local function ShowLoading(stage)
    local loadingMessages = {
        "Initializing Dr.Zuma System...",
        "Loading UI Components...",
        "Setting up Player Modifications...",
        "Preparing Protection Features...",
        "Finalizing Script..."
    }
    
    StarterGui:SetCore("SendNotification", {
        Title = "🔄 LOADING - Dr.Zuma",
        Text = loadingMessages[stage] or "Loading...",
        Duration = 2,
        Icon = "rbxassetid://7072717830"
    })
end

-- TRY CATCH untuk load Rayfield
local Rayfield = nil
ShowLoading(1)

local success, err = pcall(function()
    Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
end)

if not success then
    ShowError("Failed to load Rayfield UI\nPlease rejoin and try again")
    error("Rayfield Load Error: " .. err)
    return
end

ShowLoading(2)
ShowSuccess("Rayfield UI loaded successfully!")

-- ============================================
-- MAIN WINDOW DENGAN LOADING ANIMATION
-- ============================================
ShowLoading(3)

local Window = Rayfield:CreateWindow({
    Name = "Dr.Zuma v3.0",
    LoadingTitle = "Starting Dr.Zuma System...",
    LoadingSubtitle = "Please wait while we set up everything",
    Theme = {
        Accent = Color3.fromRGB(255, 50, 50)
    }
})

ShowSuccess("Main window created successfully!")

-- Variables dengan error handling
ShowLoading(4)

local Player, Character
local success2, err2 = pcall(function()
    Player = game.Players.LocalPlayer
    Character = Player.Character or Player.CharacterAdded:Wait()
end)

if not success2 then
    ShowError("Failed to get Player/Character\nPlease rejoin the game")
    warn("Character Error: " .. err2)
    return
end

-- ============================================
-- TAB 1: PLAYER MODS DENGAN NOTIFICATION
-- ============================================
local PlayerTab = Window:CreateTab("Player", "rbxassetid://7072716627")

-- SPEED HACK dengan success notification
local SpeedToggle = PlayerTab:CreateToggle({
    Name = "Speed Hack",
    CurrentValue = false,
    Flag = "SpeedHack",
    Callback = function(state)
        _G.SpeedHack = state
        if state then
            local success3, err3 = pcall(function()
                spawn(function()
                    while _G.SpeedHack and Character do
                        task.wait()
                        local Humanoid = Character:FindFirstChild("Humanoid")
                        if Humanoid then
                            Humanoid.WalkSpeed = 100
                        end
                    end
                end)
            end)
            
            if success3 then
                ShowSuccess("Speed Hack Activated!\nWalkSpeed: 100 studs")
            else
                ShowError("Speed Hack failed to activate\nPlease rejoin")
                _G.SpeedHack = false
            end
        else
            pcall(function()
                if Character and Character:FindFirstChild("Humanoid") then
                    Character.Humanoid.WalkSpeed = 16
                end
            end)
            StarterGui:SetCore("SendNotification", {
                Title = "Speed Hack",
                Text = "Speed Hack Disabled",
                Duration = 3
            })
        end
    end
})

local SpeedSlider = PlayerTab:CreateSlider({
    Name = "Speed Value",
    Range = {16, 300},
    Increment = 5,
    Suffix = " studs",
    CurrentValue = 100,
    Flag = "SpeedValue",
    Callback = function(value)
        local success4, err4 = pcall(function()
            if _G.SpeedHack and Character then
                local Humanoid = Character:FindFirstChild("Humanoid")
                if Humanoid then
                    Humanoid.WalkSpeed = value
                    StarterGui:SetCore("SendNotification", {
                        Title = "Speed Updated",
                        Text = "New speed: " .. value .. " studs",
                        Duration = 3
                    })
                end
            end
        end)
        
        if not success4 then
            ShowError("Failed to update speed value")
        end
    end
})

-- JUMP HACK dengan error handling
local JumpToggle = PlayerTab:CreateToggle({
    Name = "High Jump",
    CurrentValue = false,
    Flag = "JumpHack",
    Callback = function(state)
        _G.JumpHack = state
        if state then
            local success5, err5 = pcall(function()
                spawn(function()
                    while _G.JumpHack and Character do
                        task.wait()
                        local Humanoid = Character:FindFirstChild("Humanoid")
                        if Humanoid then
                            Humanoid.JumpPower = 150
                        end
                    end
                end)
            end)
            
            if success5 then
                ShowSuccess("High Jump Activated!\nJumpPower: 150")
            else
                ShowError("High Jump activation failed\nError: " .. tostring(err5))
                _G.JumpHack = false
            end
        else
            pcall(function()
                if Character and Character:FindFirstChild("Humanoid") then
                    Character.Humanoid.JumpPower = 50
                end
            end)
        end
    end
})

-- ============================================
-- TAB 2: GOD MODE DENGAN LOADING NOTIFICATION
-- ============================================
ShowLoading(5)

local GodTab = Window:CreateTab("Protection", "rbxassetid://7072717830")

local GodToggle = GodTab:CreateToggle({
    Name = "God Mode",
    CurrentValue = false,
    Flag = "GodMode",
    Callback = function(state)
        _G.GodMode = state
        if state then
            StarterGui:SetCore("SendNotification", {
                Title = "Loading God Mode...",
                Text = "Setting up immortality system",
                Duration = 2
            })
            
            task.wait(1)
            
            local success6, err6 = pcall(function()
                spawn(function()
                    while _G.GodMode and Character do
                        task.wait(0.1)
                        local Humanoid = Character:FindFirstChild("Humanoid")
                        if Humanoid then
                            Humanoid.MaxHealth = math.huge
                            Humanoid.Health = math.huge
                        end
                    end
                end)
            end)
            
            if success6 then
                ShowSuccess("God Mode Activated!\nYou are now invincible")
            else
                ShowError("God Mode failed to activate\nPlease rejoin game")
                _G.GodMode = false
            end
        else
            StarterGui:SetCore("SendNotification", {
                Title = "God Mode",
                Text = "God Mode Disabled",
                Duration = 3
            })
        end
    end
})

-- ============================================
-- SCRIPT COMPLETION NOTIFICATION
-- ============================================
task.wait(1)
ShowLoading(5)

-- Final Success Message
StarterGui:SetCore("SendNotification", {
    Title = "🎉 Dr.Zuma Script Ready!",
    Text = "All features loaded successfully\nEnjoy your game!",
    Duration = 5,
    Icon = "rbxassetid://7072717830"
})

-- Credit notification
task.wait(2)
StarterGui:SetCore("SendNotification", {
    Title = "CREDITS",
    Text = "Script: Dr.Zuma\nDeveloper: YAMA 🇵🇸",
    Duration = 6
})

print("========================================")
print("Dr.Zuma Script Loaded with Notification System")
print("Credit: YAMA 🇵🇸")
print("Status: SUCCESS")
print("========================================")

-- Auto rejoin suggestion jika ada error
game:GetService("Players").PlayerRemoving:Connect(function(player)
    if player == Player then
        ShowError("Player left game\nPlease rejoin to use script again")
    end
end)

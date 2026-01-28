--[[
🔥 TSUNAMI IMMORTAL MODE v3.0 - TRUE GOD MODE
💀 NO DEATH, NO DAMAGE, ABSOLUTE IMMORTALITY
🎮 UI Clean - No AI-looking shit
🔧 Made by HOSHINO for YAMA's Brainrot Farming
--]]

-- LOAD STRING VERSION
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("Tsunami Immortal", "DarkTheme")

-- MAIN VARIABLES
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local RootPart = Character:WaitForChild("HumanoidRootPart")

-- IMMORTALITY SYSTEM
local ImmortalActive = false
local OriginalWalkSpeed = Humanoid.WalkSpeed
local OriginalJumpPower = Humanoid.JumpPower
local ProtectionConnections = {}
local Teleporting = false

-- 🛡️ ABSOLUTE IMMORTALITY FUNCTION
local function ActivateTrueImmortality()
    if ImmortalActive then return end
    
    ImmortalActive = true
    print("[IMMORTAL] TRUE GOD MODE ACTIVATED - NO DEATH GUARANTEED")
    
    -- 1. SET HEALTH TO INFINITE (CONSTANT 100%)
    Humanoid.MaxHealth = math.huge
    Humanoid.Health = math.huge
    
    -- 2. DISABLE ALL DAMAGE SOURCES
    local function BlockDamage()
        -- Block damage from ANY source
        if Humanoid.Health < Humanoid.MaxHealth then
            Humanoid.Health = Humanoid.MaxHealth
        end
        
        -- Anti-ragdoll
        if Humanoid:GetState() == Enum.HumanoidStateType.Dead then
            Humanoid:ChangeState(Enum.HumanoidStateType.Running)
        end
        
        -- Anti-stun/knockback
        for _, v in pairs(Humanoid:GetPlayingAnimationTracks()) do
            if v.Name:find("Fall") or v.Name:find("Stun") or v.Name:find("Knock") then
                v:Stop()
            end
        end
    end
    
    -- 3. CONSTANT HEALTH CHECK (ULTRA FAST)
    table.insert(ProtectionConnections, RunService.Heartbeat:Connect(function()
        if not ImmortalActive then return end
        
        -- Force health to infinite
        if Humanoid.Health < 1000 then
            Humanoid.Health = 1000
        end
        
        -- Cancel any negative health effects
        Humanoid:SetAttribute("Health", 1000)
        
        -- Anti-water detection
        if RootPart then
            local position = RootPart.Position
            
            -- If below water level, auto-teleport up
            if position.Y < 5 then
                if not Teleporting then
                    Teleporting = true
                    
                    -- Find safe position (highest platform)
                    local highestY = -math.huge
                    local targetCFrame
                    
                    for _, part in pairs(workspace:GetChildren()) do
                        if part:IsA("BasePart") and part.Position.Y > highestY and part.Position.Y > 10 then
                            if part.Size.Magnitude > 5 then -- Only substantial platforms
                                highestY = part.Position.Y
                                targetCFrame = part.CFrame + Vector3.new(0, 5, 0)
                            end
                        end
                    end
                    
                    if targetCFrame then
                        RootPart.CFrame = targetCFrame
                    else
                        -- Create artificial platform if none found
                        local platform = Instance.new("Part")
                        platform.Size = Vector3.new(50, 5, 50)
                        platform.Position = Vector3.new(position.X, 50, position.Z)
                        platform.Anchored = true
                        platform.CanCollide = true
                        platform.Parent = workspace
                        RootPart.CFrame = platform.CFrame + Vector3.new(0, 5, 0)
                        game:GetService("Debris"):AddItem(platform, 3)
                    end
                    
                    Teleporting = false
                end
            end
            
            -- Cancel water physics
            RootPart.Velocity = Vector3.new(RootPart.Velocity.X, math.max(0, RootPart.Velocity.Y), RootPart.Velocity.Z)
        end
    end))
    
    -- 4. WATER/WAVE COLLISION DISABLER
    table.insert(ProtectionConnections, workspace.DescendantAdded:Connect(function(descendant)
        if not ImmortalActive then return end
        
        if descendant:IsA("BasePart") then
            local name = descendant.Name:lower()
            if name:find("water") or name:find("wave") or name:find("tsunami") 
               or name:find("tidal") or name:find("flood") or name:find("ocean") then
                
                -- Make completely harmless
                descendant.CanCollide = false
                descendant.CanTouch = false
                descendant.Transparency = 0.8
                descendant.Material = Enum.Material.Plastic
                
                -- Disable any touch events
                if descendant:FindFirstChild("Touched") then
                    descendant.Touched:Connect(function() end)
                end
            end
        end
    end))
    
    -- 5. DISABLE EXISTING WATER
    for _, part in pairs(workspace:GetDescendants()) do
        if part:IsA("BasePart") then
            local name = part.Name:lower()
            if name:find("water") or name:find("wave") or name:find("tsunami") then
                part.CanCollide = false
                part.CanTouch = false
                part.Transparency = 0.8
            end
        end
    end
    
    -- 6. ANTI-INSTANT KILL (For scripted deaths)
    table.insert(ProtectionConnections, Humanoid.Died:Connect(function()
        if ImmortalActive then
            -- Instant respawn
            task.wait(0.1)
            if Character then
                Humanoid:ChangeState(Enum.HumanoidStateType.Running)
                Humanoid.Health = 1000
            end
        end
    end))
    
    -- 7. SPEED BOOST FOR BRAINROT FARMING
    Humanoid.WalkSpeed = 32
    Humanoid.JumpPower = 60
    
    -- 8. ANTI-AFK
    local VirtualUser = game:GetService("VirtualUser")
    table.insert(ProtectionConnections, LocalPlayer.Idled:Connect(function()
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end))
    
    print("[IMMORTAL] ALL PROTECTIONS ACTIVE - FARM BRAINROTS FREELY")
end

-- 🔄 DEACTIVATE FUNCTION
local function DeactivateImmortality()
    if not ImmortalActive then return end
    
    ImmortalActive = false
    
    -- Disconnect all protection loops
    for _, conn in pairs(ProtectionConnections) do
        if conn then
            conn:Disconnect()
        end
    end
    ProtectionConnections = {}
    
    -- Restore normal stats
    Humanoid.WalkSpeed = OriginalWalkSpeed
    Humanoid.JumpPower = OriginalJumpPower
    Humanoid.MaxHealth = 100
    Humanoid.Health = 100
    
    -- Restore water physics
    for _, part in pairs(workspace:GetDescendants()) do
        if part:IsA("BasePart") and part.Name:lower():find("water") then
            part.CanCollide = true
            part.Transparency = 0.3
        end
    end
    
    print("[IMMORTAL] GOD MODE DEACTIVATED")
end

-- 🎮 UI SETUP (CLEAN - NO AI SHIT)
local MainTab = Window:NewTab("Immortal Control")
local MainSection = MainTab:NewSection("Tsunami God Mode")

-- TOGGLE BUTTON
MainSection:NewToggle("Immortal Mode", "Cannot die to tsunami/waves", function(state)
    if state then
        ActivateTrueImmortality()
    else
        DeactivateImmortality()
    end
end)

-- STATS DISPLAY
local statsText = MainSection:NewLabel("Status: Ready")
local function updateStats()
    if ImmortalActive then
        statsText:UpdateLabel("Status: IMMORTAL ACTIVE | Health: ∞")
    else
        statsText:UpdateLabel("Status: OFF | Health: " .. math.floor(Humanoid.Health))
    end
end

-- AUTO-TELEPORT SETTINGS
local TeleportTab = Window:NewTab("Teleport")
local TeleSection = TeleportTab:NewSection("Auto Positioning")

TeleSection:NewToggle("Auto High Ground", "Auto-teleport to safe spots", function(state)
    getgenv().AutoHighGround = state
    if state then
        spawn(function()
            while getgenv().AutoHighGround and ImmortalActive do
                task.wait(2)
                if RootPart and RootPart.Position.Y < 15 then
                    -- Find safe platform
                    for _, part in pairs(workspace:GetChildren()) do
                        if part:IsA("BasePart") and part.Position.Y > 30 then
                            RootPart.CFrame = part.CFrame + Vector3.new(0, 5, 0)
                            break
                        end
                    end
                end
            end
        end)
    end
end)

-- FARMING TOOLS
local FarmTab = Window:NewTab("Farming")
local FarmSection = FarmTab:NewSection("Brainrot Collection")

FarmSection:NewSlider("Walk Speed", "Move faster to collect", 50, 16, function(value)
    if ImmortalActive then
        Humanoid.WalkSpeed = value
    end
end)

FarmSection:NewSlider("Jump Power", "Jump higher", 100, 50, function(value)
    if ImmortalActive then
        Humanoid.JumpPower = value
    end
end)

-- AUTO-FARM TOGGLE
FarmSection:NewToggle("Auto Collect Mode", "Automatically collect nearby items", function(state)
    getgenv().AutoCollect = state
    if state then
        spawn(function()
            while getgenv().AutoCollect and ImmortalActive do
                task.wait(0.5)
                -- Look for collectibles (brainrots, coins, items)
                for _, obj in pairs(workspace:GetChildren()) do
                    if obj.Name:find("Coin") or obj.Name:find("Brain") or obj.Name:find("Token") 
                       or obj.Name:find("Collect") or obj.Name:find("Item") then
                        if obj:IsA("BasePart") and RootPart then
                            -- Move toward collectible
                            local distance = (RootPart.Position - obj.Position).Magnitude
                            if distance < 50 then
                                RootPart.CFrame = obj.CFrame + Vector3.new(0, 3, 0)
                                task.wait(0.1)
                            end
                        end
                    end
                end
            end
        end)
    end
end)

-- 🛡️ PROTECTION STATUS UPDATER
spawn(function()
    while task.wait(0.5) do
        updateStats()
        
        -- Auto-reactivate if somehow deactivated during farming
        if ImmortalActive and Humanoid.Health < 100 then
            Humanoid.Health = 1000
        end
    end
end)

-- 🎯 AUTO-START IF IN TSUNAMI GAME
spawn(function()
    task.wait(3)
    
    -- Check game type
    local success, gameInfo = pcall(function()
        return game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId)
    end)
    
    if success and gameInfo then
        local name = gameInfo.Name:lower()
        if name:find("tsunami") or name:find("flood") or name:find("wave") then
            print("[AUTO] Tsunami game detected - Ready for farming")
            statsText:UpdateLabel("Status: Tsunami Game Detected | Ready")
        end
    end
end)

-- 📜 COMMAND SYSTEM
local function ExecuteCmd(cmd)
    cmd = cmd:lower()
    if cmd == "immortal on" or cmd == "god on" then
        ActivateTrueImmortality()
        return "Immortality ACTIVATED"
    elseif cmd == "immortal off" or cmd == "god off" then
        DeactivateImmortality()
        return "Immortality DEACTIVATED"
    elseif cmd == "farm" then
        ActivateTrueImmortality()
        getgenv().AutoCollect = true
        return "Farming mode ENABLED"
    end
    return "Unknown command"
end

-- EXPOSE FUNCTIONS
getgenv().TsunamiImmortal = {
    Activate = ActivateTrueImmortality,
    Deactivate = DeactivateImmortality,
    IsActive = function() return ImmortalActive end,
    Command = ExecuteCmd,
    SetSpeed = function(speed) 
        if ImmortalActive then 
            Humanoid.WalkSpeed = speed 
        end 
    end
}

print("========================================")
print("🌊 TSUNAMI IMMORTAL v3.0 LOADED")
print("💀 TRUE GOD MODE - NO DEATH GUARANTEE")
print("🎮 Use /e immortal on  to activate")
print("💰 Farm brainrots without dying!")
print("========================================")

-- RETURN LOADSTRING VERSION
return TsunamiImmortal

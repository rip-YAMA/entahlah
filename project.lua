-- Pastiin load Rayfield dengan method yang work di Xeno
local success, Rayfield = pcall(function()
    return loadstring(game:HttpGet('https://raw.githubusercontent.com/shlexware/Rayfield/main/source.lua'))()
end)

if not success then
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "HOSHINO ERROR",
        Text = "Gagal load Rayfield! Coba inject lagi.",
        Duration = 5
    })
    return
end

-- Cek environment Xeno
local isXeno = false
if syn and syn.request then
    isXeno = false
elseif request and getexecutorname then
    if string.find(string.lower(getexecutorname() or ""), "xeno") then
        isXeno = true
    end
end

-- Konfigurasi khusus Xeno
local Window = Rayfield:CreateWindow({
    Name = " HOSHINO HUB (Xeno Edition)",
    LoadingTitle = "HOSHINO CØRE",
    LoadingSubtitle = "Optimized for Xeno Executor",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "HoshinoConfig_Xeno",
        FileName = "XenoSettings"
    },
    Discord = {
        Enabled = false, -- Xeno kadang error kalo pake discord
    },
    KeySystem = false, -- Nonaktifin keysystem buat Xeno (sering error)
})

-- Tab dengan icon yang compatible
local MainTab = Window:CreateTab("Main", "http://www.roblox.com/asset/?id=4483362458") 
local PlayerTab = Window:CreateTab("Player", "http://www.roblox.com/asset/?id=4483362458")

-- Section Auto Farm (Xeno Compatible)
local FarmSection = MainTab:CreateSection("Auto Farm")
local AutoFarmToggle = MainTab:CreateToggle({
    Name = " Auto Farm Coin",
    CurrentValue = false,
    Flag = "AutoFarmXeno",
    Callback = function(Value)
        _G.AutoFarm = Value
        
        -- Farm function yang aman buat Xeno
        local function safeFarm()
            pcall(function()
                -- Cari coin di workspace
                for _, coin in ipairs(workspace:GetDescendants()) do
                    if coin.Name == "Coin" or coin.Name == "MoneyBag" then
                        if coin:FindFirstChild("TouchInterest") then
                            firetouchinterest(game.Players.LocalPlayer.Character.HumanoidRootPart, coin, 0)
                            firetouchinterest(game.Players.LocalPlayer.Character.HumanoidRootPart, coin, 1)
                        end
                    end
                end
                
                -- Atau panggil remote event yang umum
                local events = {
                    "CollectCoin",
                    "CollectMoney",
                    "FarmEvent",
                    "AddMoney"
                }
                
                for _, eventName in ipairs(events) do
                    local remote = game:GetService("ReplicatedStorage"):FindFirstChild(eventName)
                    if remote then
                        if remote:IsA("RemoteEvent") then
                            remote:FireServer()
                        elseif remote:IsA("RemoteFunction") then
                            remote:InvokeServer()
                        end
                    end
                end
            end)
        end
        
        while _G.AutoFarm and task.wait(0.5) do
            safeFarm()
        end
    end,
})

-- Speed Slider dengan limit buat Xeno
local SpeedSlider = MainTab:CreateSlider({
    Name = " Walk Speed",
    Range = {16, 200}, -- Jangan terlalu tinggi buat Xeno
    Increment = 5,
    Suffix = "studs",
    CurrentValue = 16,
    Flag = "WalkSpeedXeno",
    Callback = function(Value)
        pcall(function()
            local char = game.Players.LocalPlayer.Character
            if char and char:FindFirstChild("Humanoid") then
                char.Humanoid.WalkSpeed = Value
            end
        end)
    end,
})

-- Jump Power Slider
local JumpSlider = MainTab:CreateSlider({
    Name = " Jump Power",
    Range = {50, 200},
    Increment = 10,
    Suffix = "power",
    CurrentValue = 50,
    Flag = "JumpPowerXeno",
    Callback = function(Value)
        pcall(function()
            local char = game.Players.LocalPlayer.Character
            if char and char:FindFirstChild("Humanoid") then
                char.Humanoid.JumpPower = Value
            end
        end)
    end,
})

-- Fly Button (Xeno Compatible)
local FlyButton = PlayerTab:CreateButton({
    Name = " Toggle Fly",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/XNEOFF/FlyGuiV3/main/FlyGuiV3.txt"))()
    end,
})

-- Noclip Button
local NoclipToggle = PlayerTab:CreateToggle({
    Name = " Noclip",
    CurrentValue = false,
    Flag = "NoclipXeno",
    Callback = function(Value)
        _G.Noclip = Value
        
        if Value then
            game:GetService("RunService").Stepped:Connect(function()
                if _G.Noclip then
                    pcall(function()
                        for _, part in ipairs(game.Players.LocalPlayer.Character:GetDescendants()) do
                            if part:IsA("BasePart") then
                                part.CanCollide = false
                            end
                        end
                    end)
                end
            end)
        end
    end,
})

-- Infinite Jump
local InfiniteJumpToggle = PlayerTab:CreateToggle({
    Name = "♾️ Infinite Jump",
    CurrentValue = false,
    Flag = "InfJumpXeno",
    Callback = function(Value)
        _G.InfiniteJump = Value
        
        local UserInputService = game:GetService("UserInputService")
        local jumps = 0
        
        UserInputService.JumpRequest:Connect(function()
            if _G.InfiniteJump then
                pcall(function()
                    game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
                end)
            end
        end)
    end,
})

-- ESP Function (Simple untuk Xeno)
local ESPToggle = PlayerTab:CreateToggle({
    Name = "👁️ Player ESP",
    CurrentValue = false,
    Flag = "ESPXeno",
    Callback = function(Value)
        _G.ESPEnabled = Value
        
        local function createESP(player)
            if player ~= game.Players.LocalPlayer then
                local char = player.Character
                if char then
                    local highlight = Instance.new("Highlight")
                    highlight.Name = "HOSHINO_ESP"
                    highlight.FillColor = Color3.fromRGB(255, 0, 0)
                    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                    highlight.FillTransparency = 0.5
                    highlight.OutlineTransparency = 0
                    highlight.Parent = char
                    highlight.Adornee = char
                    
                    player.CharacterAdded:Connect(function(newChar)
                        task.wait(1)
                        local newHighlight = highlight:Clone()
                        newHighlight.Parent = newChar
                        newHighlight.Adornee = newChar
                    end)
                end
            end
        end
        
        if Value then
            for _, player in ipairs(game.Players:GetPlayers()) do
                createESP(player)
            end
            
            game.Players.PlayerAdded:Connect(createESP)
        else
            for _, player in ipairs(game.Players:GetPlayers()) do
                if player.Character then
                    local esp = player.Character:FindFirstChild("HOSHINO_ESP")
                    if esp then
                        esp:Destroy()
                    end
                end
            end
        end
    end,
})

-- Teleport Section
local TeleportSection = PlayerTab:CreateSection("Teleport")
local TeleportDropdown = PlayerTab:CreateDropdown({
    Name = " Teleport to Player",
    Options = {},
    CurrentOption = "",
    MultipleOptions = false,
    Flag = "TeleportPlayerXeno",
    Callback = function(Option)
        pcall(function()
            local target = game.Players[Option]
            if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame
            end
        end)
    end,
})

-- Update player list
task.spawn(function()
    while task.wait(5) do
        local players = {}
        for _, player in ipairs(game.Players:GetPlayers()) do
            if player ~= game.Players.LocalPlayer then
                table.insert(players, player.Name)
            end
        end
        TeleportDropdown:SetOptions(players)
    end
end)

-- Destroy GUI Button
local DestroyButton = PlayerTab:CreateButton({
    Name = "Destroy GUI",
    Callback = function()
        Rayfield:Destroy()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "HOSHINO",
            Text = "GUI Destroyed!",
            Duration = 3
        })
    end,
})

-- Auto Execute Settings
task.wait(1)
Rayfield:Notify({
    Title = "HOSHINO HUB LOADED",
    Content = "Xeno Executor Detected\nInject Status: SUCCESS",
    Duration = 6,
    Image = 4483362458,
})

-- Fluent UI Library
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

-- MEMBUAT WINDOW UTAMA (Tampilan Persis Seperti Gambar)
local Window = Fluent:CreateWindow({
    Title = "CloutHub | SAE | KEYLESS",
    SubTitle = "discord.gg/cyDpbvxeGN - KEYLESS",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Theme = "Darker",
    MinimizeKey = Enum.KeyCode.LeftControl
})

-- MEMBUAT TAB
local Tabs = {
    AutoFarm = Window:AddTab({ Title = "Auto Farm", Icon = "rbxassetid://10723415903" }),
    EggSelection = Window:AddTab({ Title = "Egg Selection", Icon = "rbxassetid://10723414920" }),
    Character = Window:AddTab({ Title = "Character", Icon = "rbxassetid://10723417131" }),
    ESP = Window:AddTab({ Title = "ESP", Icon = "rbxassetid://10723423881" }),
    ShopSell = Window:AddTab({ Title = "Shop & Sell", Icon = "rbxassetid://10723414308" }),
    Boss = Window:AddTab({ Title = "Boss", Icon = "rbxassetid://10723415124" }),
    Events = Window:AddTab({ Title = "Events", Icon = "rbxassetid://10723415250" }),
    Stats = Window:AddTab({ Title = "Stats", Icon = "rbxassetid://10723415383" }),
    Config = Window:AddTab({ Title = "Config", Icon = "rbxassetid://10723415510" }),
    Webhook = Window:AddTab({ Title = "Webhook", Icon = "rbxassetid://10723415638" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "rbxassetid://10723415766" })
}

local Options = Fluent.Options

---------------------------------------------------------
-- 1. TAB AUTO FARM (Auto Steal Modes & Extras)
---------------------------------------------------------
Tabs.AutoFarm:AddSection("Auto Steal Modes")

-- Auto Steal (Tween)
local ToggleTween = Tabs.AutoFarm:AddToggle("AutoStealTween", {
    Title = "Auto Steal (Tween)",
    Description = "Flies out and steals eggs non stop, nice and smooth",
    Default = false
})

ToggleTween:OnChanged(function()
    _G.AutoTween = Options.AutoStealTween.Value
    task.spawn(function()
        while _G.AutoTween do
            task.wait(0.1)
            for _, obj in pairs(workspace:GetDescendants()) do
                if obj:IsA("ProximityPrompt") and obj.Parent then
                    local eggPart = obj.Parent
                    local hrp = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                    if hrp and eggPart:IsA("BasePart") then
                        local tweenInfo = TweenInfo.new(1, Enum.EasingStyle.Linear)
                        local tween = game:GetService("TweenService"):Create(hrp, tweenInfo, {CFrame = eggPart.CFrame * CFrame.new(0, 3, 0)})
                        tween:Play()
                        tween.Completed:Wait()
                        fireproximityprompt(obj)
                    end
                end
            end
        end
    end)
end)

-- Auto Steal (Teleport)
local ToggleTP = Tabs.AutoFarm:AddToggle("AutoStealTP", {
    Title = "Auto Steal (Teleport)",
    Description = "Warps straight to eggs and steals on repeat",
    Default = false
})

ToggleTP:OnChanged(function()
    _G.AutoTP = Options.AutoStealTP.Value
    task.spawn(function()
        while _G.AutoTP do
            task.wait(0.2)
            for _, obj in pairs(workspace:GetDescendants()) do
                if obj:IsA("ProximityPrompt") and obj.Parent then
                    local hrp = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                    if hrp and obj.Parent:IsA("BasePart") then
                        hrp.CFrame = obj.Parent.CFrame * CFrame.new(0, 3, 0)
                        task.wait(0.1)
                        fireproximityprompt(obj)
                    end
                end
            end
        end
    end)
end)

Tabs.AutoFarm:AddSection("Farm Extras")

-- Auto Claim
local ToggleClaim = Tabs.AutoFarm:AddToggle("AutoClaim", {
    Title = "Auto Claim",
    Description = "Picks up earnings and rewards for you",
    Default = false
})

ToggleClaim:OnChanged(function()
    _G.AutoClaim = Options.AutoClaim.Value
    task.spawn(function()
        while _G.AutoClaim do
            task.wait(1)
            for _, v in pairs(game:GetService("ReplicatedStorage"):GetDescendants()) do
                if v:IsA("RemoteEvent") and (v.Name:lower():find("claim") or v.Name:lower():find("reward")) then
                    v:FireServer()
                end
            end
        end
    end)
end)

-- Equip Best Pets
Tabs.AutoFarm:AddToggle("EquipBest", {
    Title = "Equip Best Pets",
    Description = "Equips your strongest pets on its own",
    Default = false
})

-- Fast Cycle
Tabs.AutoFarm:AddToggle("FastCycle", {
    Title = "Fast Cycle",
    Description = "Shorter waits between steals, grab cooldown under a second",
    Default = true
})

---------------------------------------------------------
-- 2. TAB CHARACTER (Speed, Anti-Trap, Anti-Ragdoll)
---------------------------------------------------------
Tabs.Character:AddSection("Movement & Protection")

Tabs.Character:AddSlider("WalkSpeed", {
    Title = "Walk Speed",
    Description = "Ubah kecepatan karakter kamu",
    Default = 16,
    Min = 16,
    Max = 200,
    Rounding = 0,
    Callback = function(Value)
        if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
            game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
        end
    end
})

---------------------------------------------------------
-- 3. TAB ESP
---------------------------------------------------------
Tabs.ESP:AddSection("Visual Options")

Tabs.ESP:AddToggle("EggESP", {
    Title = "Egg ESP",
    Description = "Lihat posisi telur tembus tembok",
    Default = false,
    Callback = function(Value)
        _G.ESP = Value
        task.spawn(function()
            while _G.ESP do
                task.wait(2)
                for _, v in pairs(workspace:GetDescendants()) do
                    if v:IsA("ProximityPrompt") and v.Parent and not v.Parent:FindFirstChild("ESPHighlight") then
                        local highlight = Instance.new("Highlight")
                        highlight.Name = "ESPHighlight"
                        highlight.FillColor = Color3.fromRGB(0, 255, 138)
                        highlight.Parent = v.Parent
                    end
                end
            end
        end)
    end
})

-- NOTIFIKASI
Fluent:Notify({
    Title = "CloutHub Loaded!",
    Content = "Script berhasil di-load sempurna.",
    Duration = 5
})

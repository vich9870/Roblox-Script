-- Load UI Library (Rayfield)
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Steal an Egg Hub 🥚",
   LoadingTitle = "Loading Script...",
   LoadingSubtitle = "by Vich9870",
   ConfigurationSaving = { Enabled = false },
   KeySystem = false
})

-- TAB MAIN
local MainTab = Window:CreateTab("Main Features", 4483362458)

-- 1. TOGGLE SPEED
MainTab:CreateToggle({
   Name = "Speed Hack",
   CurrentValue = false,
   Flag = "SpeedToggle",
   Callback = function(Value)
      _G.SpeedHack = Value
      task.spawn(function()
         while _G.SpeedHack do
            task.wait(0.1)
            if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
               game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 50
            end
         end
         if not _G.SpeedHack and game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
            game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 16
         end
      end)
   end,
})

-- 2. TOGGLE AUTO TELEPORT & STEAL EGG
MainTab:CreateToggle({
   Name = "Auto Teleport & Steal Egg",
   CurrentValue = false,
   Flag = "AutoStealToggle",
   Callback = function(Value)
      _G.AutoSteal = Value
      task.spawn(function()
         while _G.AutoSteal do
            task.wait(0.5)
            for _, obj in pairs(workspace:GetDescendants()) do
               if obj:IsA("ProximityPrompt") and obj.Parent then
                  local eggPart = obj.Parent
                  local hrp = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                  if hrp and eggPart:IsA("BasePart") then
                     hrp.CFrame = eggPart.CFrame * CFrame.new(0, 3, 0)
                     task.wait(0.1)
                     fireproximityprompt(obj)
                  end
               end
            end
         end
      end)
   end,
})

-- TAB VISUAL & PROTECTION
local VisualTab = Window:CreateTab("Visual & Protection", 4483362458)

-- 3. TOGGLE ESP
VisualTab:CreateToggle({
   Name = "Egg ESP",
   CurrentValue = false,
   Flag = "ESPToggle",
   Callback = function(Value)
      _G.ESP = Value
      if not _G.ESP then
         for _, v in pairs(workspace:GetDescendants()) do
            if v:FindFirstChild("ESPHighlight") then
               v.ESPHighlight:Destroy()
            end
         end
      end
      task.spawn(function()
         while _G.ESP do
            task.wait(2)
            for _, v in pairs(workspace:GetDescendants()) do
               if v:IsA("ProximityPrompt") and v.Parent and not v.Parent:FindFirstChild("ESPHighlight") then
                  local highlight = Instance.new("Highlight")
                  highlight.Name = "ESPHighlight"
                  highlight.FillColor = Color3.fromRGB(255, 255, 0)
                  highlight.Parent = v.Parent
               end
            end
         end
      end)
   end,
})

-- 4. BUTTON BOOST FPS
VisualTab:CreateButton({
   Name = "Boost FPS (Remove Lag)",
   Callback = function()
      for _, v in pairs(workspace:GetDescendants()) do
         if v:IsA("BasePart") then
            v.Material = Enum.Material.SmoothPlastic
            v.Reflectance = 0
         elseif v:IsA("Decal") or v:IsA("Texture") then
            v:Destroy()
         elseif v:IsA("ParticleEmitter") or v:IsA("Trail") then
            v.Enabled = false
         end
      end
      game:GetService("Lighting").GlobalShadows = false
      Rayfield:Notify({Title = "Success", Content = "FPS Boosted!", Duration = 3})
   end,
})

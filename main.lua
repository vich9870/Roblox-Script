-- // Steal an Egg - Super Hub Script
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local LocalPlayer = Players.LocalPlayer

-- Notifikasi Aktif
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "Steal an Egg Hub",
    Text = "Semua fitur berhasil dimuat!",
    Duration = 5
})

-- 1. SPEED HACK
local function applySpeed()
    task.spawn(function()
        while task.wait(0.1) do
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                LocalPlayer.Character.Humanoid.WalkSpeed = 50 -- Ubah angka ini sesuai kebutuhan
            end
        end
    end)
end
applySpeed()

-- 2. AUTO TELEPORT KE TELUR & AUTO INTERACT
task.spawn(function()
    while task.wait(0.5) do
        for _, obj in pairs(Workspace:GetDescendants()) do
            if obj:IsA("ProximityPrompt") and obj.Parent then
                local eggPart = obj.Parent
                if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    -- Teleport ke lokasi telur
                    if eggPart:IsA("BasePart") then
                        LocalPlayer.Character.HumanoidRootPart.CFrame = eggPart.CFrame * CFrame.new(0, 3, 0)
                        task.wait(0.1)
                        fireproximityprompt(obj)
                    end
                end
            end
        end
    end
end)

-- 3. ESP (Melihat Telur & Player Tembus Tembok)
local function applyESP(part, color, text)
    if not part:FindFirstChild("ESPHighlight") then
        local highlight = Instance.new("Highlight")
        highlight.Name = "ESPHighlight"
        highlight.FillColor = color
        highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
        highlight.FillTransparency = 0.5
        highlight.Parent = part
    end
end

task.spawn(function()
    while task.wait(2) do
        for _, v in pairs(Workspace:GetDescendants()) do
            if v:IsA("ProximityPrompt") and v.Parent then
                applyESP(v.Parent, Color3.fromRGB(255, 255, 0), "Egg")
            end
        end
    end
end)

-- 4. OTOMATIS LAWAN DOCTOR SCRAMBLE (Auto Fight)
task.spawn(function()
    while task.wait(0.3) do
        for _, npc in pairs(Workspace:GetDescendants()) do
            if npc.Name:lower():find("scramble") or npc.Name:lower():find("doctor") then
                if npc:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character then
                    -- Serang NPC / Gunakan Tool
                    local tool = LocalPlayer.Character:FindFirstChildOfClass("Tool") or LocalPlayer.Backpack:FindFirstChildOfClass("Tool")
                    if tool then
                        tool.Parent = LocalPlayer.Character
                        tool:Activate()
                    end
                end
            end
        end
    end
end)

-- 5. ANTI HIT, ANTI TRAP, ANTI RAGDOLL
RunService.Stepped:Connect(function()
    if LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = true
            end
        end
        local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
            humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
            humanoid.PlatformStand = false
        end
    end
end)

-- 6. AUTO CLAIM ITEM & AUTO BUY
task.spawn(function()
    while task.wait(1) do
        -- Trigger remote events umum untuk claim/buy
        for _, v in pairs(game:GetService("ReplicatedStorage"):GetDescendants()) do
            if v:IsA("RemoteEvent") then
                if v.Name:lower():find("claim") or v.Name:lower():find("buy") or v.Name:lower():find("reward") then
                    v:FireServer()
                end
            end
        end
    end
end)

-- 7. BOOST FPS (Menghapus Leg & Efek Berat)
local function boostFPS()
    for _, v in pairs(Workspace:GetDescendants()) do
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
end
boostFPS()

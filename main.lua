local Players = game:GetService("Players")

-- Membuat leaderstats untuk menyimpan jumlah telur pemain
Players.PlayerAdded:Connect(function(player)
	local leaderstats = Instance.new("Folder")
	leaderstats.Name = "leaderstats"
	leaderstats.Parent = player

	local eggCount = Instance.new("IntValue")
	eggCount.Name = "Eggs"
	eggCount.Value = 0
	eggCount.Parent = leaderstats
end)

-- Fungsi untuk mencuri telur
local eggPart = workspace:WaitForChild("EggPart")
local proximityPrompt = eggPart:FindFirstChildOfClass("ProximityPrompt")

if proximityPrompt then
	proximityPrompt.Triggered:Connect(function(player)
		local leaderstats = player:FindFirstChild("leaderstats")
		if leaderstats then
			local eggCount = leaderstats:FindFirstChild("Eggs")
			if eggCount then
				-- Tambah jumlah telur pemain
				eggCount.Value = eggCount.Value + 1
				
				-- Sembunyikan telur sementara (efek diambil)
				eggPart.Transparency = 1
				eggPart.CanCollide = false
				proximityPrompt.Enabled = false
				
				-- Waktu respawn telur (contoh: 5 detik)
				task.wait(5)
				
				-- Munculkan kembali telur
				eggPart.Transparency = 0
				eggPart.CanCollide = true
				proximityPrompt.Enabled = true
			end
		end
	end)
end

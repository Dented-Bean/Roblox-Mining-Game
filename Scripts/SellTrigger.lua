print("Hello world!")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local playerCollections = ReplicatedStorage:WaitForChild("PlayerCollections")
local updateEvent = ReplicatedStorage:WaitForChild("UpdateCollection")

local zone = script.Parent
local cooldown = {}

zone.Touched:Connect(function(hit)
	local character = hit.Parent
	local player = game.Players:GetPlayerFromCharacter(character)
	if not player then return end
	if cooldown[player] then return end

	local folder = playerCollections:FindFirstChild(player.Name)
	if not folder then return end

	local totalCoins = 0

	for _, ore in ipairs(folder:GetChildren()) do
		local value = 0
		if ore.Name == "Dirt" then value = 1
		elseif ore.Name == "CopperOre" then value = 10
		elseif ore.Name == "IronOre" then value = 25
		elseif ore.Name == "GoldOre" then value = 50 end

		totalCoins += value * ore.Value
		ore.Value = 0
	end

	-- Add coins
	local coins = player:FindFirstChild("Coins")
	if coins then
		coins.Value += totalCoins
	end

	-- Tell client
	updateEvent:FireClient(player, {}, totalCoins)

	-- Cooldown to prevent reselling too fast
	cooldown[player] = true
	task.delay(3, function()
		cooldown[player] = nil
	end)
end)

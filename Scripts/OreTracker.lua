print("Hello world!")

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Create the shared ore collection folder
local playerCollections = Instance.new("Folder")
playerCollections.Name = "PlayerCollections"
playerCollections.Parent = ReplicatedStorage

-- Create SellInventory RemoteEvent (only once)
if not ReplicatedStorage:FindFirstChild("SellInventory") then
	local sellEvent = Instance.new("RemoteEvent")
	sellEvent.Name = "SellInventory"
	sellEvent.Parent = ReplicatedStorage
end

local oreMinedEvent = ReplicatedStorage:WaitForChild("OreMined")
local updateEvent = ReplicatedStorage:WaitForChild("UpdateCollection")

-- Setup ore tracking per player
Players.PlayerAdded:Connect(function(player)
	local folder = Instance.new("Folder")
	folder.Name = player.Name
	folder.Parent = playerCollections
	
	local coins = Instance.new("IntValue")
	coins.Name = "Coins"
	coins.Value = 0
	coins.Parent = player

	player.AncestryChanged:Connect(function()
		if not player:IsDescendantOf(game) then
			if playerCollections:FindFirstChild(player.Name) then
				playerCollections[player.Name]:Destroy()
			end
		end
	end)
end)

-- When a player mines
oreMinedEvent.OnServerEvent:Connect(function(player, oreName)
	local folder = playerCollections:FindFirstChild(player.Name)
	if not folder then return end

	local oreValue = folder:FindFirstChild(oreName)
	if not oreValue then
		oreValue = Instance.new("IntValue")
		oreValue.Name = oreName
		oreValue.Parent = folder
	end

	oreValue.Value += 1

	-- Send a collection snapshot to client
	local snapshot = {}
	for _, ore in ipairs(folder:GetChildren()) do
		snapshot[ore.Name] = ore.Value
	end

	updateEvent:FireClient(player, snapshot)
	print(player.Name .. " mined: " .. oreName)
end)


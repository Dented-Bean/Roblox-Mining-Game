print("Hello world!")

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local playerCollections = ReplicatedStorage:WaitForChild("PlayerCollections")
local sellEvent = ReplicatedStorage:WaitForChild("SellInventory")
local updateEvent = ReplicatedStorage:WaitForChild("UpdateCollection")

sellEvent.OnServerEvent:Connect(function(player)

	-- Teleport to SellZone
	local sellZone = workspace:FindFirstChild("SellZone")
	if sellZone then
		print("Teleporting to:", sellZone.Position)
		player.Character:MoveTo(sellZone.Position + Vector3.new(0, 5, 0))
	else
		warn("SellZone not found!")
	end
end)

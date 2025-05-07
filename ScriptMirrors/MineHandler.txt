print("Hello world!")
local event = game.ReplicatedStorage:WaitForChild("MineRequest")

event.OnServerEvent:Connect(function(player, target)
	if target and target:IsDescendantOf(workspace) and target.Name == "MineBlock" then
		target:Destroy()
	end
end)

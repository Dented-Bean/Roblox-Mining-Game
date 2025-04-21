print("Hello world!")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

if not ReplicatedStorage:FindFirstChild("OreTotal") then
	local oreCount = Instance.new("IntValue")
	oreCount.Name = "OreTotal"
	oreCount.Value = 0
	oreCount.Parent = ReplicatedStorage
end

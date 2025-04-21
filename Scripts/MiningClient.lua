local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer
local mouse = player:GetMouse()
local mineEvent = ReplicatedStorage:WaitForChild("GenerateAdjacentBlocks")

local maxBackpack = 200

-- Safely wait for OreTotal to exist
local oreTotalValue
repeat
	oreTotalValue = ReplicatedStorage:FindFirstChild("OreTotal")
	task.wait()
until oreTotalValue

print("✔ OreTotal linked:", oreTotalValue.Value)

-- UI Stuff
local inventoryFullUI = player:WaitForChild("PlayerGui"):WaitForChild("InventoryFullUI")
local popup = inventoryFullUI:WaitForChild("PopupFrame")
local sellButton = popup:WaitForChild("SellButton")

-- Mining state
local mining = false
local mineCooldown = 0.001

local function snapVector(vec)
	local x = math.abs(vec.X)
	local y = math.abs(vec.Y)
	local z = math.abs(vec.Z)
	if x > y and x > z then
		return Vector3.new(vec.X > 0 and 1 or -1, 0, 0)
	elseif y > x and y > z then
		return Vector3.new(0, vec.Y > 0 and 1 or -1, 0)
	else
		return Vector3.new(0, 0, vec.Z > 0 and 1 or -1)
	end
end

-- Mining loop
task.spawn(function()
	while true do
		if mining then
			if oreTotalValue.Value >= maxBackpack then
				popup.Visible = true
			else
				local target = mouse.Target
				if target and target.Name == "Block" then
					local hitPosition = mouse.Hit.Position
					local normal = snapVector((hitPosition - target.Position).Unit)
					mineEvent:FireServer(target.Position, normal)

					local oreName = target.Parent.Name
					ReplicatedStorage:WaitForChild("OreMined"):FireServer(oreName)
				end
			end
		end
		task.wait(mineCooldown)
	end
end)

-- Mouse input
mouse.Button1Down:Connect(function()
	mining = true
end)

mouse.Button1Up:Connect(function()
	mining = false
end)

-- Sell button
sellButton.MouseButton1Click:Connect(function()
	popup.Visible = false
	ReplicatedStorage:WaitForChild("SellInventory"):FireServer()
end)

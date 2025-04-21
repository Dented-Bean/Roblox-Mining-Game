print("Hello world!")

local currentOreTotal = 0

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = game.Players.LocalPlayer

print("Received collection update:", collection)

local maxBackpack = 200
local oreUI = player:WaitForChild("PlayerGui"):WaitForChild("OreCollectionUI")
local scrollFrame = oreUI:WaitForChild("ScrollFrameContainer"):WaitForChild("ScrollFrame")
local backpackLabel = oreUI:WaitForChild("BackpackHeader"):WaitForChild("BackpackLabel")


local oreUI = player:WaitForChild("PlayerGui"):WaitForChild("OreCollectionUI")
local scrollFrame = oreUI:WaitForChild("ScrollFrameContainer"):WaitForChild("ScrollFrame")

-- Clear and re-create UI entries
local function updateCollectionUI(collection)
	scrollFrame:ClearAllChildren()
	
	local oreTotalValue = game:GetService("ReplicatedStorage"):WaitForChild("OreTotal")

	-- Calculate total ore count
	local total = 0
	for _, count in pairs(collection) do
		total += count
	end

	-- Update backpack label
	backpackLabel.Text = tostring(total) .. "/" .. tostring(maxBackpack)

	currentOreTotal = total
	oreTotalValue.Value = total

	print("Backpack count updated:", total)

	-- Add layout again after clearing
	local layout = Instance.new("UIListLayout")
	layout.SortOrder = Enum.SortOrder.Name
	layout.Parent = scrollFrame

	local sorted = {}

	for oreName, count in pairs(collection) do
		table.insert(sorted, {name = oreName, count = count})
	end

	table.sort(sorted, function(a, b)
		return a.count > b.count
	end)

	for _, ore in ipairs(sorted) do
		local oreName = ore.name
		local count = ore.count

		local entry = Instance.new("Frame")
		entry.Size = UDim2.new(1, 0, 0, 30)
		entry.BackgroundTransparency = 1

		local colorBox = Instance.new("Frame")
		colorBox.Size = UDim2.new(0, 20, 0, 20)
		colorBox.Position = UDim2.new(0, 5, 0.5, -10)
		colorBox.BackgroundColor3 = getOreColor(oreName)
		colorBox.BorderSizePixel = 0
		colorBox.Parent = entry

		local label = Instance.new("TextLabel")
		label.Text = oreName .. " x" .. count
		label.Size = UDim2.new(1, -30, 1, 0)
		label.Position = UDim2.new(0, 30, 0, 0)
		label.BackgroundTransparency = 1
		label.TextColor3 = Color3.new(1, 1, 1)
		label.TextXAlignment = Enum.TextXAlignment.Left
		label.Font = Enum.Font.Gotham
		label.TextSize = 14
		label.Parent = entry

		entry.Parent = scrollFrame
	end

end

-- Dummy color matcher (adjust this to match your ore colors)
function getOreColor(name)
	if name == "CopperOre" then
		return Color3.fromRGB(184, 115, 51)
	elseif name == "IronOre" then
		return Color3.fromRGB(209, 209, 209)
	elseif name == "GoldOre" then
		return Color3.fromRGB(255, 215, 0)
	elseif name == "Dirt" then
		return Color3.fromRGB(128, 59, 28)
	else
		return Color3.new(1, 1, 1)
	end
end

-- Listen for update from server
ReplicatedStorage:WaitForChild("UpdateCollection").OnClientEvent:Connect(updateCollectionUI)
print("UI received update from server")

print("Hello world!")
local auras = {"Common", "Uncommon", "Rare", "Legendary", "Mythic"}
local auraChances = {0.5, 0.3, 0.15, 0.045, 0.005} -- Must add up to 1

local button = script.Parent
local clickDetector = button:FindFirstChild("ClickDetector")

local function pickAura()
	local rand = math.random()
	local cumulative = 0

	for i, chance in ipairs(auraChances) do
		cumulative += chance
		if rand <= cumulative then
			return auras[i]
		end
	end
	return "Error"
end

clickDetector.MouseClick:Connect(function(player)
	local aura = pickAura()
	local playerGui = player:FindFirstChild("PlayerGui")
	if playerGui then
		local gui = playerGui:FindFirstChild("ScreenGui")
		if gui then
			local label = gui:FindFirstChild("ResultLabel")
			if label then
				label.Text = "You rolled: " .. aura
			end
		end
	end
end)

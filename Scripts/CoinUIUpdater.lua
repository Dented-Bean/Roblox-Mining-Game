print("Hello world!")

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local coinUI = playerGui:WaitForChild("OreCollectionUI")
local coinLabel = coinUI:WaitForChild("CoinHeader"):WaitForChild("CoinLabel")

-- Create floating +X gain label
local floatingText = Instance.new("TextLabel")
floatingText.BackgroundTransparency = 1
floatingText.TextColor3 = Color3.fromRGB(0, 255, 0)
floatingText.Font = Enum.Font.GothamBold
floatingText.TextSize = 21
floatingText.AnchorPoint = Vector2.new(0, 0.5)
floatingText.Position = UDim2.new(1, 10, 0.5, 0) -- to the right of coin label
floatingText.Size = UDim2.new(0, 100, 0, 24)
floatingText.Visible = false
floatingText.TextXAlignment = Enum.TextXAlignment.Left
floatingText.Parent = coinUI:WaitForChild("CoinHeader")

-- Listen for UpdateCollection and handle totalCoins (sent during sell)
ReplicatedStorage:WaitForChild("UpdateCollection").OnClientEvent:Connect(function(collection, totalCoins)
	if totalCoins then
		-- Update the coin label to match server value
		local coins = player:FindFirstChild("Coins")
		if coins then
			coinLabel.Text = tostring(coins.Value)
		end

		-- Show floating +X text
		floatingText.Text = "+" .. tostring(totalCoins)
		floatingText.Visible = true
		floatingText.TextTransparency = 0

		-- Fade out after 2 seconds
		task.delay(2, function()
			for i = 0, 1, 0.05 do
				floatingText.TextTransparency = i
				task.wait(0.05)
			end
			floatingText.Visible = false
		end)
	end
end)

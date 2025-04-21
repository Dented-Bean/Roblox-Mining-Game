print("Hello world!")

local player = game.Players.LocalPlayer
local gui = player:WaitForChild("PlayerGui"):WaitForChild("ShopUI")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

local TweenService = game:GetService("TweenService")
local screenFader = player.PlayerGui:WaitForChild("ScreenFaderGui"):WaitForChild("ScreenFader")


-- 🕒 Wait for ShopUI to exist
local shopUI
repeat
	shopUI = player:FindFirstChild("PlayerGui"):FindFirstChild("ShopUI")
	task.wait()
until shopUI
local fullScreen = shopUI:WaitForChild("FullScreenFrame")
local exitButton = fullScreen:WaitForChild("ExitShopButton")

-- UI references
local pickaxeImage = gui:WaitForChild("Pickaxe1")
local pickaxeWorth = gui:WaitForChild("FullScreenFrame"):WaitForChild("PickaxeWorth")
local nextPickaxe = gui:WaitForChild("FullScreenFrame"):WaitForChild("NextPickaxeButton")
local purchaseButton = gui:WaitForChild("FullScreenFrame"):WaitForChild("PurchaseButton")
local confirmFrame = gui:WaitForChild("ConfirmPurchase")
local cancelPurchase = confirmFrame:WaitForChild("CancelPurchaseButton")
local confirmPurchase = confirmFrame:WaitForChild("ConfirmPurchaseButton")

-- Pickaxe data
local pickaxes = {
	{image = "rbxassetid://16022870159", price = 100},
	{image = "rbxassetid://16022870355", price = 250},
	{image = "rbxassetid://16022870550", price = 500}
}
local currentIndex = 1

-- Function to update image + price
local function updatePickaxe()
	local data = pickaxes[currentIndex]
	pickaxeImage.Image = data.image
	pickaxeWorth.Text = "$" .. data.price
end

local function fadeScreen(targetTransparency, duration)
	local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)
	local tween = TweenService:Create(screenFader, tweenInfo, {BackgroundTransparency = targetTransparency})
	tween:Play()
	return tween
end

-- Next pickaxe button
nextPickaxe.MouseButton1Click:Connect(function()
	currentIndex += 1
	if currentIndex > #pickaxes then currentIndex = 1 end
	updatePickaxe()
end)

-- Purchase logic
purchaseButton.MouseButton1Click:Connect(function()
	confirmFrame.Visible = true
end)

cancelPurchase.MouseButton1Click:Connect(function()
	confirmFrame.Visible = false
end)

confirmPurchase.MouseButton1Click:Connect(function()
	confirmFrame.Visible = false
	print("✅ Purchase confirmed (logic coming soon)")
end)

exitButton.MouseButton1Click:Connect(function()
	shopUI.Enabled = false
	fullScreen.Visible = false
	pickaxeImage.Visible = false
	purchaseButton.Visible = false
	exitButton.Visible = false
	pickaxeWorth.Visible = false
	nextPickaxe.Visible = false
	confirmFrame.Visible = false
end)

print("🧠 ExitButton found:", exitButton)

-- Init
updatePickaxe()
confirmFrame.Visible = false

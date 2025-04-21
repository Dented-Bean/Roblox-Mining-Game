print("Hello world!")
-- Make shop UI elements visible when testing
game.Players.PlayerAdded:Connect(function(player)
	local gui = player:WaitForChild("PlayerGui"):WaitForChild("ShopUI")

	gui.Enabled = true

	gui:WaitForChild("Pickaxe1").Visible = true
	gui:WaitForChild("ConfirmPurchase").Visible = true
	gui:WaitForChild("FullScreenFrame").Visible = true

	local fs = gui.FullScreenFrame
	fs:WaitForChild("NextPickaxeButton").Visible = true
	fs:WaitForChild("ExitShopButton").Visible = true
	fs:WaitForChild("NextShopButton").Visible = true
	fs:WaitForChild("PurchaseButton").Visible = true
	fs:WaitForChild("PickaxeWorth").Visible = true
end)

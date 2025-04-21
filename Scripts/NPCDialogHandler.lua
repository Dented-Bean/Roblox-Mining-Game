print("Hello world!")

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

-- Wait for PlayerGui
repeat task.wait() until player:FindFirstChild("PlayerGui")

local dialogUI = player.PlayerGui:WaitForChild("DialogUI")
local dialogFrame = dialogUI:WaitForChild("DialogFrame")
local dialogLabel = dialogFrame:WaitForChild("DialogLabel")
local dialogOptions = dialogFrame:WaitForChild("DialogOptions")
local dialogOptionsFrame = dialogFrame:WaitForChild("DialogOptionsFrame")

local pickaxeButton = dialogOptionsFrame:WaitForChild("PickaxeButton")
local backpackButton = dialogOptionsFrame:WaitForChild("BackpackButton")
local goodbyeButton = dialogOptionsFrame:WaitForChild("GoodbyeButton")
local tempButton = dialogOptionsFrame:WaitForChild("TempButton")

local shopUI = player.PlayerGui:WaitForChild("ShopUI")
local fullScreen = shopUI:WaitForChild("FullScreenFrame")
local pickaxeImage = shopUI:WaitForChild("Pickaxe1")
local pickaxeWorth = fullScreen:WaitForChild("PickaxeWorth")
local nextPickaxe = fullScreen:WaitForChild("NextPickaxeButton")
local purchaseButton = fullScreen:WaitForChild("PurchaseButton")
local exitButton = fullScreen:WaitForChild("ExitShopButton")
local confirmFrame = shopUI:WaitForChild("ConfirmPurchase")

local prompt = workspace:WaitForChild("ShopNPC"):WaitForChild("Head"):WaitForChild("ProximityPrompt")
local cameraFocusPart = workspace.ShopAssets:WaitForChild("CameraFocus")
local shopCam = workspace.ShopAssets:WaitForChild("PickaxeShopCam")

local screenFader = player.PlayerGui:WaitForChild("ScreenFader")

-- Dialog lines
local dialogLines = {
	"Hey, welcome to my shop, looking for anything specific?",
	"Greetings and salutations!"
}

-- Text typing
local function typeText(text)
	dialogLabel.Text = ""
	for i = 1, #text do
		dialogLabel.Text = string.sub(text, 1, i)
		task.wait(0.045)
	end
end

-- Fade screen helper
local function fadeScreen(alpha, duration)
	screenFader.BackgroundTransparency = (alpha == 0 and 1 or 0)
	screenFader.Visible = true

	local tween = TweenService:Create(screenFader, TweenInfo.new(duration), {
		BackgroundTransparency = alpha
	})
	tween:Play()
	tween.Completed:Wait()
	if alpha == 1 then screenFader.Visible = false end
end

-- Dialog animation
local function playDialogBoxAnimation()
	dialogFrame.Size = UDim2.new(0, 4, 0.1, 0)
	dialogFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
	dialogFrame.Visible = true

	local step1 = TweenService:Create(dialogFrame, TweenInfo.new(0.6), {Size = UDim2.new(0, 4, 0.1, 0)})
	local step2 = TweenService:Create(dialogFrame, TweenInfo.new(0.6), {Size = UDim2.new(0.45, 0, 0.1, 0)})
	local step3 = TweenService:Create(dialogFrame, TweenInfo.new(0.6), {Size = UDim2.new(0.45, 0, 0.3, 0)})

	step1:Play()
	step1.Completed:Wait()
	step2:Play()
	step2.Completed:Wait()
end

-- Fade in buttons one by one in order
local function revealDialogOptions()
	dialogOptionsFrame.Visible = true
	local buttonOrder = {
		pickaxeButton,
		backpackButton,
		tempButton,
		goodbyeButton
	}
	for _, button in ipairs(buttonOrder) do
		button.Visible = true
		button.TextTransparency = 1
		button.BackgroundTransparency = 1

		TweenService:Create(button, TweenInfo.new(0.2), {TextTransparency = 0}):Play()
		TweenService:Create(button, TweenInfo.new(0.2), {BackgroundTransparency = 0}):Play()
		task.wait(0.2)
	end
end

-- Player pressed E
prompt.Triggered:Connect(function()
	prompt.Enabled = false

	camera.CameraType = Enum.CameraType.Scriptable
	local tween = TweenService:Create(camera, TweenInfo.new(0.6, Enum.EasingStyle.Sine), {
		CFrame = CFrame.new(cameraFocusPart.Position, cameraFocusPart.Position + cameraFocusPart.CFrame.LookVector)
	})
	tween:Play()
	tween.Completed:Wait()

	dialogUI.Enabled = true
	playDialogBoxAnimation()
	typeText(dialogLines[math.random(1, #dialogLines)])
	revealDialogOptions()
end)

-- Pickaxes button
pickaxeButton.MouseButton1Click:Connect(function()
	dialogUI.Enabled = false
	fadeScreen(0, 0.75)
	task.wait(0.75)

	camera.CameraType = Enum.CameraType.Scriptable
	camera.CFrame = shopCam.CFrame

	fadeScreen(1, 0.75)
	task.wait(0.5)

	shopUI.Enabled = true
	fullScreen.Visible = true
	pickaxeImage.Visible = true
	purchaseButton.Visible = true
	exitButton.Visible = true
	pickaxeWorth.Visible = true
	nextPickaxe.Visible = true
	confirmFrame.Visible = false

	print("✅ Pickaxe Shop UI opened")
end)

-- Backpacks button
backpackButton.MouseButton1Click:Connect(function()
	print("Open Backpack Shop (coming soon)")
end)

-- Temp button
tempButton.MouseButton1Click:Connect(function()
	print("Temp button clicked (does nothing yet)")
end)

-- Goodbye button
goodbyeButton.MouseButton1Click:Connect(function()
	dialogUI.Enabled = false
	dialogFrame.Visible = false
	dialogOptionsFrame.Visible = false
	for _, b in pairs(dialogOptionsFrame:GetChildren()) do
		if b:IsA("TextButton") then
			b.Visible = false
		end
	end

	fadeScreen(0, 0.75)
	task.wait(0.75)

	camera.CameraType = Enum.CameraType.Custom
	camera.CameraSubject = player.Character:WaitForChild("Humanoid")

	fadeScreen(1, 0.75)
	task.wait(0.5)

	prompt.Enabled = true
end)

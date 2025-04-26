print("Hello world!")

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

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
local ScreenFaderGui = player.PlayerGui:WaitForChild("ScreenFaderGui")
local screenFader = ScreenFaderGui:WaitForChild("ScreenFader")

local cameraFocusPart = workspace:WaitForChild("ShopNPC"):WaitForChild("CameraFocus")
local pickaxeShopCam = workspace:WaitForChild("ShopAssets"):WaitForChild("PickaxeShopCam")
local originalCameraCFrame = nil

-- Fade Function
local function fadeScreen(targetTransparency, duration)
	local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Linear)
	local tween = TweenService:Create(screenFader, tweenInfo, {BackgroundTransparency = targetTransparency})
	tween:Play()
	tween.Completed:Wait()
end

-- NPC Text Typing
local function typeDialog(text)
	dialogLabel.Text = ""
	for i = 1, #text do
		dialogLabel.Text = string.sub(text, 1, i)
		task.wait(0.025)
	end
	-- 🕓 Add a delay before expanding down
	task.wait(0.4) -- adjust this number to your liking
end

-- Button Reveal
local function revealDialogOptions()
	dialogOptionsFrame.Visible = true -- ✅ Reveal the button container
	
	local orderedButtons = {
		dialogOptionsFrame:FindFirstChild("PickaxeButton"),
		dialogOptionsFrame:FindFirstChild("BackpackButton"),
		dialogOptionsFrame:FindFirstChild("TempButton"),
		dialogOptionsFrame:FindFirstChild("GoodbyeButton")
	}

	for i, button in ipairs(orderedButtons) do
		if button then
			button.Visible = true
			button.TextTransparency = 1
			button.BackgroundTransparency = 1
			task.delay((i - 1) * 0.2, function()
				local tween = TweenService:Create(button, TweenInfo.new(0.3), {
					TextTransparency = 0,
					BackgroundTransparency = 0
				})
				tween:Play()
			end)
		end
	end
end

-- Animate Dialog Box
local function animateDialogBox(callback)
	dialogUI.Enabled = true
	dialogFrame.Visible = true
	dialogLabel.Text = "" -- ✨ This clears leftover text
	dialogFrame.AnchorPoint = Vector2.new(0.5, 0)
	dialogFrame.Position = UDim2.new(0.5, 0, 0.55, 0)
	dialogFrame.Size = UDim2.new(0, 4, 0, 4)

	for _, btn in pairs(dialogOptionsFrame:GetChildren()) do
		if btn:IsA("TextButton") then
			btn.Visible = false
		end
	end

	local step1 = TweenService:Create(dialogFrame, TweenInfo.new(0.6), {Size = UDim2.new(0, 4, 0.1, 0)})
	local step2 = TweenService:Create(dialogFrame, TweenInfo.new(0.6), {Size = UDim2.new(0.45, 0, 0.1, 0)})
	local step3 = TweenService:Create(dialogFrame, TweenInfo.new(0.6), {Size = UDim2.new(0.45, 0, 0.3, 0)})

	step1:Play()
	step1.Completed:Wait()
	step2:Play()
	step2.Completed:Wait()
	callback()
	step3:Play()
	step3.Completed:Wait()
	revealDialogOptions()
end

-- Prompt Trigger
prompt.Triggered:Connect(function()
	prompt.Enabled = false
	-- Lock the camera to allow manipulation
	camera.CameraType = Enum.CameraType.Scriptable

	-- Get current camera position (player view, whether in 1st or 3rd person)
	local startCFrame = camera.CFrame

	-- Set target CFrame (in front of the NPC's face)
	local targetPosition = cameraFocusPart.Position
	local targetLookAt = targetPosition + cameraFocusPart.CFrame.LookVector
	local endCFrame = CFrame.new(targetPosition, targetLookAt)

	-- Tween from the player’s current view to the NPC’s face
	originalCameraCFrame = camera.CFrame
	camera.CFrame = startCFrame
	local tweenInfo = TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
	local camTween = TweenService:Create(camera, tweenInfo, { CFrame = endCFrame })
	camTween:Play()

	local randomLine = "Greetings and salutations!" -- Fixed text for now
	animateDialogBox(function()
		typeDialog(randomLine)
	end)

	print("Proximity prompt triggered")
end)

-- Pickaxe Button Logic
pickaxeButton.MouseButton1Click:Connect(function()
	print("🔁 Pickaxe Shop transition started")
	dialogUI.Enabled = false

	fadeScreen(0, 0.75)
	task.wait(0.75)

	camera.CameraType = Enum.CameraType.Scriptable
	camera.CFrame = pickaxeShopCam.CFrame

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

	print("✅ Pickaxe Shop UI opened with camera transition")
end)

backpackButton.MouseButton1Click:Connect(function()
	print("Open Backpack Shop (coming soon)")
end)

goodbyeButton.MouseButton1Click:Connect(function()
	print("👋 Player clicked Nevermind")

	-- Fade to black
	fadeScreen(0, 0.75)
	task.wait(0.75)

	-- Return the camera
	if originalCameraCFrame then
		camera.CameraType = Enum.CameraType.Scriptable
		camera.CFrame = originalCameraCFrame
	end

	-- Fade back in
	fadeScreen(1, 0.75)

	-- Re-enable default camera
	task.wait(0.5)
	camera.CameraType = Enum.CameraType.Custom

	-- Hide UI
	dialogUI.Enabled = false
	prompt.Enabled = true
end)


tempButton.MouseButton1Click:Connect(function()
	print("Temp button clicked (does nothing yet)")
end)

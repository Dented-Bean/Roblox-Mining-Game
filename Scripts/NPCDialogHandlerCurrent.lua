print("NPCDialogHandler started running")

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local camera = workspace.CurrentCamera

-- Wait for PlayerGui to exist
repeat task.wait() until player:FindFirstChild("PlayerGui")

-- UI Elements
local dialogUI = player.PlayerGui:WaitForChild("DialogUI")
local dialogFrame = dialogUI:WaitForChild("DialogFrame")
local dialogLabel = dialogFrame:WaitForChild("DialogLabel")
local dialogOptions = dialogFrame:WaitForChild("DialogOptions")
local dialogOptionsFrame = dialogFrame:WaitForChild("DialogOptionsFrame")

-- Buttons
local pickaxeButton = dialogOptionsFrame:WaitForChild("PickaxeButton")
local backpackButton = dialogOptionsFrame:WaitForChild("BackpackButton")
local goodbyeButton = dialogOptionsFrame:WaitForChild("GoodbyeButton")
local tempButton = dialogOptionsFrame:WaitForChild("TempButton")

-- Fade UI (correct structure based on GitHub layout)
local screenFaderGui = player.PlayerGui:WaitForChild("ScreenFaderGui")
local screenFader = screenFaderGui:WaitForChild("ScreenFader")

-- NPC + Camera Parts
local shopNPC = workspace:WaitForChild("ShopNPC")
local cameraFocus = shopNPC:WaitForChild("CameraFocus")

-- Settings
local typingSpeed = 0.03
local fadeTime = 0.5

-- State control
local inDialog = false

-- Typing function
local function typeText(text)
	dialogLabel.Text = ""
	for i = 1, #text do
		dialogLabel.Text = string.sub(text, 1, i)
		RunService.Heartbeat:Wait()
		wait(typingSpeed)
	end
end

-- Fade function
local function fadeScreen(fadeIn)
	local goal = {}
	goal.BackgroundTransparency = fadeIn and 1 or 0
	local tween = TweenService:Create(screenFader, TweenInfo.new(fadeTime), goal)
	tween:Play()
	tween.Completed:Wait()
end

-- Open Dialog
local function openDialog()
	print("openDialog() was called")
	inDialog = true
	print("openDialog() was called") -- 🧼 Step 1

	-- Move Camera
	camera.CameraType = Enum.CameraType.Scriptable
	print("Camera set to Scriptable") -- 🧼 Step 2
	camera.CFrame = camera.CFrame:Lerp(cameraFocus.CFrame, 0.5)
	print("Camera Lerp attempted") -- 🧼 Step 3

	-- Animate Dot > Line > Box > Text > Buttons
	dialogUI.Enabled = true
	print("Dialog UI enabled") -- 🧼 Step 4
	dialogFrame.Size = UDim2.new(0, 5, 0, 5)
	dialogFrame.Position = UDim2.new(0.5, -2, 0.4, -2)
	print("Dialog Frame positioned") -- 🧼 Step 5

	TweenService:Create(dialogFrame, TweenInfo.new(0.4), {Size = UDim2.new(0, 5, 0.2, 0)}):Play()
	task.wait(0.4)
	TweenService:Create(dialogFrame, TweenInfo.new(0.4), {Size = UDim2.new(0.4, 0, 0.2, 0)}):Play()
	task.wait(0.4)
	typeText("Greetings and salutations!")
	task.wait(0.5)
	TweenService:Create(dialogFrame, TweenInfo.new(0.3), {Size = UDim2.new(0.4, 0, 0.5, 0)}):Play()
	task.wait(0.3)
	
	-- Fade in buttons
	for _, button in pairs(dialogOptionsFrame:GetChildren()) do
		if button:IsA("TextButton") then
			button.Visible = true
			button.BackgroundTransparency = 1
			TweenService:Create(button, TweenInfo.new(0.2), {BackgroundTransparency = 0}):Play()
			task.wait(0.1)
		end
	end
end

-- Close Dialog
local function closeDialog()
	-- Fade to black
	fadeScreen(false)

	-- Reset camera
	camera.CameraType = Enum.CameraType.Custom

	-- Disable UI
	dialogUI.Enabled = false
	for _, button in pairs(dialogOptionsFrame:GetChildren()) do
		if button:IsA("TextButton") then
			button.Visible = false
		end
	end

	-- Fade back in
	fadeScreen(true)

	inDialog = false
end

-- Goodbye Button Behavior
goodbyeButton.MouseButton1Click:Connect(function()
	if inDialog then
		closeDialog()
	end
end)

-- AFTER all your WaitForChilds are done (bottom of script)

-- Confirm character is ready
player.CharacterAdded:Wait()

-- Confirm PlayerGui is ready
repeat task.wait() until player:FindFirstChild("PlayerGui")

print("Ready to detect input")

-- Secure Input Detection

local function onInputBegan(input, processed)
	if processed then return end
	if input.KeyCode == Enum.KeyCode.E and not inDialog then
		print("E key pressed!") -- 🧼 Now printing
		openDialog()
	end
end

-- Wait for character and camera to be ready
-- NEW: Using ContextActionService instead of UserInputService
local ContextActionService = game:GetService("ContextActionService")

local function onEPressed(actionName, inputState, inputObject)
	if inputState == Enum.UserInputState.Begin and not inDialog then
		print("✅ E key detected via ContextActionService")
		openDialog()
	end
end

-- Wait until fully ready
repeat task.wait() until player.Character and player.Character:FindFirstChild("HumanoidRootPart")
repeat task.wait() until workspace.CurrentCamera
repeat task.wait() until player:FindFirstChild("PlayerGui")

print("✅ Setup complete, binding E key...")

-- Bind E key to the action
ContextActionService:BindAction("OpenNPCDialog", onEPressed, false, Enum.KeyCode.E)

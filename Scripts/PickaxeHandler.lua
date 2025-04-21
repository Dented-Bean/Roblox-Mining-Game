print("Hello world!")
local tool = script.Parent
local player = game.Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local RS = game:GetService("RunService")

local holding = false
local cooldown = 0.25 -- seconds between mine attempts

-- Function to mine the block the mouse is pointing at
local function mineBlock()
	local mouse = player:GetMouse()
	local target = mouse.Target

	if target and target.Name == "MineBlock" then
		-- Send a remote event to server to destroy it
		game.ReplicatedStorage.MineRequest:FireServer(target)
	end
end

-- Run mining repeatedly while mouse held
local function mineLoop()
	while holding do
		mineBlock()
		wait(cooldown)
	end
end

-- Start mining on mouse down
UIS.InputBegan:Connect(function(input, gameProcessed)
	if input.UserInputType == Enum.UserInputType.MouseButton1 and tool.Parent == player.Character then
		holding = true
		mineLoop()
	end
end)

-- Stop mining on mouse release
UIS.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		holding = false
	end
end)

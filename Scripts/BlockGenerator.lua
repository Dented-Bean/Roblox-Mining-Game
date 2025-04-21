print("Hello world!")

local blockSize = Vector3.new(6, 6, 6)

local surfaceSize = 15 -- 15x15 surface zone
local blockCountToFree = 15
local shaftTopY = 1800
local freeMineY = shaftTopY - (blockCountToFree * blockSize.Y)

local blockSizeX = blockSize.X
local maxShaftBounds = (surfaceSize * blockSizeX) / 2
local shaftMinX = -maxShaftBounds + blockSizeX
local shaftMaxX = maxShaftBounds - blockSizeX
local shaftMinZ = -maxShaftBounds + blockSizeX
local shaftMaxZ = maxShaftBounds - blockSizeX



local event = game.ReplicatedStorage:WaitForChild("GenerateAdjacentBlocks")
local template = game.ReplicatedStorage:WaitForChild("BlockTemplate")
local blockSize = Vector3.new(6, 6, 6)
local shaftTopY = 1800 -- highest Y where blocks are allowed to generate

local generatedPositions = {}

local function snapToGrid(pos)
	return Vector3.new(
		math.floor(pos.X / blockSize.X + 0.5) * blockSize.X,
		math.floor(pos.Y / blockSize.Y + 0.5) * blockSize.Y,
		math.floor(pos.Z / blockSize.Z + 0.5) * blockSize.Z
	)
end



local oreFolder = game.ReplicatedStorage:WaitForChild("OreBlocks")

local function getRandomOreTemplate()
	local roll = math.random(1, 1000)

	if roll <= 5 then -- 0.5%
		return oreFolder:FindFirstChild("GoldOre")
	elseif roll <= 30 then -- 2.5%
		return oreFolder:FindFirstChild("IronOre")
	elseif roll <= 100 then -- 7%
		return oreFolder:FindFirstChild("CopperOre")
	else
		return oreFolder:FindFirstChild("Dirt") -- fallback
	end
end

local function generateBlock(position)
	local snapped = snapToGrid(position)
	local key = tostring(snapped)
	if generatedPositions[key] then return end
	generatedPositions[key] = true

	local template = getRandomOreTemplate()
	if not template then warn("Missing ore template!") return end

	local clone = template:Clone()
	clone.PrimaryPart = clone:FindFirstChild("Block")
	clone:SetPrimaryPartCFrame(CFrame.new(snapped))
	clone.Parent = workspace
	
	-- 🔆 Add light to brighten the block (temporary for testing)
	local light = Instance.new("PointLight")
	light.Range = 8
	light.Brightness = 0.6
	light.Color = Color3.new(1, 1, 1)
	light.Parent = clone.PrimaryPart

end


local function isInsideSurfaceBounds(pos)
	local half = (surfaceSize * blockSize.X) / 2
	return math.abs(pos.X) <= half and math.abs(pos.Z) <= half
end

local function preloadSurfaceMine(centerPosition)
	local half = math.floor(surfaceSize / 2)

	for x = -half, half - 1 do
		for y = 0, blockCountToFree - 1 do
			for z = -half, half - 1 do
				local pos = centerPosition + Vector3.new(
					x * blockSize.X,
					-y * blockSize.Y,
					z * blockSize.Z
				)
				generateBlock(pos)
			end
		end
	end
end

local function generateAdjacent(centerPos, skipNormal)
	local offsets = {
		Vector3.new(0, -blockSize.Y, 0), -- down
		Vector3.new(0, blockSize.Y, 0),  -- up
		Vector3.new(blockSize.X, 0, 0),  -- right
		Vector3.new(-blockSize.X, 0, 0), -- left
		Vector3.new(0, 0, blockSize.Z),  -- forward
		Vector3.new(0, 0, -blockSize.Z), -- back
	}



	for _, offset in ipairs(offsets) do
		local direction = offset.Unit
		if direction ~= skipNormal then
			local newPos = centerPos + offset
			local newY = newPos.Y

			local insideSurface = isInsideSurfaceBounds(newPos)

			-- Block upward mining near surface if outside surface area
			if direction == Vector3.new(0, 1, 0) then
				if newY > freeMineY and not insideSurface then
					continue -- don't generate upward blocks above free mine depth
				end
			end
			
			if newPos.Y > shaftTopY then
				continue -- don't generate blocks above the shaft surface
			end

			-- Block generation outside shaft wall, but only while inside surface zone
			if newY > freeMineY then
				if newPos.X < shaftMinX or newPos.X > shaftMaxX or newPos.Z < shaftMinZ or newPos.Z > shaftMaxZ then
					continue
				end
			end

			generateBlock(newPos)
		end
	end
end

-- 🔥 NEW version with skip direction
event.OnServerEvent:Connect(function(player, position, skipNormal)
	if typeof(position) ~= "Vector3" or typeof(skipNormal) ~= "Vector3" then return end

	-- Destroy the mined block if it's still there
	local snapped = snapToGrid(position)
	for _, part in pairs(workspace:GetChildren()) do
		if part:IsA("Model") and part.PrimaryPart and snapToGrid(part.PrimaryPart.Position) == snapped then
			part:Destroy()
		end
	end

	generateAdjacent(position, skipNormal)
end)
-- Spawn the first block to kick things off
task.delay(1, function()
end)

	task.delay(1, function()
		preloadSurfaceMine(Vector3.new(0, 1800, 0)) -- center of surface shaft
	end)

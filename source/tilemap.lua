Tilemap = {}

-- TODO: getWallsLayer and getSnakeLayer are very similar. Combine into one function?
local function getWallsLayer(levelData)
	local layers = levelData.layers
	local wallsLayer = nil

	for i = 1, #layers do
		if layers[i].name == "walls" then
			wallsLayer = layers[i]
		end
	end

	if not wallsLayer then
		print("ERROR LOCATING WALLS LAYER IN LEVEL DATA")
		return nil
	end

	return wallsLayer
end

local function getSnakeLayer(levelData)
	local layers = levelData.layers
	local snakeLayer = nil

	for i = 1, #layers do
		if layers[i].name == "snake" then
			snakeLayer = layers[i]
		end
	end

	if not snakeLayer then
		print("ERROR LOCATING SNAKE LAYER IN LEVEL DATA")
	end

	return snakeLayer
end

local function getSnakeSpawnObject(snakeLayer)
	local objects = snakeLayer.objects
	local spawnObject = nil

	for i = 1, #objects do
		if objects[i].name == "spawn" then
			spawnObject = objects[i]
		end
	end

	if not spawnObject then
		print("ERROR LOADING SPAWN OBJECT FROM SNAKE LAYER IN LEVEL DATA")
	end

	return spawnObject
end

local function getWallsTileset(levelData)
	local tilesets = levelData.tilesets
	local wallsTileset = nil

	for i = 1, #tilesets do
		if tilesets[i].name == "walls" then
			wallsTileset = tilesets[i]
		end
	end

	if not wallsTileset then
		print("ERROR LOCATING WALLS TILESET IN LEVEL DATA")
		return nil
	end

	return wallsTileset
end

function Tilemap:loadLevelJsonData(levelJsonFilePath)
	local levelData = nil
	local file = playdate.file.open(levelJsonFilePath)

	if file then
		local fileSize = playdate.file.getSize(levelJsonFilePath)
		levelData = file:read(fileSize)
		file:close()

		if not levelData then
			print("ERROR LOADING DATA for " .. path)
			return nil
		end
	end

	local jsonTable = json.decode(levelData)

	if not jsonTable then
		print("ERROR PARSING JSON DATA for " .. levelPath)
		return nil
	end

	return jsonTable
end

function Tilemap:getWallLocations(levelData)
	local wallLocations = {}

	local wallsLayer = getWallsLayer(levelData)
	local wallsTileset = getWallsTileset(levelData)

	if wallsLayer == nil or wallsTileset == nil then
		return nil
	end

	local wallsData = wallsLayer.data
	local rows = wallsLayer.height
	local columns = wallsLayer.width

	local tileHeight = wallsTileset.tileheight
	local tileWidth = wallsTileset.tilewidth

	-- TODO: Iterate from 0 rather than from 1?
	for row = 1, rows do
		for column = 1, columns do
			local index = column + ((row - 1) * columns)
			if wallsData[index] == 2 then
				local wallLocation = {(column - 1) * tileWidth, (row - 1) * tileHeight}
				table.insert(wallLocations, 1, wallLocation)
			end
		end
	end

	return wallLocations
end

function Tilemap:getSnakeSpawnLocation(levelData)
	local snakeLayer = getSnakeLayer(levelData)
	local snakeSpawnObject = getSnakeSpawnObject(snakeLayer)

	if not snakeSpawnObject.x or not snakeSpawnObject.y then
		print("ERROR LOADING X AND Y COORDINATES FOR SNAKE SPAWN LOCATION")
		return nil
	end

	return {snakeSpawnObject.x, snakeSpawnObject.y}
end

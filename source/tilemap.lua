function loadLevelJsonData(levelJsonFilePath)
	local levelData = nil
	local file = playdate.file.open(levelJsonFilePath)

	if file then
		local fileSize = playdate.file.getSize(levelJsonFilePath)
		levelData = file:read(fileSize)
		file:close()

		if not levelData then
			print('ERROR LOADING DATA for ' .. path)
			return nil
		end
	end

	local jsonTable = json.decode(levelData)

	if not jsonTable then
		print('ERROR PARSING JSON DATA for ' .. levelPath)
		return nil
	end

	return jsonTable
end

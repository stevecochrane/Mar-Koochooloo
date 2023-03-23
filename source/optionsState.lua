import "optionsDifficulty"
import "optionsMode"
import "optionsPressStart"

local gfx <const> = playdate.graphics

local optionsScreenImage = gfx.image.new("images/options-screen")
local optionsMode = nil
local optionsDifficulty = nil
local optionsPressStart = nil

OptionsState = {}

function OptionsState:switch()
	stateSwitchInProgress = false
	gameState = "options"

	-- Clear player's progress whenever they enter/re-enter the Options screen
	currentLevel = 1

	menuBgm:setVolume("0.75")
	menuBgm:play(0)

	local backgroundSprite = gfx.sprite.new(optionsScreenImage)
	backgroundSprite:setCenter(0, 0)
	backgroundSprite:moveTo(0, 0)
	backgroundSprite:add()

	optionsPressStart = OptionsPressStart()
	optionsPressStart:moveTo(0, 176)
	optionsPressStart:addSprite()

	optionsMode = OptionsMode()
	optionsMode:setMode(mode)
	optionsMode:select()
	optionsMode:addSprite()

	optionsDifficulty = OptionsDifficulty()
	optionsDifficulty:setDifficulty(difficultySetting)
	optionsDifficulty:addSprite()

	SystemMenu:removeItems()
end

function OptionsState:update()
	if playdate.buttonJustPressed(playdate.kButtonLeft) then
		if optionsMode.selected == true then
			clickSound:play()

			-- TODO: Extract this into a function
			if mode == "speed" then
				mode = "puzzle"
			else
				mode = "speed"
			end

			optionsMode:setMode(mode)

		elseif optionsDifficulty.selected == true and difficultySetting > difficultyMin then
			clickSound:play()
			difficultySetting -= 1
			playerMoveInterval = difficultySpeedMap[difficultySetting]
			optionsDifficulty:setDifficulty(difficultySetting)

		end
	end

	if playdate.buttonJustPressed(playdate.kButtonRight) then
		if optionsMode.selected == true then
			clickSound:play()

			-- TODO: Extract this into a function
			if mode == "speed" then
				mode = "puzzle"
			else
				mode = "speed"
			end

			optionsMode:setMode(mode)

		elseif optionsDifficulty.selected == true and difficultySetting < difficultyMax then
			clickSound:play()
			difficultySetting += 1
			playerMoveInterval = difficultySpeedMap[difficultySetting]
			optionsDifficulty:setDifficulty(difficultySetting)
		end
	end

	if playdate.buttonJustPressed(playdate.kButtonUp) or playdate.buttonJustPressed(playdate.kButtonDown) then
		if optionsMode.selected == true then
			clickSound:play()
			optionsMode:deselect()
			optionsDifficulty:select()
		elseif optionsDifficulty.selected == true then
			clickSound:play()
			optionsMode:select()
			optionsDifficulty:deselect()
		end
	end

	if stateSwitchInProgress == false and playdate.buttonJustPressed(playdate.kButtonA) then
		optionsPressStart:blink()
		menuBgm:setVolume("0.0", "0.0", stateSwitchFullDurationSeconds)
		gameStartSound:play()
		stateSwitchInProgress = true
		playdate.timer.performAfterDelay(stateSwitchAnimationDuration, gfx.sprite.removeAll)
		playdate.timer.performAfterDelay(stateSwitchFullDuration, PlayState.switch)
	end
end

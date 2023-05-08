import "optionsControl"
import "optionsDifficulty"
import "optionsHeading"
import "optionsMusic"
import "optionsPressStart"

local gfx <const> = playdate.graphics

local optionsHeading = nil
local optionsControl = nil
local optionsDifficulty = nil
local optionsMusic = nil
local optionsPressStart = nil

OptionsState = {}

function OptionsState:switch()
	stateSwitchInProgress = false
	gameState = "options"

	-- Clear player's progress whenever they enter/re-enter the Options screen
	currentLevel = 1

	menuBgm:setVolume("0.75")
	menuBgm:play(0)

	optionsHeading = OptionsHeading()
	optionsHeading:moveTo(0, 0)
	optionsHeading:addSprite()

	optionsControl = OptionsControl()
	optionsControl:setControl(control)
	optionsControl:select()
	optionsControl:addSprite()

	optionsDifficulty = OptionsDifficulty()
	optionsDifficulty:setDifficulty(difficultySetting)
	optionsDifficulty:addSprite()

	optionsMusic = OptionsMusic()
	optionsMusic:setMusic(music)
	optionsMusic:addSprite()

	optionsPressStart = OptionsPressStart()
	optionsPressStart:moveTo(0, 192)
	optionsPressStart:addSprite()

	SystemMenu:removeItems()
end

function OptionsState:update()
	if playdate.buttonJustPressed(playdate.kButtonLeft) then
		if optionsControl.selected == true then
			clickSound:play()
			if control == "speed" then
				control = "puzzle"
			else
				control = "speed"
			end
			optionsControl:setControl(control)

		elseif optionsDifficulty.selected == true and difficultySetting > difficultyMin then
			clickSound:play()
			difficultySetting -= 1
			playerMoveInterval = difficultySpeedMap[difficultySetting]
			optionsDifficulty:setDifficulty(difficultySetting)

		elseif optionsMusic.selected == true then
			clickSound:play()
			if music == "one" then
				music = "two"
			else
				music = "one"
			end
			optionsMusic:setMusic(music)
		end
	end

	if playdate.buttonJustPressed(playdate.kButtonRight) then
		if optionsControl.selected == true then
			clickSound:play()
			if control == "speed" then
				control = "puzzle"
			else
				control = "speed"
			end
			optionsControl:setControl(control)

		elseif optionsDifficulty.selected == true and difficultySetting < difficultyMax then
			clickSound:play()
			difficultySetting += 1
			playerMoveInterval = difficultySpeedMap[difficultySetting]
			optionsDifficulty:setDifficulty(difficultySetting)

		elseif optionsMusic.selected == true then
			clickSound:play()
			if music == "one" then
				music = "two"
			else
				music = "one"
			end
			optionsMusic:setMusic(music)
		end
	end

	if playdate.buttonJustPressed(playdate.kButtonUp) then
		clickSound:play()

		if optionsControl.selected == true then
			optionsControl:deselect()
			optionsMusic:select()
		elseif optionsDifficulty.selected == true then
			optionsDifficulty:deselect()
			optionsControl:select()
		else
			optionsMusic:deselect()
			optionsDifficulty:select()
		end
	end

	if playdate.buttonJustPressed(playdate.kButtonDown) then
		clickSound:play()

		if optionsControl.selected == true then
			optionsControl:deselect()
			optionsDifficulty:select()
		elseif optionsDifficulty.selected == true then
			optionsMusic:select()
			optionsDifficulty:deselect()
		else
			optionsControl:select()
			optionsMusic:deselect()
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

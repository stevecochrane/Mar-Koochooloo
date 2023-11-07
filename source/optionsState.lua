import "optionsMode"
import "optionsSpeed"
import "optionsHeading"
import "optionsMusic"
import "optionsPressStart"

local gfx <const> = playdate.graphics

local optionsHeading = nil
local optionsMode = nil
local optionsSpeed = nil
local optionsMusic = nil
local optionsPressStart = nil

OptionsState = {}

function OptionsState:enableGentleMode()
	optionsSpeed:hide()
	optionsMusic:moveToSecondRow()
end

function OptionsState:enableClassicMode()
	optionsSpeed:show()
	optionsMusic:moveToThirdRow()
end

function OptionsState:switch()
	stateSwitchInProgress = false
	gameState = "options"

	-- Clear player's progress whenever they enter/re-enter the Options screen
	currentLevel = 1

	menuBgm:setVolume("0.8")
	menuBgm:play(0)

	optionsHeading = OptionsHeading()
	optionsHeading:moveTo(0, 0)
	optionsHeading:addSprite()

	optionsMode = OptionsMode()
	optionsMode:setMode(mode)
	optionsMode:select()
	optionsMode:addSprite()

	optionsSpeed = OptionsSpeed()
	optionsSpeed:setSpeed(speedSetting)
	optionsSpeed:addSprite()

	optionsMusic = OptionsMusic()
	optionsMusic:setMusic(music)
	optionsMusic:addSprite()

	optionsPressStart = OptionsPressStart()
	optionsPressStart:moveTo(0, 195)
	optionsPressStart:addSprite()

	if mode == "gentle" then
		OptionsState:enableGentleMode()
	else
		OptionsState:enableClassicMode()
	end

	SystemMenu:removeItems()
end

function OptionsState:update()
	if stateSwitchInProgress == false and playdate.buttonJustPressed(playdate.kButtonLeft) then
		if optionsMode.selected == true then
			clickSound:play()
			if mode == "classic" then
				mode = "gentle"
				OptionsState:enableGentleMode()
			else
				mode = "classic"
				OptionsState:enableClassicMode()
			end
			optionsMode:setMode(mode)

		elseif optionsSpeed.selected == true and speedSetting > speedMin then
			clickSound:play()
			speedSetting -= 1
			playerMoveInterval = speedMap[speedSetting]
			optionsSpeed:setSpeed(speedSetting)

		elseif optionsMusic.selected == true then
			clickSound:play()
			if music == 1 then
				music = 3
			elseif music == 2 then
				music = 1
			else
				music = 2
			end
			optionsMusic:setMusic(music)
		end
	end

	if stateSwitchInProgress == false and playdate.buttonJustPressed(playdate.kButtonRight) then
		if optionsMode.selected == true then
			clickSound:play()
			if mode == "classic" then
				mode = "gentle"
				OptionsState:enableGentleMode()
			else
				mode = "classic"
				OptionsState:enableClassicMode()
			end
			optionsMode:setMode(mode)

		elseif optionsSpeed.selected == true and speedSetting < speedMax then
			clickSound:play()
			speedSetting += 1
			playerMoveInterval = speedMap[speedSetting]
			optionsSpeed:setSpeed(speedSetting)

		elseif optionsMusic.selected == true then
			clickSound:play()
			if music == 1 then
				music = 2
			elseif music == 2 then
				music = 3
			else
				music = 1
			end
			optionsMusic:setMusic(music)
		end
	end

	if stateSwitchInProgress == false and playdate.buttonJustPressed(playdate.kButtonUp) then
		clickSound:play()

		if optionsMode.selected == true then
			optionsMode:deselect()
			optionsMusic:select()
		elseif optionsSpeed.selected == true then
			optionsSpeed:deselect()
			optionsMode:select()
		else
			optionsMusic:deselect()
			if mode == "classic" then
				optionsSpeed:select()
			else
				optionsMode:select()
			end
		end
	end

	if stateSwitchInProgress == false and playdate.buttonJustPressed(playdate.kButtonDown) then
		clickSound:play()

		if optionsMode.selected == true then
			optionsMode:deselect()
			if mode == "classic" then
				optionsSpeed:select()
			else
				optionsMusic:select()
			end
		elseif optionsSpeed.selected == true then
			optionsMusic:select()
			optionsSpeed:deselect()
		else
			optionsMode:select()
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

	if stateSwitchInProgress == false and playdate.buttonJustPressed(playdate.kButtonB) then
		gfx.sprite.removeAll()
		stateSwitchInProgress = true
		playdate.timer.performAfterDelay(stateSwitchPauseDuration, TitleState.switch)
	end
end

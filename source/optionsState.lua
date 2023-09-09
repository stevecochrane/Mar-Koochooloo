import "optionsControl"
import "optionsSpeed"
import "optionsHeading"
import "optionsMusic"
import "optionsPressStart"

local gfx <const> = playdate.graphics

local optionsHeading = nil
local optionsControl = nil
local optionsSpeed = nil
local optionsMusic = nil
local optionsPressStart = nil

OptionsState = {}

function OptionsState:enableManualControl()
	optionsSpeed:hide()
	optionsMusic:moveToSecondRow()
end

function OptionsState:enableClassicControl()
	optionsSpeed:show()
	optionsMusic:moveToThirdRow()
end

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

	optionsSpeed = OptionsSpeed()
	optionsSpeed:setSpeed(speedSetting)
	optionsSpeed:addSprite()

	optionsMusic = OptionsMusic()
	optionsMusic:setMusic(music)
	optionsMusic:addSprite()

	optionsPressStart = OptionsPressStart()
	optionsPressStart:moveTo(0, 195)
	optionsPressStart:addSprite()

	if control == "manual" then
		OptionsState:enableManualControl()
	else
		OptionsState:enableClassicControl()
	end

	SystemMenu:removeItems()
end

function OptionsState:update()
	if playdate.buttonJustPressed(playdate.kButtonLeft) then
		if optionsControl.selected == true then
			clickSound:play()
			if control == "classic" then
				control = "manual"
				OptionsState:enableManualControl()
			else
				control = "classic"
				OptionsState:enableClassicControl()
			end
			optionsControl:setControl(control)

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

	if playdate.buttonJustPressed(playdate.kButtonRight) then
		if optionsControl.selected == true then
			clickSound:play()
			if control == "classic" then
				control = "manual"
				OptionsState:enableManualControl()
			else
				control = "classic"
				OptionsState:enableClassicControl()
			end
			optionsControl:setControl(control)

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

	if playdate.buttonJustPressed(playdate.kButtonUp) then
		clickSound:play()

		if optionsControl.selected == true then
			optionsControl:deselect()
			optionsMusic:select()
		elseif optionsSpeed.selected == true then
			optionsSpeed:deselect()
			optionsControl:select()
		else
			optionsMusic:deselect()
			if control == "classic" then
				optionsSpeed:select()
			else
				optionsControl:select()
			end
		end
	end

	if playdate.buttonJustPressed(playdate.kButtonDown) then
		clickSound:play()

		if optionsControl.selected == true then
			optionsControl:deselect()
			if control == "classic" then
				optionsSpeed:select()
			else
				optionsMusic:select()
			end
		elseif optionsSpeed.selected == true then
			optionsMusic:select()
			optionsSpeed:deselect()
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

	if stateSwitchInProgress == false and playdate.buttonJustPressed(playdate.kButtonB) then
		gfx.sprite.removeAll()
		stateSwitchInProgress = true
		playdate.timer.performAfterDelay(stateSwitchPauseDuration, TitleState.switch)
	end
end

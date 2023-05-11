import "titleCredits"
import "titleStart"

local gfx <const> = playdate.graphics

local titleScreenImage = gfx.image.new("images/title-screen")
local titleCredits = nil
local titleStart = nil

TitleState = {}

function TitleState:switch()
	stateSwitchInProgress = false
	gameState = "title"

	local titleScreenSprite = gfx.sprite.new(titleScreenImage)
	titleScreenSprite:moveTo(200, 120)
	titleScreenSprite:add()

	titleStart = TitleStart()
	titleStart:select()
	titleStart:addSprite()

	titleCredits = TitleCredits()
	titleCredits:addSprite()

	menuBgm:load("music/menu")
	menuBgm:setVolume("0.75")
	menuBgm:play(0)
end

function TitleState:update()
	if playdate.buttonJustPressed(playdate.kButtonUp) or playdate.buttonJustPressed(playdate.kButtonDown) then
		if titleStart.selected == true then
			clickSound:play()
			titleStart:deselect()
			titleCredits:select()
		elseif titleCredits.selected == true then
			clickSound:play()
			titleStart:select()
			titleCredits:deselect()
		end
	end

	if stateSwitchInProgress == false and playdate.buttonJustPressed(playdate.kButtonA) then
		if titleStart.selected == true then
			gameStartSound:play()
			titleStart:blink()
			stateSwitchInProgress = true
			playdate.timer.performAfterDelay(stateSwitchAnimationDuration, gfx.sprite.removeAll)
			playdate.timer.performAfterDelay(stateSwitchFullDuration, OptionsState.switch)
		elseif titleCredits.selected == true then
			gfx.sprite.removeAll()
			stateSwitchInProgress = true
			playdate.timer.performAfterDelay(stateSwitchPauseDuration, CreditsState.switch)
		end
	end
end

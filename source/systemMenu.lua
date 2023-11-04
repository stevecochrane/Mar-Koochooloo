local gfx <const> = playdate.graphics
local systemMenu = playdate.getSystemMenu()

SystemMenu = {}

function SystemMenu:addItems()
	systemMenu:removeAllMenuItems()

	systemMenu:addMenuItem("Retry", function()
		moveTimer:remove()
		stageBgm:stop()
		gfx.sprite.removeAll()
		stateSwitchInProgress = true
		playdate.timer.performAfterDelay(stateSwitchPauseDuration, PlayState.switch)
	end)

	systemMenu:addMenuItem("Options", function()
		moveTimer:remove()
		stageBgm:stop()
		gfx.sprite.removeAll()
		stateSwitchInProgress = true
		playdate.timer.performAfterDelay(stateSwitchPauseDuration, OptionsState.switch)
	end)
end

function SystemMenu:removeItems()
	systemMenu:removeAllMenuItems()
end

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

		-- There is occasional weirdness when exiting the system menu where parts of
		-- playState continue to update during the transition. Setting gameState to
		-- a non-existent other state ensures playState is immediately paused.
		gameState = "void"

		playdate.timer.performAfterDelay(stateSwitchPauseDuration, PlayState.switch)
	end)

	systemMenu:addMenuItem("Options", function()
		moveTimer:remove()
		stageBgm:stop()
		gfx.sprite.removeAll()
		stateSwitchInProgress = true
		gameState = "void" -- See comment in above Retry handler
		playdate.timer.performAfterDelay(stateSwitchPauseDuration, OptionsState.switch)
	end)
end

function SystemMenu:removeItems()
	systemMenu:removeAllMenuItems()
end

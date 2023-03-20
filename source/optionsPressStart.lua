local gfx <const> = playdate.graphics

class("OptionsPressStart").extends(gfx.sprite)

function OptionsPressStart:init()
	OptionsPressStart.super.init(self)

	self.blinker = gfx.animation.blinker.new()
	self.blinker.cycles = 10
	self.blinker.onDuration = 150
	self.blinker.offDuration = 150

	self.visible = true

	self:setZIndex(1)
	self:setCenter(0, 0)
	self:setSize(400, 24)
end

function OptionsPressStart:blink()
	self.blinker:start()
end

function OptionsPressStart:update()
	if self.blinker.running then
		if self.visible and not self.blinker.on then
			self.visible = false
			self:markDirty()
		elseif not self.visible and self.blinker.on then
			self.visible = true
			self:markDirty()
		end
	end
end

function OptionsPressStart:draw()
	if self.visible then
		gfx.setImageDrawMode(gfx.kDrawModeFillWhite)
	else
		gfx.setImageDrawMode(gfx.kDrawModeWhiteTransparent)
	end
	gfx.drawTextAligned("Press Ⓐ to Start", 200, 0, kTextAlignment.center)
	gfx.setImageDrawMode(gfx.kDrawModeCopy)
end

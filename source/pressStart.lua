local gfx <const> = playdate.graphics

class("PressStart").extends(gfx.sprite)

function PressStart:init()
	PressStart.super.init(self)
	self:setZIndex(1)
	self:setCenter(0, 0)
	self:setSize(400, 24)
end

function PressStart:draw()
	gfx.setImageDrawMode(gfx.kDrawModeFillWhite)
	gfx.drawTextAligned("Press Ⓐ to Start", 200, 0, kTextAlignment.center)
	gfx.setImageDrawMode(gfx.kDrawModeCopy)
end

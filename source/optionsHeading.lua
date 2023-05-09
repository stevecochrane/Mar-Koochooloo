local gfx <const> = playdate.graphics

class("OptionsHeading").extends(gfx.sprite)

function OptionsHeading:init()
	OptionsHeading.super.init(self)
	self:setCenter(0, 0)
	self:setSize(400, 64)
	self:moveTo(0, 0)
end

function OptionsHeading:draw()
	gfx.setImageDrawMode(gfx.kDrawModeFillWhite)
	gfx.drawTextAligned("Options", 200, 27, kTextAlignment.center)
	gfx.setImageDrawMode(gfx.kDrawModeCopy)

	gfx.setLineWidth(1)
	gfx.drawLine(32, 55, 400 - 32, 55)
end

local gfx <const> = playdate.graphics

class("Copyright").extends(gfx.sprite)

function Copyright:init()
	Copyright.super.init(self)
	self:setZIndex(1)
	self:setCenter(0, 0)
	self:setSize(400, 16)
	self:moveTo(0, 208)
end

function Copyright:draw()
	gfx.setImageDrawMode(gfx.kDrawModeFillWhite)
	gfx.drawTextAligned("© 2023 Steve Cochrane", 200, 0, kTextAlignment.center)
	gfx.setImageDrawMode(gfx.kDrawModeCopy)
end

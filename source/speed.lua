class('Speed').extends(playdate.graphics.sprite)

function Speed:init()
	Speed.super.init(self)

	self.speed = 0

	self:setZIndex(900)
	self:setIgnoresDrawOffset(true)
	self:setCenter(0, 0)
	self:setSize(40, 20)
	self:moveTo(40, 40)
end

function Speed:setSpeed(newSpeed)
	self.speed = newSpeed
	self:markDirty()
end

function Speed:draw()
	playdate.graphics.setImageDrawMode(playdate.graphics.kDrawModeFillWhite)
	playdate.graphics.drawText(tostring(self.speed), 0, 0)
	playdate.graphics.setImageDrawMode(playdate.graphics.kDrawModeCopy)
end

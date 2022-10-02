local gfx <const> = playdate.graphics

class("FoodEaten").extends(playdate.graphics.sprite)

function FoodEaten:init()
	FoodEaten.super.init(self)

	self.count = 0

	self:setZIndex(1)
	self:setCenter(0, 0)
	self:setSize(400, 24)
	self:moveTo(0, 32)
end

function FoodEaten:setCount(newCount)
	self.count = newCount
	self:markDirty()
end

function FoodEaten:draw()
	local noun = "apples"

	if (self.count == 1) then
		noun = "apple"
	end

	gfx.setImageDrawMode(gfx.kDrawModeFillWhite)
	gfx.drawTextAligned("You ate *" .. tostring(self.count) .. "* " .. noun .. "!", 200, 0, kTextAlignment.center)
	gfx.setImageDrawMode(gfx.kDrawModeCopy)
end

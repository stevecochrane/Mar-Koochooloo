local gfx <const> = playdate.graphics

local foodImage = gfx.image.new("images/food")

class("TitleCredits").extends(gfx.sprite)

function TitleCredits:init()
	TitleCredits.super.init(self)

	self.foodSprite = nil
	self.selected = false

	self:setZIndex(1)
	self:setCenter(0, 0)
	self:setSize(272, 20)
	self:moveTo(150, 168)
end

function TitleCredits:select()
	self.selected = true

	self.foodSprite = gfx.sprite.new(foodImage)
	self.foodSprite:setCenter(0, 0)
	self.foodSprite:moveTo(self.x, self.y + 1)
	self.foodSprite:add()

	self:markDirty()
end

function TitleCredits:deselect()
	self.selected = false

	self.foodSprite:remove()

	self:markDirty()
end

function TitleCredits:draw()
	gfx.setImageDrawMode(gfx.kDrawModeFillWhite)
	gfx.drawText("Credits", 24, 0)
	gfx.setImageDrawMode(gfx.kDrawModeCopy)
end

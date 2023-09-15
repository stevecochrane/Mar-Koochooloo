local gfx <const> = playdate.graphics

local arrowLeftImage = gfx.image.new("images/arrow-left")
local arrowRightImage = gfx.image.new("images/arrow-right")
local foodImage = gfx.image.new("images/food")

class("OptionsSpeed").extends(gfx.sprite)

function OptionsSpeed:init()
	OptionsSpeed.super.init(self)

	self.foodSprite = nil
	self.selected = false
	self.speed = 0

	self:setZIndex(1)
	self:setCenter(0, 0)
	self:setSize(304, 20)
	self:moveTo(48, 111)

	self.arrowLeftSprite = gfx.sprite.new(arrowLeftImage)
	self.arrowLeftSprite:setCenter(0, 0)
	self.arrowLeftSprite:moveTo(self.x + 127, self.y + 2)
	self.arrowLeftSprite:add()

	self.arrowRightSprite = gfx.sprite.new(arrowRightImage)
	self.arrowRightSprite:setCenter(0, 0)
	self.arrowRightSprite:moveTo(self.x + 170, self.y + 2)
	self.arrowRightSprite:add()
end

function OptionsSpeed:setSpeed(newSpeed)
	self.speed = newSpeed
	self:markDirty()
end

function OptionsSpeed:select()
	self.selected = true

	self.foodSprite = gfx.sprite.new(foodImage)
	self.foodSprite:setCenter(0, 0)
	self.foodSprite:moveTo(self.x, self.y)
	self.foodSprite:add()

	self:markDirty()
end

function OptionsSpeed:deselect()
	self.selected = false

	self.foodSprite:remove()

	self:markDirty()
end

function OptionsSpeed:hide()
	self:setVisible(false)
	self.arrowLeftSprite:setVisible(false)
	self.arrowRightSprite:setVisible(false)
	self:markDirty()
end

function OptionsSpeed:show()
	self:setVisible(true)
	self.arrowLeftSprite:setVisible(true)
	self.arrowRightSprite:setVisible(true)
	self:markDirty()
end

function OptionsSpeed:draw()
	gfx.setImageDrawMode(gfx.kDrawModeFillWhite)

	-- Draw "Speed" label text
	gfx.drawText("Speed", 24, 0)

	-- Draw speed setting number as string
	gfx.drawTextAligned(tostring(self.speed), 152, 0, kTextAlignment.center)

	gfx.setImageDrawMode(gfx.kDrawModeCopy)
end

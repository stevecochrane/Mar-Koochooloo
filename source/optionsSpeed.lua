local gfx <const> = playdate.graphics

local appleImage = gfx.image.new("images/apple")
local arrowLeftImage = gfx.image.new("images/arrow-left")
local arrowRightImage = gfx.image.new("images/arrow-right")

class("OptionsSpeed").extends(gfx.sprite)

function OptionsSpeed:init()
	OptionsSpeed.super.init(self)

	self.appleSprite = nil
	self.selected = false
	self.speed = 0

	self:setZIndex(1)
	self:setCenter(0, 0)
	self:setSize(272, 20)
	self:moveTo(72, 112)

	self.arrowLeftSprite = gfx.sprite.new(arrowLeftImage)
	self.arrowLeftSprite:setCenter(0, 0)
	self.arrowLeftSprite:moveTo(self.x + 165, self.y)
	self.arrowLeftSprite:add()

	self.arrowRightSprite = gfx.sprite.new(arrowRightImage)
	self.arrowRightSprite:setCenter(0, 0)
	self.arrowRightSprite:moveTo(self.x + 208, self.y)
	self.arrowRightSprite:add()
end

function OptionsSpeed:setSpeed(newSpeed)
	self.speed = newSpeed
	self:markDirty()
end

function OptionsSpeed:select()
	self.selected = true

	self.appleSprite = gfx.sprite.new(appleImage)
	self.appleSprite:setCenter(0, 0)
	self.appleSprite:moveTo(self.x, self.y)
	self.appleSprite:add()

	self:markDirty()
end

function OptionsSpeed:deselect()
	self.selected = false

	self.appleSprite:remove()

	self:markDirty()
end

function OptionsSpeed:draw()
	gfx.setImageDrawMode(gfx.kDrawModeFillWhite)

	-- Draw "Speed" label text
	gfx.drawText("Speed", 24, 0)

	-- Draw speed setting number as string
	gfx.drawTextAligned(tostring(self.speed), 191, 0, kTextAlignment.center)

	gfx.setImageDrawMode(gfx.kDrawModeCopy)
end

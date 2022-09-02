local gfx <const> = playdate.graphics

local appleImage = gfx.image.new("images/apple")

class("Walls").extends(playdate.graphics.sprite)

function Walls:init()
	Walls.super.init(self)

	self.appleSprite = nil
	self.selected = false
	self.speed = 0

	self:setZIndex(1)
	self:setCenter(0, 0)
	self:setSize(272, 20)
	self:moveTo(72, 112)
end

function Walls:setSpeed(newSpeed)
	self.speed = newSpeed
	self:markDirty()
end

function Walls:select()
	self.selected = true

	self.appleSprite = gfx.sprite.new(appleImage)
	self.appleSprite:setCenter(0, 0)
	self.appleSprite:moveTo(self.x, self.y)
	self.appleSprite:add()

	self:markDirty()
end

function Walls:deselect()
	self.selected = false

	self.appleSprite:remove()

	self:markDirty()
end

function Walls:draw()
	gfx.setImageDrawMode(gfx.kDrawModeFillWhite)

	-- Draw "Speed" label text
	gfx.drawText("Walls", 24, 0)

	gfx.setImageDrawMode(gfx.kDrawModeCopy)
end

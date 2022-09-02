local gfx <const> = playdate.graphics

local appleImage = gfx.image.new("images/apple")

class("Speed").extends(playdate.graphics.sprite)

function Speed:init()
	Speed.super.init(self)

	self.appleSprite = nil
	self.selected = false
	self.speed = 0

	self:setZIndex(1)
	self:setCenter(0, 0)
	self:setSize(272, 20)
	self:moveTo(72, 80)
end

function Speed:setSpeed(newSpeed)
	self.speed = newSpeed
	self:markDirty()
end

function Speed:select()
	self.selected = true

	self.appleSprite = gfx.sprite.new(appleImage)
	self.appleSprite:setCenter(0, 0)
	self.appleSprite:moveTo(self.x, self.y)
	self.appleSprite:add()

	self:markDirty()
end

function Speed:unselect()
	self.selected = false

	self.appleSprite:remove()

	self:markDirty()
end

function Speed:draw()
	gfx.setImageDrawMode(gfx.kDrawModeFillWhite)

	-- Draw "Speed" label text
	gfx.drawText("Speed", 24, 0)

	-- Draw speed setting number as string
	gfx.drawText(tostring(self.speed), 184, 0)

	gfx.setImageDrawMode(gfx.kDrawModeCopy)
end

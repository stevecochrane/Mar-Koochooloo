local gfx <const> = playdate.graphics

local appleImage = gfx.image.new("images/apple")
local radioNotSelectedImage = gfx.image.new("images/radio-not-selected")
local radioSelectedImage = gfx.image.new("images/radio-selected")

class("Walls").extends(playdate.graphics.sprite)

function Walls:init()
	Walls.super.init(self)

	self.appleSprite = nil
	self.enabled = true
	self.radioYesSprite = nil
	self.radioNoSprite = nil
	self.selected = false
	self.speed = 0

	self:setZIndex(1)
	self:setCenter(0, 0)
	self:setSize(272, 20)
	self:moveTo(72, 112)

	self.radioYesSprite = gfx.sprite.new(radioSelectedImage)
	self.radioYesSprite:setCenter(0, 0)
	self.radioYesSprite:moveTo(self.x + 138, self.y)
	self.radioYesSprite:add()

	self.radioNoSprite = gfx.sprite.new(radioNotSelectedImage)
	self.radioNoSprite:setCenter(0, 0)
	self.radioNoSprite:moveTo(self.x + 197, self.y)
	self.radioNoSprite:add()
end

function Walls:toggle()
	self.enabled = not self.enabled
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

	-- Draw "Yes" and "No" label text
	gfx.drawText("Yes", 156, 0)
	gfx.drawText("No", 215, 0)

	gfx.setImageDrawMode(gfx.kDrawModeCopy)
end

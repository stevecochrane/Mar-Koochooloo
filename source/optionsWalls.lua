local gfx <const> = playdate.graphics

local appleImage = gfx.image.new("images/apple")
local radioNotSelectedImage = gfx.image.new("images/radio-not-selected")
local radioSelectedImage = gfx.image.new("images/radio-selected")

class("OptionsWalls").extends(gfx.sprite)

function OptionsWalls:init()
	OptionsWalls.super.init(self)

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

function OptionsWalls:setEnabled(newEnabled)
	self.enabled = newEnabled
	self:updateDisplay()
end

function OptionsWalls:toggle()
	self.enabled = not self.enabled
	self:updateDisplay()
end

function OptionsWalls:updateDisplay()
	if self.enabled == true then
		self.radioYesSprite:setImage(radioSelectedImage)
		self.radioNoSprite:setImage(radioNotSelectedImage)
	else
		self.radioYesSprite:setImage(radioNotSelectedImage)
		self.radioNoSprite:setImage(radioSelectedImage)
	end

	self:markDirty()
end

function OptionsWalls:select()
	self.selected = true

	self.appleSprite = gfx.sprite.new(appleImage)
	self.appleSprite:setCenter(0, 0)
	self.appleSprite:moveTo(self.x, self.y)
	self.appleSprite:add()

	self:markDirty()
end

function OptionsWalls:deselect()
	self.selected = false

	self.appleSprite:remove()

	self:markDirty()
end

function OptionsWalls:draw()
	gfx.setImageDrawMode(gfx.kDrawModeFillWhite)

	-- Draw "Walls" label text
	gfx.drawText("Walls", 24, 0)

	-- Draw "Yes" and "No" label text
	gfx.drawText("Yes", 156, 0)
	gfx.drawText("No", 215, 0)

	gfx.setImageDrawMode(gfx.kDrawModeCopy)
end

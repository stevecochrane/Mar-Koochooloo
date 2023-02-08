local gfx <const> = playdate.graphics

local appleImage = gfx.image.new("images/apple")
local radioNotSelectedImage = gfx.image.new("images/radio-not-selected")
local radioSelectedImage = gfx.image.new("images/radio-selected")

class("OptionsMode").extends(gfx.sprite)

function OptionsMode:init()
	OptionsMode.super.init(self)

	self.appleSprite = nil
	self.mode = "speed"
	self.radioSpeedSprite = nil
	self.radioPuzzleSprite = nil
	self.selected = false

	self:setZIndex(1)
	self:setCenter(0, 0)
	self:setSize(272, 20)
	self:moveTo(72, 80)

	self.radioSpeedSprite = gfx.sprite.new(radioSelectedImage)
	self.radioSpeedSprite:setCenter(0, 0)
	self.radioSpeedSprite:moveTo(self.x + 122, self.y)
	self.radioSpeedSprite:add()

	self.radioPuzzleSprite = gfx.sprite.new(radioNotSelectedImage)
	self.radioPuzzleSprite:setCenter(0, 0)
	self.radioPuzzleSprite:moveTo(self.x + 205, self.y)
	self.radioPuzzleSprite:add()
end

function OptionsMode:setMode(newMode)
	self.mode = newMode
	self:updateDisplay()
end

function OptionsMode:toggle()
	if self.mode == "speed" then
		self.mode = "puzzle"
	else
		self.mode = "speed"
	end
	self:updateDisplay()
end

function OptionsMode:updateDisplay()
	if self.mode == "speed" then
		self.radioSpeedSprite:setImage(radioSelectedImage)
		self.radioPuzzleSprite:setImage(radioNotSelectedImage)
	else
		self.radioSpeedSprite:setImage(radioNotSelectedImage)
		self.radioPuzzleSprite:setImage(radioSelectedImage)
	end

	self:markDirty()
end

function OptionsMode:select()
	self.selected = true

	self.appleSprite = gfx.sprite.new(appleImage)
	self.appleSprite:setCenter(0, 0)
	self.appleSprite:moveTo(self.x, self.y)
	self.appleSprite:add()

	self:markDirty()
end

function OptionsMode:deselect()
	self.selected = false

	self.appleSprite:remove()

	self:markDirty()
end

function OptionsMode:draw()
	gfx.setImageDrawMode(gfx.kDrawModeFillWhite)

	gfx.drawText("Mode", 24, 0)
	gfx.drawText("Speed", 140, 0)
	gfx.drawText("Puzzle", 223, 0)

	gfx.setImageDrawMode(gfx.kDrawModeCopy)
end

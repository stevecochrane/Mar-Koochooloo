local gfx <const> = playdate.graphics

local appleImage = gfx.image.new("images/apple")
local classicImage = gfx.image.new("images/options-classic")
local classicSelectedImage = gfx.image.new("images/options-classic-selected")
local manualImage = gfx.image.new("images/options-manual")
local manualSelectedImage = gfx.image.new("images/options-manual-selected")

class("OptionsMode").extends(gfx.sprite)

function OptionsMode:init()
	OptionsMode.super.init(self)

	self.appleSprite = nil
	self.mode = "speed"
	self.classicSprite = nil
	self.manualSprite = nil
	self.selected = false

	self:setZIndex(1)
	self:setCenter(0, 0)
	self:setSize(304, 25)
	self:moveTo(48, 80)

	self.classicSprite = gfx.sprite.new(classicSelectedImage)
	self.classicSprite:setCenter(0, 0)
	self.classicSprite:moveTo(self.x + 122, self.y)
	self.classicSprite:add()

	self.manualSprite = gfx.sprite.new(manualSelectedImage)
	self.manualSprite:setCenter(0, 0)
	self.manualSprite:moveTo(self.x + 207, self.y)
	self.manualSprite:add()
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
		self.classicSprite:setImage(classicSelectedImage)
		self.manualSprite:setImage(manualImage)
	else
		self.classicSprite:setImage(classicImage)
		self.manualSprite:setImage(manualSelectedImage)
	end

	self:markDirty()
end

function OptionsMode:select()
	self.selected = true

	self.appleSprite = gfx.sprite.new(appleImage)
	self.appleSprite:setCenter(0, 0)
	self.appleSprite:moveTo(self.x, self.y + 4)
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
	gfx.drawText("Controls", 24, 3)
	gfx.setImageDrawMode(gfx.kDrawModeCopy)
end
